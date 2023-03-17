data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias" 
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh") 
  vars = {
    server-name = var.server-name
  }
}     #Bu Terraform dosyası (.tf) bir modülün içinde yer alıyor gibi görünüyor. file fonksiyonu, bir dosyanın içeriğini okumak için kullanılır. Burada, abspath fonksiyonu, belirtilen yolu tam bir dizin yolu haline getirir. Bu, ilgili dosyanın mutlak yolunu oluşturmak için kullanılır.    ${path.module} ifadesi, mevcut Terraform dosyasının dizin yolunu döndürür. abspath fonksiyonu bu yolu tam bir dizin yolu haline getirir. Sonuç olarak, file("${abspath(path.module)}/userdata.sh") ifadesi, mevcut Terraform modülündeki userdata.sh dosyasının mutlak yolunu elde etmek için kullanılır. Bu ifade, Terraform tarafından userdata.sh dosyasının içeriğini okumak için kullanılabilir.

resource "aws_instance" "tfmyec2" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  count = var.num_of_instance
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  user_data = data.template_file.userdata.rendered  # "rendered" yerine bir kaç tane attribute daha var bu data tarz dataları çekmek için ama diğerleri hata veriyor. 
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name = "${var.tag}-terraform-sec-grp"
  tags = {
    Name = var.tag
  }

  dynamic "ingress" {           
    for_each = var.docker-instance-ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 
  }                     # Tekrar eden blokları tek blok ile ayarlayıp sadece değişen  kısımları tek bir variable ile ayarlayabiliyoruz. port'u bir iterator olarak atıyoruz ve bu sayede her seferinde "docker-instance-ports.value" şeklinde yazmamıza gerek kalmıyor.

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
}