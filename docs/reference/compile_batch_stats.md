# Compile Batch Statistics into a Tidy Data Frame

Iterates through a list of 'BioThermR' objects, extracts the
pre-calculated statistics (from `analyze_thermal_stats`), and aggregates
them into a single summary data frame. This function transforms the
nested list structure into a flat, tabular format (Tidy Data) suitable
for downstream statistical analysis (ANOVA, t-test) or visualization.

## Usage

``` r
compile_batch_stats(img_list)
```

## Arguments

- img_list:

  A list of 'BioThermR' objects (typically the output of a batch
  processing workflow). Note:
  [`analyze_thermal_stats`](https://rightsz.github.io/BioThermR/reference/analyze_thermal_stats.md)
  must be run on these objects first to populate the 'stats' slot.

## Value

A `data.frame` where:

- **Rows** represent individual images.

- **Columns** include 'Filename' and all metrics computed by
  `analyze_thermal_stats` (e.g., Min, Max, Mean, Median, SD, IQR, CV,
  Peak_Density).

## Examples

``` r
if (FALSE) { # \dontrun{
# 1. Import and Process
batch <- read_thermal_batch("data/")
batch <- lapply(batch, analyze_thermal_stats)

# 2. Compile Results
df_results <- compile_batch_stats(batch)

# 3. View
head(df_results)
} # }
```
