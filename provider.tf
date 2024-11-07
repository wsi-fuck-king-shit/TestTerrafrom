terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

provider "tls" {
}

provider "local" {
}

data "aws_caller_identity" "caller" {
}
