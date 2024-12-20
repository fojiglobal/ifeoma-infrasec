# AWS Organization
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

# AWS Organization Account - 'CS2-Sandbox' -> Imported
resource "aws_organizations_account" "cs2-sandbox" {
  name  = "cs2-sandbox"
  email = "alearning58+cs2sandbox@gmail.com"
  parent_id = aws_organizations_organizational_unit.cs2-sandbox.id
}

# AWS Organization Account - 'CS2-Secops' 
resource "aws_organizations_account" "cs2-secops" {
  name  = "cs2-secops"
  email = "alearning58+cs2secops@gmail.com"
  parent_id = aws_organizations_organizational_unit.cs2-secops.id
}

# Import AWS SSO Permission set 
resource "aws_ssoadmin_permission_set" "admin-permission" {
  name             = "AdministratorAccess"
  instance_arn     = tolist(data.aws_ssoadmin_instances.fojiglobal.arns)[0]
}

resource "aws_ssoadmin_permission_set" "billing-permission" {
  name             = "Billing"
  instance_arn     = tolist(data.aws_ssoadmin_instances.fojiglobal.arns)[0]
}