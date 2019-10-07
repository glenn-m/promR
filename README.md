
<!-- README.md is generated from README.Rmd. Please edit that file -->

# promR <img src="man/figures/logo.png" align="right" />

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
| :------------- | :----------------------- | :----------- | :------------- | ----: | ---: |
| go\_goroutines | demo.robustperception.io | prometheus   | 1556402510.823 |    93 | 9090 |
| go\_goroutines | demo.robustperception.io | pushgateway  | 1556402510.823 |    43 | 9091 |
| go\_goroutines | demo.robustperception.io | alertmanager | 1556402510.823 |    34 | 9093 |
| go\_goroutines | demo.robustperception.io | node         | 1556402510.823 |    10 | 9100 |

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
| :------------- | :----------------------- | :--------- | ---: | :------------- | ----: |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556401970.999 |    97 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556401980.999 |    96 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556401990.999 |    96 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556402000.999 |    96 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556402010.999 |    96 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1556402020.999 |    96 |

### Metadata Query

#### Get metadata for all node exporter metrics.

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics_metadata <- prom$metadataQuery(match_target = '{job="node"}')
```

**Output:**

| metric                                    | type    | help                                                     | unit | instance                      | job  |
| :---------------------------------------- | :------ | :------------------------------------------------------- | :--- | :---------------------------- | :--- |
| node\_timex\_pps\_shift\_seconds          | gauge   | Pulse per second interval duration.                      |      | demo.robustperception.io:9100 | node |
| process\_virtual\_memory\_max\_bytes      | gauge   | Maximum amount of virtual memory available in bytes.     |      | demo.robustperception.io:9100 | node |
| node\_network\_receive\_compressed\_total | counter | Network device statistic receive\_compressed.            |      | demo.robustperception.io:9100 | node |
| node\_network\_carrier\_changes\_total    | counter | carrier\_changes\_total value of /sys/class/net/<iface>. |      | demo.robustperception.io:9100 | node |
| node\_vmstat\_pgpgout                     | unknown | /proc/vmstat information field pgpgout.                  |      | demo.robustperception.io:9100 | node |
| node\_vmstat\_pswpout                     | unknown | /proc/vmstat information field pswpout.                  |      | demo.robustperception.io:9100 | node |

### Get metadata for all metrics.

``` r
library(promR)
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
metrics_metadata <- prom$metadataQuery(match_target = '{job=~".+"}')
```

**Output:**

| metric                           | type    | help                                                    | unit | instance                      | job  |
| :------------------------------- | :------ | :------------------------------------------------------ | :--- | :---------------------------- | :--- |
| go\_memstats\_alloc\_bytes       | gauge   | Number of bytes allocated and still in use.             |      | demo.robustperception.io:9100 | node |
| node\_timex\_pps\_jitter\_total  | counter | Pulse per second count of jitter limit exceeded events. |      | demo.robustperception.io:9100 | node |
| go\_threads                      | gauge   | Number of OS threads created.                           |      | demo.robustperception.io:9100 | node |
| node\_cpu\_guest\_seconds\_total | counter | Seconds the cpus spent in guests (VMs) for each mode.   |      | demo.robustperception.io:9100 | node |
| node\_memory\_CmaFree\_bytes     | gauge   | Memory information field CmaFree\_bytes.                |      | demo.robustperception.io:9100 | node |
| node\_netstat\_Tcp\_RetransSegs  | unknown | Statistic TcpRetransSegs.                               |      | demo.robustperception.io:9100 | node |

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
