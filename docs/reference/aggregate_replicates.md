# Aggregate Technical Replicates for Statistical Rigor

Collapses technical replicates (e.g., multiple thermal images taken of
the same animal) into a single biological data point per subject. This
step is crucial for avoiding pseudoreplication in downstream statistical
analyses (e.g., t-tests, ANOVA).

## Usage

``` r
aggregate_replicates(data, id_col, method = "mean", keep_cols = NULL)
```

## Arguments

- data:

  A data frame. Typically the output from
  [`compile_batch_stats`](https://rightsz.github.io/BioThermR/reference/compile_batch_stats.md)
  or
  [`merge_clinical_data`](https://rightsz.github.io/BioThermR/reference/merge_clinical_data.md).

- id_col:

  String. The column name representing the unique Biological Subject ID
  (e.g., "MouseID", "Subject_No"). Rows sharing this ID will be
  condensed into one.

- method:

  String. The mathematical function used for aggregation: either
  `"mean"` (default) or `"median"`. Median is often more robust to
  outliers (e.g., one blurry image).

- keep_cols:

  Vector of strings. Names of non-numeric metadata columns to preserve
  in the final output (e.g., "Group", "Genotype", "Sex", "Treatment").

## Value

A data frame with exactly one row per unique ID. The column order is
reorganized to place ID and metadata first, followed by the aggregated
thermal statistics and the `n_replicates` count.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- aggregate_replicates(
  data = df_raw,
  id_col = "SampleID",
  method = "median",
  keep_cols = c("Group", "Sex")
)
} # }
```
