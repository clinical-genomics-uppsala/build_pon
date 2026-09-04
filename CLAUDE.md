# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`build_pon` (a.k.a. "PoN Builder") is a Snakemake workflow that builds **Panel of Normals** files
from PacBio HiFi (REVIO) normal BAMs: a CNVkit `.cnn` reference, a merged SNV/indel VCF for
DeepSomatic, a merged SV VCF (pbsv + Severus + Sniffles2), and a MultiQC report.

Almost all rules come from external **hydra-genetics** modules pulled from GitHub at parse time;
this repo mostly wires them together and overrides their inputs.

## Commands

Everything runs through [pixi](https://pixi.sh) (`pixi install` first). Tasks are in `pixi.toml`:

```bash
pixi run all-dry      # snakemake -n with config/config.yaml
pixi run all-full     # full run via profiles/marvin_cpu (SLURM/drmaa)
pixi run test-dry     # same as all-dry, samples/units passed explicitly via --config
pixi run test-full
pixi run tests        # PYTHONPATH=. pytest .tests/unit/
pixi run fmt-wf       # snakefmt -l 130 workflow/
pixi run fmt-py       # snakefmt -l 130 workflow/scripts/
pixi run fmt-tests
pixi run rulegraph    # regenerate images/rulegraph.svg
```

Single unit test:

```bash
PYTHONPATH=. pixi run pytest .tests/unit/test_utils.py::TestGetUnitsColumn::test_returns_unique_values -v
```

Lint as CI does:

```bash
pixi run pycodestyle --max-line-length=130 --statistics workflow/scripts
pixi run snakefmt --check -l 130 workflow
```

Dry run / lint against the small integration dataset — note the **two layered `--configfiles`**,
run from inside `.tests/integration`:

```bash
cd .tests/integration
pixi run snakemake -n -s ../../workflow/Snakefile --configfiles ../../config/config.yaml config/config.yaml
pixi run snakemake --lint -n -s ../../workflow/Snakefile --configfiles ../../config/config.yaml config/config.yaml
```

Two pixi environments exist: `default` (hydra-genetics 4.0.0 + Snakemake 7, Python 3.9) and
`snakemake9` (Snakemake 9, Python ≥3.11). Select with `pixi run -e snakemake9 ...`.

## Architecture

### Snakefile composition
- `workflow/Snakefile` defines `rule all` **before** the `module` blocks — each hydra-genetics
  module also declares an `all` rule, so ordering is load-bearing.
- Modules (`alignment`, `annotation`, `cnv_sv`, `prealignment`, `references`, `snv_indels`, `qc`)
  are fetched with `github(...)` at the tag in `config["module_versions"]`. Several are pinned to
  `develop`, so parsing requires network access and results can shift when upstream moves.
- Local rules are rare by design: only `samtools_dict`, `references_bed_to_interval_list`, and
  `bgzip_sv_vcf`. Everything else is `use rule X from <module> as <module>_X with: ...`.
  Follow that `<module-prefix>_<rule-name>` naming when adding rules.
- Most `with:` blocks exist to **override inputs**: upstream rules resolve BAMs via `get_bam()`
  from `units.tsv`, which points at *unmapped* BAMs; this pipeline needs the aligned ones under
  `alignment/pbmm2_align/` or `alignment/vacmap_align/`.

### Two alignment tracks
- **pbmm2** — primary; feeds CNVkit, DeepSomatic, pbsv, whatshap, and all QC rules.
- **VACmap** — separate merge/index chain; Sniffles2 reads from `alignment/vacmap_align/`.
- The `aligner` config key plus `get_aligner_bam` / `get_aligner_bai` in
  [workflow/scripts/utils.py](workflow/scripts/utils.py) select which track a rule reads (used by
  Severus). `workflow/scripts/` is added to `sys.path` from `common.smk`.

### common.smk
[workflow/rules/common.smk](workflow/rules/common.smk) is the config hub:
- Validates `config`, `resources`, `samples`, `units`, and the output spec against
  `workflow/schemas/*.schema.yaml`. **Any new config key must be added to
  `config.schema.yaml` or the run aborts.**
- `units` is indexed by `(sample, type, processing_unit, barcode)` for PACBIO/ONT platforms and by
  `(sample, type, flowcell, lane, barcode)` otherwise.
- Global wildcard constraint `type="N"` — this pipeline only ever processes normals.
- `onstart` writes pipeline/software versions and the resolved config under `results/versions/`.

### Output spec drives the DAG
`config/output_files.yaml` is the contract between internal paths and deliverables. For each entry,
`compile_output_file_list` adds the `output` path to `rule all`, and `generate_copy_rules`
metaprograms a `_copy_<name>` rule (built as a source string and `exec`'d into `workflow.globals`).
**To add a deliverable, add an entry there — do not write a copy rule by hand.**

### Configuration
`config/config.yaml` holds per-rule containers, `extra` flags, and reference paths. YAML anchors
(`&trf`, `&severus_pon`, `&design_bed`) share reference paths across rule sections. CNVkit bin size
lives in `cnvkit_create_targets.extra` / `cnvkit_build_normal_reference.extra`.

## Conventions and gotchas

- **Line length 130** everywhere (snakefmt and pycodestyle).
- PR titles must follow Conventional Commits (enforced by CI); `release-please` cuts releases from
  `main`. Day-to-day work targets `develop`.
- Prefer reusing an existing hydra-genetics module rule over writing a local one.
- `config/config.yaml` reference paths are **absolute paths on the Marvin cluster**
  (`/beegfs-storage/projects/wp2/...`). `.tests/integration/config/config.yaml` overrides them with
  small dummy files — that is why the layered `--configfiles` order matters.
- Do not attempt a full run on `osx-arm64`; the containers are linux-64.
- Working directories `alignment/`, `prealignment/`, `references/`, `snv_indels/`, `cnv_sv/`,
  `results/`, and `ref_data/` are gitignored outputs, except the tracked dummies under
  `.tests/integration/ref_data/`.
- `sync_to_marvin.sh` rsyncs the repo to the cluster, excluding data, refs, results, and docs.
- Stale bits to be aware of: `pixi.toml` still defines `precom` / `precom-fmt` tasks although no
  `.pre-commit-config.yaml` exists; the README output table names `multiqc_design2.html` while
  `config/output_files.yaml` produces `multiqc_normals.html`.

## Open issue: Jumble dummy annotation in the integration test

`.tests/integration/ref_data/jumble_dummy_annotation.RDS` is a **zero-byte placeholder**. That is
enough for the dry-run and `--lint` CI (which never execute containers), but a real run of
`.github/workflows/integration.yaml` (manual `workflow_dispatch`) now reaches `jumble_reference` and
will die in `readRDS()` on the empty file. Jumble's `build_reference()` accepts an annotation source
only if it is the string `"biomart"` or a path matching `\.RDS$`, then immediately `readRDS`es it.

Fixing it means writing a structurally valid minimal annotation — a list named `cancergenes_clinseq`,
`allgenes`, `allexons` — and then confirming `build_reference()` survives it on the tiny test BAM.
That cannot be verified on `osx-arm64` (the containers are linux-64), so it needs an actual
integration run. Deferred deliberately; not yet attempted.

Note the upstream module has the same problem: `hydra-genetics/references` ships
`.tests/integration/reference/jumble_dummy_annotation.txt`, also zero bytes, and a `.txt` suffix
fails Jumble's `\.RDS$` check outright.
