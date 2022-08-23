variable "profile" {
  type    = string
  default = "sandbox"
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "environment" {
  type     = string
  nullable = false
}

variable "service" {
  type    = string
  default = "fargate-tutorial"
}
