terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "thelongradio-terraform"
    key    = "cluster-config/production"
    region = "us-east-1"
  }

  required_version = "~> 1.2.8"
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region = "us-east-1"
}