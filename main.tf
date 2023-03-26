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
    subnets          = ["subnet-035781b4468f3aa57"]
    security_groups  = ["sg-0076afc693f213c24"]
    assign_public_ip = "true"
  }

}
