resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE" 
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
}


resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "test_codebuild_project_apply"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE" 
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

resource "aws_codepipeline" "cicd-pipeline" {
    name     = "cicd-pipeline"
    role_arn = aws_iam_role.codepipeline-role.arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_artifacts.id
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
            output_artifacts = ["tf-code"]
            configuration = {
                FullRepositoryId = "dmirandam/AWS-Pipeline-Terraform"
                BranchName = "main"
                ConnectionArn = var.codestar_credentials
                OutputArtifactFormat = "CODE_ZIP"

            }
        }
    }

    stage {
      name = "Plan"
      action {
        name            = "Build"
        category        = "Build"
        provider        = "CodeBuild"
        version         = "1" 
        owner           = "AWS"
        input_artifacts = ["tf-code"]
        configuration = {
            ProjectName = "tf-cicd-plan"
            
        }
      }
    }

    stage {
      name = "Deploy"
      action {
        name            = "Deploy"
        category        = "Build"
        provider        = "CodeBuild"
        version         = "1" 
        owner           = "AWS"
        input_artifacts = ["tf-code"]
        configuration = {
            ProjectName = "tf-cicd-plan"
            
        }
      }
    }
}