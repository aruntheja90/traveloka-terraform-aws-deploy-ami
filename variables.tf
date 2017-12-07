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

variable "additional-s3-put-object-permissions" {
  type    = "list"
  description = "S3 paths CodeBuild and CodePipeline will also have PutObject permission to."
  default = []
}

variable "additional-s3-get-object-permissions" {
  type    = "list"
  description = "S3 paths CodeBuild and CodePipeline will also have Get and GetObjectVersion permission to."
  default = []
}

variable "service-s3-ami-id-key" {
  type    = "string"
  description = "the s3 path (from the app bucket) of a file containing ami id that should be deployed"
}

variable "service-s3-deploy-conf-zip-key" {
  type    = "string"
  description = "the s3 path (from the app bucket) of a zip file containing terraform configuration"
}

variable "plan-buildspec" {
  type    = "string"
  description = "the buildspec for the plan CodeBuild project"
}

variable "apply-buildspec" {
  type    = "string"
  description = "the buildspec for the apply CodeBuild project"
}
