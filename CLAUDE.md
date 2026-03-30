# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

**build_pon** is a [Hydra-Genetics](https://hydra-genetics.readthedocs.io/) Snakemake workflow module that builds Panel of Normals (PoN) files for:
- **CNVkit** (`cnvkit.PoN.cnn`) — copy number variation analysis
- **DeepSomatic** (`normal_db.vcf.gz`) — variant calling

It expects PacBio HiFi (REVIO platform) normal samples and produces MultiQC QC reports alongside the PoN files.

## Commands

Dependencies are managed with [pixi](https://pixi.sh). All common tasks are defined as `pixi run` commands:

```bash
pixi run dry        # Snakemake dry-run (validate DAG without executing)
pixi run full       # Full pipeline run via SLURM (marvin_cpu profile)
pixi run tests      # Unit tests: PYTHONPATH=. pytest .tests/unit/
pixi run precom     # Pre-commit checks (runs pytest)
pixi run fmt-wf     # Format workflow/Snakefile with snakefmt
pixi run fmt-py     # Format Python scripts in workflow/scripts/
pixi run rulegraph  # Generate SVG rule dependency graph
```

Integration tests (requires Singularity + configured references):
```bash
cd .tests/integration && snakemake -s ../../Snakefile \
  --configfiles ../../config/config.yaml config/config.yaml \
  -j1 --use-singularity
```

## Architecture

### Module System

The pipeline imports tools from external Hydra-Genetics repositories pinned in `config/config.yaml` under `module_versions`. Each module is fetched via GitHub URL in `workflow/Snakefile` using Snakemake's `module` directive. Versions are updated by changing the branch/tag in `config/config.yaml`.

### Two PoN Tracks (run in parallel)

```
BAM inputs (samples.tsv / units.tsv)
  ↓ prealignment_pbmarkdup (duplicate marking)
  ↓ alignment_pbmm2_align → alignment_pbmm2_merge → samtools_index
  ├── CNVkit track:
  │     references_cnvkit_create_targets
  │     references_cnvkit_create_anti_targets
  │     references_cnvkit_build_normal_reference → cnvkit.PoN.cnn
  ├── DeepSomatic track:
  │     references_deepsomatic_pon → annotation_whatshap_phase
  │     cnv_sv_tabix → references_bcftools_merge → normal_db.vcf.gz
  └── QC track:
        qc_mosdepth / qc_picard_* / qc_sequali → qc_multiqc_longread
```

All rules enforce `type="N"` (normal samples only) via wildcard constraints.

### Key Files

| File | Purpose |
|------|---------|
| `workflow/Snakefile` | Entry point; imports external modules, defines `rule all` |
| `workflow/rules/common.smk` | Config loading, schema validation, `compile_output_file_list()`, `generate_copy_rules()` |
| `config/config.yaml` | Reference paths, tool parameters, module version pins |
| `config/output_files.yaml` | Declares the three pipeline outputs consumed by `rule all` |
| `config/samples.tsv` / `units.tsv` | Sample metadata; `type` must be `N` |
| `workflow/schemas/` | JSON schemas validating config, resources, samples, units |
| `profiles/marvin_cpu/config.yaml` | SLURM/Singularity execution profile |

### Adding or Modifying Outputs

1. Add entry to `config/output_files.yaml`
2. Ensure the corresponding rule exists (in an imported module or locally)
3. `compile_output_file_list()` in `common.smk` will automatically include it in `rule all`

### Rule Overrides

External module rules are customized using the `use rule ... with:` pattern in `Snakefile`. This allows changing `input`, `output`, `params`, or `resources` without forking the upstream module.
