variable "name" {
  default = "alb"
}
variable "env" {}
variable "tags" {}
variable "allow_alb_cidr" {}
variable "subnets" {}
variable "vpc_id" {}
variable "internal" {}