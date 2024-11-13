# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "line_channel_secret" {
  type = string
}

variable "line_channel_access_token" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "zip_file_name" {
  type = string
}

variable "node_env" {
  type = string
}

variable "port" {
  type = string
}
