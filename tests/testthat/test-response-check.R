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
