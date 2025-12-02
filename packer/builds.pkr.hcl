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
    source      = "scripts/setup-locale.sh"
    destination = "/tmp/setup-locale.sh"
  }

  provisioner "file" {
    source      = "scripts/cleanup.sh"
    destination = "/tmp/cleanup.sh"
  }

  # Execute system setup script
  provisioner "shell" {
    environment_vars = ["SSH_PUBLIC_KEY=${local.ssh_public_key}"]
    inline = [
      "whoami",
      "chmod +x /tmp/setup-system.sh",
      "/tmp/setup-system.sh"
    ]
  }

  # Setup locale
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/setup-locale.sh",
      "/tmp/setup-locale.sh"
    ]
    max_retries = 1
  }

  # Execute cleanup script
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/cleanup.sh",
      "/tmp/cleanup.sh"
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }

  post-processor "shell-local" {
    inline = [
      "echo 'Built image version: ${var.image_version}' > built_version.txt",
      "echo 'Build completed at $(date)' >> built_version.txt"
    ]
  }
}
