data "template_file" "codebuild_rollback_command" {
  template = "${file("${path.module}/codebuild-rollback-buildspec.tpl")}"
  vars {
      s3-ami_id-path = "s3://${var.service-s3-bucket}/${var.service-s3-ami-id-key}"
  }
}

resource "aws_codebuild_project" "override" {
    name         = "${var.service-name}-override-${var.environment}"
    description  = "Write a specific AMI ID to s3://${var.service-s3-bucket}/${local.common-pipeline-name}/instance-ami-id-${var.environment}.tfvars"
    service_role = "${aws_iam_role.codebuild-override.arn}"

    artifacts {
        type = "NO_ARTIFACTS"
        # namespace_type = "BUILD_ID"
        # packaging = "ZIP"
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image        = "aws/codebuild/ubuntu-base:14.04"
        type         = "LINUX_CONTAINER"
    }

    source {
        type     = "S3"
        buildspec = "${data.template_file.codebuild_rollback_command.rendered}"
        location = "${var.service-s3-bucket}/${local.common-pipeline-name}/${var.service-name}.zip"
    }

    tags {
        "ProductDomain" = "${var.product-domain}"
    }
}
