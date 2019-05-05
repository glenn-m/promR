#' @title Various utility functions
#' @description Utility functions, usually called within the package and not
#'   exported.
#'
#' @name utilities
NULL
#> NULL

#' @section Checking Prometheus Server response:
#'   Returns more meanigful error code
#' @param response  httr response object
#' @rdname utilities
#' @keywords internal
response_check <- function(response) {
  # Check that we got a JSON response
  if (httr::http_type(response) != "application/json") {
    stop("Prometheus API did not return json", call. = FALSE)
  }

  # Check we didn't get any error status_code
  switch(
    as.character(response$status_code),
    "400" = prometheus_err("Query parameters are missing or incorrect", response),
    "422" = prometheus_err("Expression cannot be executed", response),
    "503" = prometheus_err("Query timed out or aborted", response)
  )
}

prometheus_err <- function(error_string, response) {
  prometheus_error <-
    jsonlite::fromJSON(httr::content(response, "text"))$error
  stop(sprintf("%s, %s", error_string, prometheus_error), call. = FALSE)
}

#' @section Check Metrics Object:
#'   Check if metrics objects contains data. If there is no data for time
#'   period referenced in the query this function will return an error.
#' @param metrics Generated metrics object
#' @rdname utilities
#' @keywords internal
metrics_check <- function(metric) {
  withCallingHandlers(
    expr =
      checkmate::assert_data_frame(
        x = metric,
        min.rows = 1,
        min.cols = 2
      ),
    error = function(e) {
      stop("Returned metrics object is empty: ", e, call. = FALSE)
    }
  )
}

#' @section Wrapper - httr Get:
#'   Wrapper function for curl fetch memory to facilitate testing via mockr.
#' @param ... As in
#' @keywords internal
wrapper_httr_get <- function(...) {
  httr::GET(...)
}
