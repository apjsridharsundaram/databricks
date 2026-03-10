# =============================================================================
# Complete Databricks Workspace Module - SRA-Aligned
# Creates everything needed for a production-ready Databricks workspace
# All resources created through modules (AWS public modules + our modules)
# =============================================================================

# Provider requirements are in versions.tf

# =============================================================================
# DATA SOURCES
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}

data "databricks_aws_assume_role_policy" "this" {
  provider    = databricks.account
  external_id = var.databricks_account_id
}


# =============================================================================
# LOCALS
# =============================================================================

locals {
  prefix = var.workspace_name
  suffix = random_string.suffix.result

  computed_aws_partition = var.databricks_gov_shard != null ? "aws-us-gov" : "aws"

  databricks_aws_account_id = var.databricks_gov_shard == "civilian" ? "044793339203" : (
    var.databricks_gov_shard == "dod" ? "170661010020" : "414351767826"
  )

  databricks_ec2_image_account_id = var.databricks_gov_shard != null ? "044732911619" : "601306020600"



  assume_role_partition = var.databricks_gov_shard == "dod" ? "aws-us-gov-dod" : (
    var.databricks_gov_shard == "civilian" ? "aws-us-gov" : "aws"
  )

  cmk_admin_value = var.cmk_admin_arn != null ? var.cmk_admin_arn : "arn:${local.computed_aws_partition}:iam::${data.aws_caller_identity.current.account_id}:root"

  root_bucket_name = module.s3_bucket.s3_bucket_id

  # SCC Relay PrivateLink endpoint service names per region
  scc_relay_service = {
    "ap-northeast-1" = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-02aa633bda3edbec0"
    "ap-northeast-2" = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0dc0e98a5800db5c4"
    "ap-south-1"     = "com.amazonaws.vpce.ap-south-1.vpce-svc-03fd4d9b61414f3de"
    "ap-southeast-1" = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-0557367c6fc1a0c5c"
    "ap-southeast-2" = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b4a72e8f825495f6"
    "ap-southeast-3" = "com.amazonaws.vpce.ap-southeast-3.vpce-svc-025ca447c232c6a1b"
    "ca-central-1"   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0c4e25bdbcbfbb684"
    "eu-central-1"   = "com.amazonaws.vpce.eu-central-1.vpce-svc-08e5dfca9572c85c4"
    "eu-west-1"      = "com.amazonaws.vpce.eu-west-1.vpce-svc-09b4eb2bc775f4e8c"
    "eu-west-2"      = "com.amazonaws.vpce.eu-west-2.vpce-svc-05279412bf5353a45"
    "eu-west-3"      = "com.amazonaws.vpce.eu-west-3.vpce-svc-005b039dd0b5f857d"
    "sa-east-1"      = "com.amazonaws.vpce.sa-east-1.vpce-svc-0e61564963be1b43f"
    "us-east-1"      = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
    "us-east-2"      = "com.amazonaws.vpce.us-east-2.vpce-svc-090a8fab0d73e39a6"
    "us-west-1"      = "com.amazonaws.vpce.us-west-1.vpce-svc-04cb91f9372b792fe"
    "us-west-2"      = "com.amazonaws.vpce.us-west-2.vpce-svc-0158114c0c730c3bb"
  }

  # Workspace API PrivateLink endpoint service names per region
  workspace_api_service = {
    "ap-northeast-1" = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-02691fd610d24fd64"
    "ap-northeast-2" = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0babb9bde64f34d7e"
    "ap-south-1"     = "com.amazonaws.vpce.ap-south-1.vpce-svc-0dbfe5d9ee18d6411"
    "ap-southeast-1" = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-02535b257fc253ff4"
    "ap-southeast-2" = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b87155ddd6954974"
    "ap-southeast-3" = "com.amazonaws.vpce.ap-southeast-3.vpce-svc-07a698e7e9ccfd04a"
    "ca-central-1"   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0205f197ec0e28d65"
    "eu-central-1"   = "com.amazonaws.vpce.eu-central-1.vpce-svc-081f78503812597f7"
    "eu-west-1"      = "com.amazonaws.vpce.eu-west-1.vpce-svc-0da6ebf1461278016"
    "eu-west-2"      = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"
    "eu-west-3"      = "com.amazonaws.vpce.eu-west-3.vpce-svc-008b9368d1d011f37"
    "sa-east-1"      = "com.amazonaws.vpce.sa-east-1.vpce-svc-0bafcea8cdfe11b66"
    "us-east-1"      = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
    "us-east-2"      = "com.amazonaws.vpce.us-east-2.vpce-svc-041dc2b4d7796b8d3"
    "us-west-1"      = "com.amazonaws.vpce.us-west-1.vpce-svc-09bb6ca26208063f2"
    "us-west-2"      = "com.amazonaws.vpce.us-west-2.vpce-svc-0129f463fcfbc46c5"
  }

  # Egress ports with GovCloud port 6666 exclusion
  effective_sg_egress_ports = var.databricks_gov_shard == "civilian" || var.databricks_gov_shard == "dod" ? [for port in var.sg_egress_ports : port if port != 6666] : var.sg_egress_ports
}

# =============================================================================
# RANDOM SUFFIX MODULE
# =============================================================================

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# =============================================================================
# AWS VPC MODULE
# =============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.prefix}-vpc-${local.suffix}"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.enable_private_link ? [] : var.public_subnets_cidr
  intra_subnets   = var.enable_private_link ? var.privatelink_subnets_cidr : []

  enable_nat_gateway     = var.enable_private_link ? false : true
  single_nat_gateway     = var.enable_private_link ? false : var.single_nat_gateway
  one_nat_gateway_per_az = var.enable_private_link ? false : var.one_nat_gateway_per_az
  create_igw             = var.enable_private_link ? false : true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  private_subnet_names = [for az in slice(data.aws_availability_zones.available.names, 0, 2) : "${local.prefix}-private-${az}"]
  intra_subnet_names   = var.enable_private_link ? [for az in slice(data.aws_availability_zones.available.names, 0, 2) : "${local.prefix}-privatelink-${az}"] : []

  tags = merge(
    var.tags,
    {
      Name      = "${local.prefix}-vpc-${local.suffix}"
      Purpose   = "Databricks Workspace"
      ManagedBy = "Terraform"
    }
  )

  private_subnet_tags = {
    "databricks-private" = "true"
  }

  public_subnet_tags = {
    "databricks-public" = "true"
  }
}

# =============================================================================
# AWS WORKSPACE SECURITY GROUP MODULE (SRA-aligned, GovCloud-aware)
# =============================================================================

module "sg_workspace" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${local.prefix}-workspace-sg-${local.suffix}"
  vpc_id = module.vpc.vpc_id

  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Databricks - Workspace SG - Internode Communication"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      description = "Databricks - Workspace SG - Internode Communication"
    }
  ]

  egress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Databricks - Workspace SG - Internode Communication"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      description = "Databricks - Workspace SG - Internode Communication"
    }
  ]

  egress_with_cidr_blocks = [for port in local.effective_sg_egress_ports : {
    from_port   = port
    to_port     = port
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
    description = "Databricks - Workspace SG - Control plane port ${port}"
  }]

  egress_with_prefix_list_ids = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      prefix_list_ids = data.aws_prefix_list.s3.id
      description     = "S3 Gateway Endpoint"
    }
  ]

  tags = merge(var.tags, { Name = "${local.prefix}-workspace-sg-${local.suffix}" })
}

# =============================================================================
# AWS PRIVATELINK SECURITY GROUP MODULE (SRA-aligned, GovCloud-aware)
# =============================================================================

module "sg_privatelink" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  count   = var.enable_private_link ? 1 : 0

  name   = "${local.prefix}-privatelink-sg-${local.suffix}"
  vpc_id = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = concat(
    [
      {
        from_port                = "443"
        to_port                  = "443"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - REST API"
      },
      {
        from_port                = "2443"
        to_port                  = "2443"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - SCC Compliance Security Profile"
      },
      {
        from_port                = "5432"
        to_port                  = "5432"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - PostgreSQL / Lakebase"
      },
      {
        from_port                = "8443"
        to_port                  = "8443"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - Compute to Control Plane API"
      },
      {
        from_port                = "8444"
        to_port                  = "8444"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - Unity Catalog Logging and Lineage"
      },
      {
        from_port                = "8445"
        to_port                  = "8451"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - Future Extendability"
      }
    ],
    var.databricks_gov_shard == "civilian" || var.databricks_gov_shard == "dod" ? [] : [
      {
        from_port                = "6666"
        to_port                  = "6666"
        protocol                 = "tcp"
        source_security_group_id = module.sg_workspace.security_group_id
        description              = "Databricks - PrivateLink Endpoint SG - Secure Cluster Connectivity"
      }
    ]
  )

  number_of_computed_ingress_with_source_security_group_id = var.databricks_gov_shard == "civilian" || var.databricks_gov_shard == "dod" ? 6 : 7

  tags = merge(var.tags, { Name = "${local.prefix}-privatelink-sg-${local.suffix}" })
}

# =============================================================================
# AWS S3 ROOT STORAGE BUCKET
# =============================================================================

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${local.prefix}-root-${local.suffix}"

  force_destroy       = var.force_destroy
  acceleration_status = "Suspended"

  versioning = {
    enabled = var.root_bucket_versioning
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = var.enable_cmk ? "aws:kms" : "AES256"
        kms_master_key_id = var.enable_cmk ? module.kms_workspace_storage[0].key_arn : null
      }
      bucket_key_enabled = var.enable_cmk
    }
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Grant Databricks Access"
        Effect = "Allow"
        Principal = {
          AWS = "arn:${local.computed_aws_partition}:iam::${local.databricks_aws_account_id}:root"
        }
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:s3:::${local.prefix}-root-${local.suffix}/*",
          "arn:${local.computed_aws_partition}:s3:::${local.prefix}-root-${local.suffix}"
        ]
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/DatabricksAccountId" = var.databricks_account_id
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name    = "Databricks Workspace Storage"
    Purpose = "Databricks Root Storage"
  })
}

# =============================================================================
# AWS PRIVATELINK VPC ENDPOINTS MODULE
# S3 Gateway + STS/Kinesis/Backend REST/Backend Relay Interface endpoints
# =============================================================================

module "vpc_endpoints" {
  count = var.enable_private_link ? 1 : 0

  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.sg_privatelink[0].security_group_id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = merge(var.tags, { Name = "${local.prefix}-s3-vpc-endpoint-${local.suffix}" })
    }
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.intra_subnets
      tags                = merge(var.tags, { Name = "${local.prefix}-sts-vpc-endpoint-${local.suffix}" })
    }
    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = module.vpc.intra_subnets
      tags                = merge(var.tags, { Name = "${local.prefix}-kinesis-vpc-endpoint-${local.suffix}" })
    }
    backend_rest = {
      service_name        = local.workspace_api_service[var.aws_region]
      private_dns_enabled = true
      subnet_ids          = module.vpc.intra_subnets
      tags                = merge(var.tags, { Name = "${local.prefix}-databricks-backend-rest-${local.suffix}" })
    }
    backend_relay = {
      service_name        = local.scc_relay_service[var.aws_region]
      private_dns_enabled = true
      subnet_ids          = module.vpc.intra_subnets
      tags                = merge(var.tags, { Name = "${local.prefix}-databricks-backend-relay-${local.suffix}" })
    }
  }
}

# =============================================================================
# DATABRICKS PRIVATELINK REGISTRATION
# =============================================================================

resource "databricks_mws_vpc_endpoint" "backend_rest" {
  provider = databricks.account
  count    = var.enable_private_link ? 1 : 0

  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = module.vpc_endpoints[0].endpoints["backend_rest"].id
  vpc_endpoint_name   = "${local.prefix}-vpce-backend-${module.vpc.vpc_id}"
  region              = var.aws_region
}

resource "databricks_mws_vpc_endpoint" "backend_relay" {
  provider = databricks.account
  count    = var.enable_private_link ? 1 : 0

  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = module.vpc_endpoints[0].endpoints["backend_relay"].id
  vpc_endpoint_name   = "${local.prefix}-vpce-relay-${module.vpc.vpc_id}"
  region              = var.aws_region
}

resource "databricks_mws_private_access_settings" "this" {
  provider = databricks.account
  count    = var.enable_private_link ? 1 : 0

  private_access_settings_name = "${local.prefix}-PAS-${local.suffix}"
  region                       = var.aws_region
  public_access_enabled        = var.public_access_enabled
  private_access_level         = var.private_access_level
}

# =============================================================================
# AWS KMS - WORKSPACE STORAGE (SRA-aligned with DatabricksAccountId + EBS)
# =============================================================================

module "kms_workspace_storage" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"
  count   = var.enable_cmk ? 1 : 0

  description = "KMS key for Databricks workspace storage encryption"
  key_usage   = "ENCRYPT_DECRYPT"

  key_statements = [
    {
      sid    = "Enable IAM User Permissions"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.cmk_admin_value]
        }
      ]
      actions   = ["kms:*"]
      resources = ["*"]
    },
    {
      sid    = "Allow Databricks to use KMS key for DBFS"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:${local.computed_aws_partition}:iam::${local.databricks_aws_account_id}:root"]
        }
      ]
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "aws:PrincipalTag/DatabricksAccountId"
          values   = [var.databricks_account_id]
        }
      ]
    },
    {
      sid    = "Allow Databricks to use KMS key for EBS"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [module.iam_assumable_role_databricks.iam_role_arn]
        }
      ]
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:CreateGrant",
        "kms:DescribeKey"
      ]
      resources = ["*"]
      conditions = [
        {
          test     = "ForAnyValue:StringLike"
          variable = "kms:ViaService"
          values   = ["ec2.*.amazonaws.com"]
        }
      ]
    }
  ]

  tags = merge(var.tags, { Name = "databricks-workspace-storage-cmk" })
}

# =============================================================================
# AWS KMS - MANAGED SERVICES (SRA-aligned: Encrypt/Decrypt only)
# =============================================================================

module "kms_managed_services" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"
  count   = var.enable_cmk ? 1 : 0

  description = "KMS key for Databricks managed services encryption"
  key_usage   = "ENCRYPT_DECRYPT"

  key_statements = [
    {
      sid    = "Enable IAM User Permissions"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.cmk_admin_value]
        }
      ]
      actions   = ["kms:*"]
      resources = ["*"]
    },
    {
      sid    = "Allow Databricks to use KMS key for managed services"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:${local.computed_aws_partition}:iam::${local.databricks_aws_account_id}:root"]
        }
      ]
      actions = [
        "kms:Encrypt",
        "kms:Decrypt"
      ]
      resources = ["*"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "aws:PrincipalTag/DatabricksAccountId"
          values   = [var.databricks_account_id]
        }
      ]
    }
  ]

  tags = merge(var.tags, { Name = "databricks-managed-services-cmk" })
}

# =============================================================================
# AWS IAM ROLE MODULE
# =============================================================================

module "iam_assumable_role_databricks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_arns = []

  create_role                       = true
  role_name                         = "${local.prefix}-cross-account-${local.suffix}"
  role_requires_mfa                 = false
  create_custom_role_trust_policy   = true
  custom_role_trust_policy          = data.databricks_aws_assume_role_policy.this.json

  custom_role_policy_arns = [module.iam_policy_databricks.arn]

  tags = merge(var.tags, { Name = "Databricks Cross-Account Role" })
}

# =============================================================================
# AWS IAM POLICY MODULE (SRA-aligned: GetLaunchTemplateData, GetSpotPlacementScores, AllowEC2Tagging)
# =============================================================================

module "iam_policy_databricks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name        = "${local.prefix}-databricks-policy-${local.suffix}"
  description = "Databricks cross-account policy with full EC2 and networking permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CreateEC2ResourcesWithRequestTag"
        Effect = "Allow"
        Action = [
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:CreateVolume",
          "ec2:RequestSpotInstances",
          "ec2:RunInstances"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:launch-template/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*"
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "AllowDatabricksTagOnCreate"
        Effect = "Allow"
        Action = ["ec2:CreateTags"]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:launch-template/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = [
              "CreateFleet",
              "CreateLaunchTemplate",
              "CreateVolume",
              "RequestSpotInstances",
              "RunInstances"
            ]
            "aws:RequestTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "ModifyEC2ResourcesByResourceTags"
        Effect = "Allow"
        Action = [
          "ec2:AssignPrivateIpAddresses",
          "ec2:AssociateIamInstanceProfile",
          "ec2:AttachVolume",
          "ec2:CancelSpotInstanceRequests",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DetachVolume",
          "ec2:DisassociateIamInstanceProfile",
          "ec2:ModifyFleet",
          "ec2:ModifyLaunchTemplate",
          "ec2:RequestSpotInstances",
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateVolume",
          "ec2:RunInstances"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:launch-template/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:spot-instance-request/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "GetEC2LaunchTemplateDataByTag"
        Effect = "Allow"
        Action = [
          "ec2:GetLaunchTemplateData"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "DescribeEC2Resources"
        Effect = "Allow"
        Action = [
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeFleetHistory",
          "ec2:DescribeFleetInstances",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeFleets",
          "ec2:DescribeIamInstanceProfileAssociations",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribePrefixLists",
          "ec2:DescribeReservedInstancesOfferings",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:GetSpotPlacementScores"
        ]
        Resource = "*"
      },
      {
        Sid    = "DeleteEC2ResourcesByTag"
        Effect = "Allow"
        Action = [
          "ec2:DeleteFleets",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:TerminateInstances"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:launch-template/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:spot-instance-request/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "AllowEC2TaggingOnDatabricksResources"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:launch-template/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:fleet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:spot-instance-request/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Vendor" = "Databricks"
          }
        }
      },
      {
        Sid    = "VpcNonresourceSpecificActions"
        Effect = "Allow"
        Action = [
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Resource = "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/${module.sg_workspace.security_group_id}"
        Condition = {
          StringEquals = {
            "ec2:vpc" = "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/${module.vpc.vpc_id}"
          }
        }
      },
      {
        Sid    = "RestrictAMIUsageToDatabricksDeny"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:RequestSpotInstances"
        ]
        Resource = "arn:${local.computed_aws_partition}:ec2:*:*:image/*"
        Condition = {
          StringNotEquals = {
            "ec2:Owner" = local.databricks_ec2_image_account_id
          }
        }
      },
      {
        Sid    = "RestrictAMIUsageToDatabricksAllow"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:RequestSpotInstances"
        ]
        Resource = "arn:${local.computed_aws_partition}:ec2:*:*:image/*"
        Condition = {
          StringEquals = {
            "ec2:Owner" = local.databricks_ec2_image_account_id
          }
        }
      },
      {
        Sid    = "AllowRunInstancesWithScopedResources"
        Effect = "Allow"
        Action = "ec2:RunInstances"
        Resource = [
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subnet/*",
          "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:security-group/*"
        ]
        Condition = {
          StringEqualsIfExists = {
            "ec2:vpc" = "arn:${local.computed_aws_partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:vpc/${module.vpc.vpc_id}"
          }
        }
      },
      {
        Sid    = "IAMRoleForEC2Spot"
        Effect = "Allow"
        Action = ["iam:CreateServiceLinkedRole"]
        Resource = [
          "arn:${local.computed_aws_partition}:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "spot.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(var.tags, { Name = "Databricks Cross-Account Policy" })
}

# =============================================================================
# DATABRICKS MWS MODULES - ACCOUNT LEVEL
# =============================================================================

resource "time_sleep" "iam_role_propagation" {
  depends_on      = [module.iam_assumable_role_databricks]
  create_duration = "20s"
}

module "mws_credentials" {
  source = "./modules/mws-credentials"
  providers = {
    databricks = databricks.account
  }

  account_id       = var.databricks_account_id
  credentials_name = "${local.prefix}-credentials-${local.suffix}"
  role_arn         = module.iam_assumable_role_databricks.iam_role_arn

  depends_on = [time_sleep.iam_role_propagation]
}

module "mws_storage" {
  source = "./modules/mws-storage-configuration"
  providers = {
    databricks = databricks.account
  }

  account_id                 = var.databricks_account_id
  storage_configuration_name = "${local.prefix}-storage-${local.suffix}"
  bucket_name                = module.s3_bucket.s3_bucket_id
}

module "mws_networks" {
  source = "./modules/mws-networks"
  providers = {
    databricks = databricks.account
  }

  account_id         = var.databricks_account_id
  network_name       = "${local.prefix}-network-${local.suffix}"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.sg_workspace.security_group_id]

  vpc_endpoints = {
    dataplane_relay = var.enable_private_link ? [databricks_mws_vpc_endpoint.backend_relay[0].vpc_endpoint_id] : []
    rest_api        = var.enable_private_link ? [databricks_mws_vpc_endpoint.backend_rest[0].vpc_endpoint_id] : []
  }
}

# Register CMK with Databricks
resource "databricks_mws_customer_managed_keys" "managed_services" {
  provider = databricks.account
  count    = var.enable_cmk ? 1 : 0

  account_id = var.databricks_account_id

  aws_key_info {
    key_arn   = module.kms_managed_services[0].key_arn
    key_alias = "alias/${local.prefix}-managed-services-${local.suffix}"
  }

  use_cases = ["MANAGED_SERVICES"]
}

resource "databricks_mws_customer_managed_keys" "workspace_storage" {
  provider = databricks.account
  count    = var.enable_cmk ? 1 : 0

  account_id = var.databricks_account_id

  aws_key_info {
    key_arn   = module.kms_workspace_storage[0].key_arn
    key_alias = "alias/${local.prefix}-workspace-storage-${local.suffix}"
  }

  use_cases = ["STORAGE"]
}

# =============================================================================
# NETWORK CONNECTIVITY CONFIGURATION (NCC) - SRA Gap #1
# =============================================================================

resource "databricks_mws_network_connectivity_config" "ncc" {
  provider = databricks.account
  count    = var.enable_ncc ? 1 : 0

  name   = "${local.prefix}-ncc-${local.suffix}"
  region = var.aws_region
}


# =============================================================================
# DATABRICKS WORKSPACE MODULE
# =============================================================================

module "workspace" {
  source = "./modules/workspace"
  providers = {
    databricks = databricks.account
  }

  account_id      = var.databricks_account_id
  workspace_name  = "${local.prefix}-${local.suffix}"
  aws_region      = var.aws_region
  deployment_name = var.deployment_name

  credentials_id           = module.mws_credentials.credentials_id
  storage_configuration_id = module.mws_storage.storage_configuration_id
  network_id               = module.mws_networks.network_id

  managed_services_customer_managed_key_id = var.enable_cmk ? databricks_mws_customer_managed_keys.managed_services[0].customer_managed_key_id : null
  storage_customer_managed_key_id          = var.enable_cmk ? databricks_mws_customer_managed_keys.workspace_storage[0].customer_managed_key_id : null

  private_access_settings_id = var.enable_private_link ? databricks_mws_private_access_settings.this[0].private_access_settings_id : null

  pricing_tier = var.pricing_tier
  custom_tags  = var.tags

  depends_on = [module.s3_bucket]
}

# =============================================================================
# POST-WORKSPACE: NCC BINDING - SRA Gap #1
# =============================================================================

resource "databricks_mws_ncc_binding" "this" {
  provider = databricks.account
  count    = var.enable_ncc ? 1 : 0

  network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc[0].network_connectivity_config_id
  workspace_id                   = module.workspace.workspace_id
}


# =============================================================================
# AUDIT LOG DELIVERY - SRA Gap #3
# =============================================================================

module "s3_audit_log_delivery" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"
  count   = var.enable_audit_logs ? 1 : 0

  bucket        = "${local.prefix}-audit-log-delivery-${local.suffix}"
  force_destroy = var.force_destroy

  versioning = {
    enabled = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.databricks_aws_bucket_policy.audit_log_delivery[0].json

  tags = merge(var.tags, {
    Name    = "${local.prefix}-audit-log-delivery-${local.suffix}"
    Purpose = "Databricks Audit Log Delivery"
  })
}

data "databricks_aws_assume_role_policy" "log_delivery" {
  provider         = databricks.account
  count            = var.enable_audit_logs ? 1 : 0
  external_id      = var.databricks_account_id
  for_log_delivery = true
  aws_partition    = local.assume_role_partition
}

module "iam_role_audit_log_delivery" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"
  count   = var.enable_audit_logs ? 1 : 0

  create_role                     = true
  role_name                       = "${local.prefix}-audit-log-delivery-role-${local.suffix}"
  role_description                = "(${local.prefix}) Audit Log Delivery role"
  role_requires_mfa               = false
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.databricks_aws_assume_role_policy.log_delivery[0].json
  trusted_role_arns               = []

  tags = merge(var.tags, {
    Name = "${local.prefix}-audit-log-delivery-role-${local.suffix}"
  })
}

resource "time_sleep" "audit_log_role_propagation" {
  count = var.enable_audit_logs ? 1 : 0

  depends_on      = [module.iam_role_audit_log_delivery]
  create_duration = "10s"
}

data "databricks_aws_bucket_policy" "audit_log_delivery" {
  provider         = databricks.account
  count            = var.enable_audit_logs ? 1 : 0
  full_access_role = module.iam_role_audit_log_delivery[0].iam_role_arn
  aws_partition    = local.assume_role_partition
  bucket           = "${local.prefix}-audit-log-delivery-${local.suffix}"
}

resource "databricks_mws_credentials" "audit_log_writer" {
  provider = databricks.account
  count    = var.enable_audit_logs ? 1 : 0

  credentials_name = "${local.prefix}-audit-log-delivery-credential-${local.suffix}"
  role_arn         = module.iam_role_audit_log_delivery[0].iam_role_arn

  depends_on = [time_sleep.audit_log_role_propagation]
}

resource "databricks_mws_storage_configurations" "audit_log_bucket" {
  provider = databricks.account
  count    = var.enable_audit_logs ? 1 : 0

  account_id                 = var.databricks_account_id
  storage_configuration_name = "${local.prefix}-audit-log-delivery-storage-${local.suffix}"
  bucket_name                = module.s3_audit_log_delivery[0].s3_bucket_id
}

resource "databricks_mws_log_delivery" "audit_logs" {
  provider = databricks.account
  count    = var.enable_audit_logs ? 1 : 0

  account_id               = var.databricks_account_id
  credentials_id           = databricks_mws_credentials.audit_log_writer[0].credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.audit_log_bucket[0].storage_configuration_id
  delivery_path_prefix     = "audit-logs"
  config_name              = "Audit Logs"
  log_type                 = "AUDIT_LOGS"
  output_format            = "JSON"
}

# =============================================================================
# UNITY CATALOG MODULES
# =============================================================================

module "metastore" {
  source = "./modules/metastore"
  providers = {
    databricks = databricks.account
  }
  count = var.create_metastore ? 1 : 0

  name   = "${local.prefix}-metastore-${var.aws_region}-${local.suffix}"
  region = var.aws_region
  owner  = var.metastore_owner

  force_destroy = var.force_destroy
}

resource "databricks_metastore_assignment" "this" {
  provider     = databricks.account
  count        = var.create_metastore ? 1 : 0
  workspace_id = module.workspace.workspace_id
  metastore_id = module.metastore[0].metastore_id

  depends_on = [module.metastore, module.workspace]
}

# =============================================================================
# UNITY CATALOG: Catalog Infrastructure (SRA-aligned)
# Creates dedicated S3 bucket, KMS key, IAM role, storage credential,
# external location, and catalog - following the SRA pattern.
# =============================================================================

locals {
  uc_catalog_bucket_name = "${local.prefix}-catalog-${module.workspace.workspace_id}"
  uc_catalog_role_name   = "${local.prefix}-catalog-${module.workspace.workspace_id}"
  uc_catalog_name_safe   = replace(local.uc_catalog_bucket_name, "-", "_")
  uc_iam_arn             = "arn:${local.computed_aws_partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.uc_catalog_role_name}"
}

module "kms_catalog_storage" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"
  count   = var.create_default_catalog ? 1 : 0

  description = "KMS key for Databricks catalog storage"
  key_usage   = "ENCRYPT_DECRYPT"

  computed_aliases = {
    "catalog-storage" = {
      name = "${local.prefix}-catalog-storage-${local.suffix}-key"
    }
  }

  key_statements = [
    {
      sid    = "Enable IAM User Permissions"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.cmk_admin_value]
        }
      ]
      actions   = ["kms:*"]
      resources = ["*"]
    },
    {
      sid    = "Allow IAM Role to use the key"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.uc_iam_arn]
        }
      ]
      actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey*"]
      resources = ["*"]
    }
  ]

  tags = merge(var.tags, { Name = "${local.prefix}-catalog-storage-key-${local.suffix}" })
}

resource "databricks_storage_credential" "catalog" {
  provider = databricks.workspace
  count    = var.create_default_catalog ? 1 : 0
  name     = "${local.uc_catalog_bucket_name}-storage-credential"

  aws_iam_role {
    role_arn = local.uc_iam_arn
  }
  isolation_mode = "ISOLATION_MODE_ISOLATED"

  depends_on = [databricks_metastore_assignment.this]
}

data "databricks_aws_unity_catalog_assume_role_policy" "this" {
  provider              = databricks.workspace
  count                 = var.create_default_catalog ? 1 : 0
  aws_account_id        = data.aws_caller_identity.current.account_id
  role_name             = local.uc_catalog_role_name
  unity_catalog_iam_arn = var.unity_catalog_iam_arn
  external_id           = databricks_storage_credential.catalog[0].aws_iam_role[0].external_id
}

data "databricks_aws_unity_catalog_policy" "this" {
  provider       = databricks.workspace
  count          = var.create_default_catalog ? 1 : 0
  aws_account_id = data.aws_caller_identity.current.account_id
  bucket_name    = local.uc_catalog_bucket_name
  role_name      = local.uc_catalog_role_name
  kms_name       = module.kms_catalog_storage[0].key_arn
}

module "iam_policy_unity_catalog" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"
  count   = var.create_default_catalog ? 1 : 0

  name   = "${local.prefix}-catalog-policy-${local.suffix}"
  policy = data.databricks_aws_unity_catalog_policy.this[0].json
}

module "iam_role_unity_catalog" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"
  count   = var.create_default_catalog ? 1 : 0

  create_role                     = true
  role_name                       = local.uc_catalog_role_name
  role_requires_mfa               = false
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.databricks_aws_unity_catalog_assume_role_policy.this[0].json
  trusted_role_arns               = []

  custom_role_policy_arns = [module.iam_policy_unity_catalog[0].arn]

  tags = merge(var.tags, { Name = local.uc_catalog_role_name })
}

module "s3_unity_catalog" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"
  count   = var.create_default_catalog ? 1 : 0

  bucket        = local.uc_catalog_bucket_name
  force_destroy = var.force_destroy

  versioning = {
    enabled = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.kms_catalog_storage[0].key_arn
      }
    }
  }

  tags = merge(var.tags, { Name = local.uc_catalog_bucket_name })
}

resource "time_sleep" "catalog_iam_propagation" {
  count           = var.create_default_catalog ? 1 : 0
  depends_on      = [module.iam_role_unity_catalog]
  create_duration = "60s"
}

resource "databricks_external_location" "catalog" {
  provider        = databricks.workspace
  count           = var.create_default_catalog ? 1 : 0
  name            = "${local.uc_catalog_bucket_name}-external-location"
  url             = "s3://${local.uc_catalog_bucket_name}/"
  credential_name = databricks_storage_credential.catalog[0].id
  comment         = "External location for catalog"
  isolation_mode  = "ISOLATION_MODE_ISOLATED"

  depends_on = [time_sleep.catalog_iam_propagation]
}

resource "databricks_catalog" "default" {
  provider       = databricks.workspace
  count          = var.create_default_catalog ? 1 : 0
  name           = local.uc_catalog_name_safe
  comment        = "Catalog for workspace ${module.workspace.workspace_id}"
  isolation_mode = var.catalog_isolation_mode
  storage_root   = "s3://${local.uc_catalog_bucket_name}/"
  owner          = var.catalog_owner
  force_destroy  = var.force_destroy

  properties = merge(
    var.catalog_properties,
    { created_by = "terraform-complete-workspace-module" }
  )

  depends_on = [databricks_external_location.catalog]
}

resource "databricks_default_namespace_setting" "this" {
  provider = databricks.workspace
  count    = var.create_default_catalog ? 1 : 0
  namespace {
    value = local.uc_catalog_name_safe
  }
  depends_on = [databricks_catalog.default]
}

# =============================================================================
# MEDALLION ARCHITECTURE SCHEMAS
# =============================================================================

module "schema_bronze" {
  source = "./modules/schema"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_default_catalog && var.create_bronze_schema ? 1 : 0

  catalog_name  = databricks_catalog.default[0].name
  name          = "bronze"
  comment       = "Bronze layer - raw data"
  properties    = { layer = "bronze", data_class = "raw" }
  force_destroy = var.force_destroy

  depends_on = [databricks_catalog.default]
}

module "schema_silver" {
  source = "./modules/schema"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_default_catalog && var.create_silver_schema ? 1 : 0

  catalog_name  = databricks_catalog.default[0].name
  name          = "silver"
  comment       = "Silver layer - cleaned and transformed data"
  properties    = { layer = "silver", data_class = "cleansed" }
  force_destroy = var.force_destroy

  depends_on = [databricks_catalog.default]
}

module "schema_gold" {
  source = "./modules/schema"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_default_catalog && var.create_gold_schema ? 1 : 0

  catalog_name  = databricks_catalog.default[0].name
  name          = "gold"
  comment       = "Gold layer - aggregated business-level data"
  properties    = { layer = "gold", data_class = "aggregated" }
  force_destroy = var.force_destroy

  depends_on = [databricks_catalog.default]
}

# =============================================================================
# WORKSPACE SECURITY MODULES
# =============================================================================

module "workspace_security" {
  source = "./modules/workspace-conf"
  providers = {
    databricks = databricks.workspace
  }
  count = var.configure_workspace_security ? 1 : 0

  enable_results_downloading      = false
  enable_notebook_table_clipboard = false
  enable_export_notebook          = false
  enable_dbfs_file_browser        = false
  enable_upload_data_uis          = false

  enable_verbose_audit_logs         = true
  enforce_user_isolation            = true
  store_results_in_customer_account = true

  disable_legacy_access = true
  disable_legacy_dbfs   = true
}

# =============================================================================
# COMPLIANCE SECURITY PROFILE (CSP) - SRA Gap #5
# =============================================================================

resource "databricks_compliance_security_profile_workspace_setting" "this" {
  provider = databricks.workspace
  count    = var.enable_csp ? 1 : 0

  compliance_security_profile_workspace {
    is_enabled           = true
    compliance_standards = var.compliance_standards
  }
}

# =============================================================================
# CLUSTER POLICY, IP ACCESS LIST, ADMIN GROUP
# =============================================================================

module "secure_cluster_policy" {
  source = "./modules/cluster-policy"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_cluster_policy ? 1 : 0

  name        = var.cluster_policy_name
  description = "Secure cluster policy - unlimited capacity with security controls"

  definition = jsonencode(merge(
    {
      "data_security_mode" = {
        type  = "fixed"
        value = "USER_ISOLATION"
      }
      "enable_local_disk_encryption" = {
        type  = "fixed"
        value = true
      }
      "autotermination_minutes" = {
        type     = "range"
        minValue = var.min_autotermination_minutes
        maxValue = var.max_autotermination_minutes
      }
      "ssh_public_keys" = {
        type  = "fixed"
        value = []
      }
      "spark_conf.spark.databricks.acl.dfAclsEnabled" = {
        type  = "fixed"
        value = "true"
      }
      "spark_conf.spark.databricks.passthrough.enabled" = {
        type  = "fixed"
        value = "false"
      }
      "spark_conf.spark.databricks.repl.allowedLanguages" = {
        type  = "fixed"
        value = "python,sql,scala,r"
      }
    },
    var.allowed_spark_versions != null ? {
      "spark_version" = { type = "regex", pattern = var.allowed_spark_versions }
    } : {
      "spark_version" = { type = "regex", pattern = "^[0-9]+\\.[0-9]+\\.x-.*" }
    },
    length(var.allowed_instance_types) > 0 ? {
      "node_type_id" = { type = "allowlist", values = var.allowed_instance_types }
    } : {}
  ))

  max_clusters_per_user = var.max_clusters_per_user
}

module "ip_access_list" {
  source = "./modules/ip-access-list"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_ip_access_list && length(var.allowed_ip_addresses) > 0 ? 1 : 0

  label        = var.ip_access_list_label
  list_type    = "ALLOW"
  ip_addresses = var.allowed_ip_addresses
  enabled      = true
}

module "admin_group" {
  source = "./modules/group"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_admin_group ? 1 : 0

  display_name = var.admin_group_name

  allow_cluster_create       = true
  allow_instance_pool_create = true
  databricks_sql_access      = true
  workspace_access           = true

  force = true
}

module "data_engineers_group" {
  source = "./modules/group"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_data_engineers_group ? 1 : 0

  display_name = var.data_engineers_group_name

  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true

  force = true

  depends_on = [module.admin_group]
}

module "data_scientists_group" {
  source = "./modules/group"
  providers = {
    databricks = databricks.workspace
  }
  count = var.create_data_scientists_group ? 1 : 0

  display_name = var.data_scientists_group_name

  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true

  force = true

  depends_on = [module.admin_group]
}
