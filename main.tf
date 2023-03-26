provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "app" {
  name = "app"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    name            = "app"
    image           = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings    = [{
      containerPort = 3000
      hostPort      = 0
    }]
    essential       = true
  }])

  memory     = 512
  cpu        = 256
}

resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = "app"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-12345678"]
    security_groups  = ["sg-12345678"]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/73e2d6bc24d8a067"
    container_name   = "app"
    container_port   = 3000
  }
}

output "url" {
  value = "http://${aws_ecs_service.app.load_balancer[0].dns_name}:3000"
}
