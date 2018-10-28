# promR

R library for reading and analysing metrics stored on a Prometheus server.

## Installation

```r
if (requireNamespace("devtools", quietly = TRUE)) {
    devtools::install_github('glenn-m/promR')
} else {
    install.packages("devtools")
    devtools::install_github('glenn-m/R')
}
```

## Usage
Query to retrieve the services up currently. 

```R
prom <- Prometheus$new(host = "http://prometheus", port = 9090)
metrics <- prom$query(query = "up", time = "2018-10-26T20:10:51.781Z")
```
