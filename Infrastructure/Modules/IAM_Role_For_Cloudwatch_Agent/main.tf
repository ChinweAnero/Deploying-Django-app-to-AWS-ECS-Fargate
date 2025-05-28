# resource "aws_iam_role" "cloudwatch_role" {
#   name = var.cloudwatch_agent_role_name
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })
#
#   tags = {
#     tag-key = "cloudwatch_agent"
#   }
# }
#
# resource "aws_iam_role_policy" "test_policy" {
#   name = "test_policy"
#   role = aws_iam_role.cloudwatch_role
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#           "ecs:ListTasks",
#           "ecs:ListServices",
#           "ecs:DescribeContainerInstances",
#           "ecs:DescribeServices",
#           "ecs:DescribeTasks",
#           "ecs:DescribeTaskDefinition"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }