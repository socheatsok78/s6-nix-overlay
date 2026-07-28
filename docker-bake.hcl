group "default" {
  targets = [
    "s6-overlay-container",
    "s6-overlay-container-layered",
  ]
}

target "s6-overlay-container" {
  target = "s6-overlay-container"
  platforms = [ "local" ]
  outputs = [ "result" ]
}

target "s6-overlay-container-layered" {
  target = "s6-overlay-container-layered"
  platforms = [ "local" ]
  outputs = [ "result" ]
}
