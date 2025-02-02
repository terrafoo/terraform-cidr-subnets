
locals {
  cidr_netmask = tonumber(split("/", var.base_cidr_block)[1])

  networks_netmask_to_bits = [
    for i, v in var.networks : {
      name     = v.name,
      new_bits = tonumber(v.netmask - local.cidr_netmask)
    }
  ]

  # total number of bit for IPv4 or IPv6 - if cidrnetmask() works, then CIDR is IPv4
  ip_pool_bits = can(cidrnetmask(var.base_cidr_block)) ? 32 : 128

  networks_ip_count = [
    for network in local.networks_netmask_to_bits :
    pow(2, (local.ip_pool_bits - network.new_bits))
  ]

  name_prefixes = toset(
    [
      for name, _ in local.addrs_by_name :
      split(var.separator, name)[0]
    ]
  )

  addrs_by_idx = (
    var.reverse ? [
      # each network
      for i, new_bits in local.networks_netmask_to_bits[*].new_bits :
      cidrsubnet(
        var.base_cidr_block,
        # size of prefix to create
        new_bits,
        (
          # number of possible prefix of size `new_bits` in `base_cidr_block` prefix size
          # e.g. base_cidr_block = 10.0.0.0/24, new_bits = 6 (/30 - /24), number of prefixes is 2^6 = 64
          (pow(2, new_bits)) - (
            # round up total number of IPs requested so far to the nearest multiple of requested prefix
            # e.g. requested IPs so far = 12, requested prefix = /28 (16 IPs), ceil(12 / 16) * 16 = 16
            ceil(
              # get sum of the number of IPs requested up to the current index, divided by the current requested
              # number of IPs
              sum(slice(local.networks_ip_count, 0, (i + 1))) / local.networks_ip_count[i]
              # multiply by the current requested number of IPs to round up to the closest multiple
            ) * local.networks_ip_count[i]
            # divide by the number of requested IPs to offset the position
          ) / local.networks_ip_count[i]
        )
      )
    ] :
    cidrsubnets(var.base_cidr_block, local.networks_netmask_to_bits[*].new_bits...)
  )

  addrs_by_name = {
    for i, n in local.networks_netmask_to_bits :
    n.name => local.addrs_by_idx[i] if n.name != null
  }

  network_objs = [
    for i, n in local.networks_netmask_to_bits : {
      name       = n.name
      netmask    = var.networks[i].netmask
      bits       = n.new_bits
      cidr_block = n.name != null ? local.addrs_by_idx[i] : tostring(null)
    }
  ]

  grouped_by_separator = try({
    for _, type in local.name_prefixes :
    type => {
      for name, cidr in local.addrs_by_name :
      split(var.separator, name)[1] => cidr if split(var.separator, name)[0] == type
    }
  }, null)
}
