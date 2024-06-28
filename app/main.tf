# terraform {
#   backend "s3" {
#     region     = "us-east-1"
#     # access_key = "YOUR-ACCESS-KEY"
#     # secret_key = "YOUR-SECRET-KEY"
#     shared_credentials_files = ["../.secrets/credentials"]
#     bucket = "backend-eazyastuces"
#     key = "eazy-astuce.tfstate"
#   }
# }

provider "aws" {
  region     = "us-east-1"
  # access_key = "YOUR-ACCESS-KEY"
  # secret_key = "YOUR-SECRET-KEY"
  shared_credentials_files = ["../../.secrets/credentials"]
  profile = "default"
}

module "ec2" {
  depends_on = [ module.sg, module.keypair]
  source = "../modules/ec2"
  instance_type = "t2.micro"
  aws_common_tag = {
    Name = "ec2-eazy-astuce"
  }
  key_name = module.keypair.key_name
  security_groups = [module.sg.aws_sg_name]
  private_key = module.keypair.private_key
}

module "keypair" {
  source = "../modules/keypair"
  key_name = "devops-keypair"
}

module "sg" {
  source = "../modules/sg"
  sg_name = "eazyastuce-sg"
}

resource "null_resource" "name" {
  depends_on = [ module.ec2 ]
  provisioner "local-exec" {
    command = "echo PUBLIC_IP: ${module.ec2.public_ip} - PUBLIC_DNS: ${module.ec2.public_dns}  > ip_ec2.txt"
  }
}