output "instance_public_ip" {
  value = aws_instance.tfmyec2.*.public_ip
}

output "sec_gr_id" {
  value = aws_security_group.tf-sec-gr.id
}

output "instance_id" {
  value = aws_instance.tfmyec2.*.id
}                           

            # Burada ilk ve ikinci output'ta "*" kullanmamızın sebebi instance'ı resource olarak tanımlarken count satırı kullanmış olmamız. Birden fazla olduğunda her biri için ayrı bir output olacak.