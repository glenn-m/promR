## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----example_instant, echo=TRUE, eval=TRUE, cache=TRUE-------------------
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
# Timestamps can be in rfc3339 or unix format
metrics_instant <- prom$query(query = "go_goroutines", time = as.POSIXct(Sys.time() - 60))

## ----example_instant_object, echo=FALSE, eval=TRUE, cache=TRUE-----------
knitr::kable(head(metrics_instant))

