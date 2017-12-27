# traveloka-terraform-aws-deploy-ami
A Terraform module which creates a AWS CodePipeline pipeline, two CodeBuild project, along with their respective IAM roles and least-privilege policies
This pipeline and build projects can be used to deploy baked AMIs to an infrastructure environment. The intent is to create an instance of this module for each infrastructure environment

## Usage
```
module "traveloka-deploy-ami-staging" {
  source = "git@github.com:traveloka/traveloka-terraform-aws-deploy-ami.git"
  service-name = "traveloka-flight"
  service-s3-bucket = "flight-bucket-example"
  product-domain = "flight-team"
  environment = "staging"
  ec2-instance-role-arn = "${aws_iam_role.staging.arn}"
  service-s3-ami-id-key = "traveloka-flight-deploy-ami/instance_ami_id-staging.tfvars"
  service-s3-deploy-conf-zip-key = "traveloka-flight-deploy-ami/staging-traveloka-flight.zip"
  plan-buildspec = "buildspec-deploy-ami-plan-staging.yml"
  apply-buildspec = "buildspec-deploy-ami-apply-staging.yml"
  additional-s3-get-object-permissions = [
    "arn:aws:s3:::traveloka-flight/traveloka-flight-deploy-ami/instance_ami_id-staging.tfvars",
    "arn:aws:s3:::traveloka-flight/traveloka-flight-deploy-ami/staging-traveloka-flight.zip",
  ]
  additional-s3-put-object-permissions = [
    "arn:aws:s3:::traveloka-flight/traveloka-flight-deploy-ami/instance_ami_id-staging.tfvars",
    "arn:aws:s3:::traveloka-flight/traveloka-flight-deploy-ami*/*",
    "arn:aws:s3:::traveloka-flight/traveloka-flight-deploy-ami/staging-deployment.tfstate"
  ]
}
```

## Conventions
 - The created pipeline name will be `${var.service-name}-deploy-ami-${var.environment}`
 - The codepipeline IAM role name will be `CodePipelineDeployAmi-${var.service-name}`
 - The codepipeline IAM role inline policy name will be:
    - `CodePipelineDeployAmi-${var.service-name}-S3`
 - The created build project name will be:
    - `${var.service-name}-deploy-ami-plan-${var.environment}`
    - `${var.service-name}-deploy-ami-apply-${var.environment}`
    - `${var.service-name}-override-${var.environment}`
 - The codebuild IAM role name will be:
    - `CodeBuildDeployAmi-${var.service-name}-${var.environment}`
    - `CodeBuildOverride-${var.service-name}-${var.environment}`
 - The codebuild IAM role inline policy name will be:
    - `CodeBuildDeployAmi-${var.service-name}-${var.environment}-S3`
    - `CodeBuildOverride-${var.service-name}-${var.environment}-S3`
    - `CodeBuildDeployAmi-${var.service-name}-${var.environment}-CloudWatch`
    - `CodeBuildOverride-${var.service-name}-${var.environment}-CloudWatch`
    - `CodeBuildDeployAmi-${var.service-name}-${var.environment}-Terraform`
 - The build project environment image is `aws/codebuild/ubuntu-base:14.04`
 - The build project will be tagged:
    - "Service" = "${var.service-name}"
    - "ProductDomain" = "${var.product-domain}"
    - "Environment" = "management"
 - The plan and apply build projects will have permission to:
    - Create and Delete Launch Configuration which name is `${var.service-name}-app-*`
    - Create Update Delete Auto Scaling Group:
      - which name is `${var.service-name}-app-*`
      - which target group name is `${var.service-name}-app-*`
      - which launch config name is as mentioned above
      - having these tags on creation:
        - "Service" = "${var.service-name}"
        - "ServiceVersion" = any
        - "Cluster" = "${var.service-name}-app"
        - "ProductDomain" = "${var.product-domain}"
        - "Environment" = "management"
        - "Application" = any
        - "Description" = any

## Authors

 - [Salvian Reynaldi](https://github.com/salvianreynaldi)


## License

Apache 2. See LICENSE for full details.
