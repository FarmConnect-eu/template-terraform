# minio-iam-user

Terraform module for creating IAM users in MinIO with policy attachments.

## Overview

Creates and manages MinIO IAM users with:
- User creation with optional secret key
- Policy attachment support
- User enable/disable control
- Tagging support

## Usage

### Basic User

```hcl
module "terraform_user" {
  source = "../../template-terraform/modules/minio-iam-user"

  name = "terraform-backend"
}
```

### User with Policy Attachment

```hcl
module "backup_user" {
  source = "../../template-terraform/modules/minio-iam-user"

  name          = "backup-service"
  policy_names  = ["backup-read-write"]
  tags = {
    service = "backup"
    env     = "production"
  }
}
```

### User with Custom Secret

```hcl
module "app_user" {
  source = "../../template-terraform/modules/minio-iam-user"

  name   = "application-service"
  secret = var.minio_app_secret  # Use sensitive variable
}
```

### Disabled User

```hcl
module "deprecated_user" {
  source = "../../template-terraform/modules/minio-iam-user"

  name         = "old-service"
  disable_user = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| minio | >= 2.0.0 |

## Provider Configuration

```hcl
provider "minio" {
  minio_server   = var.minio_endpoint    # e.g., minio.farmconnect.local:9000
  minio_user     = var.minio_root_user
  minio_password = var.minio_root_password
  minio_ssl      = true
}
```

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `name` | IAM user name | `string` |

### Optional

| Name | Description | Type | Default | Sensitive |
|------|-------------|------|---------|-----------|
| `secret` | Secret key (auto-generated if null) | `string` | `null` | **Yes** |
| `policy_names` | Policies to attach | `list(string)` | `[]` | No |
| `disable_user` | Disable the user | `bool` | `false` | No |
| `force_destroy` | Delete user with non-Terraform access keys | `bool` | `false` | No |
| `tags` | Tags for the user | `map(string)` | `{}` | No |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `id` | IAM user ID | No |
| `name` | IAM user name | No |
| `status` | User status | No |
| `secret` | User secret key | **Yes** |
| `attached_policies` | List of attached policy names | No |
| `user_summary` | Summary object | No |

## Name Validation

User names must contain only:
- Alphanumeric characters (`a-z`, `A-Z`, `0-9`)
- Special characters: `+ = , . @ _ -`

## Complete Example

```hcl
terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = ">= 2.0.0"
    }
  }
}

provider "minio" {
  minio_server   = "svc-minio-1.farmconnect.local:9000"
  minio_user     = var.minio_root_user
  minio_password = var.minio_root_password
  minio_ssl      = true
}

# Create policy first
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

# Create user with policy
module "terraform_user" {
  source = "../../template-terraform/modules/minio-iam-user"

  name         = "terraform-backend"
  policy_names = [module.terraform_policy.name]
  tags = {
    purpose = "terraform-state"
    managed = "terraform"
  }
}

output "terraform_access_key" {
  value = module.terraform_user.name
}

output "terraform_secret_key" {
  value     = module.terraform_user.secret
  sensitive = true
}
```

## Integration with Terraform S3 Backend

```hcl
# After creating the MinIO user, configure backend:
terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "infra-nfs/terraform.tfstate"
    region                      = "main"
    endpoint                    = "https://svc-minio-1.farmconnect.local:9000"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
    # access_key and secret_key from environment or -backend-config
  }
}
```

## Related Modules

| Module | Purpose |
|--------|---------|
| `minio-iam-policy` | Create IAM policies |
| `minio-bucket` | Create S3 buckets (placeholder) |

## Prerequisites

1. MinIO server running (`svc-minio-1`)
2. Root credentials available
3. Policies created before user (if attaching)
