module "this" {
  source = "../../"

  base_cidr_block = "10.0.0.0/8"

  networks = [
    {
      name    = "private/foo"
      netmask = 28
    },
    {
      name    = "private/bar"
      netmask = 28
    },
    {
      name    = "private/baz"
      netmask = 28
    },
    {
      name    = "public/foo"
      netmask = 26
    },
    {
      name    = "public/bar"
      netmask = 26
    },
    {
      name    = "public/baz"
      netmask = 26
    }
  ]
}
