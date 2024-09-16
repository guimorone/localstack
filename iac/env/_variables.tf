variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Environment where resources will be created"
}

locals {
  tag_platform    = "Platform"
  tag_component   = "Component"
  tag_client      = "Client"
  tag_environment = var.env
  tag_squad       = "Squad"
  tag_product     = "Product"
  tag_project     = "Project"


  default_tags = {
    "Platform" : upper(local.tag_platform),
    "Component" : upper(local.tag_component),
    "Client" : upper(local.tag_client)
    "Environment" : upper(local.tag_environment),
    "ManagedWith" : upper("terraform"),
    "Squad" : upper(local.tag_squad),
    "CreatedBy" : upper(local.tag_squad),
    "Product" : upper(local.tag_product),
    "Project" : upper(local.tag_project)
  }

  prefix     = "test"
  table_name = "${var.env}-${local.prefix}"
}
