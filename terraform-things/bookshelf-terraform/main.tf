
module "networking" {
  source = "./modules/networking"            
  region = var.region
}   
module "cloud_sql" {
  source     = "./modules/cloud_sql"
  project_id    = var.project_id
  region     =  var.region
  vpc_network_self_link = module.networking.vpc_network_self_link
  depends_on = [ module.networking ]
}

module "cloud_storage" {
  source = "./modules/cloud_storage"
  project_id = var.project_id
  region = var.region
  lastname = var.lastname
}

module "health_check" {
  source = "./modules/health_check"
  project_id = var.project_id
}

module "compute_engine" {
  source = "./modules/compute_engine"
  project_id = var.project_id
  vpc_network = module.networking.vpc_network
  subnet = module.networking.subnet
  service_account_email = var.service_account_email
  sql_connection_name = var.sql_connection_name
  cloudsql_user = var.cloudsql_user
  cloudsql_password = var.cloudsql_password
  cloudsql_database = var.cloudsql_database
  cloud_storage_bucket = var.cloud_storage_bucket
  google_oauth2_client_id = var.google_oauth2_client_id
  google_oauth2_client_secret = var.google_oauth2_client_secret
  data_backend = var.data_backend
  image = var.image
  region = var.region
  instance_template_name = var.instance_template_name
  health_check_name= module.health_check.health_check_self_link
  depends_on = [ module.cloud_sql, module.networking, module.health_check, module.cloud_storage ]
}

module "load_balancer" {
  source = "./modules/load_balancer"
  project_id = var.project_id
  region = var.region
  health_check_self_link = module.health_check.health_check_self_link
  instance_group_name = module.compute_engine.instance_group_name
  depends_on = [ module.compute_engine ]
}