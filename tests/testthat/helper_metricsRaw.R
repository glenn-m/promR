metricsRaw_instant <- list(status = "success",
                           data = list(
                             resultType = "vector",
                             result = structure(
                               list(
                                 metric = structure(
                                   list(
                                     `__name__` = c("up", "up", "up",
                                                    "up"),
                                     instance = c(
                                       "demo.robustperception.io:9090",
                                       "demo.robustperception.io:9091",
                                       "demo.robustperception.io:9093",
                                       "demo.robustperception.io:9100"
                                     ),
                                     job = c("prometheus", "pushgateway", "alertmanager", "node")
                                   ),
                                   class = "data.frame",
                                   row.names = c(NA, 4L)
                                 ),
                                 value = list(
                                   c("1554912623.372", "1"),
                                   c("1554912623.372", "1"),
                                   c("1554912623.372",
                                     "1"),
                                   c("1554912623.372", "1")
                                 )
                               ),
                               class = "data.frame",
                               row.names = c(NA,
                                             4L)
                             )
                           ))
