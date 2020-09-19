context("Test API responses: instant query")

with_mock_api({
  test_that(desc = "promR instant query gets response",
            code = {
              metrics_instant <- prom$query(query = "go_goroutines",
                                            time = as.numeric(as.POSIXct("2020-09-18 12:25:57 EDT")))
              expect_is(object = metrics_instant, class = "data.frame")
              expect_gt(object = ncol(metrics_instant), expected = 2)
              expect_gt(object = nrow(metrics_instant), expected = 2)
              expect_named(object = metrics_instant)
            })
})
