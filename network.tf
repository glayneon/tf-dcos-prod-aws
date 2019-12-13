resource "null_resource" "update-vpc" {
  provisioner "local-exec" {
    command = "aws 
