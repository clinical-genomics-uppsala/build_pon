# <img src="images/hydragenetics.png" width=40 /> PoN Builder

#### Create Panel of Normals for CNVkit, DeepSomatic, and SVDB (using Sniffles2 and PBSV)

![Lint](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)
![snakemake dry run](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/snakemake-dry-run.yaml/badge.svg?branch=develop)
![integration test](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/integration.yaml/badge.svg?branch=develop)

![pycodestyle](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/pycodestyle.yaml/badge.svg?branch=develop)
![pytest](https://github.com/clinical-genomics-uppsala/build_pon/actions/workflows/pytest.yaml/badge.svg?branch=develop)

[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)

## :speech_balloon: Introduction

Builds Panel of Normals (PoN) files from PacBio HiFi (REVIO) normal samples for use with:

- **CNVkit** — copy number variation analysis
- **DeepSomatic** — small variant calling
- **PBSV**, **Severus** and **Sniffles2** — structural variant calling

Also produces a MultiQC QC report (coverage, alignment metrics, per-read QC).

## :heavy_exclamation_mark: Dependencies

All dependencies are managed by [pixi](https://pixi.sh). Install pixi, then run:

```bash
pixi install
```

This resolves and installs all required packages (Python, Snakemake, hydra-genetics, and other tools) as defined in `pixi.toml`. Container images for individual pipeline tools are pulled automatically at runtime via Singularity/Apptainer and are listed in `config/config.yaml`.

## :school_satchel: Preparations

### Sample data

Input data should be added to [`config/samples.tsv`](config/samples.tsv) and [`config/units.tsv`](config/units.tsv). Both files can be made using `hydra-genetics create-input-files` command.

| Column | File | Description |
|--------|------|-------------|
| `sample` | `samples.tsv` | Unique sample ID, one per row |
| `sample` | `units.tsv` | Same sample ID as in `samples.tsv` |
| `type` | `units.tsv` | Must be `N` (normal) |
| `platform` | `units.tsv` | Sequencing platform, e.g. `PACBIO` |
| `machine` | `units.tsv` | Machine model, e.g. `REVIO` |
| `processing_unit` | `units.tsv` | Run/flowcell identifier |
| `barcode` | `units.tsv` | Barcode string (must not be `NA`) |
| `methylation` | `units.tsv` | Whether methylation data is present (`Yes`/`No`) |
| `bam` | `units.tsv` | Absolute path to input BAM file |

### Reference data

The following reference files must be configured in `config/config.yaml` under the `reference` key:

| Key | Description |
|-----|-------------|
| `fasta` | Reference genome FASTA |
| `fai` | FASTA index (`.fai`) |
| `design_bed` | Capture design BED file |
| `trf` | Tandem repeat file for PBSV (`.bed`) |
| `mappability` | Mappability file for CNVkit |
| `severus_pon` | 1000 genomes database used by Severus to filter out normal variants (`.tsv.gz`) |


## :white_check_mark: Testing

Unit tests:

```bash
pixi run tests
```

## :rocket: Usage

Dry-run to validate the DAG:

```bash
pixi run all-dry
```

Full run on a SLURM cluster:

```bash
pixi run all-full
```

### Important configuration information

Bin size for CNVkit rules can be specified under `extra` key in `config/config.yaml`, for instance:

```yaml
cnvkit_create_targets:
    extra: "-a 2000"

cnvkit_build_normal_reference:
    extra: "--target-avg-size 2000"
```

### Output files

| File | Description |
|------|-------------|
| `results/cnvkit_build_normal_reference/cnvkit.PoN.cnn` | PoN for CNVkit (copy number) |
| `results/bcftools_merge/snv_normal.vcf.gz` | PoN for DeepSomatic (small variants) |
| `results/bcftools_merge/sv_normal.vcf.gz` | Merged SV calls from PBSV, Severus and Sniffles2 |
| `results/qc/multiqc/multiqc_design2.html` | MultiQC report |

## :judge: Rule Graph
![rule_graph_reference](images/rulegraph.svg)
