
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

| X\_\_name\_\_  | instance                 | job          | timestamp      | value | port |
| :------------- | :----------------------- | :----------- | :------------- | :---- | ---: |
| go\_goroutines | demo.robustperception.io | prometheus   | 1554361300.944 | 99    | 9090 |
| go\_goroutines | demo.robustperception.io | pushgateway  | 1554361300.944 | 40    | 9091 |
| go\_goroutines | demo.robustperception.io | alertmanager | 1554361300.944 | 35    | 9093 |
| go\_goroutines | demo.robustperception.io | node         | 1554361300.944 | 7     | 9100 |

### Range query

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

| **name**            | instance                 | job        | port | timestamp      | value |
| :------------------ | :----------------------- | :--------- | ---: | :------------- | :---- |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360761.112 | 92    |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360771.112 | 92    |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360781.112 | 92    |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360791.112 | 92    |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360801.112 | 92    |
| go\_goroutines      | demo.robustperception.io | prometheus | 9090 | 1554360811.112 | 92    |
| \#\#\# Metadata Que | ry                       |            |      |                |       |

You can query the metadata API of Prometheus to get metadata about the
metrics.

#### Get metadata for all Metrics.

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics_metadata <- prom$metadataQuery(match_target = '{job=~"..*"}')
```

**Output:** target.instance target.job 1 demo.robustperception.io:9093
alertmanager 2 demo.robustperception.io:9093 alertmanager 3
demo.robustperception.io:9093 alertmanager 4
demo.robustperception.io:9093 alertmanager 5
demo.robustperception.io:9093 alertmanager 6
demo.robustperception.io:9093 alertmanager metric type 1
alertmanager\_cluster\_failed\_peers gauge 2
alertmanager\_nflog\_query\_duration\_seconds histogram 3 go\_info gauge
4 go\_memstats\_gc\_sys\_bytes gauge 5
net\_conntrack\_dialer\_conn\_failed\_total counter 6
process\_cpu\_seconds\_total counter help 1 Number indicating the
current number of failed peers in the cluster. 2 Duration of
notification log query evaluation. 3 Information about the Go
environment. 4 Number of bytes used for garbage collection system
metadata. 5 Total number of connections failed to dial by the dialer a
given name. 6 Total user and system CPU time spent in seconds. unit 1  
2  
3  
4  
5  
6

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
