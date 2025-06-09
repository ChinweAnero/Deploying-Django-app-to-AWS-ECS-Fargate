variable "name" {
  type = string
  description = "name of the resource"
}
variable "code_pipeline_role_arn" {
  type = string
  description = "iam role for codepipeline"
}
variable "s3_bucket_for_codepipelineartifacts" {
  type = string
  description = "s3 bucket to store artifacts"
}
variable "Repository" {
  type = string
  description = "app repository"
}

variable "Branch" {
  type = string
  description = "repo branch to use"
}
variable "connection_arn" {
  type = string
  description = "code star github connection"
}

variable "ProjectName_backend" {
  type = string
  description = "name of the project"
}
variable "ProjectName_frontend" {
  type = string
  description = "name of the project"
}
variable "PromprojectName" {
  type = string
  description = "name of pipeline project"
}
variable "AppName_Backend" {
  type = string
  description = "name of the application"
}
variable "DeploymentGroup_backend" {
  type = string
  description = "name of the deployment group"
}
variable "AppName_frontend" {
  type = string
  description = "name of the application"
}
variable "PromappName" {
  type = string
  description = "name of prometheus application"
}
variable "DeploymentGroup_frontend" {
  type = string
  description = "name of the deployment group"
}
variable "PromDeploymentGroup" {
  type = string
  description = "prometheus deployment group"
}
