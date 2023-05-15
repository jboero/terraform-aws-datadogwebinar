variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "Datadog Webinar"
}

variable "aws_region" {
  type = string
  description = "AWS region to use if needed."
  default = "europe-west-1"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key required"
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key required"
}

variable "DD_CLIENT_TOKEN" {
  type = string
  description = "DataDog API token required"
}

variable "DD_APPLICATION_ID" {
  type = string
  description = "Datadog Application ID required"
}

variable "org_name" {
  type = string
  default = "datadog-org"
}

variable "vpc_name" {
  type = string
  default = "datadog-webminar"
}
