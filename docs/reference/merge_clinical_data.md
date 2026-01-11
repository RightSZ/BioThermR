# Merge Thermal Stats with Clinical Data

Merges the compiled thermal statistics with an external clinical dataset
based on filenames/IDs. Automatically handles column name conflicts
(removes .x/.y suffixes).

## Usage

``` r
merge_clinical_data(
  thermal_df,
  clinical_df,
  thermal_id = "Filename",
  clinical_id = "Filename",
  clean_ids = TRUE
)
```

## Arguments

- thermal_df:

  Data frame. The output from compile_batch_stats().

- clinical_df:

  Data frame. Your external clinical data.

- thermal_id:

  String. Column name in thermal_df to merge on. Default is "Filename".

- clinical_id:

  String. Column name in clinical_df to merge on. Default is "Filename".

- clean_ids:

  Logical. If TRUE, automatically removes file paths and extensions for
  matching. Default is TRUE.

## Value

A merged data frame.
