variable "project_name" {
}

variable "cms_server_api_key" {
}

variable "site_deployment_subnet" {
}

variable "site_deployment_security_group" {
}

variable "hosting_aliases" {
  type = list(string)
  default = []
}

variable "hosting_certificate_arn" {
  default = ""
}
