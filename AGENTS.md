---
name: build_pon
description: "build_pon is a Snakemake-based bioinformatics workflow. Its primary purpose is to generate Panel of Normals (PoN) files for use with CNVkit, DeepSomatic and SVDB, as well as MultiQC report with sequencing and mapping quality metrics."
---

## Project Overview
`build_pon` is a Snakemake-based bioinformatics workflow. Its primary purpose is to generate **Panel of Normals (PoN)** files for use with **CNVkit**, **DeepSomatic** and **SVDB**, as well as MultiQC report with sequencing and mapping quality metrics.

### Key Technologies
- **Snakemake**: Workflow management and rule orchestration.
- **Python (3.9+)**: Core logic, data manipulation (pandas), and validation.
- **Singularity**: Containerized execution of bioinformatics tools.
- **Hydra-Genetics Framework**: Utilizes modular Snakemake patterns for reusability.
- **Pixi**: External dependency and environment management (python version, snakemake version etc.).

### Architecture
The project follows a modular architecture where it "uses" rules from external Hydra-Genetics repositories (alignment, annotation, cnv_sv, etc.) while defining local rules for PoN-specific processing.

- `workflow/Snakefile`: Main entry point; defines the rule `all` and includes modules.
- `workflow/rules/common.smk`: Central hub for configuration loading, YAML schema validation, and utility functions like `compile_output_file_list`.
- `config/`: Contains default configurations and input metadata templates (`samples.tsv`, `units.tsv`).
- `workflow/schemas/`: YAML schemas ensuring all configuration and metadata files meet specific requirements.

## Building and Running

### Main Workflow
Dry-run:
```bash
pixi run test-dry
```
Full run:
```bash
pixi run test-full
```

Do not use full run on osx-arm64 platform (this computer). Use `pixi run test-dry` instead.

### Key Inputs
- `config/samples.tsv`: Lists unique sample IDs.
- `config/units.tsv`: Maps samples to their respective BAM files and metadata (platform, type, etc.).
- `config/config.yaml`: Global settings, including reference paths and module-specific parameters.

### Expected Outputs

described by user in `config/output_files.yaml`. Normally, the expected outputs are normal SNP/Indel VCF, normal SV VCF, normal CNVkit PoN (.cnn format), and MultiQC report.

## Testing and Quality Assurance

### Integration Tests
The project includes a small integration test dataset which is not intended for this platform (osx-arm64):
```bash
cd .tests/integration
pixi run snakemake -s ../../Snakefile --configfiles ../../config/config.yaml config/config.yaml -j1 --use-singularity
```

### Unit Tests
Python scripts in `workflow/scripts/` are tested using `pytest`:
```bash
pix run tests
```

### Linting and Formatting
- **Snakemake**: `snakefmt` is used for consistent formatting.
- **Python**: `pycodestyle` (PEP8) is enforced.
- CI pipelines in `.github/workflows/` automate these checks on every push to `main` or `develop`.

## Development Conventions
- **Modular Design**: Avoid defining large local rules; instead, use available [Hydra-Genetics](https://github.com/orgs/hydra-genetics/repositories) modules.
- **Validation**: All configuration changes should be reflected in the corresponding schema files in `workflow/schemas/`.
- **Reproducibility**: Always use `--use-singularity` to ensure software versions are locked via containers.
- **Metadata Strictness**: `samples.tsv` and `units.tsv` must strictly follow the schema defined in `workflow/schemas/`.
