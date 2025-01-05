#### Web ACL to protect our app in the staging environment

resource "aws_wafv2_web_acl" "staging_waf" {
  name        = "${local.env}-waf"
  description = "Using Web ACLs for our ALB using AWS Managed Rules"
  scope       = "REGIONAL"

  # Default web ACL action for requests that don't match any rules
  default_action {
    allow {}
  }

  # Admin protection AWS Managed rule group
  rule {
    name     = "AWSManagedRulesAdminProtectionRuleSet"
    priority = 10
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "admin-protection-ruleset-metric"
    }
  }

  # Core rule set AWS Managed rule group
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 20
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "common-ruleset-metric"
    }
  }

  # Known bad inputs AWS Managed rule group
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 30
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "known-bad-inputs-ruleset-metric"
    }
  }

  # Linux operating system AWS Managed rule group
  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 40
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "linux-ruleset-metric"
    }
  }

  # PHP application AWS Managed rule group
  rule {
    name     = "AWSManagedRulesPHPRuleSet"
    priority = 50
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "php-ruleset-metric"
    }
  }

  # POSIX operating system AWS Managed rule group
  rule {
    name     = "AWSManagedRulesPOSIXRuleSet"
    priority = 60
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "posix-ruleset-metric"
    }
  }

  # SQL database AWS Managed rule group
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 70
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "sql-injection-ruleset-metric"
    }
  }

  # WordPress application AWS Managed rule group
  rule {
    name     = "AWSManagedRulesWordPressRuleSet"
    priority = 80
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "wordpress-ruleset-metric"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.env}-waf-metric"
    sampled_requests_enabled   = true
  }
}

# WAF association with ALB

resource "aws_wafv2_web_acl_association" "staging_waf_alb_association" {
  resource_arn = module.staging.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.staging_waf.arn
}
