# minio-iam-policy

Terraform module for creating IAM policies in MinIO.

## Overview

Creates IAM policies in MinIO using AWS-compatible policy documents.

## Usage

### Basic Policy

```hcl
module "readonly_policy" {
  source = "../../template-terraform/modules/minio-iam-policy"

  name = "bucket-readonly"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
      }
    ]
  })
}
```

### Read-Write Policy

```hcl
module "terraform_policy" {
  source = "../../template-terraform/modules/minio-iam-policy"

  name = "terraform-state-rw"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = ["arn:aws:s3:::terraform/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::terraform"]
      }
    ]
  })
}
```

### Auto-Generated Name

```hcl
module "backup_policy" {
  source = "../../template-terraform/modules/minio-iam-policy"

  name_prefix = "backup-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = ["arn:aws:s3:::backups", "arn:aws:s3:::backups/*"]
      }
    ]
  })
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| minio | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | Policy name (conflicts with `name_prefix`) | `string` | `null` |
| `name_prefix` | Prefix for auto-generated name | `string` | `null` |
| `policy` | Policy document as JSON string | `string` | **Required** |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Policy ID |
| `name` | Policy name |

## Policy Document Format

MinIO uses AWS S3-compatible IAM policies:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow|Deny",
      "Action": ["s3:ActionName"],
      "Resource": ["arn:aws:s3:::bucket-name/*"]
    }
  ]
}
```

## Common Actions

| Action | Description |
|--------|-------------|
| `s3:GetObject` | Read objects |
| `s3:PutObject` | Write objects |
| `s3:DeleteObject` | Delete objects |
| `s3:ListBucket` | List bucket contents |
| `s3:GetBucketLocation` | Get bucket region |
| `s3:*` | All S3 actions |

## Resource Patterns

| Pattern | Matches |
|---------|---------|
| `arn:aws:s3:::bucket` | Bucket itself |
| `arn:aws:s3:::bucket/*` | All objects in bucket |
| `arn:aws:s3:::bucket/prefix/*` | Objects with prefix |
| `arn:aws:s3:::*` | All buckets |

## Validation

The module validates that `policy` is valid JSON.

## Related Modules

| Module | Purpose |
|--------|---------|
| `minio-iam-user` | Create users and attach policies |
