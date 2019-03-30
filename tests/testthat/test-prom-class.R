context("Test class creation")

test_that(desc = "Object of Prometheus class is created",
          code = expect_is(
            object = Prometheus$new(host = "https://foo.bar", port = 9090),
            class = "Prometheus"
          ))

# Test whether package can pull some sample data, only run if connection
# available and host is responsive
if (requireNamespace(package = "curl", quietly = TRUE)) {
  if (curl::has_internet()) {

    # Source query data once to use later across tests
    dta_tst_metrics <-

    test_that(
      desc = "Object Prometheous class is populated with data",
      code = expect_

      )
    )
  }
}
