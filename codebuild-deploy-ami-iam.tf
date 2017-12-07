data "aws_iam_policy_document" "codebuild-deploy-ami-s3" {    
    statement {
        effect = "Allow",
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "arn:aws:s3:::${var.service-s3-bucket}/*/*",
            "arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}/instance-ami-id-${var.environment}.tfvars",
            "arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}/${var.environment}-deployment.tfstate"
        ]
    }
    statement {
        effect = "Allow",
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "arn:aws:s3:::${var.service-s3-bucket}/*/*",
            "arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}/${var.environment}-deployment.tfstate"
        ]
    }
}
data "aws_iam_policy_document" "codebuild-deploy-ami-cloudwatch" {
    statement {
        effect = "Allow",
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.env-plan-pipeline-name}",
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.env-apply-pipeline-name}",
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.env-plan-pipeline-name}:*",
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.env-apply-pipeline-name}:*"
        ]
    }
}
data "aws_iam_policy_document" "codebuild-deploy-ami-terraform" {
    statement {
        effect = "Allow",
        actions = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeLaunchConfigurations",
            # "autoscaling:DescribeLoadBalancers",
            # "autoscaling:DescribePolicies",
            # "autoscaling:DescribeScalingActivities",
            # "autoscaling:DescribeScheduledActions",
            # "ec2:DescribeAvailabilityZones",
            "ec2:DescribeImages",
            # "ec2:DescribeInstances",
            # "ec2:DescribeRegions",
            # "ec2:DescribeSecurityGroups",
            # "ec2:DescribeSubnets",
            # "ec2:DescribeTags",
            # "ec2:DescribeVpcs",
            # "elasticloadbalancing:DescribeListeners",
            # "elasticloadbalancing:DescribeLoadBalancerAttributes",
            # "elasticloadbalancing:DescribeLoadBalancers",
            # "elasticloadbalancing:DescribeRules",
            # "elasticloadbalancing:DescribeTargetGroupAttributes",
            # "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetHealth",
            # "iam:ListServerCertificates"
        ]
        resources = [
            "*"
        ]
    }
    statement {
        effect = "Allow",
        actions = [
            "iam:PassRole"
        ]
        resources = [
            "${var.ec2-instance-role-arn}"
        ]
    }
    statement {
        effect = "Allow",
        actions = [
            "autoscaling:CreateLaunchConfiguration",
            "autoscaling:DeleteLaunchConfiguration"
        ]
        resources = [
            "arn:aws:autoscaling:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:launchConfiguration:*:launchConfigurationName/${var.service-name}-app-*"
        ]
    }
    statement {
        effect = "Allow",
        actions = [
            "autoscaling:CreateAutoScalingGroup"
        ]
        resources = [
            "arn:aws:autoscaling:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:autoScalingGroup:*:autoScalingGroupName/${var.service-name}-app-*"
        ]
        condition = {
            test = "StringLike"
            variable = "autoscaling:LaunchConfigurationName"
            values = [
                "${var.service-name}-app-*"
            ]
        }
        condition = {
            test = "ForAllValues:StringLike"
            variable = "autoscaling:TargetGroupARNs"
            values = [
                "arn:aws:elasticloadbalancing:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:targetgroup/${var.service-name}-app-*"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "aws:RequestTag/Service"
            values = [
                "${var.service-name}"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "aws:RequestTag/Cluster"
            values = [
                "${var.service-name}-app"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "aws:RequestTag/ProductDomain"
            values = [
                "${var.product-domain}"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "aws:RequestTag/Environment"
            values = [
                "${var.environment}"
            ]
        }
        condition = {
            test = "StringLike"
            variable = "aws:RequestTag/ServiceVersion"
            values = [
                "*"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "aws:RequestTag/Application"
            values = [
                "java-7"
            ]
        }
        condition = {
            test = "StringLike"
            variable = "aws:RequestTag/Description"
            values = [
                "*"
            ]
        }
    }
    statement {
        effect = "Allow",
        actions = [
            "autoscaling:UpdateAutoScalingGroup",
            "autoscaling:DeleteAutoScalingGroup"
        ]
        resources = [
            "arn:aws:autoscaling:*:${data.aws_caller_identity.current.account_id}:autoScalingGroup:*:autoScalingGroupName/${var.service-name}-app-*"
        ]
        condition = {
            # only for UpdateAutoscalingGroup
            test = "StringLikeIfExists"
            variable = "autoscaling:LaunchConfigurationName"
            values = [
                "${var.service-name}-app-*"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "autoscaling:ResourceTag/Service"
            values = [
                "${var.service-name}"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "autoscaling:ResourceTag/Cluster"
            values = [
                "${var.service-name}-app"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "autoscaling:ResourceTag/ProductDomain"
            values = [
                "${var.product-domain}"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "autoscaling:ResourceTag/Environment"
            values = [
                "${var.environment}"
            ]
        }
        condition = {
            test = "StringLike"
            variable = "autoscaling:ResourceTag/ServiceVersion"
            values = [
                "*"
            ]
        }
        condition = {
            test = "StringEquals"
            variable = "autoscaling:ResourceTag/Application"
            values = [
                "java-7"
            ]
        }
        condition = {
            test = "StringLike"
            variable = "autoscaling:ResourceTag/Description"
            values = [
                "*"
            ]
        }
    }
}

resource "aws_iam_role" "codebuild-deploy-ami" {
  name = "CodeBuildDeployAmi-${var.service-name}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild-assume.json}"
  force_detach_policies = true
}

resource "aws_iam_role_policy" "codebuild-deploy-ami-terraform" {
  name = "CodeBuildDeployAmi-${var.service-name}-${var.environment}-Terraform"
  role = "${aws_iam_role.codebuild-deploy-ami.id}"
  policy = "${data.aws_iam_policy_document.codebuild-deploy-ami-terraform.json}"
}


resource "aws_iam_role_policy" "codebuild-deploy-ami-cloudwatch" {
  name = "CodeBuildDeployAmi-${var.service-name}-${var.environment}-CloudWatch"
  role = "${aws_iam_role.codebuild-deploy-ami.id}"
  policy = "${data.aws_iam_policy_document.codebuild-deploy-ami-cloudwatch.json}"
}

resource "aws_iam_role_policy" "codebuild-deploy-ami-s3" {
  name = "CodeBuildDeployAmi-${var.service-name}-${var.environment}-S3"
  role = "${aws_iam_role.codebuild-deploy-ami.id}"
  policy = "${data.aws_iam_policy_document.codebuild-deploy-ami-s3.json}"
}
