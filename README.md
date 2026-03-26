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
- **PBSV** and **Sniffles2** — structural variant calling

Also produces a MultiQC QC report (coverage, alignment metrics, per-read QC).

## :heavy_exclamation_mark: Dependencies

[![hydra-genetics](https://img.shields.io/badge/hydragenetics-v3.3.2-blue)](https://github.com/hydra-genetics/)
[![python](https://img.shields.io/badge/python-3.9-blue)](https://www.python.org/)
[![snakemake](https://img.shields.io/badge/snakemake->=7.32.4,<8-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.0.0-blue)](https://sylabs.io/docs/)
[![pixi](https://img.shields.io/badge/pixi-0.39.0-blue)](https://pixi.sh)

## :school_satchel: Preparations

### Sample data

Input data should be added to [`config/samples.tsv`](config/samples.tsv) and [`config/units.tsv`](config/units.tsv).

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

## :white_check_mark: Testing

Unit tests:

```bash
pixi run tests
```

Integration test (requires Singularity and configured reference data):

```bash
cd .tests/integration
snakemake -s ../../Snakefile --configfiles ../../config/config.yaml config/config.yaml -j1 --use-singularity
```

`../../config/config.yaml` is the main config; `config/config.yaml` is the test override. Values in the latter take precedence.

## :rocket: Usage

Dry-run to validate the DAG:

```bash
# using hydra-genetics v4.0.0
pixi run -e hg4 dry
```

Full run on a SLURM cluster:

```bash
# using hydra-genetics v4.0.0
pixi run -e hg4 full
```

### Output files

| File | Description |
|------|-------------|
| `results/cnvkit_build_normal_reference/cnvkit.PoN.cnn` | PoN for CNVkit (copy number) |
| `results/bcftools_merge/snv_normal.vcf.gz` | PoN for DeepSomatic (small variants) |
| `results/bcftools_merge/sv_normal.vcf.gz` | Merged SV calls from PBSV + Sniffles2 (structural variants) |
| `results/qc/multiqc/multiqc_design2.html` | MultiQC report |

## :judge: Rule Graph
![rule_graph_reference](images/rulegraph.svg)
