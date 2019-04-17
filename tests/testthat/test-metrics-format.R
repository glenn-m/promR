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

# TODO: To be replaced with_mock or comparable
# if (requireNamespace(package = "curl", quietly = TRUE)) {
#   if (curl::has_internet()) {
#     prom <-
#       Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
#     metrics <-
#       prom$query(query = "go_goroutines")
#     test_that(desc = "Metric names are correct",
#               code = expect_named(
#                 object = metrics,
#                 expected = c("X__name__", "instance", "job", "timestamp", "value", "port")
#               ))
#   }
# }

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
