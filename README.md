# Radtribution Dictionary

A comprehensive reference for network authentication attributes used in RADIUS and TACACS+ protocols across multiple vendor platforms. The project aims to document all vendor-specific attributes (VSAs) with their implementations and use cases.

## Features

- **Multi-vendor support**: Cisco, Juniper, Palo Alto, Fortinet, Aruba/HP, Arista, Extreme Networks, CheckPoint, WatchGuard, Meraki, Unifi, and more
- **Protocol coverage**: Both RADIUS and TACACS+ attributes
- **Use case documentation**: Detailed implementation guides for various scenarios
- **Searchable interface**: Easily find attributes by name, function, or vendor
- **Feature filtering**: Filter attributes by capabilities (ACL, VLAN, QoS, etc.)
- **Export functionality**: Export filtered attribute data to CSV or JSON
- **Debugging tools**: Built-in logging and troubleshooting features

## Use Cases

The Radtribution Dictionary provides implementation guidance for:

- VPN Authentication & Authorization
- 802.1X Network Access Control
- User Role-Based Access Control
- Dynamic VLAN Assignment
- QoS and Bandwidth Control
- Change of Authorization (CoA)
- Security Group Tags (SGT)
- Administrative Access Control
- URL Redirection & Captive Portals
- Downloadable ACLs
- IPv6 Support
- Multicast Control

## Vendors Covered

- Cisco (IOS, IOS-XE, NX-OS)
- Juniper Networks
- Palo Alto Networks
- Fortinet
- Aruba
- HP
- Dell
- Arista
- Extreme Networks
- Check Point
- WatchGuard
- Meraki
- Unifi
- Alcatel/Nokia
- Huawei
- F5
- SonicWall
- Zyxel
- Brocade
- Microsoft NAS

## Local Development

To run this project locally, simply clone the repository and open the index.html file in your web browser:

```bash
git clone https://github.com/your-username/radtribution-dictionary.git
cd radtribution-dictionary
# Open index.html in your preferred browser
```

## Advanced Usage

### Debugging Mode

Press `Ctrl+D` to toggle debugging mode, which provides detailed console logging and export functionality.

### Advanced Search

Use column-specific search with the format `column:term`:
- `vendor:cisco` - Search for Cisco attributes
- `name:vlan` - Search for attributes with "vlan" in the name
- `description:vpn` - Search for attributes related to VPN in the description

### Keyboard Shortcuts

- `Ctrl+F` - Focus the search box
- `Ctrl+D` - Toggle debugging mode

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
