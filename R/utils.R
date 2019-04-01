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
  prometheus_error <- jsonlite::fromJSON(httr::content(response, "text"))$error
  stop(sprintf("%s, %s", error_string, prometheus_error), call. = FALSE)
}
