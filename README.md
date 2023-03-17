Terraform Module to provision an AWS EC2 instance with the latest amazon linux 2 ami and installed docker in it.

Not intended for production use. It is an example module.

It is just for showing how to create a publish module in Terraform Registry.

Usage:

```hcl

provider "aws" {
  region = "us-east-1"
}

module "docker_instance" {
    source = "MarcusGNS/docker-instance/aws"
    key_name = "clarusway"
}
```


# Source ismini  kendi github account name'imiz ile değiştirdik. Ardından da bu isimde bir dosyayı github'ımızda açıyoruz. ----->>>>>  Repository name: terraform-aws-docker-instance  (Burada isme önce terraform, ardından provider-name, ardından mantıklı/açıklayıcı bir isim.)