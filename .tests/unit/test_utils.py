import pytest
import pandas as pd
from types import SimpleNamespace

from workflow.scripts.utils import get_units_column, get_aligner_bam, get_aligner_bai


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture
def units():
    return pd.DataFrame(
        {
            "sample": ["S1", "S2", "S2", "S3"],
            "type": ["N", "N", "N", "N"],
            "processing_unit": ["PU1", "PU2", "PU3", "PU4"],
            "score": [1.0, None, 3.0, None],
        }
    )


@pytest.fixture
def wildcards_with_type():
    return SimpleNamespace(sample="S1", type="N")


@pytest.fixture
def wildcards_no_type():
    return SimpleNamespace(sample="S1")


@pytest.fixture
def config_pbmm2():
    return {"aligner": "pbmm2"}


@pytest.fixture
def config_vacmap():
    return {"aligner": "vacmap"}


@pytest.fixture
def config_empty():
    return {}


# ---------------------------------------------------------------------------
# get_units_column
# ---------------------------------------------------------------------------


class TestGetUnitsColumn:
    def test_returns_unique_values(self, units):
        result = get_units_column(units, "sample")
        assert sorted(result) == ["S1", "S2", "S3"]

    def test_missing_column_returns_empty_list(self, units):
        assert get_units_column(units, "nonexistent") == []

    def test_ignores_nan_values(self, units):
        result = get_units_column(units, "score")
        assert sorted(result) == [1.0, 3.0]

    def test_all_nan_returns_empty_list(self):
        df = pd.DataFrame({"sample": [None, None]})
        assert get_units_column(df, "sample") == []

    def test_returns_list(self, units):
        assert isinstance(get_units_column(units, "sample"), list)


# ---------------------------------------------------------------------------
# get_aligner_bam
# ---------------------------------------------------------------------------


class TestGetAlignerBam:
    def test_uses_configured_aligner(self, wildcards_with_type, config_pbmm2):
        result = get_aligner_bam(wildcards_with_type, config_pbmm2)
        assert result == "alignment/pbmm2_align/S1_N.bam"

    def test_vacmap_aligner(self, wildcards_with_type, config_vacmap):
        result = get_aligner_bam(wildcards_with_type, config_vacmap)
        assert result == "alignment/vacmap_align/S1_N.bam"

    def test_type_override(self, wildcards_no_type, config_pbmm2):
        result = get_aligner_bam(wildcards_no_type, config_pbmm2, type_override="N")
        assert result == "alignment/pbmm2_align/S1_N.bam"

    def test_type_override_takes_precedence(self, wildcards_with_type, config_pbmm2):
        result = get_aligner_bam(wildcards_with_type, config_pbmm2, type_override="T")
        assert result == "alignment/pbmm2_align/S1_T.bam"

    def test_default_aligner_when_not_in_config(self, wildcards_with_type, config_empty):
        result = get_aligner_bam(wildcards_with_type, config_empty)
        assert result == "alignment/pbmm2_align/S1_N.bam"


# ---------------------------------------------------------------------------
# get_aligner_bai
# ---------------------------------------------------------------------------


class TestGetAlignerBai:
    def test_uses_configured_aligner(self, wildcards_with_type, config_pbmm2):
        result = get_aligner_bai(wildcards_with_type, config_pbmm2)
        assert result == "alignment/pbmm2_align/S1_N.bam.bai"

    def test_vacmap_aligner(self, wildcards_with_type, config_vacmap):
        result = get_aligner_bai(wildcards_with_type, config_vacmap)
        assert result == "alignment/vacmap_align/S1_N.bam.bai"

    def test_type_override(self, wildcards_no_type, config_pbmm2):
        result = get_aligner_bai(wildcards_no_type, config_pbmm2, type_override="N")
        assert result == "alignment/pbmm2_align/S1_N.bam.bai"

    def test_type_override_takes_precedence(self, wildcards_with_type, config_pbmm2):
        result = get_aligner_bai(wildcards_with_type, config_pbmm2, type_override="T")
        assert result == "alignment/pbmm2_align/S1_T.bam.bai"

    def test_default_aligner_when_not_in_config(self, wildcards_with_type, config_empty):
        result = get_aligner_bai(wildcards_with_type, config_empty)
        assert result == "alignment/pbmm2_align/S1_N.bam.bai"
