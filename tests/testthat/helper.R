library(httptest)

# Create prom object of Prometheus class
# to use for function testing
prom <- Prometheus$new(host = "http://demo.robustperception.io", port = 9090)
