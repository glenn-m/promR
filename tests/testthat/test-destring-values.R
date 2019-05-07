context("Value columns are correctly converted")

test_that(desc = "Mixed vector is correctly converted",
          code = expect_identical(
            object =
              destring(c(
                1, 1.1, "A", NA, NA_character_
              )),
            expected = c(1, 1.1, rep(NA, times = 3))
          ))

test_that(desc = "Numeric vector is untouched",
          code = expect_identical(
            object = destring(c(1,1.1, 1e3, -9)),
            expected = c(1, 1.1, 1e3, -9)
          ))

test_that(desc = "Numeric is returned when factor type is provided",
          code = {
            x <- factor(c("1", "2"))
            output <- destring(x)
            expect_equal(is.numeric(output),
                         TRUE)
          })

test_that(desc = "If column names are null, null is returned",
          code = {
            df <- data.frame(matrix(ncol = 3, nrow = 0))
            colnames(df) <- c(NULL, NULL, NULL)
            expect_equal(rename_metrics_data_frame(df),
                         df)
          })

