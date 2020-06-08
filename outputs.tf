output "public-ip" {
    value = "ssh ${var.linux_user}@${data.azurerm_public_ip.public-ip.ip_address}"
}
