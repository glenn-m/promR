context("Instant metrics data is formatted correctly")

test_that(desc = "Instant mertics results are data frame",
          code = expect_is(object = metrics_current,
                           class = "data.frame"))

test_that(desc = "Instant metrics are named",
          code = expect_named(object = metrics_current))

test_that(desc = "Instant metrics are not empty",
          code = expect_gte(object = nrow(metrics_current),
                            expected = 2))

# Source, response-like objects
test_that(desc = "Column __name__ in data frame is renamed to name",
          code = expect_named(
            object = {
              test_data_frame <- data.frame(some_column = 1,
                                            X__name__ = 2)
              rename_metrics_data_frame(test_data_frame)
            },
            expected = c("some_column", "name")
          ))
