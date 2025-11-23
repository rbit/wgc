# wgc - WireGuard Connection Manager

![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)

> Run and monitor multiple isolated WireGuard tunnels using Linux network namespaces.

`wgc` is a bash script for managing multiple, simultaneous WireGuard connections on a Linux system. Its core feature is the use of **Linux network namespaces** (`ip netns`).

Each VPN connection is brought up inside an isolated namespace, which gets its own network interface, routing table, and DNS configuration. This allows multiple VPNs to be active concurrently without route conflicts, and it isolates the VPN traffic from the host system's main network.

Additions in this fork:
* Command line flag for the path to the directory that contains the wireguard configuration files
* Command line flag for a path to a file containing this peer's private key
* Support for multiple IP addresses, including IPv6 addresses
* Support for user environment pass-through for the exec command, allowing, for example, Wayland clients to execute

---

## Usage

The general syntax is `wgc [command] <vpn_name>`.

The script requires `sudo` or root access for most of its commands because it manipulates network interfaces and namespaces.

```
Usage: wgc [-c|--cfgdir config_dir] [-p|--prvkey private_key_file] [start <vpn>|stop <vpn>|status <vpn>|active|list|exec <vpn> <command>]

If omitted, config_dir defaults to /etc/wireguard
If omitted, private_key must be given in the config file

<vpn>.conf should match the name of a config file in the config directory

Commands:
  start  - Start the VPN connection
  stop   - Stop the VPN connection
  status - Show VPN connection status
  active - Show active VPN namespaces
  list   - List config files in config_dir
  exec   - Execute a command in the VPN namespace
```

## Examples

```
wgc -c ~/.config/wireguard -p <(rbw get <vpn>) start <vpn>
wgc exec <vpn> curl ifconfig.me
wgc exec <vpn> -- brave --enable-features=TouchpadOverscrollHistoryNavigation
```

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).
See the [LICENSE](LICENSE) file for details.
