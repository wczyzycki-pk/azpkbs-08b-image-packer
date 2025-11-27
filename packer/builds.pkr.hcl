# Build configuration
build {
  sources = ["source.azure-arm.debian"]

  # Setup sudo access for packer user
  provisioner "shell" {
    inline = [
      "echo 'packer ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/packer > /dev/null",
      "sudo chmod 0440 /etc/sudoers.d/packer"
    ]
  }

  # Upload scripts to the VM
  provisioner "file" {
    source      = "scripts/setup-system.sh"
    destination = "/tmp/setup-system.sh"
  }

  provisioner "file" {
    source      = "scripts/cleanup.sh"
    destination = "/tmp/cleanup.sh"
  }

  provisioner "file" {
    content     = templatefile("scripts/setup-ssh-key.tpl.sh", { ssh_public_key = local.ssh_public_key })
    destination = "/tmp/setup-ssh-key.sh"
  }

  # Execute system setup script
  provisioner "shell" {
    inline = [
      "whoami",
      "chmod +x /tmp/setup-system.sh",
      "/tmp/setup-system.sh"
    ]
  }

  # Execute SSH key setup script
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/setup-ssh-key.sh",
      "/tmp/setup-ssh-key.sh"
    ]
  }

  # Execute cleanup script
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/cleanup.sh",
      "/tmp/cleanup.sh"
    ]
  }
}
