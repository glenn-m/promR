
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

To retrieve the value of the `http_requests_total` metric at
`2018-10-26T20:10:51.781Z`

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics <- prom$query(query = "go_goroutines", 
                      time = format(Sys.time(),  "%Y-%m-%dT%H:%M:%SZ"))
```

**Output:**

| X\_\_name\_\_  | instance                      | job          | timestamp  | value |
| :------------- | :---------------------------- | :----------- | :--------- | :---- |
| go\_goroutines | demo.robustperception.io:9090 | prometheus   | 1553953021 | 84    |
| go\_goroutines | demo.robustperception.io:9091 | pushgateway  | 1553953021 | 40    |
| go\_goroutines | demo.robustperception.io:9093 | alertmanager | 1553953021 | 34    |
| go\_goroutines | demo.robustperception.io:9100 | node         | 1553953021 | 7     |

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
