context("Test range and instant formatting support functions")

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


test_that(
  desc = "Unnamed object returns self",
  code = expect_identical(object = rename_metrics_data_frame(unname(mtcars)),
                          expected = unname(mtcars))
)
