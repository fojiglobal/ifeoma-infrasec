# Get SSO information 
data "aws_ssoadmin_instances" "fojiglobal" {}

output "arn" {
  value = tolist(data.aws_ssoadmin_instances.fojiglobal.arns)[0]
}

# Import AWS Account within an Organization
import {
  to = aws_organizations_account.cs2-sandbox
  id = "050451401939"
}

# Import SSO Permission Sets
import {
  to = aws_ssoadmin_permission_set.admin-permission
  id = "arn:aws:sso:::permissionSet/ssoins-6684f9ed6fbd1238/ps-7cb412c40678a886,${tolist(data.aws_ssoadmin_instances.fojiglobal.arns)[0]}"
}

import {
  to = aws_ssoadmin_permission_set.billing-permission
  id = "arn:aws:sso:::permissionSet/ssoins-6684f9ed6fbd1238/ps-488b480a090a936b,${tolist(data.aws_ssoadmin_instances.fojiglobal.arns)[0]}"
}