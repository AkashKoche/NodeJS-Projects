provider "google" {
  credentials = file("/home/akash/GCP/Projects/weighty-card-416417-3084c2fe604a.json")
  project     = "weighty-card-416417"
  region      = "us-central1"
}

resource "google_compute_firewall" "allow-http" {
  name = "allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "microservice-instance" {
  name         = "nodejs-microserive-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
       // Ephemeral IP
    }
  }

metadata = {
  ssh-keys = "ansible:${file("~/.ssh/gcp_ssh.pub")}"
}
  metadata_startup_script = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo useradd -aG docker $USER
              sudo docker pull akashkoche/nodejs-projects:v1.0
              sudo docker run -d -p 80:3000 akashkoche/nodejs-projects:v1.0
          EOF
}

output "instance_ip" {
  value = google_compute_instance.microservice-instance.network_interface[0].access_config[0].nat_ip
}
