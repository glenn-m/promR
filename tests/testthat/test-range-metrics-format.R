context("Range metrics data is formatted correctly")

with_mock_api({
  prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
  metrics_range <- prom$rangeQuery(
    query = "go_goroutines",
    start = as.numeric(as.POSIXct("2019-08-11 12:20:32 BST")),
    end = as.numeric(as.POSIXct("2019-08-11 12:30:46 BST")),
    step = "10s"
  )
  metrics_instant <- prom$query(query = "go_goroutines",
                                time = as.numeric(as.POSIXct("2019-08-11 12:25:57 BST")))

  test_that(desc = "Range metrics results are data frame",
            code = expect_is(object = metrics_range,
                             class = "data.frame"))

  test_that(desc = "Range metrics are named",
            code = expect_named(object = metrics_range))

  test_that(desc = "Instant metrics are not empty",
            code = expect_gte(object = nrow(metrics_instant),
                              expected = 2))

})



test_that(
  desc = "Error is generated for non-data-frame",
  code = expect_error(object = format_metrics_range_data(x = 1),
                      regexp = "^Assertion on \\'x\\'\\sfailed:")
)

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
