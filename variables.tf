variable "base_cidr_block" {
  description = <<-EOT
    A network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within.
  EOT

  type = string
}

variable "networks" {
  description = <<-EOT
    A list of objects describing requested subnetwork prefixes. netmask is the requested subnetwork cidr to slice from
    base_cidr_block.
  EOT

  type = list(
    object({
      name    = string
      netmask = number
    })
  )
}

variable "reverse" {
  description = <<-EOT
    If set to `true` subprefixes are allocated from the end of base_cidr_block prefix instead of the start, default.
    Currently only supports networks where netmask is the same length for each prefix. Mixing prefix lengths in
    `var.networks[*].netmask` will result in unexpect behaviour.
  EOT

  type     = bool
  default  = false
  nullable = false
}

variable "separator" {
  description = <<-EOT
    Used to provide an output of grouped subnets based on a split()[0].
  EOT

  type    = string
  default = "/"
}
