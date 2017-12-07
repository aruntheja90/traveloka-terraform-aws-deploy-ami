locals {
    common-pipeline-name = "${var.service-name}-deploy-ami"
    env-pipeline-name = "${local.common-pipeline-name}-${var.environment}"
    env-plan-pipeline-name = "${local.env-pipeline-name}-plan"
    env-apply-pipeline-name = "${local.env-pipeline-name}-apply"
}