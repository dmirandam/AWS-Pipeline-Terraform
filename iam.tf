#--------------CodePipeline-----------------

resource "aws_iam_role" "codepipeline-role" {
  name = "codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}


data "aws_iam_policy_document" "tf-cicd-policies-cp" {
  statement {
    sid = ""
    actions = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect = "Allow"
  }

  statement {
    sid = ""
    actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }  
}

resource "aws_iam_policy" "tf-pipeline-policy" {
  name = "tf-pipeline-policy"
  path = "/"
  policy = data.aws_iam_policy_document.tf-cicd-policies-cp.json 
}

resource "aws_iam_role_policy_attachment" "tf-pipeline-attachment" {
  role = aws_iam_role.codepipeline-role.id
  policy_arn = aws_iam_policy.tf-pipeline-policy.arn
}


#--------------Codebuild-----------------

resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-policies-cb" {
  statement {
    sid = ""
    actions = ["logs:*","s3:*","codebuild:*", "secretmanager:*", "iam:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-build-policy" {
  name = "tf-build-policy"
  path = "/"
  policy = data.aws_iam_policy_document.tf-cicd-policies-cb.json 
}

resource "aws_iam_role_policy_attachment" "tf-build-attachment-1" {
  role = aws_iam_role.codebuild-role.id
  policy_arn = aws_iam_policy.tf-build-policy.arn
}

resource "aws_iam_role_policy_attachment" "tf-build-attachment-2" {
  role = aws_iam_role.codebuild-role.id
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}