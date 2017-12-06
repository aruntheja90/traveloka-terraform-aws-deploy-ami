version: 0.2
phases:
  build:
    commands:
      - if [ -n "$AMI_ID" ]; then echo instance-ami-id=\"$AMI_ID\" > instance-ami-id.tfvars; aws s3 cp instance-ami-id.tfvars ${s3-ami_id-path}; fi
