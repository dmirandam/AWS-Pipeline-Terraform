terraform {
  backend "s3" {

    bucket  = "aws-cicd-pipeline-is2"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-2"

  }
}

provider "aws" {
  region = "us-east-2"
}

