variable "vsphere_password" {
  type = string
  default = ""
}
variable "vsphere_server" {
  type = string
  default = ""
}
variable "vsphere_datacenter" {
	type = string
	default = "ha-datacenter"
}
variable "vsphere_user" {
  type = string
  default = ""
}
variable "cluster_vm_prefix" {
  type = string
  default = ""
}
variable "cluster_domain" {
  type = string
  default = ""
}
variable "base_domain" {
	type = string
	default = ""
}
variable "vm_network" {
	type = string
	default "VM Network"
}
variable "compute_count" {
  type = string
  default = ""
}
variable "control_plane_count" {
  type = string
  default = ""
}
variable "bootstrap_ip_address" {
  type = string
  default = ""
}
variable "bootstrap_ignition_path" {
  type = string
  default = ""
}
variable "compute_ignition_path" {
  type = string
  default = ""
}
variable "control_plane_ignition_path" {
  type = string
  default = ""
}
variable "bootstrap_mem" {
  type = string
  default = ""
}
variable "bootstrap_num_cpu" {
  type = string
  default = ""
}
variable "compute_ip_addresses" {
  type = list(string)
  default = [""]
}
variable "compute_mem" {
  type = string
  default = ""
}
variable "compute_num_cpu" {
  type = string
  default = ""
}
variable "control_plane_ip_addresses" {
  type = list(string)
  default = [""]
}
variable "control_plane_mem" {
  type = string
  default = ""
}
variable "control_plane_num_cpu" {
  type = string
  default = ""
}
variable "machine_cidr" {
  type = string
  default = ""
}
variable "vm_dns_addresses" {
  type = list(string)
  default = [""]
}

variable "ssh_public_key_path" {
	type = string
	default = "${HOME}/.ssh/id_rsa.pub"
}