context("Test parse_timeout")

test_that(desc = "Timeout must not be a negative number",
          code = expect_failure(
            expect_error(
              parse_timeout("-5h"),
              "Can't use negative timeout values, please use a positive number."
            )
          ))

test_that(desc = "Timeout must have the unit of 's', 'h', or 'd' ",
          code = expect_failure(
            expect_error(
              parse_timeout("-2y"),
              "Couldn't identify timeout value. Please use 's', 'm', or 'h'"
            )
          ))

test_that(desc = "Timeout gets converted into common unit (s)",
          code = expect_failure(expect_error(parse_timeout("2h"),
                                             7200)))
