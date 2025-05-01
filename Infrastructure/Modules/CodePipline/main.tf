
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
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Repo             = var.Repository
        Owner            = var.Owner
        Branch           = var.Branch
        PollForSourceChanges = true
        OAuthToken = var.oauth_github_token
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
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_backend"]
      version  = "1"

      configuration = {
        ProjectName = var.ProjectName_backend
      }
    }
  }

    stage {
    name = "Build"

    action {
      name             = "Build_frontend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
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
      name     = "Deploy_frontend"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact_backend"]
      version  = "1"

      configuration = {
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact_backend"
        AppSpecTemplatePath            = "appspec.yaml"
        AppName                = var.AppName_Backend
        DeploymentGroupName            = var.DeploymentGroup_backend
        TaskDefinitionTemplateArtifact = "BuildArtifact_backend"

      }
    }
  }

    stage {
    name = "Deploy"

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
        AppSpecTemplatePath            = "appspec.yaml"
        AppName                = var.AppName_frontend
        DeploymentGroupName            = var.DeploymentGroup_frontend
        TaskDefinitionTemplateArtifact = "BuildArtifact_frontend"
      }
    }
  }
}



















