output "vpc_network" {
  value = google_compute_network.bookshelf_vpc.name
}

output "subnet" {
  value = google_compute_subnetwork.bookshelf_subnet.name
}
output "vpc_network_self_link" {
  value = google_compute_network.bookshelf_vpc.self_link
}
