context("Test API responses: metadata query")

with_mock_api({
  test_that(desc = "promR metadata query gets response",
            code = {
              metrics_metadata <- prom$metadataQuery(match_target = '{job="prometheus"}')
              expect_is(object = metrics_metadata, class = "data.frame")
              expect_equal(object = ncol(metrics_metadata), expected = 6)
              expect_equal(object = nrow(metrics_metadata), expected = 161)
              expect_named(object = metrics_metadata)
            })
})
