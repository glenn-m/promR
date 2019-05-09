context("Test Prometheus Response Check")

test_that(desc = "Error is raised if 400 received from server.",
          code = {
            response <- structure(list(
              url = "foo.bar",
              status_code = 400,
              headers = list(`Content-Type` = "application/json"),
              content = charToRaw(
                "{\"status\":\"error\",\"errorType\":\"bad_data\",\"error\":\"cannot parse \\\"2019-04-01T20:36:34\\\" to a valid timestamp\"}"
              )
            ),
            class = "response")
            expect_error(
              response_check(response),
              'Query parameters are missing or incorrect, cannot parse "2019-04-01T20:36:34" to a valid timestamp'
            )
          })

test_that(desc = "Error is raised if 422 received from server.",
          code = {
            response <- structure(list(
              url = "foo.bar",
              status_code = 422,
              headers = list(`Content-Type` = "application/json"),
              content = charToRaw(
                "{\"status\":\"error\",\"errorType\":\"bad_data\",\"error\":\"expression could not be executed\"}"
              )
            ),
            class = "response")
            expect_error(response_check(response),
                         "expression could not be executed")
          })

test_that(desc = "Error is raised if 503 received from server.",
          code = {
            response <- structure(list(
              url = "foo.bar",
              status_code = 503,
              headers = list(`Content-Type` = "application/json"),
              content = charToRaw(
                "{\"status\":\"error\",\"errorType\":\"bad_data\",\"error\":\"query timed out\"}"
              )
            ),
            class = "response")
            expect_error(response_check(response),
                         "query timed out")
          })

test_that(desc = "Error is raised when response type is not application/json.",
          code = {
            response <- structure(list(
              url = "foo.bar",
              status_code = 200,
              headers = list(`Content-Type` = "text/html")
            ),
            class = "response")
            expect_error(response_check(response),
                         "Prometheus API did not return JSON")
          })

test_that(desc = "OK when application type is json and status code is 200.",
          code = {
            response <- structure(list(
              url = "foo.bar",
              status_code = 200,
              headers = list(`Content-Type` = "application/json")
            ),
            class = "response")
            expect_silent(response_check(response))
          })
