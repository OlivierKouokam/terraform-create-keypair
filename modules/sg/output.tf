output "aws_sg_name" {
  value = aws_security_group.allow_http_https.name
}

#Getting the output from private key is via this command below:
#terraform output -raw private_key