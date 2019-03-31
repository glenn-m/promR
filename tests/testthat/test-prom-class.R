context("Test class creation")

test_that(desc = "Object of Prometheus class is created",
          code = expect_is(
            object = Prometheus$new(host = "https://foo.bar", port = 9090),
            class = "Prometheus"
          ))

