context("Value columns are correctly converted")

test_that(desc = "Mixed vector is correctly converted",
          code = expect_identical(object = destring(c(
            1, 1.1, "A", NA, NA_character_
          )),
          expected = c(1, 1.1, rep(NA, times = 3))))

test_that(desc = "Numeric vector is untouched",
          code = expect_identical(object = destring(c(1, 1.1, 1e3, -9)),
                                  expected = c(1, 1.1, 1e3, -9)))
