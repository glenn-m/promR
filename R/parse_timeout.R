#' @section Utility function for parsing timeout argument \code{parse_timeout}:
#'   Fixes potentially problematic timeout argument.
#' @param timeout_val A timeout value assigned by user.
#' @rdname utilities
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
