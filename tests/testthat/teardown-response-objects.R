# Clean support package from testing env
teardown(code = {
  detach("package:mockery", unload = TRUE)
})
