output "network_cidr_blocks" {
  description = <<-EOT
    A map from network names to allocated address prefixes in CIDR notation.
  EOT

  value = tomap(local.addrs_by_name)
}

output "networks" {
  description = <<-EOT
    A list of objects corresponding to each of the objects in the input variable
    'networks', each extended with a new attribute 'cidr_block' giving the network's
    allocated address prefix.
  EOT

  value = tolist(local.network_objs)
}

output "base_cidr_block" {
  description = <<-EOT
    Echoes back the base_cidr_block input variable value, for convenience if passing the
    result of this module elsewhere as an object.
  EOT

  value = var.base_cidr_block
}

output "grouped_by_separator" {
  description = <<-EOT
    Group outputs if the name of ranges are prefixed by a separator (default is /). If no
    separator is provided in any name, grouped_by_separator output will be null.
  EOT

  value = local.grouped_by_separator
}
