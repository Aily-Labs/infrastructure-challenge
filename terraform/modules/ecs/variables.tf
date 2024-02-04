variable "name" {
  type    = string
  default = "infrastructure"
}

variable "alb_deletion_protection" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "ecs_task_cpu" {
  type = number
}

variable "ecs_task_memory" {
  type = number
}

variable "frontend_docker_image" {
  type = string
}

variable "flask_api_docker_image" {
  type = string
}

variable "ecr_repositories_arn" {
  type = list(string)
}
