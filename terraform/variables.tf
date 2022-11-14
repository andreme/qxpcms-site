variable "project_name" {
}

variable "cms_server_api_key" {
}

variable "site_deployment_subnet" {
}

variable "site_deployment_security_group" {
}

variable "hosting_domains" {
  type = list(string)
  default = []
}

variable "hosting_certificate_arn" {
  default = ""
}

variable "hosting_redirect_from_naked_to_www" {
  default = false
}

variable "tz" {
  default = "Australia/Sydney"
}
