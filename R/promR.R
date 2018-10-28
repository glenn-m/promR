library('httr')
#'
#' @name Prometheus
#' @title Prometheus
#' @description Reference Class to interface with a Prometheus Server
#' @field host The hostname of the Prometheus server
#' @field port The port number of the Prometheus server
#' @examples
#' prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
Prometheus <- setRefClass("Prometheus", fields = list(host = "character", port = "numeric"))

#'
#' @name Prometheus_query
#' @description Run a instant query against the Prometheus Server
#' @title Prometheus Instant Query
#' @param query The PromQL query
#' @param time Evaluation timestamp, can be a rfc3339 or unix timestamp. Optional, defaults to current Prometheus server time.
#' @param timeout Evaluation timeout. Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' metrics <- prom$query(query = "up", time = "2018-10-26T20:10:51.781Z")
#' metrics <- prom$query(query = "up", time = "1540677062")
Prometheus$methods(
  query = function(query, time = 'NULL', timeout = 'NULL') {
    params <- list(query = query)

    # If time is not provided the current server time is used in query
    if (!(time == 'NULL')) {
      params <- c(params, time = time)
    }

    # If timeout is not provided it uses server default
    if (!(timeout == 'NULL')) {
      params <- c(params, timeout = timeout)
    }

    r <- GET(paste0(c(host, ":", port, "/api/v1/query"), collapse = ""),
             query = params)
    return(content(r, as = "text"))
  }
)

#'
#' @name Prometheus_rangeQuery
#' @title Promtheus Range Query
#' @description Run a range query against the Prometheus Server
#' @param query The PromQL query
#' @param start Start timestamp, can be a rfc3339 or unix timestamp.
#' @param end End timestamp, can be a rfc3339 or unix timestamp.
#' @param step Query resolution step width (e.g. 15s)
#' @param timeout Evaluation timeout. Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' rangeMetrics <- prom$rangeQuery(query = "up", start = "2018-10-25T20:10:51.781Z", end = "2018-10-26T20:10:51.781Z", step = "15s")
Prometheus$methods(
  rangeQuery = function(query, start, end, step, timeout = 'NULL') {
    params <- list(query = query, start = start, end = end, step = step)

    # If timeout is not provided it uses server default
    if (!(timeout == 'NULL')) {
      params <- c(params, timeout = timeout)
    }

    r <- GET(paste0(c(host, ":", port, "/api/v1/query_range"), collapse = ""),
             query = params)
    return(content(r, as = "text"))
  }
)
