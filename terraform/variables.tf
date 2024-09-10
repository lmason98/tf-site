variable "region" {
  description = "AWS resource region"
  default     = "us-west-1"
}

variable "state_name" {
  description = "S3 State bucket name, must be unique"
  default     = "tf-site-state"
}

variable "static_name" {
  description = "S3 Static files bucket name, must be unique"
  default     = "tf-site-static"
}

variable "lock_name" {
  description = "DynamoDB locks table name"
  default     = "tf-site-state-lock"
}