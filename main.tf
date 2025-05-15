
# The configuration for the `remote` backend.
terraform {
  backend "remote" {
        # The name of your Terraform Cloud organization.
    organization = "Chinwe-Org"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "weather_app_infra_workspace"
    }
  }
}

# An example resource that does nothing.
    resource "null_resource" "example" {
      triggers = {
        value = "nothing to do here!"
      }
    }