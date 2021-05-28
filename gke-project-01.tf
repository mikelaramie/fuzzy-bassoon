// Networks 
resource "google_compute_network" "gke-project-01-default-network" {
  project                 = module.gke-project-01.project_id
  name                    = "default"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

// cluster-01
resource "google_service_account" "gke-project-01-gke-cluster-01" {
  project      = module.gke-project-01.project_id
  account_id   = "gke-cluster-01"
  display_name = "GKE Cluster 01"
}

resource "google_container_cluster" "gke-project-01-cluster-01" {
  project                  = module.gke-project-01.project_id
  name                     = "cluster-01"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 2
  networking_mode          = "VPC_NATIVE"
  network                  = google_compute_network.gke-project-01-default-network.name
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "" //defaults to /14
    services_ipv4_cidr_block = "" //defaults to /14
  }
}

resource "google_container_node_pool" "gke-project-01-cluster-01-pool-01" {
  project            = module.gke-project-01.project_id
  name               = "pool-01"
  location           = var.zone
  cluster            = google_container_cluster.gke-project-01-cluster-01.name
  initial_node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }

  node_config {
    preemptible  = true //set to false if you want stable hosts
    machine_type = "e2-standard-4"
    /*
    "e2-standard-4" allows for a suitable number of CPUs to run both the LW agent and
    the Bank of Anthos demo environment.  For a full list of available machine types
    visit https://cloud.google.com/compute/docs/machine-types    
    */
    image_type = "cos"
    /* Available Linux options are "cos", "cos_containerd", "ubuntu", "ubuntu_containerd" 
    For more info (including Windows options) visit
    https://cloud.google.com/kubernetes-engine/docs/concepts/node-images
    */
    service_account = google_service_account.gke-project-01-gke-cluster-01.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

// cluster-02
resource "google_service_account" "gke-project-01-gke-cluster-02" {
  project      = module.gke-project-01.project_id
  account_id   = "gke-cluster-02"
  display_name = "GKE Cluster 02"
}

resource "google_container_cluster" "gke-project-01-cluster-02" {
  project                  = module.gke-project-01.project_id
  name                     = "cluster-02"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 2
  networking_mode          = "VPC_NATIVE"
  network                  = google_compute_network.gke-project-01-default-network.name
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "" //defaults to /14
    services_ipv4_cidr_block = "" //defaults to /14
  }
}

resource "google_container_node_pool" "gke-project-01-cluster-02-pool-01" {
  project            = module.gke-project-01.project_id
  name               = "pool-01"
  location           = var.zone
  cluster            = google_container_cluster.gke-project-01-cluster-02.name
  initial_node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }

  node_config {
    preemptible  = false //set to true if you want preemptible hosts
    machine_type = "e2-standard-4"
    /*
    "e2-standard-4" allows for a suitable number of CPUs to run both the LW agent and
    the Bank of Anthos demo environment.  For a full list of available machine types
    visit https://cloud.google.com/compute/docs/machine-types    
    */
    image_type = "cos_containerd"
    /* Available Linux options are "cos", "cos_containerd", "ubuntu", "ubuntu_containerd" 
    For more info (including Windows options) visit
    https://cloud.google.com/kubernetes-engine/docs/concepts/node-images
    */
    service_account = google_service_account.gke-project-01-gke-cluster-02.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

// Outputs
output "gke-project-01-cluster-01-kubectl-command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gke-project-01-cluster-01.name} --zone ${google_container_cluster.gke-project-01-cluster-01.location} --project ${module.gke-project-01.project_id}"
}

output "gke-project-01-cluster-02-kubectl-command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gke-project-01-cluster-02.name} --zone ${google_container_cluster.gke-project-01-cluster-02.location} --project ${module.gke-project-01.project_id}"
}
