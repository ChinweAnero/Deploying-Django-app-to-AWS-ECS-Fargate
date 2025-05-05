
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
        DetectChanges = true
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
        TaskDefinitionTemplatePath     = "App/taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_backend"
        AppSpecTemplatePath            = "App/appspec.yml"
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
       TaskDefinitionTemplatePath     = "App/taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_frontend"
        AppSpecTemplatePath            = "App/appspec.yml"
        ApplicationName              = var.AppName_frontend
        DeploymentGroupName            = var.DeploymentGroup_frontend
        TaskDefinitionTemplateArtifact = "BuildArtifact_frontend"
      }
    }
  }
}



















