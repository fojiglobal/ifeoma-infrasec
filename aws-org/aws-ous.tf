# AWS Organizations Organizational Units

resource "aws_organizations_organizational_unit" "cs2-sandbox" {
  name      = "sandbox"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "cs2-secops" {
  name      = "secops"
  parent_id = aws_organizations_organization.org.roots[0].id
}