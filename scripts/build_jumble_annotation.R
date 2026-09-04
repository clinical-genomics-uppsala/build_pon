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
# Defaults: jumble_gene_annotation_hg38.RDS, hg38, and the Ensembl host that serves
# that assembly. Pass an explicit host only to override the default.

suppressPackageStartupMessages({
  library(biomaRt)
  library(data.table)
  library(Jumble)
})

args <- commandArgs(trailingOnly = TRUE)
out_file <- if (length(args) >= 1) args[1] else "jumble_gene_annotation_hg38.RDS"
genome <- if (length(args) >= 3) args[3] else "hg38"

if (!genome %in% c("hg19", "hg38")) stop("genome must be hg19 or hg38, got: ", genome)

# The two assemblies live on different Ensembl hosts, and the host alone decides which
# one you get. Passing GRCh = 37 to useEnsembl() does NOT help: biomaRt derives a host
# from GRCh only when host= is absent, so alongside an explicit host the argument is
# silently ignored - hg19 would quietly be served GRCh38 coordinates. These defaults are
# the same URLs biomaRt's own .constructEnsemblURL() builds.
default_host <- if (genome == "hg19") "https://grch37.ensembl.org" else "https://jun2026.archive.ensembl.org"
host <- if (length(args) >= 2 && nzchar(args[2])) args[2] else default_host
expected_assembly <- if (genome == "hg19") "GRCh37" else "GRCh38"

chromosomes <- c(as.character(1:22), "X", "Y")

message("Host:   ", host)
message("Genome: ", genome)
message("Output: ", out_file)

mart <- useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl", host = host)
# See header: without this, queries go to www.ensembl.org and fail with 405.
mart@host <- paste0(sub("/+$", "", host), "/biomart/martservice")
message("Query endpoint: ", mart@host)

# Since the host silently determines the assembly, confirm the endpoint really serves the
# requested one - before spending an hour fetching from it, and long before saveRDS().
datasets <- listDatasets(mart)
assembly <- datasets$version[datasets$dataset == "hsapiens_gene_ensembl"]
if (length(assembly) != 1) {
  stop("could not determine which assembly ", mart@host, " serves")
}
message("Assembly: ", assembly)
if (!startsWith(assembly, expected_assembly)) {
  stop("genome ", genome, " requires ", expected_assembly, ", but ", host, " serves ", assembly)
}

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

# fetch_ensembl_data() only warns when a chromosome fails, so a partial result would
# otherwise be saved silently and quietly bias the PoN. Exons come from a second,
# independent chromosome-by-chromosome pass, so they have to be checked separately from
# the genes - and every protein-coding gene in Ensembl has at least one exon row, so a
# retained gene without exons also means the exon pass dropped something.
stopifnot(nrow(allgenes) > 0, nrow(allexons) > 0)
missing_gene_chroms <- setdiff(chromosomes, unique(as.character(allgenes$`Chromosome/scaffold name`)))
missing_exon_chroms <- setdiff(chromosomes, unique(as.character(allexons$`Chromosome/scaffold name`)))
genes_without_exons <- setdiff(allgenes$`Gene stable ID`, unique(allexons$`Gene stable ID`))
if (length(missing_gene_chroms) > 0 || length(missing_exon_chroms) > 0 || length(genes_without_exons) > 0) {
  msg <- "the fetch was incomplete, rerun:"
  if (length(missing_gene_chroms) > 0) {
    msg <- paste0(msg, "\n  no genes on chromosome(s): ", paste(missing_gene_chroms, collapse = ", "))
  }
  if (length(missing_exon_chroms) > 0) {
    msg <- paste0(msg, "\n  no exons on chromosome(s): ", paste(missing_exon_chroms, collapse = ", "))
  }
  if (length(genes_without_exons) > 0) {
    msg <- paste0(msg, "\n  genes with no exon rows: ", length(genes_without_exons),
                  " (e.g. ", paste(utils::head(genes_without_exons, 3), collapse = ", "), ")")
  }
  stop(msg)
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
