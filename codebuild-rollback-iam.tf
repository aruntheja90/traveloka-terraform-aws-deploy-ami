data "aws_iam_policy_document" "codebuild-override-s3" {    
    statement {
        effect = "Allow",
        actions = [
            "s3:PutObject"
        ]
        resources = "${var.additional-s3-put-object-permissions}"
    }
    statement {
        effect = "Allow",
        actions = [
            "s3:GetObject"
        ]
        resources = "${var.additional-s3-get-object-permissions}"
    }
}
data "aws_iam_policy_document" "codebuild-override-cloudwatch" {
    statement {
        effect = "Allow",
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.service-name}-override-${var.environment}",
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.service-name}-override-${var.environment}:*"
        ]
    }
}

resource "aws_iam_role" "codebuild-override" {
  name = "CodeBuildOverride-${var.service-name}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild-assume.json}"
  force_detach_policies = true
}

resource "aws_iam_role_policy" "codebuild-override-cloudwatch" {
  name = "CodeBuildOverride-${var.service-name}-${var.environment}-CloudWatch"
  role = "${aws_iam_role.codebuild-override.id}"
  policy = "${data.aws_iam_policy_document.codebuild-override-cloudwatch.json}"
}

resource "aws_iam_role_policy" "codebuild-override-s3" {
  name = "CodeBuildOverride-${var.service-name}-${var.environment}-S3"
  role = "${aws_iam_role.codebuild-override.id}"
  policy = "${data.aws_iam_policy_document.codebuild-override-s3.json}"
}
