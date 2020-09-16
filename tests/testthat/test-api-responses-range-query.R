context("Test API responses: range query")

with_mock_api({
  test_that(desc = "promR instant query gets response",
            code = {
              metrics_range <- prom$rangeQuery(
                query = "go_goroutines",
                start = as.numeric(as.POSIXct("2019-09-05 12:20:32 BST")),
                end = as.numeric(as.POSIXct("2019-09-05 12:30:46 BST")),
                step = "10s"
              )
              expect_is(object = metrics_range, class = "data.frame")
              expect_gt(object = ncol(metrics_range), expected = 2)
              expect_gt(object = nrow(metrics_range), expected = 2)
              expect_named(object = metrics_range)
            })
})
