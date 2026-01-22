# Interactive ROI Selector with Denoising (Shiny App)

Launches a Shiny GUI application that allows users to interactively
refine regions of interest (ROI) for a batch of thermal images. Key
features include dynamic temperature thresholding and an automated
"Clean Noise" tool that removes artifacts by retaining only the largest
connected object (e.g., the mouse).

## Usage

``` r
roi_filter_interactive(img_input, start_index = 1, use_processed = TRUE)
```

## Arguments

- img_input:

  A single 'BioThermR' object OR a list of 'BioThermR' objects (e.g.,
  from `read_thermal_batch`).

- start_index:

  Integer. The index of the image to start viewing. Default is 1. Useful
  for resuming work on a large batch.

- use_processed:

  Logical. If `TRUE` (default), the interactive filter is applied to the
  already 'processed' matrix (e.g., refining an auto-segmented result).
  If `FALSE`, it starts from the raw data.

## Value

The modified 'BioThermR' object (or list of objects). **Note:** You must
assign the result of this function to a variable (e.g.,
`data <- roi_filter_interactive(data)`) to save the changes.

## Details

This function opens a local web server (Shiny App). The workflow is as
follows:

1.  **Navigate:** Use "Prev/Next" buttons to browse the image batch.

2.  **Threshold:** Adjust the slider to set the min/max temperature
    range. Real-time feedback is shown on the plot.

3.  **Denoise:** Toggle the "Remove Noise" button. This applies a
    topological filter (Connected Component Analysis) that identifies
    the largest contiguous heat source and removes all smaller isolated
    islands (e.g., urine spots, reflections).

4.  **Confirm:** Click "Confirm" to lock in the settings for the current
    image and auto-advance.

5.  **Export:** Click "Finish & Export Data" to close the app and return
    the processed object list to the R console.
