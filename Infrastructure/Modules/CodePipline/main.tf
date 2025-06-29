
resource "aws_codepipeline" "codepipeline" {
  name     = var.name
  role_arn = var.code_pipeline_role_arn

  artifact_store {
    location = var.s3_bucket_for_codepipelineartifacts
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        FullRepositoryId = var.Repository
        BranchName           = var.Branch
        DetectChanges = "true"
        ConnectionArn = var.connection_arn
      }
    }

  }

  stage {
    name = "Build"

    action {
      name     = "Build_backend"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      output_artifacts = ["BuildArtifact_backend"]
      version  = "1"

      configuration = {
        ProjectName = var.ProjectName_backend
      }
    }

    action {
      name             = "Build_frontend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildArtifact_frontend"]
      version          = "1"

      configuration = {
        ProjectName = var.ProjectName_frontend

      }
    }
    action {
      name     = "Build_prometheus"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      output_artifacts = ["BuildArtifact_prometheus"]
      version  = "1"

      configuration = {
        ProjectName = var.PromprojectName
      }
    }
    # action {
    #   name     = "Build_prometheus_UI"
    #   category = "Build"
    #   owner    = "AWS"
    #   provider = "CodeBuild"
    #   input_artifacts = ["SourceOutput"]
    #   output_artifacts = ["BuildArtifact_prometheus_UI"]
    #   version  = "1"
    #
    #   configuration = {
    #     ProjectName = var.PromuiprojectName
    #   }
    # }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy_backend"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact_backend"]
      version  = "1"

      configuration = {
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_backend"
        AppSpecTemplatePath            = "appspec.json"
        ApplicationName                = var.AppName_Backend
        DeploymentGroupName            = var.DeploymentGroup_backend
        TaskDefinitionTemplateArtifact = "BuildArtifact_backend"

      }
    }

    action {
      name            = "Deploy_frontend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact_frontend"]
      version         = "1"

      configuration = {
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_frontend"
        AppSpecTemplatePath            = "appspec.json"
        ApplicationName              = var.AppName_frontend
        DeploymentGroupName            = var.DeploymentGroup_frontend
        TaskDefinitionTemplateArtifact = "BuildArtifact_frontend"
      }
    }
    action {
      name            = "Deploy_prometheus"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact_prometheus"]
      version         = "1"

      configuration = {
        TaskDefinitionTemplatePath     = "prometheus-taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_prometheus"
        AppSpecTemplatePath            = "prometheus-appspec.json"
        ApplicationName              = var.PromappName
        DeploymentGroupName            = var.PromDeploymentGroup
        TaskDefinitionTemplateArtifact = "BuildArtifact_prometheus"
      }
    }
    # action {
    #   name            = "Deploy_prometheus_UI"
    #   category        = "Deploy"
    #   owner           = "AWS"
    #   provider        = "CodeDeployToECS"
    #   input_artifacts = ["BuildArtifact_prometheus_UI"]
    #   version         = "1"
    #
    #   configuration = {
    #     TaskDefinitionTemplatePath     = "prometheus-taskdef.json"
    #     AppSpecTemplateArtifact        = "BuildArtifact_prometheus_UI"
    #     AppSpecTemplatePath            = "prometheus-appspec.json"
    #     ApplicationName              = var.PromUIappName
    #     DeploymentGroupName            = var.PromUIDeploymentGroup
    #     TaskDefinitionTemplateArtifact = "BuildArtifact_prometheus_UI"
    #   }
    # }
  }
}



















