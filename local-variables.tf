locals {
    common-pipeline-name = "${var.service-name}-deploy-ami"
    env-pipeline-name = "${local.common-pipeline-name}-${var.environment}"
    env-plan-pipeline-name = "${local.env-pipeline-name}-plan"
    env-apply-pipeline-name = "${local.env-pipeline-name}-apply"
    s3-get-list = "${concat(list("arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}*/*"), var.additional-s3-get-object-permissions)}"
    s3-put-list = "${concat(list("arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}*/*"), var.additional-s3-put-object-permissions)}"
}
