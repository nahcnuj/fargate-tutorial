resource "aws_ecs_service" "fargate-tutorial" {
  name            = var.service
  task_definition = aws_ecs_task_definition.fargate-tutorial.arn
  launch_type     = "FARGATE"
}

resource "aws_ecs_task_definition" "fargate-tutorial" {
  family = var.service

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  network_mode = "awsvpc"

  container_definitions = jsonencode(
    [
      {
        name  = var.service
        image = "${aws_ecr_repository.fargate-tutorial.repository_url}:latest"
        portMappings = [
          {
            containerPort = 3000
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-region        = var.region
            awslogs-group         = aws_cloudwatch_log_group.fargate-tutorial.name
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )

  execution_role_arn = aws_iam_role.fargate-tutorial_task_execution_role.arn
}

resource "aws_cloudwatch_log_group" "fargate-tutorial" {
  name              = "/ecs/fargate-tutorial"
  retention_in_days = 7
}
