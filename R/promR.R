#'
#' @name Prometheus
#' @title Prometheus class
#' @description Reference Class to interface with a Prometheus Server
#' @exportClass Prometheus
#' @export Prometheus
#' @import methods
#' @field host The hostname of the Prometheus server
#' @field port The port number of the Prometheus server
#' @examples
#' prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
Prometheus <-
  setRefClass("Prometheus", fields = list(host = "character", port = "numeric"))

#'
#' @name Prometheus_query
#' @title Prometheus Instant Query
#' @description Run a instant query against the Prometheus Server
#' @param query The PromQL query
#' @param time Evaluation timestamp, can be a rfc3339 or unix timestamp. Optional, defaults to current Prometheus server time.
#' @param timeout Evaluation timeout. Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' metrics <- prom$query(query = "up", time = "2018-10-26T20:10:51.781Z")
#' metrics <- prom$query(query = "up", time = "1540677062")
Prometheus$methods(
  query = function(query,
                   time = NULL,
                   timeout = NULL) {
    params <- list(query = query)

    # If time is not provided the current server time is used in query
    if (!is.null(time)) {
      params <- c(params, time = time)
    }

    # If timeout is not provided it uses server default
    if (!is.null(time)) {
      params <- c(params, timeout = timeout)
    }

    r <-
      httr::GET(paste0(c(host, ":", port, "/api/v1/query"), collapse = ""),
                query = params)
    metricsRaw <-
      jsonlite::fromJSON(httr::content(r, as = "text", encoding = "utf-8"))
    metrics <- data.frame(metricsRaw$data$result$metric)
    for (row in 1:nrow(metrics)) {
      metrics$timestamp[[row]] <- metricsRaw$data$result$value[[row]][1]
      metrics$value[[row]] <- metricsRaw$data$result$value[[row]][2]
    }
    return(metrics)
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
  rangeQuery = function(query, start, end, step, timeout = NULL) {
    params <- list(
      query = query,
      start = start,
      end = end,
      step = step
    )

    # If timeout is not provided it uses server default
    if (!is.null(timeout)) {
      params <- c(params, timeout = timeout)
    }

    r <-
      httr::GET(paste0(c(host, ":", port, "/api/v1/query_range"), collapse = ""),
                query = params)
    metricsRaw <-
      jsonlite::fromJSON(httr::content(r, as = "text", encoding = "utf-8"))
    metrics <- data.frame(metricsRaw$data$result)
    return(metrics)
  }
)
