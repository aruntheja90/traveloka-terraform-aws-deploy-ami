locals {
    common-pipeline-name = "${var.service-name}-deploy-ami"
    env-pipeline-name = "${local.common-pipeline-name}-${var.environment}"
    env-plan-pipeline-name = "${local.common-pipeline-name}-plan-${var.environment}"
    env-apply-pipeline-name = "${local.common-pipeline-name}-apply-${var.environment}"
}
