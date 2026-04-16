# Pairwise Correlation Analysis for Thermal and External Traits

Computes pairwise correlations between a set of thermal variables and a
set of external variables. It handles missing data gracefully, performs
multiple testing corrections, and returns detailed statistical summaries
along with correlation and p-value matrices.

## Usage

``` r
correlate_thermal_traits(
  data,
  thermal_vars,
  external_vars,
  method = "spearman",
  adjust_method = "BH",
  use = "complete.obs"
)
```

## Arguments

- data:

  A \`data.frame\` containing the variables to be analyzed.

- thermal_vars:

  A character vector specifying the column names of the thermal
  variables in \`data\`.

- external_vars:

  A character vector specifying the column names of the external
  variables in \`data\`.

- method:

  A character string indicating which correlation coefficient to
  compute. Can be either \`"spearman"\` (default) or \`"pearson"\`.

- adjust_method:

  A character string specifying the method for multiple testing
  correction. Options are \`"holm"\`, \`"hochberg"\`, \`"hommel"\`,
  \`"bonferroni"\`, \`"BH"\` (default), \`"BY"\`, \`"fdr"\`, or
  \`"none"\`.

- use:

  A character string indicating how to handle missing values. Can be
  \`"complete.obs"\` (default, uses only rows with complete data across
  all selected variables) or \`"pairwise.complete.obs"\` (uses complete
  cases on a pair-by-pair basis).

## Value

A list containing the following elements:

- results:

  A data frame with detailed pairwise statistics including variable
  names, sample size (\`n\`), correlation coefficient (\`cor\`), raw
  p-value (\`p\`), adjusted p-value (\`p_adj\`), direction, significance
  label, and any warnings.

- cor_matrix:

  A numeric matrix of the calculated correlation coefficients.

- p_matrix:

  A numeric matrix of the raw p-values.

- padj_matrix:

  A numeric matrix of the adjusted p-values.

- method:

  The correlation method used.

- adjust_method:

  The p-value adjustment method used.

- use:

  The missing data handling method used.

- use_note:

  A descriptive note regarding how missing data was actually handled.

## Examples

``` r
set.seed(1234)
df <- data.frame(
  Max = rnorm(50, 35, 2),
  Min = rnorm(50, 15, 3),
  Weight = rnorm(50, 20, 5),
  Glu = runif(50, 5, 8)
)

# Introduce a few NA values to test missing data handling
df$Weight[c(2, 10)] <- NA

# Run the correlation analysis
res <- correlate_thermal_traits(
       data = df,
       thermal_vars = c("Max", "Min"),
       external_vars = c("Weight", "Glu"),
       method = "spearman",
       adjust_method = "BH",
       use = "pairwise.complete.obs"
       )
# View the detailed results data frame
head(res$results)
#>   thermal_var external_var   method  n         cor          p     p_adj
#> 1         Max       Weight spearman 48  0.10790274 0.46538913 0.5197083
#> 2         Max          Glu spearman 50  0.27270108 0.05536452 0.2214581
#> 3         Min       Weight spearman 48  0.16261398 0.26946508 0.5197083
#> 4         Min          Glu spearman 50 -0.09320528 0.51970832 0.5197083
#>   direction significance warning
#> 1  positive           ns    <NA>
#> 2  positive           ns    <NA>
#> 3  positive           ns    <NA>
#> 4  negative           ns    <NA>

# View the correlation matrix
print(res$cor_matrix)
#>        Weight         Glu
#> Max 0.1079027  0.27270108
#> Min 0.1626140 -0.09320528
```
