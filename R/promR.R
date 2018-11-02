#' @name Prometheus
#' @title Prometheus class
#' @description Reference Class to interface with a Prometheus Server
#' @exportClass Prometheus
#' @export Prometheus
#' @field host The hostname of the Prometheus server
#' @field port The port number of the Prometheus server
#' @examples
#' prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
Prometheus <-
  setRefClass("Prometheus", fields = list(host = "character", port = "numeric"))

#' Utility function for parsing timeout argument 'parse_timeout'
#' @param timeout_val A timeout value assigned by user.
parse_timeout <- function(timeout_val) {
  # If timeout starts with '-' stop the function and inform the user
  if (startsWith(timeout_val, "-"))
    stop("Can't use negative timeout values, please use a positive number.",
         call. = FALSE)

  # Identify the time unit
  time_unit <- sub("[^[:alpha:]]+", "", timeout_val)

  # Test if the time_unit > 1 or == 0. If it's the former, we assume they gave
  # something like 'minutes' instead of 'm'. If it's the latter, we assume they
  # didn't give any unit at all, e.g. '1.5'.
  if (nchar(time_unit) > 1 | nchar(time_unit) == 0)
    stop("Couldn't identify timeout value. Please use 's', 'm', or 'h'.",
         call. = FALSE)

  # Negation of %in% operator to test if time_unit is one of the three options
  `%nin%` = Negate(`%in%`)

  # If time_unit isn't in one of the three options, stop the function
  if (time_unit %nin% c("s", "m", "h"))
    stop("Timeout must be in seconds 's', minutes 'm', or hours 'h'.",
         call. = FALSE)

  # If the time_unit is identified, assign a conversion value so all timeouts
  # are measured in seconds.
  if (time_unit == "s")
    conversion <- 1
  if (time_unit == "m")
    conversion <- 60
  if (time_unit == "h")
    conversion <- 3600

  # Remove all non numerics, keep '.', convert to numeric and multiply by conversion value
  timeout_seconds <-
    as.numeric(gsub("[^0-9.]", "", timeout_val)) * conversion

  return(timeout_seconds)

}

#' Utility function for checking Prometheus Server response.
#' @param response  httr response object
response_check <- function(response) {
  switch(
    as.character(response$status_code),
    "400" = stop("Query parameters are missing or incorrect.", call. = FALSE),
    "422" = stop("Expression cannot be executed.", call. = FALSE),
    "503" = stop("Query timed out or aborted.", call. = FALSE)
  )
}

#' @name Prometheus_query
#' @title Prometheus Instant Query
#' @description Run a instant query against the Prometheus Server
#' @param query The PromQL query
#' @param time Evaluation timestamp, can be a rfc3339 or unix timestamp. Optional, defaults to current Prometheus server time.
#' @param timeout Evaluation timeout (e.g. 1h, 1.5m or 15s). Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' \donttest{
#'  prom <- Prometheus$new(host = "https://foo.bar", port = 9090)
#'  metrics <- prom$query(query = "up", time = "2018-10-26T20:10:51.781Z")
#'  metrics <- prom$query(query = "up", time = "1540677062")
#' }
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
    for (row in 1:nrow(metrics)) {
      metrics$timestamp[[row]] <- metricsRaw$data$result$value[[row]][1]
      metrics$value[[row]] <- metricsRaw$data$result$value[[row]][2]
    }
    return(metrics)
  }
)

#' @name Prometheus_rangeQuery
#' @title Promtheus Range Query
#' @description Run a range query against the Prometheus Server
#' @param query The PromQL query
#' @param start Start timestamp, can be a rfc3339 or unix timestamp.
#' @param end End timestamp, can be a rfc3339 or unix timestamp.
#' @param step Query resolution step width (e.g. 15s)
#' @param timeout Evaluation timeout. Optional, defaults to timeout value of the Prometheus server.
#' @examples
#' \donttest{
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
    return(metrics)
  }
)
