<!-- # traveloka-terraform-aws-bake-ami
A Terraform module which creates a AWS CodePipeline pipeline, two CodeBuild project, along with their respective IAM roles and least-privilege policies
This pipeline and build projects can be used to deploy baked AMIs to an environment

The intent is to create an instance of this module for each environment

## Usage
```
module "traveloka-aws-deploy-ami" {
  source = "git@github.com:traveloka/traveloka-terraform-aws-deploy-ami.git"
  service-name = "traveloka-flight"
  service-s3-bucket = "flight-staging-bucket-example"
  product-domain = "flight-team"
  environment = "staging"
  ec2-instance-role-arn = "${aws_iam_role.staging.arn}"
}
module "traveloka-aws-deploy-ami" {
  source = "git@github.com:traveloka/traveloka-terraform-aws-deploy-ami.git"
  service-name = "traveloka-flight"
  service-s3-bucket = "flight-bucket-example"
  product-domain = "flight-team"
  environment = "production"
  ec2-instance-role-arn = "${aws_iam_role.production.arn}"
}

```

## Authors

 - [Salvian Reynaldi](https://github.com/salvianreynaldi)


## License

Apache 2. See LICENSE for full details. -->
