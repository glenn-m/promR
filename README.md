
<!-- README.md is generated from README.Rmd. Please edit that file -->

# promR

[![Build
Status](https://travis-ci.org/glenn-m/promR.svg?branch=master)](https://travis-ci.org/glenn-m/promR)
[![Coverage
status](https://codecov.io/gh/glenn-m/promR/branch/master/graph/badge.svg)](https://codecov.io/github/glenn-m/promR?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

R library for reading and analysing metrics stored on a
[Prometheus](https://prometheus.io/) server.

## Installation

You can install `promR` using
[`devtools`](https://github.com/r-lib/devtools):

``` r
if (requireNamespace("devtools", quietly = TRUE)) {
    devtools::install_github('glenn-m/promR')
} else {
    install.packages("devtools")
    devtools::install_github('glenn-m/promR')
}
```

## Usage

### Instant Query

To retrieve the value of the `go_goroutines` metric 60 seconds ago.

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
# Timestamps can be in rfc3339 or unix format
metrics_instant <- prom$query(query = "go_goroutines", time = as.POSIXct(Sys.time() - 60))
```

**Output:**

| name           | instance                 | job          | timestamp      | value | port |
| :------------- | :----------------------- | :----------- | :------------- | :---- | ---: |
| go\_goroutines | demo.robustperception.io | prometheus   | 1556034455.403 | 95    | 9090 |
| go\_goroutines | demo.robustperception.io | pushgateway  | 1556034455.403 | 42    | 9091 |
| go\_goroutines | demo.robustperception.io | alertmanager | 1556034455.403 | 34    | 9093 |
| go\_goroutines | demo.robustperception.io | node         | 1556034455.403 | 9     | 9100 |

### Range Query

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics_range <- prom$rangeQuery(
  query = "go_goroutines",
  start = as.numeric(as.POSIXct(Sys.time() - 600)),
  end = as.numeric(as.POSIXct(Sys.time())),
  step = "10s"
)
```

**Output:**

| **name**       | instance                 | job        | port | timestamp      | value |
| :------------- | :----------------------- | :--------- | ---: | :------------- | :---- |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033915.739 | 95    |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033925.739 | 95    |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033935.739 | 95    |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033945.739 | 96    |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033955.739 | 95    |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556033965.739 | 95    |

## Contributing

1.  Fork it ( <https://github.com/glenn-m/promR/fork> )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Make your changes
4.  Run `devtools::test()` to ensure tests are passing.
5.  Commit your changes (git commit -am ‘Add some feature’)
6.  Push to the branch (git push origin my-new-feature)
7.  Create a new Pull Request

## Contributors

  - [Glenn McDonald](https://github.com/glenn-m)
  - [Konrad Zdeb](https://github.com/konradedgar)
  - [Tyler Littlefield](https://github.com/tyluRp)
