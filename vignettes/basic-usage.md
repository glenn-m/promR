---
title: "Basic Usage"
date: "2019-09-07"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



# Introduction

Prometheus is an open-source software project recording real-time metrics using HTTP pull model [^1]. Prometheus records metrics in a time series database and allows for high-dimensionality. 

# Queries

The `promR` package offers `Promethous` class that provides two methods of sourcing data via instant and range query. The package also facilitates sourcing of the relevant metadata. With use of the sample host, the Prometheus class can be created in the following manner.


```r
library("promR")
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
```


## Instant

The instant query sources the data for specific timestamp. The timestamp should be of class returned by `as.POSIXct`.














