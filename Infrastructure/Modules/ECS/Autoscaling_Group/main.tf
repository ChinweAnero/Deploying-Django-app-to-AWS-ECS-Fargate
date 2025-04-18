
resource "aws_appautoscaling_target" "target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.name_of_cluster}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  lifecycle {
    ignore_changes = [
      role_arn,
    ]
  }
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-policy-CPU-${var.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  step_scaling_policy_configuration {
    target_value = 50
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_type = "ECSServiceAverageCPUUtilization"

  }
}
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-policy-MEMORY-${var.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  step_scaling_policy_configuration {
    target_value = 50
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_type = "ECSServiceAverageMemoryUtilization"

  }
}

#*******************************Cloudwatch monitoring****************************************#
resource "aws_cloudwatch_metric_alarm" "ecs_alarm" {
  alarm_name          = "ecs_cpu-alarm-${var.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         =  "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 50

  dimensions = {
    "Cluster" = ""
    "Service " = ""
  }

  alarm_description = "monitor_cpu_utilzation-${var.name}"

}

resource "aws_cloudwatch_metric_alarm" "ecs_alarm" {
  alarm_name          = "ecs_memory-alarm-${var.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 50

  dimensions = {
    "Cluster" = ""
    "Service " = ""
  }

  alarm_description = "monitor_memory_utilzation-${var.name}"

}
