output "public-ip" {
    value = data.azurerm_public_ip.public-ip.ip_address
}
