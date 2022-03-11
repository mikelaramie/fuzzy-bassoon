# Creates the project for our environment
module "gke-project-01" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.3"

  name       = "gke-project-01-${random_id.suffix.hex}"
  project_id = "gke-project-01-${random_id.suffix.hex}"
  //TODO:  Refactor so that this is "parent", and can sense if there's an org or not
  org_id          = var.org_id
  folder_id       = var.folder_id != null ? var.folder_id : google_folder.main_folder[0].name
  billing_account = var.billing_account

  activate_apis = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
  ]

  default_service_account = "deprivilege"
}

// Networks 
resource "google_compute_network" "gke-project-01-default-network" {
  project                 = module.gke-project-01.project_id
  name                    = "default"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "default" {
    name       = "test-firewall"
    network    = google_compute_network.gke-project-01-default-network.name

    direction  = "INGRESS"
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
    source_ranges = ["10.0.0.0/8"]


// cluster-01
// TODO:  Refactor into a module
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
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
      display_name = "public"
    }
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

// Deploy Lacework to Cluster
// TODO:  The config_context relies on creating the kubectl entry; need to figure out a way to automate creation
/*provider "kubernetes" {
  alias          = "k8s-gke-project-01-cluster-01"
  config_path    = "~/.kube/config"
  config_context = "gke_${module.gke-project-01.project_id}_${var.zone}_${google_container_cluster.gke-project-01-cluster-01.name}"
}

resource "kubernetes_namespace" "lacework" {
  provider = kubernetes.k8s-gke-project-01-cluster-01
  metadata {
    name = "lacework"
  }
}

resource "lacework_agent_access_token" "k8s" {
  name        = google_container_cluster.gke-project-01-cluster-01.name
  description = "k8s deployment for ${google_container_cluster.gke-project-01-cluster-01.name}"
}

module "lacework_k8s_datacollector" {
  source  = "lacework/agent/kubernetes"
  version = "~> 1.0"
  providers = {
    kubernetes = kubernetes.k8s-gke-project-01-cluster-01
  }

  lacework_access_token = lacework_agent_access_token.k8s.token

  # Add the lacework_agent_tag argument to retrieve the cluster name in the Kubernetes Dossier
  lacework_agent_tags = { KubernetesCluster : "${google_container_cluster.gke-project-01-cluster-01.name}" }

  pod_cpu_request = "200m"
  pod_mem_request = "512Mi"
  pod_cpu_limit   = "1"
  pod_mem_limit   = "1024Mi"
}


// Add GAR
resource "google_artifact_registry_repository" "gke-project-01-test-repository" {
  provider      = google-beta
  project       = module.gke-project-01.project_id
  location      = var.region
  repository_id = "test-repository" //TODO: Update to bankofanthos and automate push/pull
  description   = "example docker repository"
  format        = "DOCKER"
}

// TODO:  Add GKE SAs to GAR

# Create a service-account for integrating a GAR registry with Lacework
module "lacework_gcr_svc_account" {
  source         = "lacework/service-account/gcp"
  for_gcr        = true
  for_compliance = true

  project_id = module.gke-project-01.project_id
}
*/
// Outputs
output "gke-project-01-cluster-01-kubectl-command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gke-project-01-cluster-01.name} --zone ${google_container_cluster.gke-project-01-cluster-01.location} --project ${module.gke-project-01.project_id}"
}

/*output "gke-project-01-test-repository-uri" {
  value = google_artifact_registry_repository.gke-project-01-test-repository.id
}
*/
/*
output "SA-credentials" {
  value     = jsondecode(base64decode(module.lacework_gcr_svc_account.private_key))
  sensitive = false
}
*/
