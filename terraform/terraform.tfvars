base_domain    = "okd.local"
cluster_id     = "lab"
cluster_domain = "${cluster_id}.${base_domain}"

// vSphere information
vsphere_server =
vsphere_user =
vsphere_password =
vsphere_cluster = "cluster-1"
vsphere_datacenter = "Datacenter"
vsphere_datastore = "VMWare_VMs"

// VM Stuff
vm_network = "OKD"
vm_template = "coreos-working"
machine_cidr = "192.168.1.0/24"

control_plane_count = 3
compute_count       = 2

bootstrap_num_cpu     = 4
bootstrap_mem         = 16384
control_plane_num_cpu = 4
control_plane_mem     = 16384
compute_plane_num_cpu = 4
compute_plane_mem     = 16384

bootstrap_ignition_path     = "./bootstrap.ign"
control_plane_ignition_path = "./master.ign"
compute_ignition_path       = "./worker.ign"

//
// Static Addressing
bootstrap_ip_address       =  "192.168.1.200"
control_plane_ip_addresses = ["192.168.1.201", "192.168.1.202", "192.168.1.203"]
compute_ip_addresses       = ["192.168.1.204", "192.168.1.205"]

// DNS Settings
vm_dns_addresses = ["192.168.1.210"]

// SSH Key
ssh_public_key_path = "/home/bugge/src/ocp/installer/upi/vsphere/okd_sshkeys.pub"