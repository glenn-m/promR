context("Metrics data is formatted correctly")

if (requireNamespace(package = "curl", quietly = TRUE)) {
  if (curl::has_internet()) {
    prom <-
      Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
    metrics <-
      prom$query(query = "go_goroutines",
                 time = format(Sys.time(),  "%Y-%m-%dT%H:%M:%SZ"))
    test_that(desc = "Metric names are correct",
              code = expect_named(
                object = metrics,
                expected = c("metric", "instance", "job", "timestamp", "value", "port")
              ))
  }
}
