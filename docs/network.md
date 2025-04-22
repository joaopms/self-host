# Network

The root domain is `jpms.dev`. It is used to resolve both external and internal DNS queries.

There's two physical locations: `v` and `b`. Each have their own network and DNS namespace.

Pi-hole hosts internal DNS records while Cloudflare is used to host external DNS records.
The only exception is for `*.v.jpms.dev`, hosted externally and pointing to the local Caddy IP address. This is needed since some Samsung Android devices insist on resolving using an external DNS server, even when a local one is available.

## Networks

- `10.10.1.1/16`: **`v` physical network**
- `10.10.200.1/24`: `v` virtual Proxmox internal sub-network
- `10.0.1.1/16`: **`b` physical network**
- `10.0.200.1/24`: `b` virtual Proxmox internal sub-network

Proxmox containers and VMs IDs dictate the last octet of the internal IP on the virtual network.
For example: Caddy's ID on `v` is 101, mapping to `10.10.200.101`.

## DNS records

| DNS Record                  | Use Case                            |
| --------------------------- | ----------------------------------- |
| `v.jpms.dev`                | `v` router                          | 
|  ├ `*.v.d.jpms.dev`         | `v` DHCP DNS domain                 |
|  └`*.v.jpms.dev`            | `v` internal apps, served by Caddy  | 
|                             |                                     |
| `b.jpms.dev`                | `b` router                          | 
|  ├ `*.b.d.jpms.dev`         | `b` DHCP DNS domain                 |
|  └ `*.b.jpms.dev`           | `b` internal apps, served by Caddy  | 
|                             |                                     |
| `*.d.jpms.dev`              | Proxmox hosts                       |
|  ├ `andromeda.d.jpms.dev`   | `v` Proxmox host                    |
|  ╞═`*.andromeda.d.jpms.dev` | Virtual Proxmox network DNS domain  |
|  ├ `slowpoke.d.jpms.dev`    | `b` Proxmox host                    |
|  ╘═ `*.slowpoke.d.jpms.dev` | Virtual Proxmox network DNS domain  |

### Caddy

Caddy acts as a reverse proxy for every self-hosted app.
It connects to the apps using their internal Proxmox DNS domain.
