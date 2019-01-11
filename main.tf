terraform {
  backend "atlas" {
    name    = "berchevorg/tfe-atlas-backend"
  }
}

resource "null_resource" "helloWorld" {
  provisioner "local-exec" {
    command = "echo hello world"
  }
}
