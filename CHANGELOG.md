# Changelog

## [0.2.0](https://github.com/clinical-genomics-uppsala/build_pon/compare/v0.1.0...v0.2.0) (2026-03-27)


### Features

* add different aligners, pixi, sniffles2, picard and hydra-genetics v4  ([#7](https://github.com/clinical-genomics-uppsala/build_pon/issues/7)) ([7c90ea8](https://github.com/clinical-genomics-uppsala/build_pon/commit/7c90ea827042a016652ffc7a649fa25380aaff4a))
* add QC block ([8dbc255](https://github.com/clinical-genomics-uppsala/build_pon/commit/8dbc25581c14b470ced80f945df46bcce0255b40))
* add QC, SV and configurable aligner ([#2](https://github.com/clinical-genomics-uppsala/build_pon/issues/2)) ([18a4318](https://github.com/clinical-genomics-uppsala/build_pon/commit/18a4318c915aff5469d83c8f79e28a9df221bbbe))
* add SV discovery with sniffles2 and pbsv and configurable aligner for different tools ([17c786c](https://github.com/clinical-genomics-uppsala/build_pon/commit/17c786c4831fb00b4e69e2a97fceb0342bd4f578))
* bump common container version to 4.0.0 ([1be0bfe](https://github.com/clinical-genomics-uppsala/build_pon/commit/1be0bfe03bcd6bb9939bec7a1152ce30f3fbc3e4))
* functions to create paths to bam and bai files depending on whcih aligner is configured ([2374cb9](https://github.com/clinical-genomics-uppsala/build_pon/commit/2374cb975cdf463c6d7fe879bd78e25120ad896d))
* update config with new references and tools ([1241ebc](https://github.com/clinical-genomics-uppsala/build_pon/commit/1241ebcb66e814d9950f165df9c1699044cc0783))
* use pbmm2 as primary aligner and vacmap as secondary (for sniffles2 only) ([#6](https://github.com/clinical-genomics-uppsala/build_pon/issues/6)) ([af4156f](https://github.com/clinical-genomics-uppsala/build_pon/commit/af4156f529f67deb16b4ce41ddf9e326bccea3c5))
* use pbmm2 as the main aligner; vacmap as secondary ([f2d957e](https://github.com/clinical-genomics-uppsala/build_pon/commit/f2d957e45c1ae3d0106b7833f0dfcd4f1f2ab8cf))


### Bug Fixes

* add correct docker for bed_to_interval list and extra params for bcftools merge to handle one sample cases ([2edf338](https://github.com/clinical-genomics-uppsala/build_pon/commit/2edf3389029614123f10b4c1b9c48fe0ccb5a16b))
* add required library imports ([79453f6](https://github.com/clinical-genomics-uppsala/build_pon/commit/79453f6640d435d64aa41bc136becfa9458f36c9))
* bam from pbmm2 as deepsomatic_pon input ([#5](https://github.com/clinical-genomics-uppsala/build_pon/issues/5)) ([56ffdad](https://github.com/clinical-genomics-uppsala/build_pon/commit/56ffdada539c86d6796f893e0085309138127d8f))
* deepsomatic_pon rule inputs ([fb9e4dc](https://github.com/clinical-genomics-uppsala/build_pon/commit/fb9e4dc9ca3f22a63a9b6bb0aca62e601c0d0e80))
* dry run with hydra-genetics v4 ([f1208f5](https://github.com/clinical-genomics-uppsala/build_pon/commit/f1208f531c4565135aac760c2aa9d3f621447c3b))


### Reverts

* default samples/units filenames ([d546e58](https://github.com/clinical-genomics-uppsala/build_pon/commit/d546e58e28279ddb118de98c622dd3a6ef911c42))


### Documentation

* upd rulegraph ([606f966](https://github.com/clinical-genomics-uppsala/build_pon/commit/606f9669df188fa03dfde352608ff2ef9abdc112))
* update readme ([05c7d62](https://github.com/clinical-genomics-uppsala/build_pon/commit/05c7d62419d0524cca409d665916046607fa1479))
* update README.md ([bbac476](https://github.com/clinical-genomics-uppsala/build_pon/commit/bbac476cead1d03033274d722cd761f7a7891743))
* update rulegraph ([e19a351](https://github.com/clinical-genomics-uppsala/build_pon/commit/e19a35119719098d44f253996dd07225f08660c8))
* update rulegraph ([43830ac](https://github.com/clinical-genomics-uppsala/build_pon/commit/43830ac1d3b95be045d4b0cc9adf89933b8d780f))
* update the main header in readme ([4120001](https://github.com/clinical-genomics-uppsala/build_pon/commit/41200011b66ecc3c7b60a79cf0b7257c226afab6))
* update the main header in readme ([#4](https://github.com/clinical-genomics-uppsala/build_pon/issues/4)) ([3b2347f](https://github.com/clinical-genomics-uppsala/build_pon/commit/3b2347fb5b8ba65cd5c92d9c59406d65d4b21cd0))

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
