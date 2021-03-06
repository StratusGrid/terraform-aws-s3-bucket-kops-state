# s3-bucket-kops-state
This module configures a bucket with:
 - SSE-S3 unless SSE-KMS is specified (KMS will incur an additional charge) 
 - Requires encrypted transit
 - Optional cross account trust for using this state bucket in a centralized account with other accounts storing/retrieving state from it.
   - When using cross account permissions, you will usually want to force 'bucket-owner-full-control' ACL on all objects (otherwise the bucket owner may not be able to see them). This can be done by running this command before running kops: 
```
export KOPS_STATE_S3_ACL=bucket-owner-full-control
``` 
 - Optional cross account read only option for using this state bucket in a centralized account with other accounts only retrieving state from it.
   - If you wanted to have different customers/security levels share the bucket, you would need to restructure the cross account trusting policies to map accounts to specific keys for different clusters or similar, and even then I would NOT recommend doing this (since they could still list the bucket and see names of the other clusters, even if they couldn't access them).
   - The read only option assumes you are using separate access credentials for S3 than you are using for infrastructure provisioning. See this thread for more details: https://github.com/kubernetes/kops/issues/353#issuecomment-446837838
 
 ## Example Usage:
```
module "s3_kops_state" {
  source = "StratusGrid/s3-bucket-kops-state/aws"
  version = "1.0.3"
  name_prefix = "${var.name_prefix}"
  logging_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  input_tags = "${local.common_tags}"
  sse_kms = true
  cross_account_trusted_rw_account_arns = ["arn:aws:iam::123456789:root"]
}
```
NOTE: If only using within the applied account, you can set the cross_account_trusted_rw_account_arns like so: ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
