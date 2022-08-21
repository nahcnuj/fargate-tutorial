variable "profile" {
  type    = string
  default = "sandbox"
}

variable "environment" {
  type     = string
  nullable = false
}

variable "service" {
  type    = string
  default = "fargate-tutorial"
}
