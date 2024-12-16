provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC A
resource "google_compute_network" "vpc_a" {
  name                    = var.vpc_a_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_a" {
  name          = "subnet-a"
  network       = google_compute_network.vpc_a.self_link
  ip_cidr_range = var.subnet_a_cidr
  region        = var.region
}

# VPC B
resource "google_compute_network" "vpc_b" {
  name                    = var.vpc_b_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "subnet-b"
  network       = google_compute_network.vpc_b.self_link
  ip_cidr_range = var.subnet_b_cidr
  region        = var.region
}

# Instances in VPC A
resource "google_compute_instance" "instance_a" {
  name         = "instance-a"
  machine_type = var.instance_machine_type
  zone         = var.instance_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_a.name
    
  }
}

# Instances in VPC B
resource "google_compute_instance" "instance_b" {
  name         = "instance-b"
  machine_type = var.instance_machine_type
  zone         = var.instance_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_b.name
    
  }
}

# VPC Peering
resource "google_compute_network_peering" "peering_a_to_b" {
  name         = "vpc-a-to-vpc-b"
  network      = google_compute_network.vpc_a.self_link
  peer_network = google_compute_network.vpc_b.self_link

}

# VPC Peering: vpc-b-to-vpc-a
resource "google_compute_network_peering" "peering_b_to_a" {
  name         = "vpc-b-to-vpc-a"
  network      = google_compute_network.vpc_b.self_link
  peer_network = google_compute_network.vpc_a.self_link
}

resource "google_compute_firewall" "allow_vpc_a_ingress" {
  name    = "allow-vpc-a-ingress"
  network = google_compute_network.vpc_a.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allow SSH traffic
  }

  allow {
    protocol = "icmp" 
  }

  source_ranges = [var.subnet_b_cidr] 
}

# Firewall rule for VPC B (Ingress for SSH and ICMP from VPC A)
resource "google_compute_firewall" "allow_vpc_b_ingress" {
  name    = "allow-vpc-b-ingress"
  network = google_compute_network.vpc_b.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allow SSH traffic
  }

  allow {
    protocol = "icmp" # Allow ICMP for ping
  }

  source_ranges = [var.subnet_a_cidr] 
}
