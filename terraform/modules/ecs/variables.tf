variable "name" {
  description = "Name to be used for the resources"
  type        = string
  default     = "infrastructure"
}

variable "alb_deletion_protection" {
  description = "Deletion protection for the ALB"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Desired VPC ID for this module"
  type        = string
}

variable "subnets_id" {
  description = "Desired subnets ID for this module"
  type        = list(string)
}

variable "alb_https_expose" {
  type    = bool
  default = true
}

variable "certificate_arn" {
  description = "ARN of the certificate to be used on ALB"
  type        = string
  default     = null
}

variable "alb_target_group_port" {
  description = "Port for the ALB target group"
  type        = number
  default     = 80
}

variable "zone_name" {
  description = "Route53 zone name"
  type        = string
}

variable "ecs_task_cpu" {
  description = "Number of CPUs desired in the ECS task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Number of memory desired in the ECS task"
  type        = number
  default     = 512
}

variable "ecs_flask_api_port" {
  description = "Flask API container port"
  type        = number
  default     = 8080
}

variable "ecs_task_public_ip" {
  description = "value"
  type        = bool
  default     = true
}

variable "frontend_docker_image" {
  description = "Image to be used in the frontend container"
  type        = string
  default     = null
}

variable "flask_api_docker_image" {
  description = "Image to be used in the API container"
  type        = string
  default     = null
}

variable "ecr_repositories_arn" {
  description = "List of ARNs of the ECR repositories where the Docker images for this module are stored"
  type        = list(string)
}
