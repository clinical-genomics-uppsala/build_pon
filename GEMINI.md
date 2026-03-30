# GEMINI.md - build_pon Project Context

## Project Overview
`build_pon` is a Snakemake-based bioinformatics workflow module part of the **Hydra-Genetics** ecosystem. Its primary purpose is to generate **Panel of Normals (PoN)** files for use with **CNVkit** and **DeepSomatic**, as well as MultiQC report with sequencing and mapping quality metrics.

### Key Technologies
- **Snakemake**: Workflow management and rule orchestration.
- **Python (3.8+)**: Core logic, data manipulation (pandas), and validation.
- **Singularity**: Containerized execution of bioinformatics tools.
- **Hydra-Genetics Framework**: Utilizes modular Snakemake patterns for reusability.

### Architecture
The project follows a modular architecture where it "uses" rules from external Hydra-Genetics repositories (alignment, annotation, cnv_sv, etc.) while defining local rules for PoN-specific processing.

- `workflow/Snakefile`: Main entry point; defines the rule `all` and includes modules.
- `workflow/rules/common.smk`: Central hub for configuration loading, YAML schema validation, and utility functions like `compile_output_file_list`.
- `config/`: Contains default configurations and input metadata templates (`samples.tsv`, `units.tsv`).
- `workflow/schemas/`: YAML schemas ensuring all configuration and metadata files meet specific requirements.

## Building and Running

### Main Workflow
To run the workflow with default configurations:
```bash
snakemake -s workflow/Snakefile --configfile config/config.yaml --use-singularity -j <threads>
```

### Key Inputs
- `config/samples.tsv`: Lists unique sample IDs.
- `config/units.tsv`: Maps samples to their respective BAM files and metadata (platform, type, etc.).
- `config/config.yaml`: Global settings, including reference paths and module-specific parameters.

### Expected Outputs
- `build_pon/results/cnvkit_build_normal_reference/cnvkit.PoN.cnn`: PoN file for CNVkit.
- `build_pon/results/bcftools_merge/normal_db.vcf.gz`: PoN file for DeepSomatic.

## Testing and Quality Assurance

### Integration Tests
The project includes a small integration test dataset:
```bash
cd .tests/integration
snakemake -s ../../Snakefile --configfiles ../../config/config.yaml config/config.yaml -j1 --use-singularity
```

### Unit Tests
Python scripts in `workflow/scripts/` are tested using `pytest`:
```bash
pytest workflow/scripts
```

### Linting and Formatting
- **Snakemake**: `snakefmt` is used for consistent formatting.
- **Python**: `pycodestyle` (PEP8) is enforced.
- CI pipelines in `.github/workflows/` automate these checks on every push to `main` or `develop`.

## Development Conventions
- **Modular Design**: Avoid defining large local rules; instead, wrap reusable logic into Hydra-Genetics modules or separate rules files.
- **Validation**: All configuration changes should be reflected in the corresponding schema files in `workflow/schemas/`.
- **Reproducibility**: Always use `--use-singularity` to ensure software versions are locked via containers.
- **Metadata Strictness**: `samples.tsv` and `units.tsv` must strictly follow the schema defined in `workflow/schemas/`.
