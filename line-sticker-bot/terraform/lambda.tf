# ---------------------------------------------
# Lambda関数の作成
# ---------------------------------------------
resource "aws_lambda_function" "line_bot_function" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = "sticker-bot-function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      LINE_CHANNEL_SECRET       = local.line_channel_secret
      LINE_CHANNEL_ACCESS_TOKEN = local.line_channel_access_token
    }
  }
}

# ---------------------------------------------
# localsで機密情報を管理
# ---------------------------------------------
locals {
  node_env                  = var.node_env
  port                      = var.port
  line_channel_secret       = var.line_channel_secret
  line_channel_access_token = var.line_channel_access_token
}
