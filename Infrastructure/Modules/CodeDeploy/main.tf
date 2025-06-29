
resource "aws_codedeploy_app" "code-deploy_app" {
  compute_platform = "ECS"
  name             = var.name
}



resource "aws_codedeploy_deployment_group" "deployment-group" {
  app_name               = aws_codedeploy_app.code-deploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "deployment-group-${var.name}"
  service_role_arn       = var.service_role_arn


  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_lb_listener]
      }

      target_group {
        name = var.blue_target_group
      }

      target_group {
        name = var.green_target_group
      }

    }
  }

  trigger_configuration {
    trigger_events = [
      "DeploymentSuccess",
      "DeploymentFailure",
    ]

    trigger_name       = var.trigger_name
    trigger_target_arn = var.sns_topic_arn
  }

  lifecycle {
    ignore_changes = [blue_green_deployment_config]
  }

}