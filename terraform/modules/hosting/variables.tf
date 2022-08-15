variable "project_name" {
}

variable "aliases" {
  type = list(string)
  default = []
}

variable "certificate_arn" {
  default = ""
}
