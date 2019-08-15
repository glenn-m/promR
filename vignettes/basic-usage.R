## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  collapse = TRUE,
  comment = "#>"
)

# Enable httptest for vignette development
library(httptest)
start_vignette("basic-usage")

# Load package
library("promR")

## ----example_class-------------------------------------------------------
# library("promR")
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)

## ----example_instant-----------------------------------------------------
# Timestamps can be in rfc3339 or unix format
metrics_instant <- prom$query(query = "go_goroutines", 
                              time = as.POSIXct("2019-08-11 12:25:57 BST"))

## ----show_instant_results, echo=FALSE------------------------------------
knitr::kable(metrics_instant)

## ----example_range-------------------------------------------------------
metrics_range <- prom$rangeQuery(
  query = "go_goroutines",
  start = as.numeric(as.POSIXct("2019-08-11 12:20:32 BST")),
  end = as.numeric(as.POSIXct("2019-08-11 12:30:46 BST")),
  step = "10s"
)

## ----show_range_results, echo=FALSE--------------------------------------
knitr::kable(head(metrics_range))

## ----metadata_example----------------------------------------------------
metrics_metadata <- prom$metadataQuery(match_target = '{job="node"}')

## ----show_metadata_example-----------------------------------------------
knitr::kable(head(metrics_metadata))

## ----end-setup, include=FALSE--------------------------------------------
# Close httptes vignette support
end_vignette()

