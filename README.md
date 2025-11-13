# wgc

> Run and monitor multiple isolated WireGuard tunnels using Linux network namespaces.

`wgc` is a bash script for managing multiple, simultaneous WireGuard connections on a Linux system. Its core feature is the use of **Linux network namespaces** (`ip netns`).

Each VPN connection is brought up inside an isolated namespace, which gets its own network interface, routing table, and DNS configuration. This allows multiple VPNs to be active concurrently without route conflicts, and it isolates the VPN traffic from the host system's main network.

---

## Features

* **Total Isolation:** Run multiple VPNs at the same time. Each VPN's traffic is completely separate from the host and other VPNs.
* **Targeted Execution:** Run specific commands or applications (like `curl`, `ssh`, or a browser) *inside* a VPN namespace. This routes only that application's traffic through the tunnel, while the rest of your system uses the default connection.
* [cite_start]**Automatic DNS:** Automatically sets the DNS servers specified in the `.conf` file (via the `DNS =` key) for the namespace by writing to `/etc/netns/<vpn_name>/resolv.conf`. [cite: 46, 47]
* [cite_start]**Simple Interface:** A single script with clear commands to start, stop, list, and monitor tunnels. [cite: 1]

## Requirements

* `bash`
* [cite_start]`sudo` access (the script auto-elevates if not run as root) [cite: 1]
* [cite_start]`wireguard-tools` (provides the `wg` command) [cite: 2, 4]
* [cite_start]`iproute2` (provides the `ip` command) [cite: 2, 4]

## Installation

1.  Make the script executable:
    ```bash
    chmod +x wgc
    ```
2.  Move the script to a directory in your `$PATH`, such as `/usr/local/bin`:
    ```bash
    sudo cp wgc /usr/local/bin/wgc
    ```

## Configuration

[cite_start]Your WireGuard configuration files (`.conf`) must be placed in `/etc/wireguard/`. [cite: 1, 5]

[cite_start]The script uses the filename (without the `.conf` extension) as the VPN identifier[cite: 1, 5]. For example, a file at `/etc/wireguard/work-vpn.conf` will be managed as the `work-vpn` VPN.

[cite_start]The script parses the file and expects standard WireGuard keys. [cite: 8, 9]

* **Required Keys:** The script will exit if these are missing:
    * [cite_start]`Address` [cite: 10]
    * [cite_start]`PrivateKey` [cite: 10]
    * [cite_start]`DNS` [cite: 10]
    * [cite_start]`PublicKey` [cite: 10]
    * [cite_start]`Endpoint` [cite: 10]
    * [cite_start]`AllowedIPs` [cite: 10]
* **Optional Keys:** The script also supports:
    * [cite_start]`MTU` [cite: 11, 14]
    * [cite_start]`PresharedKey` [cite: 11, 17]
    * [cite_start]`PersistentKeepalive` [cite: 11, 20]

---

## Usage

The general syntax is `sudo wgc [command] <vpn_name>`. [cite_start]The script must be run with `sudo` (or as root) because it manipulates network interfaces and namespaces. [cite: 1]

### Main Commands

* **`start <vpn>`**
    [cite_start]Starts the specified VPN connection. [cite: 1] [cite_start]This creates a new network namespace [cite: 46][cite_start], builds the WireGuard interface inside it [cite: 46][cite_start], sets up routes [cite: 46][cite_start], and configures DNS[cite: 46, 47].
    ```bash
    sudo wgc start work-vpn
    ```

* **`stop <vpn>`**
    [cite_start]Stops the VPN connection. [cite: 1] [cite_start]This terminates any processes running inside the namespace [cite: 24, 27] [cite_start]and then deletes the namespace and its interfaces[cite: 29].
    ```bash
    sudo wgc stop work-vpn
    ```

* **`status <vpn>`**
    [cite_start]Shows the detailed status of the connection [cite: 1][cite_start], including `wg` peer data, IP configuration, routes, and any active processes within the namespace. [cite: 30, 31]
    ```bash
    sudo wgc status work-vpn
    ```

* **`exec <vpn> <command...>`**
    [cite_start]Executes a command *inside* the VPN's namespace. [cite: 1, 53] This is the primary way to use the isolated connection. [cite_start]The command is run as the original user (via `$SUDO_USER`). [cite: 36]

    *Example: Check your public IP as seen by the VPN.*
    ```bash
    sudo wgc exec work-vpn curl ifconfig.me
    ```

    *Example: Start an interactive shell that uses the VPN.*
    ```bash
    sudo wgc exec work-vpn bash
    ```

* **`list`**
    [cite_start]Lists all available `.conf` files found in `/etc/wireguard/`. [cite: 1, 5]

* **`active`**
    [cite_start]Lists all *currently active* VPNs by checking for running network namespaces that contain a WireGuard interface. [cite: 1, 32, 33]

### Bash Completion

[cite_start]The script can install its own bash completion file. [cite: 1, 44]

1.  Run the following command:
    ```bash
    sudo wgc completion
    ```
2.  [cite_start]This will create the file `/etc/bash_completion.d/wgc`. [cite: 44]
3.  [cite_start]Source the file or start a new shell to use the completion. [cite: 44]
4.  [cite_start]The script provides optional instructions for `sudoers` rules to make completion seamless. [cite: 44]
