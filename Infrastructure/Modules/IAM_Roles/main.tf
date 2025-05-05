
#*******************IAM Roles*******************************************#
resource "aws_iam_role" "iam_role_ecs_task_execution" {
  name = var.name_
  count = var.create_ecs_role == true ? 1 : 0
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "ECS ROLE"
    Environment = "Prod"
  }
  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_iam_role" "role_for_ecs_task" {
  name = var.ecs_task_role_name
  count = var.create_ecs_role == true ? 1 : 0
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "ecs_task_role"
  }

  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_iam_role" "pipeline_role" {
  name = var.pipeline_role_name
  count = var.create_pipeline_role == true ? 1 : 0
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com"

        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "Pipeline Role"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_iam_role" "codeploy_role" {
  name = var.codedeploy_role_name
  count = var.create_role_for_codedeploy == true ? 1 : 0
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#**************************IAM Policies***************************#

resource "aws_iam_policy" "pipeline_role_policy" {
  count = var.create_pipeline_policy == true ? 1 : 0
  name = "Role-policy-${var.name_}"
  policy = data.aws_iam_policy_document.role_policy_pipeline_role.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "ecs_role_policy" {
  count = var.create_ecs_role == true ? 1 : 0
  name = "ecs-policy-${var.ecs_task_role_name}"
  policy = data.aws_iam_policy_document.role_policy_for_ecs_tasks.json
  lifecycle {
    create_before_destroy = true
  }
}

#****************************iam policy attachments**********************************#
resource "aws_iam_role_policy_attachment" "ecs_role_attachment" {
  count = var.create_ecs_role == true ? 1 : 0
  policy_arn = aws_iam_policy.ecs_role_policy[0].arn
  role       = aws_iam_role.role_for_ecs_task[0].name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "attach_ecs_exec_role" {
  count = length(aws_iam_role.iam_role_ecs_task_execution) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.iam_role_ecs_task_execution[0].name
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_iam_role_policy_attachment" "attach_role" {
  count = var.create_pipeline_policy == true ? 1 : 0
  policy_arn = aws_iam_policy.pipeline_role_policy[0].arn
  role       = var.attach_with_role
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_iam_role_policy_attachment" "attach_policy_for_codedeploy" {
  count = var.create_role_for_codedeploy == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.codeploy_role[0].name
}

#*************************policy data attachments*********************************#
data "aws_iam_policy_document" "role_policy_pipeline_role" {
  statement {
    sid    = "AllowS3Actions"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:List*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCodebuildActions"
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch",
      "codebuild:StopBuild"
    ]
    resources = var.codebuild_projects
  }
  statement {
    sid    = "AllowCodebuildList"
    effect = "Allow"
    actions = [
      "codebuild:ListBuilds"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCodeDeployActions"
    effect = "Allow"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentGroup",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCodeDeployConfigs"
    effect = "Allow"
    actions = [
      "codedeploy:GetDeploymentConfig",
      "codedeploy:CreateDeploymentConfig",
      "codedeploy:CreateDeploymentGroup",
      "codedeploy:GetDeploymentTarget",
      "codedeploy:StopDeployment",
      "codedeploy:ListApplications",
      "codedeploy:ListDeploymentConfigs",
      "codedeploy:ListDeploymentGroups",
      "codedeploy:ListDeployments"

    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowECRActions"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = var.ecr_repo
  }
  statement {
    sid    = "AllowECRAuthorization"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCECSServiceActions"
    effect = "Allow"
    actions = [
      "ecs:ListServices",
      "ecs:ListTasks",
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTaskSets",
      "ecs:DeleteTaskSet",
      "ecs:DeregisterContainerInstance",
      "ecs:CreateTaskSet",
      "ecs:UpdateCapacityProvider",
      "ecs:PutClusterCapacityProviders",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:RegisterTaskDefinition",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:UpdateService",
      "ecs:UpdateCluster",
      "ecs:UpdateTaskSet"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowIAMPassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCloudWatchActions"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowCodeStarConnection"
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection",
      "codestar-connections:PassConnection"
    ]
    resources = ["*"]
  }


}

data "aws_iam_policy_document" "role_policy_for_ecs_tasks" {
  statement {
    sid    = "AllowS3Actions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = var.s3_assets
  }
  statement {
    sid    = "AllowIAMPassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowDynamodbActions"
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = var.dynamo_db
  }

}


