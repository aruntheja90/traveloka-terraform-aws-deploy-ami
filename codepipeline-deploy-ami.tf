resource "aws_codepipeline" "deploy-ami" {
  name     = "${local.env-pipeline-name}"
  role_arn = "${aws_iam_role.codepipeline-deploy-ami.arn}"

  artifact_store {
    location = "${var.service-s3-bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "TfTemplate"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["TfTemplate"]

      configuration {
        S3Bucket = "${var.service-s3-bucket}"
        S3ObjectKey = "${var.service-s3-deploy-conf-zip-key}"
        PollForSourceChanges = "${var.poll-source-changes}"
      }
      run_order = 1
    }
    action {
      name             = "AmiId"
      owner            = "AWS"
      category         = "Source"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["AmiId"]

      configuration {
        S3Bucket = "${var.service-s3-bucket}"
        S3ObjectKey = "${var.service-s3-ami-id-key}"
        PollForSourceChanges = "${var.poll-source-changes}"
      }
      run_order = 1
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Plan"
      owner           = "AWS"
      category        = "Build"
      provider        = "CodeBuild"
      input_artifacts = ["TfTemplate"]
      output_artifacts = ["TfPlan"]
      version         = "1"
    
      configuration {
        ProjectName = "${aws_codebuild_project.deploy-ami-plan.name}"
      }
      run_order = 1
    }
    action {
      name            = "Approve"
      owner           = "AWS"
      category        = "Approval"
      provider        = "Manual"
      version         = "1"
      configuration {
        CustomData = "You're deploying [[${var.service-name}]] to [[${var.environment}]]. Review the `Plan` action result. Make sure the `Build` stage has just run (e.g. <1 hours) as the state may have changed."
      }
      run_order = 2
    }
    action {
      name            = "Apply"
      owner           = "AWS"
      category        = "Build"
      provider        = "CodeBuild"
      input_artifacts = ["TfPlan"]
      version         = "1"
    
      configuration {
        ProjectName = "${aws_codebuild_project.deploy-ami-apply.name}"
      }
      run_order = 3
    }
  }
}
