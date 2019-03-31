context("Test Prometheus Response Check")

test_that(
  desc = "Error is raised if 400 received from server.",
  code = {
    response <- list(status_code = 400)
  expect_error(response_check(response),
               "Query parameters are missing or incorrect.")
})

test_that(
  desc = "Error is raised if 422 received from server.",
  code = {
    response <- list(status_code = 422)
  expect_error(response_check(response),
               "Expression cannot be executed.")
})

test_that(
  desc = "Error is raised if 503 received from server.",
  code = {
    response <- list(status_code = 503)
  expect_error(response_check(response),
               "Query timed out or aborted.")
})

# Test whether package can pull some sample data, only run if connection
# available and host is responsive
if (requireNamespace(package = "curl", quietly = TRUE)) {
  if (curl::has_internet()) {
    # Source query data once to use later across tests
    prom <-
      Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    dta_tst_metrics <-
      prom$query(query = "go_goroutines",
                 time = format(Sys.time(),  "%Y-%m-%dT%H:%M:%SZ"))

    test_that(desc = "Metrics within Prometheus class are data frame.",
              code = expect_is(object = dta_tst_metrics,
                               class = "data.frame"))

    test_that(desc = "Metrics data frame has some columns.",
              code = expect_gt(object = ncol(dta_tst_metrics),
                               expected = 2))

    test_that(desc = "Metrics data frame has some rows.",
              code = expect_gt(object = nrow(dta_tst_metrics),
                               expected = 2))
  }
}
