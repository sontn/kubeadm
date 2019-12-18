
resource "google_compute_instance" "lb01" {
  boot_disk {
    auto_delete = "true"
    device_name = "lb01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "g1-small"
  name                = "lb01"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master01" {
  boot_disk {
    auto_delete = "true"
    device_name = "master01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "master01"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master02" {
  boot_disk {
    auto_delete = "true"
    device_name = "master02"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "master02"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master03" {
  boot_disk {
    auto_delete = "true"
    device_name = "master03"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "master03"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node01" {
  boot_disk {
    auto_delete = "true"
    device_name = "node01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node01"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node02" {
  boot_disk {
    auto_delete = "true"
    device_name = "node02"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node02"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node03" {
  boot_disk {
    auto_delete = "true"
    device_name = "node03"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node03"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/global/networks/default"
    network_ip         = ""
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/vinid-sandbox/regions/asia-east1/subnetworks/default"
    subnetwork_project = "vinid-sandbox"
  }
  project = "vinid-sandbox"
  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "TERMINATE"
    preemptible         = "true"
  }

  tags = ["https-server",  "http-server"]
  zone = "asia-east1-a"
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}
