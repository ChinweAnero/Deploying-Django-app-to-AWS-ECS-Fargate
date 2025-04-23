

resource "aws_codebuild_project" "codebuild" {
  name          = var.name
  build_timeout = 10
  service_role  = var.service_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_REGION"
      value = var.region_aws
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "REPO_URL"
      value = var.repo_url
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "DYNAMO_TABLE"
      value = var.dynamodb_table
    }

    environment_variable {
      name  = "TASK_DEFINITION_FAMILY_NAME"
      value = var.task_definition_family
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

     environment_variable {
      name  = "SERVICE_PORT"
      value = var.service_port
    }

     environment_variable {
      name  = "PATH_TO_FOLDER"
      value = var.folder_path
    }

    environment_variable {
      name  = "PATH_TO_FOLDER"
      value = var.folder_path
    }

    environment_variable {
      name  = "ECS_ROLE"
      value = var.ecs_role
    }

    environment_variable {
      name  = "ECS_TASK_ROLE"
      value = var.ecs_task_role
    }

    environment_variable {
      name  = "BACKEND_LB_URL"
      value = var.backend_lb_url
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

  }

  source {
    type            = "CODEPIPELINE"
    buildspec = var.build_spec

  }

  tags = {
    Environment = "Prod"
  }
}