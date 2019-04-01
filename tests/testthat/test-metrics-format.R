context("Metrics data is formatted correctly")

test_that(desc = "Instant mertics results are data frame",
          code = expect_is(object = metrics_current,
                           class = "data.frame"))

test_that(desc = "Range mertics results are data frame",
          code = expect_is(object = metrics_range,
                           class = "data.frame"))

test_that(desc = "Instant metrics are named",
          code = expect_named(object = metrics_current))

test_that(desc = "Range metrics are named",
          code = expect_named(object = metrics_range))

test_that(desc = "Instant metrics are not empty",
          code = expect_gte(object = nrow(metrics_current),
                            expected = 2))

test_that(desc = "Range metrics are not empty",
          code = expect_gte(object = nrow(metrics_range),
                            expected = 2))
