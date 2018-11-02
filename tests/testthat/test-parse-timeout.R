context("Test parse_timeout")

test_that(
  desc = "Timeout must not be a negative number",
  code =
    expect_error(
      parse_timeout("-5s"),
      "Can't use negative timeout values, please use a positive number."
    )
)

test_that(
  desc = "Timeout must have the unit of 's', 'h', or 'd'",
  code =
    expect_error(
      parse_timeout("2y"),
      "Timeout must be in seconds 's', minutes 'm', or hours 'h'."
    )
)

test_that(desc = "Timeout gets converted into common unit (s)",
          code =
            expect_equal(parse_timeout("2h"),
                         7200))
