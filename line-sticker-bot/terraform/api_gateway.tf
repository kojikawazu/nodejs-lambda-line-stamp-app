# ---------------------------------------------
# REST APIの作成
# ---------------------------------------------
resource "aws_api_gateway_rest_api" "line_bot_api" {
  name = "sticker-bot-api"
}

# ---------------------------------------------
# リソースの作成（/webhookエンドポイント）
# ---------------------------------------------
resource "aws_api_gateway_resource" "webhook_resource" {
  rest_api_id = aws_api_gateway_rest_api.line_bot_api.id
  parent_id   = aws_api_gateway_rest_api.line_bot_api.root_resource_id
  path_part   = "webhook"
}

# ---------------------------------------------
# メソッドの作成（POSTメソッド）
# ---------------------------------------------
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.line_bot_api.id
  resource_id   = aws_api_gateway_resource.webhook_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# ---------------------------------------------
# 統合の設定（Lambdaプロキシ統合）
# ---------------------------------------------
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.line_bot_api.id
  resource_id             = aws_api_gateway_resource.webhook_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.line_bot_function.invoke_arn
}

# ---------------------------------------------
# Lambda関数にAPI Gatewayからの実行権限を付与
# ---------------------------------------------
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.line_bot_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.line_bot_api.execution_arn}/*/*"
}

# ---------------------------------------------
# デプロイメントの作成
# ---------------------------------------------
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.line_bot_api.id
}

# ---------------------------------------------
# ステージの作成
# ---------------------------------------------
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.line_bot_api.id
  stage_name    = "prod"
}
