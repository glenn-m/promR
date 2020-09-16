
<!-- README.md is generated from README.Rmd. Please edit that file -->

promR <img src="man/figures/logo.png" align="right" />
======================================================

[![Build
Status](https://travis-ci.org/glenn-m/promR.svg?branch=master)](https://travis-ci.org/glenn-m/promR)
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

| name           | instance                 | job          | timestamp     | port |
|:---------------|:-------------------------|:-------------|:--------------|-----:|
| go\_goroutines | demo.robustperception.io | prometheus   | 1600223086.56 | 9090 |
| go\_goroutines | demo.robustperception.io | pushgateway  | 1600223086.56 | 9091 |
| go\_goroutines | demo.robustperception.io | alertmanager | 1600223086.56 | 9093 |
| go\_goroutines | demo.robustperception.io | node         | 1600223086.56 | 9100 |

### Range Query

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_range <- prom$rangeQuery(
      query = "go_goroutines",
      start = as.numeric(as.POSIXct(Sys.time() - 600)),
      end = as.numeric(as.POSIXct(Sys.time())),
      step = "10s"
    )

**Output:**

| **name**       | instance                 | job        | port | timestamp      | value |
|:---------------|:-------------------------|:-----------|-----:|:---------------|------:|
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222546.928 |    63 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222556.928 |    66 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222566.928 |    63 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222576.928 |    63 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222586.928 |    64 |
| go\_goroutines | demo.robustperception.io | prometheus | 9090 | 1600222596.928 |    65 |

### Metadata Query

#### Get metadata for all node exporter metrics.

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_metadata <- prom$metadataQuery(match_target = '{job="node"}')

**Output:**

| metric                               | type    | help                                                               | unit | instance                      | job  |
|:-------------------------------------|:--------|:-------------------------------------------------------------------|:-----|:------------------------------|:-----|
| go\_memstats\_other\_sys\_bytes      | gauge   | Number of bytes used for other system allocations.                 |      | demo.robustperception.io:9100 | node |
| node\_netstat\_Udp6\_NoPorts         | unknown | Statistic Udp6NoPorts.                                             |      | demo.robustperception.io:9100 | node |
| node\_network\_transmit\_errs\_total | counter | Network device statistic transmit\_errs.                           |      | demo.robustperception.io:9100 | node |
| node\_sockstat\_TCP\_alloc           | gauge   | Number of TCP sockets in state alloc.                              |      | demo.robustperception.io:9100 | node |
| node\_sockstat\_TCP\_mem             | gauge   | Number of TCP sockets in state mem.                                |      | demo.robustperception.io:9100 | node |
| go\_memstats\_next\_gc\_bytes        | gauge   | Number of heap bytes when next garbage collection will take place. |      | demo.robustperception.io:9100 | node |

### Get metadata for all metrics.

    library(promR)
    prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics_metadata <- prom$metadataQuery(match_target = '{job=~".+"}')

**Output:**

| metric                                           | type    | help                                                               | unit | instance                      | job          |
|:-------------------------------------------------|:--------|:-------------------------------------------------------------------|:-----|:------------------------------|:-------------|
| alertmanager\_nflog\_snapshot\_duration\_seconds | summary | Duration of the last notification log snapshot.                    |      | demo.robustperception.io:9093 | alertmanager |
| go\_memstats\_gc\_sys\_bytes                     | gauge   | Number of bytes used for garbage collection system metadata.       |      | demo.robustperception.io:9093 | alertmanager |
| go\_memstats\_next\_gc\_bytes                    | gauge   | Number of heap bytes when next garbage collection will take place. |      | demo.robustperception.io:9093 | alertmanager |
| go\_memstats\_heap\_sys\_bytes                   | gauge   | Number of heap bytes obtained from system.                         |      | demo.robustperception.io:9093 | alertmanager |
| go\_threads                                      | gauge   | Number of OS threads created.                                      |      | demo.robustperception.io:9093 | alertmanager |
| process\_cpu\_seconds\_total                     | counter | Total user and system CPU time spent in seconds.                   |      | demo.robustperception.io:9093 | alertmanager |

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
