context("Wrong metrics objects generate errors")

test_that(
  desc = "Empty data frame generates error",
  code = expect_error(object = metrics_check(metric = as.data.frame(NULL)),
                      regexp = "^Returned\\smetrics.*")
)

test_that(
  desc = "Data frame with no rows generates error",
  code = expect_error(object = metrics_check(
    data.frame(
      colA = character(),
      colB = character(),
      stringsAsFactors = FALSE
    )
  ),
  regexp = "^Returned\\smetrics.*")
)
