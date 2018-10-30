
<!-- README.md is generated from README.Rmd. Please edit that file -->

# promR

[![Build
Status](https://travis-ci.org/glenn-m/promR.svg?branch=master)](https://travis-ci.org/glenn-m/promR)
[![Coverage
status](https://codecov.io/gh/glenn-m/promR/branch/master/graph/badge.svg)](https://codecov.io/github/glenn-m/promR?branch=master)

R library for reading and analysing metrics stored on a Prometheus
server.

## Installation

``` r
if (requireNamespace("devtools", quietly = TRUE)) {
    devtools::install_github('glenn-m/promR')
} else {
    install.packages("devtools")
    devtools::install_github('glenn-m/R')
}
```

## Usage

To retrieve the current value of the `http_requests_total` metric

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics <- prom$query(query = "http_requests_total", time = "2018-10-26T20:10:51.781Z")
```

**Output:**

| X\_\_name\_\_         | code | handler    | instance                      | job         | method | timestamp      | value   |
| :-------------------- | :--- | :--------- | :---------------------------- | :---------- | :----- | :------------- | :------ |
| http\_requests\_total | 200  | prometheus | demo.robustperception.io:9091 | pushgateway | get    | 1540584651.781 | 2280738 |
| http\_requests\_total | 200  | static     | demo.robustperception.io:9091 | pushgateway | get    | 1540584651.781 | 5745    |
| http\_requests\_total | 200  | status     | demo.robustperception.io:9091 | pushgateway | get    | 1540584651.781 | 2268    |
| http\_requests\_total | 202  | delete     | demo.robustperception.io:9091 | pushgateway | delete | 1540584651.781 | 50      |
| http\_requests\_total | 202  | push       | demo.robustperception.io:9091 | pushgateway | post   | 1540584651.781 | 21      |
| http\_requests\_total | 202  | push       | demo.robustperception.io:9091 | pushgateway | put    | 1540584651.781 | 142551  |

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
