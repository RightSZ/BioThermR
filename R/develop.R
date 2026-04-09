#' Correlate thermal features with external traits
#'
#' Perform pairwise correlation analyses between thermal imaging-derived
#' variables and external phenotypic or experimental variables.
#'
#' This function is designed for sample-level data, typically generated after
#' thermal feature extraction, repeated-measurement aggregation (if needed),
#' and integration with external data (e.g., via `merge_clinical_data()`).
#'
#' @param data A data.frame containing both thermal variables and external variables.
#' @param thermal_vars A character vector of column names in `data` corresponding
#'   to thermal imaging features.
#' @param external_vars A character vector of column names in `data` corresponding
#'   to external traits or phenotypic variables.
#' @param method Correlation method. One of `"spearman"` or `"pearson"`.
#'   Default is `"spearman"`.
#' @param adjust_method Multiple testing correction method passed to
#'   [stats::p.adjust()]. Default is `"BH"`.
#' @param use A character string specifying how to handle missing values.
#'   One of `"complete.obs"` or `"pairwise.complete.obs"`. Default is `"complete.obs"`.
#'
#' @return A list with the following elements:
#' \describe{
#'   \item{results}{A data.frame of pairwise correlation results.}
#'   \item{cor_matrix}{A numeric matrix of correlation coefficients
#'     (rows = thermal variables, columns = external variables).}
#'   \item{p_matrix}{A numeric matrix of raw p-values.}
#'   \item{padj_matrix}{A numeric matrix of adjusted p-values.}
#'   \item{method}{The correlation method used.}
#'   \item{adjust_method}{The multiple-testing correction method used.}
#'   \item{use}{The missing-value handling mode used.}
#' }
#'
#' @details
#' Each thermal variable is correlated with each external variable. For each pair,
#' the function returns the sample size used (`n`), correlation coefficient (`cor`),
#' raw p-value (`p`), and adjusted p-value (`p_adj`).
#'
#' For `use = "complete.obs"`, each variable pair is analyzed after restricting
#' to observations with complete data for that pair.
#'
#' For `use = "pairwise.complete.obs"`, pairwise complete observations are also used.
#' In practice, the current implementation computes each pair using complete cases
#' for that specific variable pair, which is appropriate for pairwise testing.
#'
#' @examples
#' set.seed(123)
#' df <- data.frame(
#'   mean_temp = rnorm(10, 35, 0.5),
#'   median_temp = rnorm(10, 34.8, 0.4),
#'   iqr_temp = rnorm(10, 1.2, 0.2),
#'   body_weight = rnorm(10, 25, 2),
#'   glucose = rnorm(10, 7, 1),
#'   alt = rnorm(10, 40, 8)
#' )
#'
#' res <- correlate_thermal_traits(
#'   data = df,
#'   thermal_vars = c("mean_temp", "median_temp", "iqr_temp"),
#'   external_vars = c("body_weight", "glucose", "alt"),
#'   method = "spearman",
#'   adjust_method = "BH",
#'   use = "complete.obs"
#' )
#'
#' res$results
#' res$cor_matrix
#'
#' @export
correlate_thermal_traits <- function(
    data,
    thermal_vars,
    external_vars,
    method = "spearman",
    adjust_method = "BH",
    use = "complete.obs"
) {
  # -----------------------------
  # Input validation
  # -----------------------------
  if (!is.data.frame(data)) {
    stop("`data` must be a data.frame.", call. = FALSE)
  }

  if (missing(thermal_vars) || length(thermal_vars) == 0) {
    stop("`thermal_vars` must be a non-empty character vector.", call. = FALSE)
  }

  if (missing(external_vars) || length(external_vars) == 0) {
    stop("`external_vars` must be a non-empty character vector.", call. = FALSE)
  }

  if (!is.character(thermal_vars)) {
    stop("`thermal_vars` must be a character vector of column names.", call. = FALSE)
  }

  if (!is.character(external_vars)) {
    stop("`external_vars` must be a character vector of column names.", call. = FALSE)
  }

  method <- match.arg(method, choices = c("spearman", "pearson"))
  use <- match.arg(use, choices = c("complete.obs", "pairwise.complete.obs"))

  missing_thermal <- setdiff(thermal_vars, colnames(data))
  if (length(missing_thermal) > 0) {
    stop(
      sprintf(
        "The following `thermal_vars` are not found in `data`: %s",
        paste(missing_thermal, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  missing_external <- setdiff(external_vars, colnames(data))
  if (length(missing_external) > 0) {
    stop(
      sprintf(
        "The following `external_vars` are not found in `data`: %s",
        paste(missing_external, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  duplicated_vars <- intersect(thermal_vars, external_vars)
  if (length(duplicated_vars) > 0) {
    warning(
      sprintf(
        "Some variables appear in both `thermal_vars` and `external_vars`: %s",
        paste(duplicated_vars, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  # Check whether all selected variables are numeric
  selected_vars <- unique(c(thermal_vars, external_vars))
  non_numeric <- selected_vars[!vapply(data[selected_vars], is.numeric, logical(1))]
  if (length(non_numeric) > 0) {
    stop(
      sprintf(
        "All selected variables must be numeric. Non-numeric columns detected: %s",
        paste(non_numeric, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  # Validate p.adjust method early
  valid_adjust_methods <- c(
    "holm", "hochberg", "hommel", "bonferroni",
    "BH", "BY", "fdr", "none"
  )
  if (!adjust_method %in% valid_adjust_methods) {
    stop(
      sprintf(
        "`adjust_method` must be one of: %s",
        paste(valid_adjust_methods, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  # -----------------------------
  # Initialize containers
  # -----------------------------
  n_thermal <- length(thermal_vars)
  n_external <- length(external_vars)

  cor_matrix <- matrix(
    NA_real_,
    nrow = n_thermal,
    ncol = n_external,
    dimnames = list(thermal_vars, external_vars)
  )

  p_matrix <- matrix(
    NA_real_,
    nrow = n_thermal,
    ncol = n_external,
    dimnames = list(thermal_vars, external_vars)
  )

  results_list <- vector("list", length = n_thermal * n_external)
  idx <- 1L

  # -----------------------------
  # Pairwise correlation analysis
  # -----------------------------
  for (tv in thermal_vars) {
    for (ev in external_vars) {
      x <- data[[tv]]
      y <- data[[ev]]

      # Pairwise complete-case handling
      keep <- stats::complete.cases(x, y)

      x_sub <- x[keep]
      y_sub <- y[keep]
      n_used <- length(x_sub)

      # Default output for failed/insufficient pairs
      cor_est <- NA_real_
      p_val <- NA_real_
      warn_msg <- NA_character_

      # Minimum sample size check
      if (n_used < 3) {
        warn_msg <- "Too few complete observations (< 3) for correlation testing."
      } else if (stats::sd(x_sub) == 0 || stats::sd(y_sub) == 0) {
        warn_msg <- "At least one variable has zero variance; correlation is undefined."
      } else {
        test_res <- tryCatch(
          stats::cor.test(
            x = x_sub,
            y = y_sub,
            method = method,
            exact = if (method == "spearman") FALSE else NULL
          ),
          error = function(e) e
        )

        if (inherits(test_res, "error")) {
          warn_msg <- conditionMessage(test_res)
        } else {
          cor_est <- unname(test_res$estimate)
          p_val <- unname(test_res$p.value)
        }
      }

      cor_matrix[tv, ev] <- cor_est
      p_matrix[tv, ev] <- p_val

      direction <- if (is.na(cor_est)) {
        NA_character_
      } else if (cor_est > 0) {
        "positive"
      } else if (cor_est < 0) {
        "negative"
      } else {
        "zero"
      }

      results_list[[idx]] <- data.frame(
        thermal_var = tv,
        external_var = ev,
        method = method,
        n = n_used,
        cor = cor_est,
        p = p_val,
        direction = direction,
        warning = warn_msg,
        stringsAsFactors = FALSE
      )

      idx <- idx + 1L
    }
  }

  results_df <- do.call(rbind, results_list)

  # -----------------------------
  # Multiple testing correction
  # -----------------------------
  valid_p <- !is.na(results_df$p)
  results_df$p_adj <- NA_real_

  if (any(valid_p)) {
    results_df$p_adj[valid_p] <- stats::p.adjust(
      p = results_df$p[valid_p],
      method = adjust_method
    )
  }

  # Significance labels
  results_df$significance <- vapply(
    results_df$p_adj,
    FUN.VALUE = character(1),
    FUN = function(pv) {
      if (is.na(pv)) {
        ""
      } else if (pv < 0.001) {
        "***"
      } else if (pv < 0.01) {
        "**"
      } else if (pv < 0.05) {
        "*"
      } else {
        "ns"
      }
    }
  )

  # Build adjusted p-value matrix
  padj_matrix <- matrix(
    NA_real_,
    nrow = n_thermal,
    ncol = n_external,
    dimnames = list(thermal_vars, external_vars)
  )

  for (i in seq_len(nrow(results_df))) {
    padj_matrix[results_df$thermal_var[i], results_df$external_var[i]] <- results_df$p_adj[i]
  }

  # Optional: preserve requested `use` in output metadata.
  # Current implementation uses pairwise complete cases for each tested pair,
  # which is statistically appropriate for pairwise correlation testing.
  if (use == "complete.obs") {
    use_note <- "Pairwise complete cases were used for each variable pair."
  } else {
    use_note <- "Pairwise complete cases were used for each variable pair."
  }

  # Reorder columns for readability
  results_df <- results_df[, c(
    "thermal_var", "external_var", "method", "n",
    "cor", "p", "p_adj", "direction", "significance", "warning"
  )]

  rownames(results_df) <- NULL

  # -----------------------------
  # Return
  # -----------------------------
  out <- list(
    results = results_df,
    cor_matrix = cor_matrix,
    p_matrix = p_matrix,
    padj_matrix = padj_matrix,
    method = method,
    adjust_method = adjust_method,
    use = use,
    use_note = use_note
  )

  class(out) <- c("thermal_correlation_result", class(out))
  return(out)
}


#' Plot a thermal correlation heatmap
#'
#' Visualize pairwise correlations between thermal imaging-derived variables
#' and external traits as a heatmap.
#'
#' This function is designed to work with the output of
#' `correlate_thermal_traits()`.
#'
#' @param cor_result A result object returned by `correlate_thermal_traits()`,
#'   or a data.frame containing at least the columns:
#'   `thermal_var`, `external_var`, `cor`, and optionally `p`, `p_adj`,
#'   `significance`.
#' @param use_adjusted Logical. If `TRUE`, significance labels are based on
#'   adjusted p-values (`p_adj`) when available. Default is `TRUE`.
#' @param show_significance Logical. If `TRUE`, significance labels are
#'   displayed on the heatmap. Default is `TRUE`.
#' @param sig_levels Numeric vector of length 3 defining cutoffs for
#'   `"*"`, `"**"`, and `"***"`, respectively. Default is
#'   `c(0.05, 0.01, 0.001)`.
#' @param sig_ns_label Label used for non-significant results. Default is `""`.
#' @param low Color for negative correlations. Default is `"#3B82F6"`.
#' @param mid Color for zero correlation. Default is `"white"`.
#' @param high Color for positive correlations. Default is `"#EF4444"`.
#' @param midpoint Midpoint for the color scale. Default is `0`.
#' @param limits Numeric vector of length 2 for fill scale limits.
#'   Default is `c(-1, 1)`.
#' @param tile_color Border color for heatmap tiles. Default is `"grey85"`.
#' @param tile_size Border line width for tiles. Default is `0.4`.
#' @param rotate_x Angle for x-axis text. Default is `45`.
#' @param text_size Font size for significance labels. Default is `4`.
#' @param na_fill Fill color for missing values. Default is `"grey95"`.
#'
#' @return A ggplot object.
#'
#' @examples
#' # Assuming `res <- correlate_thermal_traits(...)`
#' # p <- plot_thermal_correlation_heatmap(res)
#' # print(p)
#'
#' @export
plot_thermal_correlation_heatmap <- function(
    cor_result,
    use_adjusted = TRUE,
    show_significance = TRUE,
    sig_levels = c(0.05, 0.01, 0.001),
    sig_ns_label = "",
    low = "#3B82F6",
    mid = "white",
    high = "#EF4444",
    midpoint = 0,
    limits = c(-1, 1),
    tile_color = "grey85",
    tile_size = 0.4,
    rotate_x = 45,
    text_size = 4,
    na_fill = "grey95"
) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package `ggplot2` is required but not installed.", call. = FALSE)
  }

  # -----------------------------
  # Validate sig_levels
  # -----------------------------
  if (!is.numeric(sig_levels) || length(sig_levels) != 3) {
    stop("`sig_levels` must be a numeric vector of length 3.", call. = FALSE)
  }

  # Ensure order: * > ** > ***
  sig_levels <- sort(sig_levels, decreasing = TRUE)

  # -----------------------------
  # Extract results table
  # -----------------------------
  if (inherits(cor_result, "thermal_correlation_result")) {
    df <- cor_result$results
  } else if (is.data.frame(cor_result)) {
    df <- cor_result
  } else {
    stop(
      "`cor_result` must be either a `thermal_correlation_result` object or a data.frame.",
      call. = FALSE
    )
  }

  required_cols <- c("thermal_var", "external_var", "cor")
  missing_cols <- setdiff(required_cols, colnames(df))
  if (length(missing_cols) > 0) {
    stop(
      sprintf(
        "Missing required columns in `cor_result`: %s",
        paste(missing_cols, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  # -----------------------------
  # Determine significance source
  # -----------------------------
  p_col <- NULL
  if (use_adjusted && "p_adj" %in% colnames(df)) {
    p_col <- "p_adj"
  } else if ("p" %in% colnames(df)) {
    p_col <- "p"
  }

  # -----------------------------
  # Build significance labels
  # -----------------------------
  if (show_significance) {
    if (!is.null(p_col)) {
      df$label <- vapply(
        df[[p_col]],
        FUN.VALUE = character(1),
        FUN = function(pv) {
          if (is.na(pv)) {
            ""
          } else if (pv < sig_levels[3]) {
            "***"
          } else if (pv < sig_levels[2]) {
            "**"
          } else if (pv < sig_levels[1]) {
            "*"
          } else {
            sig_ns_label
          }
        }
      )
    } else if ("significance" %in% colnames(df)) {
      df$label <- df$significance
      df$label[is.na(df$label)] <- ""
      if (!identical(sig_ns_label, "ns")) {
        df$label[df$label == "ns"] <- sig_ns_label
      }
    } else {
      df$label <- ""
    }
  } else {
    df$label <- ""
  }

  # -----------------------------
  # Preserve variable order
  # -----------------------------
  thermal_levels <- unique(df$thermal_var)
  external_levels <- unique(df$external_var)

  df$thermal_var <- factor(df$thermal_var, levels = thermal_levels)
  df$external_var <- factor(df$external_var, levels = external_levels)

  # -----------------------------
  # Plot
  # -----------------------------
  p <- ggplot2::ggplot(
    df,
    ggplot2::aes(x = external_var, y = thermal_var, fill = cor)
  ) +
    ggplot2::geom_tile(
      color = tile_color,
      linewidth = tile_size
    ) +
    ggplot2::scale_fill_gradient2(
      low = low,
      mid = mid,
      high = high,
      midpoint = midpoint,
      limits = limits,
      na.value = na_fill,
      name = "Correlation"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(
        angle = rotate_x,
        hjust = 1,
        vjust = 1
      ),
      axis.text.y = ggplot2::element_text(hjust = 1)
    )

  if (show_significance) {
    p <- p +
      ggplot2::geom_text(
        ggplot2::aes(label = label),
        size = text_size
      )
  }

  return(p)
}

#' Plot correlation between one thermal feature and one external trait
#'
#' Create a scatter plot for a single pair of variables and annotate the plot
#' with the correlation coefficient, p-value, and sample size.
#'
#' This function is intended for sample-level data, typically after thermal
#' feature extraction, repeated-measurement aggregation, and optional merging
#' with external phenotypic or clinical data.
#'
#' @param data A data.frame containing the variables to be plotted.
#' @param x A character string specifying the x-axis variable name.
#' @param y A character string specifying the y-axis variable name.
#' @param method Correlation method. One of `"spearman"` or `"pearson"`.
#'   Default is `"spearman"`.
#' @param group_var Optional character string specifying a grouping variable
#'   for point color mapping. Default is `NULL`.
#' @param use A character string specifying how to handle missing values.
#'   One of `"complete.obs"` or `"pairwise.complete.obs"`. Default is `"complete.obs"`.
#' @param add_smooth Logical. If `TRUE`, add a linear regression line with
#'   confidence interval. Default is `TRUE`.
#' @param smooth_method Method for smoothing line. Default is `"lm"`.
#' @param point_size Numeric. Size of points. Default is `2.5`.
#' @param alpha Numeric. Point transparency. Default is `0.8`.
#' @param show_stats Logical. If `TRUE`, annotate the plot with correlation
#'   statistics. Default is `TRUE`.
#' @param digits Integer. Number of digits for correlation coefficient and
#'   p-value formatting. Default is `3`.
#' @param annotation_x Numeric between 0 and 1 giving the x position of the
#'   annotation in npc coordinates. Default is `0.05`.
#' @param annotation_y Numeric between 0 and 1 giving the y position of the
#'   annotation in npc coordinates. Default is `0.95`.
#' @param xlab Optional x-axis label. Default is `NULL`, which uses `x`.
#' @param ylab Optional y-axis label. Default is `NULL`, which uses `y`.
#' @param title Optional plot title. Default is `NULL`.
#'
#' @return A ggplot object.
#'
#' @examples
#' set.seed(123)
#' df <- data.frame(
#'   mean_temp = rnorm(10, 35, 0.5),
#'   body_weight = rnorm(10, 25, 2),
#'   group = rep(c("ND", "ND4"), each = 5)
#' )
#'
#' p <- plot_thermal_correlation(
#'   data = df,
#'   x = "mean_temp",
#'   y = "body_weight",
#'   method = "spearman",
#'   group_var = "group"
#' )
#' print(p)
#'
#' @export
plot_thermal_correlation <- function(
    data,
    x,
    y,
    method = "spearman",
    group_var = NULL,
    use = "complete.obs",
    add_smooth = TRUE,
    smooth_method = "lm",
    point_size = 2.5,
    alpha = 0.8,
    show_stats = TRUE,
    digits = 3,
    annotation_x = 0.05,
    annotation_y = 0.95,
    xlab = NULL,
    ylab = NULL,
    title = NULL
) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package `ggplot2` is required but not installed.", call. = FALSE)
  }

  if (!is.data.frame(data)) {
    stop("`data` must be a data.frame.", call. = FALSE)
  }

  if (!is.character(x) || length(x) != 1L) {
    stop("`x` must be a single character string.", call. = FALSE)
  }

  if (!is.character(y) || length(y) != 1L) {
    stop("`y` must be a single character string.", call. = FALSE)
  }

  if (!x %in% colnames(data)) {
    stop(sprintf("Column `%s` not found in `data`.", x), call. = FALSE)
  }

  if (!y %in% colnames(data)) {
    stop(sprintf("Column `%s` not found in `data`.", y), call. = FALSE)
  }

  if (!is.numeric(data[[x]])) {
    stop(sprintf("Column `%s` must be numeric.", x), call. = FALSE)
  }

  if (!is.numeric(data[[y]])) {
    stop(sprintf("Column `%s` must be numeric.", y), call. = FALSE)
  }

  method <- match.arg(method, choices = c("spearman", "pearson"))
  use <- match.arg(use, choices = c("complete.obs", "pairwise.complete.obs"))

  if (!is.null(group_var)) {
    if (!is.character(group_var) || length(group_var) != 1L) {
      stop("`group_var` must be a single character string or NULL.", call. = FALSE)
    }
    if (!group_var %in% colnames(data)) {
      stop(sprintf("Column `%s` not found in `data`.", group_var), call. = FALSE)
    }
  }

  # Use complete cases for the variables involved in plotting/testing
  vars_needed <- c(x, y, group_var)
  vars_needed <- vars_needed[!is.null(vars_needed)]
  vars_needed <- unique(vars_needed)

  plot_df <- data[, vars_needed, drop = FALSE]
  keep <- stats::complete.cases(plot_df)
  plot_df <- plot_df[keep, , drop = FALSE]

  n_used <- nrow(plot_df)

  if (n_used < 3) {
    stop("Too few complete observations (< 3) to compute correlation.", call. = FALSE)
  }

  if (stats::sd(plot_df[[x]]) == 0 || stats::sd(plot_df[[y]]) == 0) {
    stop("At least one variable has zero variance; correlation is undefined.", call. = FALSE)
  }

  test_res <- stats::cor.test(
    x = plot_df[[x]],
    y = plot_df[[y]],
    method = method,
    exact = if (method == "spearman") FALSE else NULL
  )

  cor_est <- unname(test_res$estimate)
  p_val <- unname(test_res$p.value)

  cor_label <- if (method == "spearman") "rho" else "r"

  format_p <- function(p, digits = 3) {
    if (is.na(p)) {
      return("NA")
    }
    if (p < 10^(-digits)) {
      return(sprintf("< %s", format(10^(-digits), scientific = TRUE)))
    }
    sprintf(paste0("%.", digits, "f"), p)
  }

  stat_text <- paste0(
    cor_label, " = ", sprintf(paste0("%.", digits, "f"), cor_est),
    "\nP = ", format_p(p_val, digits = digits),
    "\nN = ", n_used
  )

  if (is.null(xlab)) xlab <- x
  if (is.null(ylab)) ylab <- y

  if (is.null(group_var)) {
    p <- ggplot2::ggplot(
      plot_df,
      ggplot2::aes(x = .data[[x]], y = .data[[y]])
    ) +
      ggplot2::geom_point(size = point_size, alpha = alpha)
  } else {
    p <- ggplot2::ggplot(
      plot_df,
      ggplot2::aes(x = .data[[x]], y = .data[[y]], color = .data[[group_var]])
    ) +
      ggplot2::geom_point(size = point_size, alpha = alpha)
  }

  if (add_smooth) {
    if (is.null(group_var)) {
      p <- p + ggplot2::geom_smooth(
        method = smooth_method,
        formula = y ~ x,
        se = TRUE
      )
    } else {
      p <- p + ggplot2::geom_smooth(
        ggplot2::aes(group = 1),
        method = smooth_method,
        formula = y ~ x,
        se = TRUE,
        inherit.aes = FALSE,
        data = plot_df,
        mapping = ggplot2::aes(x = .data[[x]], y = .data[[y]])
      )
    }
  }

  p <- p +
    ggplot2::labs(
      x = xlab,
      y = ylab,
      title = title,
      color = group_var
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank()
    )

  if (show_stats) {
    p <- p + ggplot2::annotate(
      geom = "text",
      x = -Inf,
      y = Inf,
      label = stat_text,
      hjust = annotation_x,
      vjust = annotation_y,
      size = 4
    )
  }

  return(p)
}
