module "this" {
  source = "../../"

  base_cidr_block = "fd8b:00dd:6ccb:7295::/64"

  reverse = true

  networks = [
    {
      name    = "private/foo"
      netmask = 64
    },
    {
      name    = "private/bar"
      netmask = 64
    },
    {
      name    = "private/baz"
      netmask = 64
    },
    {
      name    = "public/foo"
      netmask = 64
    },
    {
      name    = "public/bar"
      netmask = 64
    },
    {
      name    = "public/baz"
      netmask = 64
    }
  ]
}
