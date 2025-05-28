# Changelog

## 0.1.0 (2025-05-28)


### Features

* add function get_units_column() ([8209ca8](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/8209ca8e38bfd2fe2d8bcc254bbb140d5bea6d46))
* add output_files.yaml ([7198301](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/71983017888bfb4edf270bab0d6e6a6a4b647b34))
* update config.yaml ([7b021e7](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/7b021e7da09ba4d7a1319a20a6d5a709a59ecb8f))
* update Snakefile ([0d4051e](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/0d4051ee2a5bec14fa22360fdce56939df417a15))


### Bug Fixes

* add bai files as whatshap phase input ([94f1a2e](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/94f1a2ea7a9b1a1dd4e6225718c41a4949c7e69a))
* add bam files as input to cnvkit_build_normal_reference ([8cb0edc](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/8cb0edc05a0edf7c6cb09c01ba1e822693a43db6))
* add correct deepsomatic_pon rule ([886015c](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/886015c8e79244c627573bf70bc407edd15ff1e7))
* add more control samples, use shorter barcodes ([b095341](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/b095341ba8a69a3747fb8c4ecf6d06542aacfa85))
* add rule for merging vcf into ine PoN ([c214534](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/c214534a227acc1426dc74d07c6a575f232ca272))
* add samtools_index to Snakefile ([f0b2c5a](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/f0b2c5a2a8e6627459c03eccac69bf5c9643098e))
* change partition to low in resources.yaml ([1b73d02](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/1b73d02498b2757ed7e72ce1b1adeee9d73d1645))
* deepS to use bam files from pbmm2_align/merge not form units.tsv ([4039cb8](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/4039cb84702f9a54e5cfaf232e2f60ccc61cb9cf))
* make correct config.yaml ([60130b0](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/60130b0a60c6be74299c9ef6aeb1b9ebde71bf74))
* remove lonely quotation mark from lint.yaml ([1712ccd](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/1712ccd64a9abff33aaaf278d7c2f44796ecde25))
* replace date_string with pipeline name in common.smk ([43100d2](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/43100d2a840082b733309326e1ac29f2876a2c4d))
* typos and units validation in common.smk ([0dfd913](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/0dfd913fb94238f87a665cace2c55384d9d8890b))
* update common container version ([95d9148](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/95d91487d1349bae6b69a890ea3ef368884cd9f9))
* use develop branch in references ([509ec4f](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/509ec4f684b3a2343a3c60b6fed841d257ed8d8c))


### Documentation

* add config.yaml ([9ed9562](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/9ed95624c67206da3d8e59d51f7d95a7185472d1))
* add output_files.yaml ([e6cbae1](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/e6cbae18bae9e430cb2fa96d973c9217b9fe622d))
* add profile config ([b3f94de](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/b3f94de19b941dc493eede2fe5170427fb79fa72))
* add real paths to bam files in units.tsv ([64bb96e](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/64bb96e448d801a93b35025b127d5232b467b567))
* add real sample names to samples.tsv ([61a708b](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/61a708bd92d246c71727a6e2c69993e8823d7021))
* add rulegraph.svg ([6150846](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/6150846ab5123bcfed6499fb41c873ce7c838e90))
* increase threads to 4 in resources.yaml ([0454ce3](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/0454ce3ea322d124b076729ea73580e3a66589ea))
* update hydra-genetics version ([d80768e](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/d80768e2de543d6027decc4c580e4fdfd4a716ae))
* update README.md ([2f4623e](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/2f4623e897e02452e6eb243d66106f253d2f500d))
* update README.md ([14aefac](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/14aefacc619e2d286151774401330e9075876502))
* update README.md ([af36200](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/af362005c87d5b1650a6ab6193a983d3ffc35c55))
* update README.md ([7a66f76](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/7a66f7654b9901ec51f9a0647eb5e39e05607f1f))
* update rulegraph.svg ([ac7ed25](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/ac7ed259202da3dd2aca5dd188f9e4da4aec7432))
* update rulegraph.svg ([8ad4be0](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/8ad4be0d90b0550a572e32ea5888b75b5ef6ced0))
* update rulegraph.svg ([ebca702](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/ebca70210dd5859f06114f4553abb978da5625ca))
* update rulegraph.svg ([a9742e4](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/a9742e4a35181c2397ba328df9e8284b91672cc4))
* update rulegraph.svg ([991c80f](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/991c80f53d03ab13aba80c6eb3637e1a124710b3))
* update rulegraph.svg ([b16bb10](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/b16bb1004cbed10706f61be366ae38496c632e62))
* update samples and units ([d030c79](https://www.github.com/clinical-genomics-uppsala/build_pon/commit/d030c7927aa466a6a802e4c396e366f9e45e4fba))
