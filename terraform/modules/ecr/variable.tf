variable "repositories_name" {
  description = "A list with the names of the repositories to be created"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for each repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}
