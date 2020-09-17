
<!-- README.md is generated from README.Rmd. Please edit that file -->

promR <img src="man/figures/logo.png" align="right" />
======================================================

[![Build
status](https://github.com/glenn-m/promR/workflows/R-CMD-check/badge.svg)](https://github.com/glenn-m/promR/actions)
[![Coverage
status](https://codecov.io/gh/glenn-m/promR/branch/master/graph/badge.svg)](https://codecov.io/github/glenn-m/promR?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

R library for reading and analysing metrics stored on a
[Prometheus](https://prometheus.io/) server.

Installation
------------

You can install `promR` using
[`devtools`](https://github.com/r-lib/devtools):

    if (requireNamespace("devtools", quietly = TRUE)) {
        devtools::install_github('glenn-m/promR')
    } else {
        install.packages("devtools")
        devtools::install_github('glenn-m/promR')
    }

Usage
-----

### Instant Query

To retrieve the value of the `go_goroutines` metric 60 seconds ago.

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    # Timestamps can be in rfc3339 or unix format
    metrics_instant <- prom$query(query = "go_goroutines", time = as.POSIXct(Sys.time() - 60))

**Output:**

| name           | instance                 | job          | timestamp      | port |
|:---------------|:-------------------------|:-------------|:---------------|-----:|
| go\_goroutines | demo.robustperception.io | prometheus   | 1600355179.603 | 9090 |
| go\_goroutines | demo.robustperception.io | pushgateway  | 1600355179.603 | 9091 |
| go\_goroutines | demo.robustperception.io | alertmanager | 1600355179.603 | 9093 |
| go\_goroutines | demo.robustperception.io | node         | 1600355179.603 | 9100 |

### Range Query

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_range <- prom$rangeQuery(
      query = "go_goroutines",
      start = as.numeric(as.POSIXct(Sys.time() - 600)),
      end = as.numeric(as.POSIXct(Sys.time())),
      step = "10s"
    )

**Output:** **name** instance job port timestamp value 1 go\_goroutines
demo.robustperception.io prometheus 9090 1600354640.016 74

### Metadata Query

#### Get metadata for all node exporter metrics.

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_metadata <- prom$metadataQuery(match_target = '{job="node"}')

**Output:**

| metric                                  | type    | help                                            | unit | instance                      | job  |
|:----------------------------------------|:--------|:------------------------------------------------|:-----|:------------------------------|:-----|
| node\_disk\_read\_time\_seconds\_total  | counter | The total number of seconds spent by all reads. |      | demo.robustperception.io:9100 | node |
| node\_memory\_PageTables\_bytes         | gauge   | Memory information field PageTables\_bytes.     |      | demo.robustperception.io:9100 | node |
| node\_network\_transmit\_packets\_total | counter | Network device statistic transmit\_packets.     |      | demo.robustperception.io:9100 | node |
| node\_sockstat\_UDPLITE\_inuse          | gauge   | Number of UDPLITE sockets in state inuse.       |      | demo.robustperception.io:9100 | node |
| node\_vmstat\_pswpout                   | unknown | /proc/vmstat information field pswpout.         |      | demo.robustperception.io:9100 | node |
| node\_netstat\_Udp\_SndbufErrors        | unknown | Statistic UdpSndbufErrors.                      |      | demo.robustperception.io:9100 | node |

### Get metadata for all metrics.

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_metadata <- prom$metadataQuery(match_target = '{job=~".+"}')

**Output:**

| metric                           | type    | help                                                                                        | unit | instance                      | job         |
|:---------------------------------|:--------|:--------------------------------------------------------------------------------------------|:-----|:------------------------------|:------------|
| go\_memstats\_mcache\_sys\_bytes | gauge   | Number of bytes used for mcache structures obtained from system.                            |      | demo.robustperception.io:9091 | pushgateway |
| go\_memstats\_mspan\_sys\_bytes  | gauge   | Number of bytes used for mspan structures obtained from system.                             |      | demo.robustperception.io:9091 | pushgateway |
| go\_threads                      | gauge   | Number of OS threads created.                                                               |      | demo.robustperception.io:9091 | pushgateway |
| go\_gc\_duration\_seconds        | summary | A summary of the pause duration of garbage collection cycles.                               |      | demo.robustperception.io:9091 | pushgateway |
| go\_memstats\_gc\_cpu\_fraction  | gauge   | The fraction of this program’s available CPU time used by the GC since the program started. |      | demo.robustperception.io:9091 | pushgateway |
| go\_memstats\_heap\_alloc\_bytes | gauge   | Number of heap bytes allocated and still in use.                                            |      | demo.robustperception.io:9091 | pushgateway |

Contributing
------------

1.  Fork it (
    <a href="https://github.com/glenn-m/promR/fork" class="uri">https://github.com/glenn-m/promR/fork</a>
    )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Make your changes
4.  Run `devtools::test()` to ensure tests are passing.
5.  Commit your changes (git commit -am ‘Add some feature’)
6.  Push to the branch (git push origin my-new-feature)
7.  Create a new Pull Request

Contributors
------------

-   [Glenn McDonald](https://github.com/glenn-m)
-   [Konrad Zdeb](https://github.com/konradedgar)
-   [Tyler Littlefield](https://github.com/tyluRp)
