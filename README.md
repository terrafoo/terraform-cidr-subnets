# Terraform CIDR subnets module

Terraform module for calculating subnet addresses under a particular CIDR prefix.

This is a module is fork of https://github.com/drewmullen/terraform-cidr-subnets which is a fork of https://github.com/hashicorp/terraform-cidr-subnets - with some modifications to allow for the allocation of subnets from the end of the base CIDR block.

## Usage

```hcl
module "this" {
  source = "../../"

  base_cidr_block = "10.0.0.0/16"

  networks = [
    {
      name    = "private/foo"
      netmask = 18
    },
    {
      name    = "private/bar"
      netmask = 18
    },
    {
      name    = "private/baz"
      netmask = 18
    },
    {
      name    = "public/foo"
      netmask = 20
    },
    {
      name    = "public/bar"
      netmask = 20
    },
    {
      name    = "public/baz"
      netmask = 20
    }
  ]
}
```

## Outputs
```
this = {
  "base_cidr_block" = "10.0.0.0/16"
  "grouped_by_separator" = {
    "private" = {
      "bar" = "10.0.64.0/18"
      "baz" = "10.0.128.0/18"
      "foo" = "10.0.0.0/18"
    }
    "public" = {
      "bar" = "10.0.208.0/20"
      "baz" = "10.0.224.0/20"
      "foo" = "10.0.192.0/20"
    }
  }
  "network_cidr_blocks" = tomap({
    "private/bar" = "10.0.64.0/18"
    "private/baz" = "10.0.128.0/18"
    "private/foo" = "10.0.0.0/18"
    "public/bar" = "10.0.208.0/20"
    "public/baz" = "10.0.224.0/20"
    "public/foo" = "10.0.192.0/20"
  })
  "networks" = tolist([
    {
      "bits" = 2
      "cidr_block" = "10.0.0.0/18"
      "name" = "private/foo"
      "netmask" = 18
    },
    {
      "bits" = 2
      "cidr_block" = "10.0.64.0/18"
      "name" = "private/bar"
      "netmask" = 18
    },
    {
      "bits" = 2
      "cidr_block" = "10.0.128.0/18"
      "name" = "private/baz"
      "netmask" = 18
    },
    {
      "bits" = 4
      "cidr_block" = "10.0.192.0/20"
      "name" = "public/foo"
      "netmask" = 20
    },
    {
      "bits" = 4
      "cidr_block" = "10.0.208.0/20"
      "name" = "public/bar"
      "netmask" = 20
    },
    {
      "bits" = 4
      "cidr_block" = "10.0.224.0/20"
      "name" = "public/baz"
      "netmask" = 20
    },
  ])
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_cidr_block"></a> [base\_cidr\_block](#input\_base\_cidr\_block) | A network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within. | `string` | n/a | yes |
| <a name="input_networks"></a> [networks](#input\_networks) | A list of objects describing requested subnetwork prefixes. netmask is the requested subnetwork cidr to slice from<br>base\_cidr\_block. | <pre>list(<br>    object({<br>      name    = string<br>      netmask = number<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_reverse"></a> [reverse](#input\_reverse) | If set to `true` subprefixes are allocated from the end of base\_cidr\_block prefix instead of the start, default.<br>Currently only supports networks where netmask is the same length for each prefix. Mixing prefix lengths in<br>`var.networks[*].netmask` will result in unexpect behaviour. | `bool` | `false` | no |
| <a name="input_separator"></a> [separator](#input\_separator) | Used to provide an output of grouped subnets based on a split()[0]. | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_cidr_block"></a> [base\_cidr\_block](#output\_base\_cidr\_block) | Echoes back the base\_cidr\_block input variable value, for convenience if passing the<br>result of this module elsewhere as an object. |
| <a name="output_grouped_by_separator"></a> [grouped\_by\_separator](#output\_grouped\_by\_separator) | Group outputs if the name of ranges are prefixed by a separator (default is /). If no<br>separator is provided in any name, grouped\_by\_separator output will be null. |
| <a name="output_network_cidr_blocks"></a> [network\_cidr\_blocks](#output\_network\_cidr\_blocks) | A map from network names to allocated address prefixes in CIDR notation. |
| <a name="output_networks"></a> [networks](#output\_networks) | A list of objects corresponding to each of the objects in the input variable<br>'networks', each extended with a new attribute 'cidr\_block' giving the network's<br>allocated address prefix. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
