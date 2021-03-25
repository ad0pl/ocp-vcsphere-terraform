provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

locals {
    bootstrap_fqdns            = ["${var.cluster_vm_prefix}-bootstrap.${var.cluster_domain}"]
    control_plane_fqdns        = [for idx in range(var.control_plane_count) : "${var.cluster_vm_prefix}-control-plane-${idx}.${var.cluster_domain}"]
    compute_fqdns              = [for idx in range(var.compute_count) : "${var.cluster_vm_prefix}-compute-${idx}.${var.cluster_domain}"]
    bootstrap_ip_address       = [var.bootstrap_ip_address]
    control_plane_ip_addresses = var.control_plane_ip_addresses
    compute_ip_addresses       = var.compute_ip_addresses
}

data "vsphere_datacenter" "dc" {
    name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
    name          = var.vsphere_cluster
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
    name          = var.vsphere_datastore
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name          = var.vm_network
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name          = var.vm_template
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
    name                    = var.cluster_id
#    parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
    datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "folder" {
    path          = var.cluster_id
    type          = "vm"
    datacenter_id = data.vsphere_datacenter.dc.id
}

//
// Bootstrap VM
//
module "bootstrap" {
  source = "./vm"

  ignition = file(var.bootstrap_ignition_path)

  hostnames_ip_addresses = zipmap(
    local.bootstrap_fqdns,
    local.bootstrap_ip_address
  )

  resource_pool_id      = data.vsphere_resource_pool.resource_pool.id
  datastore_id          = data.vsphere_datastore.datastore.id
  datacenter_id         = data.vsphere_datacenter.dc.id
  network_id            = data.vsphere_network.network.id
  folder_id             = vsphere_folder.folder.path
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.bootstrap_num_cpu
  memory        = var.bootstrap_mem
  dns_addresses = var.vm_dns_addresses
}

//
// Control Plane (OCP Masters) VM
//
module "control_plane_vm" {
  source = "./vm"

  hostnames_ip_addresses = zipmap(
    local.control_plane_fqdns,
    local.control_plane_ip_addresses
  )

  ignition = file(var.control_plane_ignition_path)

  resource_pool_id      = data.vsphere_resource_pool.resource_pool.id
  datastore_id          = data.vsphere_datastore.datastore.id
  datacenter_id         = data.vsphere_datacenter.dc.id
  network_id            = data.vsphere_network.network.id
  folder_id             = vsphere_folder.folder.path
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.control_plane_num_cpu
  memory        = var.control_plane_mem
  dns_addresses = var.vm_dns_addresses
}

//
// Compute (OCP Workers) VM
//
module "compute_vm" {
  source = "./vm"

  hostnames_ip_addresses = zipmap(
    local.compute_fqdns,
    local.compute_ip_addresses
  )

  ignition = file(var.compute_ignition_path)

  resource_pool_id      = data.vsphere_resource_pool.resource_pool.id
  datastore_id          = data.vsphere_datastore.datastore.id
  datacenter_id         = data.vsphere_datacenter.dc.id
  network_id            = data.vsphere_network.network.id
  folder_id             = vsphere_folder.folder.path
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = var.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.compute_num_cpu
  memory        = var.compute_mem
  dns_addresses = var.vm_dns_addresses
}