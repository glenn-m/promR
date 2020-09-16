#' @title Prometheus class
#' @description Reference Class to interface with a Prometheus Server
#'
#' \if{html}{\figure{logo.png}{options: alt="promR logo" align="right"}}
#'
#' @exportClass Prometheus
#' @export Prometheus
#' @field host The hostname of the Prometheus server
#' @field port The port number of the Prometheus server
#' @name Prometheus-class
#' @rdname Prometheus-class
#' @examples
#' \dontrun{
#'  prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
#' }
Prometheus <-
  setRefClass("Prometheus", fields = list(host = "character", port = "numeric"))

#' @name Prometheus_query
#' @title Prometheus Instant Query
#' @description Run a instant query against the Prometheus Server
#' @param query The PromQL query
#' @param time Evaluation timestamp, can be a rfc3339 or Unix timestamp. Optional, defaults to current Prometheus server time.
#' @param timeout Evaluation timeout (e.g. 1h, 1.5m or 15s). Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' \dontrun{
#'  prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
#'  metrics <- prom$query(query = "up", time = "2018-10-26T20:10:51.781Z")
#'  metrics <- prom$query(query = "up", time = "1540677062")
#' }
Prometheus$methods(
  query = function(query,
                   time = NULL,
                   timeout = NULL) {
    'Run an instant query
    '
    params <- list(query = query)

    # If time is not provided the current server time is used in query
    if (!is.null(time)) {
      params <- c(params, time = time)
    }

    # If timeout is not provided it uses server default
    if (missing(timeout)) {
      params <- c(params, timeout = timeout)
    } else {
      params <- c(params, timeout = parse_timeout(timeout))
    }

    r <-
      httr::GET(paste0(c(host, ":", port, "/api/v1/query"), collapse = ""),
                query = params)

    # Check for particular status codes in response
    response_check(r)
    metricsRaw <-
      jsonlite::fromJSON(httr::content(r, as = "text", encoding = "utf-8"))
    metrics <- data.frame(metricsRaw$data$result$metric)
    metrics_check(metrics)
    for (row in 1:nrow(metrics)) {
      metrics$timestamp[[row]] <- metricsRaw$data$result$value[[row]][1]
      metrics$value[[row]] <- metricsRaw$data$result$value[[row]][2]
    }
    metrics <- format_metrics_instant_data(metrics)
    return(metrics)
  }
)

#' @name Prometheus_rangeQuery
#' @title Promtheus Range Query
#' @description Run a range query against the Prometheus Server
#' @param query The PromQL query
#' @param start Start timestamp, can be a rfc3339 or Unix timestamp.
#' @param end End timestamp, can be a rfc3339 or Unix timestamp.
#' @param step Query resolution step width (e.g. 15s)
#' @param timeout Evaluation timeout. Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' \dontrun{
#' prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
#' rangeMetrics <-
#'  prom$rangeQuery(
#'    query = "up",
#'    start = "2018-10-25T20:10:51.781Z",
#'    end = "2018-10-26T20:10:51.781Z",
#'    step = "15s"
#'  )
#' }
Prometheus$methods(
  rangeQuery = function(query, start, end, step, timeout = NULL) {
    'Query data for a specific range
    '
    params <- list(
      query = query,
      start = start,
      end = end,
      step = step
    )

    # If timeout is not provided it uses server default
    if (missing(timeout)) {
      params <- c(params, timeout = timeout)
    } else {
      params <- c(params, timeout = parse_timeout(timeout))
    }

    r <-
      httr::GET(paste0(c(host, ":", port, "/api/v1/query_range"), collapse = ""),
                query = params)

    # Check for particular status codes in response
    response_check(r)
    metricsRaw <-
      jsonlite::fromJSON(httr::content(r, as = "text", encoding = "utf-8"))
    metrics <- data.frame(metricsRaw$data$result)
    # Any formatting on the metrics data can take place within this function
    metrics <- format_metrics_range_data(metrics)
    return(metrics)
  }
)

#' @name Prometheus_metadataQuery
#' @title Promtheus Metadata Query
#' @description Run a metadata query against the Prometheus Server
#' @param match_target The arguement to match metrics against.
#' @param metric The metric to retrieve metadata for. Optional.
#' @param limit The number of results of targets to return.
#' @examples
#' \dontrun{
#' prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
#' metadata <- prom$metadataQuery(match_target = '{job=~"..*"}', metric = 'go_goroutines')
#' }
Prometheus$methods(
  metadataQuery = function(match_target, metric = NULL, limit = NULL) {
    params <- list(
      match_target = match_target,
      metric = metric,
      limit = limit
    )
    r <-
      httr::GET(paste0(c(host, ":", port, "/api/v1/targets/metadata"), collapse = ""),
                query = params)

    # Check for particular status codes in response
    response_check(r)

    target_metadata <- jsonlite::fromJSON(httr::content(r, as = "text", encoding = "utf-8"), flatten = TRUE)
    metadata <- format_metadata(target_metadata$data)
    return(metadata)
  }
)
