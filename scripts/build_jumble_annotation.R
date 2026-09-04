#!/usr/bin/env Rscript
# Build the gene-annotation .RDS consumed by jumble-reference.R (-a / config
# jumble_reference.annotation), without relying on biomaRt's mirror selection.
#
# Why this exists instead of Jumble:::generate_gene_annotation():
#   That function calls useEnsembl(mirror = NULL), which walks Ensembl's mirror
#   list. As of 2026-09-03 useast.ensembl.org returns 502 and asia.ensembl.org
#   returns 404 for /biomart/martservice, so it dies with "Unable to query any
#   Ensembl site" even on a machine with unrestricted internet.
#   Passing host= is not enough on its own: biomaRt refills the Mart host slot
#   from the registry, which advertises www.ensembl.org - and that gateway
#   answers POST /biomart/martservice with 405 Method Not Allowed. The archive
#   host serves the same POST correctly, so the slot is overridden below.
#
# Usage:
#   Rscript build_jumble_annotation.R [output.RDS] [ensembl_host] [genome]
# Defaults: jumble_gene_annotation_hg38.RDS, the June 2026 archive host, hg38.

suppressPackageStartupMessages({
  library(biomaRt)
  library(data.table)
  library(Jumble)
})

args <- commandArgs(trailingOnly = TRUE)
out_file <- if (length(args) >= 1) args[1] else "jumble_gene_annotation_hg38.RDS"
host <- if (length(args) >= 2) args[2] else "https://jun2026.archive.ensembl.org"
genome <- if (length(args) >= 3) args[3] else "hg38"

if (!genome %in% c("hg19", "hg38")) stop("genome must be hg19 or hg38, got: ", genome)

chromosomes <- c(as.character(1:22), "X", "Y")

message("Host:   ", host)
message("Genome: ", genome)
message("Output: ", out_file)

mart <- useEnsembl(
  biomart = "ensembl",
  dataset = "hsapiens_gene_ensembl",
  host = host,
  GRCh = if (genome == "hg19") 37 else NULL
)
# See header: without this, queries go to www.ensembl.org and fail with 405.
mart@host <- paste0(sub("/+$", "", host), "/biomart/martservice")
message("Query endpoint: ", mart@host)

# The remaining steps mirror Jumble:::generate_gene_annotation() exactly, so the
# resulting object stays byte-compatible with what build_reference() expects.
attr_genes <- c(
  "ensembl_gene_id", "external_gene_name", "chromosome_name",
  "start_position", "end_position", "gene_biotype"
)
message("Fetching gene data from Ensembl...")
allgenes <- Jumble:::fetch_ensembl_data(mart, genome, attr_genes, "genes")
allgenes <- allgenes[chromosome_name %in% chromosomes & gene_biotype == "protein_coding"]
setnames(
  allgenes,
  old = attr_genes[1:5],
  new = c(
    "Gene stable ID", "Gene name", "Chromosome/scaffold name",
    "Gene start (bp)", "Gene end (bp)"
  )
)

attr_exons <- c(
  "ensembl_gene_id", "external_gene_name", "chromosome_name",
  "exon_chrom_start", "exon_chrom_end", "rank"
)
message("Fetching exon data from Ensembl...")
allexons <- Jumble:::fetch_ensembl_data(mart, genome, attr_exons, "exons")
allexons <- allexons[chromosome_name %in% chromosomes & ensembl_gene_id %in% allgenes$`Gene stable ID`]
setnames(
  allexons,
  old = attr_exons,
  new = c(
    "Gene stable ID", "Gene name", "Chromosome/scaffold name",
    "Exon region start (bp)", "Exon region end (bp)", "Exon rank in transcript"
  )
)

cancergenes <- Jumble:::process_cancer_genes(allgenes)

# fetch_ensembl_data() only warns when a chromosome fails, so a partial result
# would otherwise be saved silently and quietly bias the PoN.
stopifnot(nrow(allgenes) > 0, nrow(allexons) > 0)
missing_chroms <- setdiff(chromosomes, unique(as.character(allgenes$`Chromosome/scaffold name`)))
if (length(missing_chroms) > 0) {
  stop("no genes returned for chromosome(s): ", paste(missing_chroms, collapse = ", "),
       " - rerun, the fetch was incomplete")
}

annotation <- list(
  cancergenes_clinseq = cancergenes,
  allgenes = allgenes,
  allexons = allexons
)

saveRDS(annotation, out_file)

message("\nSaved ", out_file)
message("  cancergenes_clinseq: ", nrow(cancergenes), " rows")
message("  allgenes:            ", nrow(allgenes), " rows")
message("  allexons:            ", nrow(allexons), " rows")
message("  chromosomes:         ", paste(sort(unique(as.character(allgenes$`Chromosome/scaffold name`))), collapse = " "))
