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

# Create response-like objects
# Metrics raw
metricsRaw <- list(status = "success",
                   data = list(
                     resultType = "vector",
                     result = structure(
                       list(
                         metric = structure(
                           list(
                             `__name__` = c("up", "up", "up",
                                            "up"),
                             instance = c(
                               "demo.robustperception.io:9090",
                               "demo.robustperception.io:9091",
                               "demo.robustperception.io:9093",
                               "demo.robustperception.io:9100"
                             ),
                             job = c("prometheus", "pushgateway", "alertmanager", "node")
                           ),
                           class = "data.frame",
                           row.names = c(NA, 4L)
                         ),
                         value = list(
                           c("1554912322.161", "1"),
                           c("1554912322.161", "1"),
                           c("1554912322.161",
                             "1"),
                           c("1554912322.161", "1")
                         )
                       ),
                       class = "data.frame",
                       row.names = c(NA,
                                     4L)
                     )
                   ))
