module "delete_vpcs" {
  source                                    = "../modules/aws-lambda/"
  function_name                             = "delete_vpcs"
  create_role                               = false
  lambda_role                               = "arn:aws:iam::761894779078:role/Service-Role-for-Lambda"
  runtime                                   = "python3.9"
  handler                                   = "delete_vpc.lambda_handler"
  source_path                               = "script/"
  timeout                                   = 300
  create_unqualified_alias_allowed_triggers = true
  create_current_version_allowed_triggers   = false
  publish                                   = true
  allowed_triggers = {
    trigger_point_deletevpc = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.trigger_point_deletevpc.arn
    }
  }
}

resource "aws_cloudwatch_event_rule" "trigger_point_deletevpc" {
  name                = "trigger_point_deletevpc"
  description         = "trigger_point_deletevpc"
  schedule_expression = "rate(5 minutes)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "trigger_point_deletevpc" {
  rule = aws_cloudwatch_event_rule.trigger_point_deletevpc.name
  arn  = module.delete_vpcs.lambda_function_arn
}

locals {
  date = timestamp()
}

output "time" {
  value = local.date
}