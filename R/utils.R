#' Basic arithmetic
#'
#' @name utilities
NULL
#> NULL

#' Utility function for checking Prometheus Server response.
#' @param response  httr response object
#' @rdname
response_check <- function(response) {
  switch(
    as.character(response$status_code),
    "400" = stop("Query parameters are missing or incorrect.", call. = FALSE),
    "422" = stop("Expression cannot be executed.", call. = FALSE),
    "503" = stop("Query timed out or aborted.", call. = FALSE)
  )
}
