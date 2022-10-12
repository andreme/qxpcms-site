variable "project_name" {
}

variable "domains" {
  type = list(string)
  default = []
  description = "Extra domains that point to this site. When using redirect_from_naked_to_www or not specifying certificate_arn, the first domain needs to be the naked domain"
}

variable "certificate_arn" {
  default = ""
  description = "DEPRECATED?"
}

variable "redirect_from_naked_to_www" {
  default = false
}
