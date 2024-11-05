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
}