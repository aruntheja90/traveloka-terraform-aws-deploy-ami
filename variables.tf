variable "service-name" {
  type    = "string"
  description = "the name of the service"
}

variable "service-s3-bucket" {
  type = "string"
  description = "the bucket name that will be CodePipeline artifact store. CodeBuild will access this too in the 'DOWNLOAD_SOURCE' phase"
}

variable "product-domain" {
  type    = "string"
  description = "the owner of this pipeline (e.g. team). This is used mostly for adding tags to resources"
}

variable "environment" {
  type    = "string"
  description = "the environment of this deployment pipeline"
}

variable "ec2-instance-role-arn" {
  type    = "string"
  description = "the arn of the instance profile's role, to give to ec2 instances"
}
