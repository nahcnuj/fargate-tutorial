variable "profile" {
  type = string
}

variable "environment" {
  type     = string
  nullable = false
}

variable "service" {
  type    = string
  default = "fargate-tutorial"
}
