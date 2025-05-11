#!/bin/bash

# RADIUS/TACACS Attributes Database Update Script
# This script updates the attributes database with comprehensive vendor information

set -e

# Create backup directory
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing files
cp -r attributes/ "$BACKUP_DIR/" 2>/dev/null || true

# Create directories if they don't exist
mkdir -p attributes/{juniper,fortinet,paloalto,dell,hp,aruba,cisco,extreme,brocade,meraki,ruckus,checkpoint,sonicwall,f5,huawei,microsoftnas,zyxel,watchguard,alcatel,arista,standard}

# Function to create comprehensive attribute JSON
create_attribute_json() {
    local vendor=$1
    local protocol=$2
    local output_file="attributes/$vendor/${protocol}_attributes.json"
    
    echo "Creating/Updating $output_file"
    
    case "$vendor:$protocol" in
        "juniper:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "juniper",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Juniper-Local-User-Name",
            "number": "1",
            "description": "Specifies a local user template to be applied, corresponding to a configured user template on the device. This attribute maps an authenticated user to a locally defined template user for permission inheritance.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Local-User-Name = 'netadmin-template' for network administrators",
            "use_cases": [
                "Map RADIUS users to locally defined permission templates",
                "Centralize user management while maintaining local permission control",
                "Create role-based access control without defining individual users locally"
            ],
            "implementation": [
                "Define local user templates with specific privilege levels on the Juniper device",
                "Configure your RADIUS server to return this VSA with the template name",
                "The template name must match exactly with one defined on your Juniper device",
                "Template users can have custom login classes, allow/deny commands, and other permissions",
                "Use 'show system login user' to verify template users on the device"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Allow-Commands",
            "number": "2",
            "description": "Lists commands that the user is allowed to execute. Used for granular CLI command control. Supports regular expressions for flexible command matching.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Allow-Commands = 'show interfaces|show system.*|show configuration' to allow specific show commands",
            "use_cases": [
                "Create custom administrative roles with specific command access",
                "Allow network operators to view configurations without modification rights",
                "Provide debug access to specific users during troubleshooting",
                "Implement least-privilege access for different support tiers"
            ],
            "implementation": [
                "Configure the RADIUS server to return this VSA with allowed commands",
                "Use regular expressions for pattern matching (e.g., 'show.*' for all show commands)",
                "Commands are evaluated in order with Juniper-Deny-Commands",
                "Use '|' to separate multiple commands or command patterns",
                "Verify command authorization with 'show system login user <username> permissions'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Deny-Commands",
            "number": "3",
            "description": "Lists commands that the user is not allowed to execute. Takes precedence over Juniper-Allow-Commands for matching commands. Supports regular expressions.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Deny-Commands = 'delete.*|request system.*' to prevent deletion and system operations",
            "use_cases": [
                "Prevent configuration changes by read-only administrators",
                "Block dangerous system operations for junior staff",
                "Create security boundaries for outsourced support teams",
                "Implement compliance requirements for change control"
            ],
            "implementation": [
                "Configure the RADIUS server to return this VSA with denied commands",
                "Use regular expressions for pattern matching",
                "Takes precedence over Allow-Commands for matching patterns",
                "Commands are evaluated as regular expressions",
                "Test command authorization before deployment with 'show system login user'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Dynamic-Profile-Name",
            "number": "7",
            "description": "Specifies the name of a dynamic profile to be applied to the subscriber session. Used extensively in broadband access scenarios for applying service parameters.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Dynamic-Profile-Name = 'GOLD-SUBSCRIBER' for premium service subscribers",
            "use_cases": [
                "Apply different service tiers to broadband subscribers",
                "Implement dynamic QoS policies based on user authentication",
                "Configure interface parameters dynamically per subscriber",
                "Support multi-play services with different profiles",
                "Enable time-based service changes using CoA"
            ],
            "implementation": [
                "Define dynamic profiles on the Juniper BNG/MX router",
                "Configure the RADIUS server to return this VSA with the profile name",
                "Profile can include CoS, firewall, routing, and interface parameters",
                "Multiple profiles can be stacked using additional VSAs",
                "Use 'show subscribers summary' to verify active profiles"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Service-Activation",
            "number": "56",
            "description": "Activates or deactivates services for a subscriber. Used with RADIUS CoA to dynamically change subscriber services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-Service-Activation = 'video-service(activate)' to enable video streaming service",
            "use_cases": [
                "Enable on-demand services for subscribers",
                "Implement usage-based service control",
                "Support promotional service activation",
                "Enable parent control features dynamically",
                "Manage multicast services per subscriber"
            ],
            "implementation": [
                "Define services in dynamic profiles on the router",
                "Use format 'service-name(activate)' or 'service-name(deactivate)'",
                "Can be sent during initial authentication or via CoA",
                "Multiple services can be activated in one attribute",
                "Monitor service status with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-IPv4-Input-Filter",
            "number": "10",
            "description": "Specifies an IPv4 firewall filter to apply to inbound traffic from the subscriber. Used for security and traffic control.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-IPv4-Input-Filter = 'SUBSCRIBER-INPUT-FILTER' for applying security policies",
            "use_cases": [
                "Implement subscriber-specific security policies",
                "Block malicious traffic from infected subscribers",
                "Apply parental control filters",
                "Enforce compliance with acceptable use policies",
                "Implement walled garden access for non-paying subscribers"
            ],
            "implementation": [
                "Define firewall filters on the Juniper device",
                "Configure the RADIUS server to return this VSA with the filter name",
                "Filter must be predefined on the device",
                "Can be changed dynamically using CoA",
                "Verify filter application with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-IPv6-Input-Filter",
            "number": "11",
            "description": "Specifies an IPv6 firewall filter to apply to inbound traffic from the subscriber. Essential for IPv6 security management.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-IPv6-Input-Filter = 'IPv6-SUBSCRIBER-FILTER' for IPv6 traffic control",
            "use_cases": [
                "Apply IPv6-specific security policies",
                "Control IPv6 traffic in dual-stack environments",
                "Implement IPv6 transition mechanism controls",
                "Block specific IPv6 protocols or ports",
                "Enable IPv6 service gradually per subscriber"
            ],
            "implementation": [
                "Define IPv6 firewall filters on the device",
                "Configure RADIUS to return this VSA",
                "Can be used alongside IPv4 filters for dual-stack",
                "Supports same features as IPv4 filters but for IPv6",
                "Monitor with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Primary-DNS",
            "number": "31",
            "description": "Specifies the primary DNS server IP address to be assigned to the subscriber. Critical for subscriber internet access.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Primary-DNS = '8.8.8.8' for Google DNS assignment",
            "use_cases": [
                "Provide DNS services to broadband subscribers",
                "Implement DNS-based content filtering",
                "Direct subscribers to specific DNS servers by service tier",
                "Support split-DNS configurations for business customers",
                "Enable DNS-based security services"
            ],
            "implementation": [
                "Configure RADIUS to return this VSA with DNS IP",
                "Often used with Juniper-Secondary-DNS",
                "Can be changed via CoA for service changes",
                "Supports both IPv4 addresses",
                "Verify with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Primary-DNS-IPv6",
            "number": "100",
            "description": "Specifies the primary IPv6 DNS server address for the subscriber. Essential for IPv6-only or dual-stack deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Primary-DNS-IPv6 = '2001:4860:4860::8888' for Google IPv6 DNS",
            "use_cases": [
                "Provide DNS services for IPv6-only subscribers",
                "Support dual-stack DNS configurations",
                "Enable IPv6 DNS64/NAT64 services",
                "Implement IPv6 DNS-based filtering",
                "Support IPv6 transition mechanisms"
            ],
            "implementation": [
                "Configure RADIUS to return this VSA with IPv6 DNS address",
                "Used in conjunction with IPv6 address assignment",
                "Can be updated via CoA",
                "Often paired with Juniper-Secondary-DNS-IPv6",
                "Monitor with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Interface-Id",
            "number": "96",
            "description": "Identifies the logical interface where the subscriber is connected. Used for subscriber session identification and management.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Interface-Id = 'xe-1/0/0.100:1234' for VLAN sub-interface identification",
            "use_cases": [
                "Track subscriber location for troubleshooting",
                "Apply interface-specific policies",
                "Support subscriber mobility between interfaces",
                "Enable per-interface service provisioning",
                "Facilitate network capacity planning"
            ],
            "implementation": [
                "Automatically sent by router during authentication",
                "Format varies by interface type (physical, logical, VLAN)",
                "Used as session identifier for CoA operations",
                "Can be used in dynamic profile variable substitution",
                "Visible in 'show subscribers detail'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-CoS-Traffic-Control-Profile",
            "number": "55",
            "description": "Specifies a Class of Service (CoS) traffic control profile for the subscriber. Used for implementing quality of service and bandwidth management.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-CoS-Traffic-Control-Profile = 'PREMIUM-1GBPS' for gigabit service tier",
            "use_cases": [
                "Implement tiered service offerings",
                "Control bandwidth per subscriber",
                "Apply traffic shaping and policing",
                "Prioritize specific application traffic",
                "Support fair usage policies"
            ],
            "implementation": [
                "Define CoS traffic control profiles on the router",
                "Configure RADIUS to return this VSA with profile name",
                "Profile includes scheduler, shaping, and queuing parameters",
                "Can be changed dynamically via CoA",
                "Monitor with 'show class-of-service interface'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Framed-Pool-Name",
            "number": "97",
            "description": "Specifies the name of the address pool from which to allocate an IP address for the subscriber. Critical for IP address management in large deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Framed-Pool-Name = 'RESIDENTIAL-POOL-1' for residential subscribers",
            "use_cases": [
                "Segregate IP pools by subscriber type",
                "Implement geographic IP allocation",
                "Support multiple service provider networks",
                "Enable IP pool exhaustion management",
                "Facilitate IP address planning and reporting"
            ],
            "implementation": [
                "Define address pools on the router",
                "Configure RADIUS to return pool name",
                "Pool must exist on the authenticating router",
                "Can be used for both IPv4 and IPv6 with separate attributes",
                "Monitor pool usage with 'show subscribers address-assignment pool'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Framed-IPv6-Pool-Name",
            "number": "98",
            "description": "Specifies the name of the IPv6 address pool for subscriber address allocation. Essential for IPv6 deployment.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Framed-IPv6-Pool-Name = 'IPv6-RESIDENTIAL' for IPv6 address allocation",
            "use_cases": [
                "Allocate IPv6 prefixes to subscribers",
                "Support different IPv6 prefix lengths by service",
                "Enable regional IPv6 addressing schemes",
                "Implement IPv6 transition strategies",
                "Support both SLAAC and DHCPv6 scenarios"
            ],
            "implementation": [
                "Define IPv6 address pools on the router",
                "Configure RADIUS to return IPv6 pool name",
                "Supports prefix delegation for home routers",
                "Can allocate /128 addresses or larger prefixes",
                "Monitor with 'show subscribers address-assignment pool'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Virtual-Router",
            "number": "1",
            "description": "Specifies the virtual router (routing instance) to be used for the subscriber session. Critical for multi-tenant and VPN services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Virtual-Router = 'CUSTOMER-A-VRF' for enterprise VPN services",
            "use_cases": [
                "Provide L3VPN services to enterprise customers",
                "Implement network segmentation for security",
                "Support multi-tenant service provider networks",
                "Enable overlapping IP address spaces",
                "Facilitate managed services offerings"
            ],
            "implementation": [
                "Define routing instances on the router",
                "Configure RADIUS to return routing instance name",
                "Instance must exist on the authenticating device",
                "Can be changed via CoA for service migration",
                "Verify with 'show route instance'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Service-Bundle-Name",
            "number": "73",
            "description": "Specifies a bundle of services to be activated for the subscriber. Simplifies service provisioning by grouping related services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-Service-Bundle-Name = 'TRIPLE-PLAY-PREMIUM' for voice, video, and data services",
            "use_cases": [
                "Deploy multi-play service packages",
                "Simplify service activation for CSRs",
                "Enable promotional service bundles",
                "Support complex service dependencies",
                "Facilitate service upgrade/downgrade paths"
            ],
            "implementation": [
                "Define service bundles in dynamic profiles",
                "Configure RADIUS to return bundle name",
                "Bundle can include multiple services and parameters",
                "Supports activation/deactivation via CoA",
                "Monitor with 'show subscribers extensive'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Acct-Terminate-Cause",
            "number": "52",
            "description": "Provides detailed termination cause codes specific to Juniper equipment. Enhanced version of standard RADIUS Acct-Terminate-Cause.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Acct-Terminate-Cause = 'subscriber-mgmt-link-down' for physical link failure",
            "use_cases": [
                "Troubleshoot subscriber disconnection issues",
                "Generate detailed service availability reports",
                "Identify patterns in service disruptions",
                "Support SLA monitoring and reporting",
                "Enable proactive network maintenance"
            ],
            "implementation": [
                "Automatically included in RADIUS accounting stop messages",
                "Provides more granular causes than standard attribute",
                "Values are specific to Juniper subscriber management",
                "Used for troubleshooting and reporting",
                "Can be parsed by billing and OSS systems"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Delegated-Pool-Name",
            "number": "100",
            "description": "Specifies the pool for IPv6 prefix delegation. Critical for providing IPv6 connectivity to customer routers.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Delegated-Pool-Name = 'PD-RESIDENTIAL-/56' for home router prefix delegation",
            "use_cases": [
                "Provide IPv6 prefixes to customer routers",
                "Support different prefix sizes by service tier",
                "Enable IPv6 deployment for residential customers",
                "Facilitate IPv6 address planning",
                "Support business customer IPv6 requirements"
            ],
            "implementation": [
                "Define delegated prefix pools on the router",
                "Configure RADIUS to return pool name",
                "Typically used with DHCPv6 prefix delegation",
                "Common prefix sizes: /56 for residential, /48 for business",
                "Monitor with 'show subscribers address-assignment pool'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-APN-Name",
            "number": "150",
            "description": "Specifies the Access Point Name for mobile subscribers. Used in mobile packet core deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-APN-Name = 'internet.provider.com' for mobile internet access",
            "use_cases": [
                "Differentiate mobile services by APN",
                "Support enterprise mobile VPN services",
                "Enable mobile IoT connectivity",
                "Implement zero-rating services",
                "Support MVNO deployments"
            ],
            "implementation": [
                "Used in mobile packet core (GGSN/PGW) deployments",
                "Configure RADIUS to return APN name",
                "APN configuration must exist on packet core",
                "Determines service parameters and routing",
                "Monitor with mobile-specific show commands"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Cos-Shaping-Rate",
            "number": "88",
            "description": "Specifies the traffic shaping rate for the subscriber. Can be used to dynamically adjust bandwidth limits.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Cos-Shaping-Rate = '100m' for 100 Mbps service",
            "use_cases": [
                "Implement dynamic bandwidth allocation",
                "Support bandwidth-on-demand services",
                "Apply fair usage policies",
                "Enable time-of-day bandwidth changes",
                "Support promotional bandwidth upgrades"
            ],
            "implementation": [
                "Specify rate in bits per second (supports k/m/g suffixes)",
                "Can be applied via initial auth or CoA",
                "Overrides rates in CoS traffic control profiles",
                "Applies to aggregate subscriber traffic",
                "Monitor with 'show class-of-service interface'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-IGMP-Enable",
            "number": "102",
            "description": "Enables or disables IGMP processing for the subscriber. Critical for multicast service delivery.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-IGMP-Enable = '1' to enable IGMP for IPTV services",
            "use_cases": [
                "Enable IPTV services for subscribers",
                "Control multicast access by service tier",
                "Implement parental controls for multicast content",
                "Support enterprise multicast applications",
                "Enable multicast-based software distribution"
            ],
            "implementation": [
                "Send value '1' to enable, '0' to disable",
                "Works with IGMP snooping on access layer",
                "Can be changed via CoA for service changes",
                "Often used with multicast filter lists",
                "Monitor with 'show igmp interface'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-MLD-Enable",
            "number": "103",
            "description": "Enables or disables MLD (Multicast Listener Discovery) for IPv6 multicast. Essential for IPv6 multicast services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-MLD-Enable = '1' to enable IPv6 multicast",
            "use_cases": [
                "Enable IPv6 multicast services",
                "Support dual-stack multicast deployments",
                "Control IPv6 multicast access",
                "Enable next-generation IPTV services",
                "Support IPv6 enterprise applications"
            ],
            "implementation": [
                "Send value '1' to enable, '0' to disable",
                "IPv6 equivalent of IGMP for IPv4",
                "Works with MLD snooping",
                "Can be changed via CoA",
                "Monitor with 'show mld interface'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Redirect-URL",
            "number": "125",
            "description": "Specifies a URL for HTTP redirect. Used for captive portal and notification services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Redirect-URL = 'http://portal.provider.com/suspended' for service suspension",
            "use_cases": [
                "Implement captive portal authentication",
                "Notify users of service issues or maintenance",
                "Direct users to payment portals",
                "Implement acceptable use policy acknowledgment",
                "Support walled garden services"
            ],
            "implementation": [
                "Requires HTTP redirect service on router",
                "URL must be accessible to subscribers",
                "Can be applied/removed via CoA",
                "Works with both IPv4 and IPv6",
                "Often used with specific firewall filters"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Acct-Input-Gigapackets",
            "number": "85",
            "description": "Reports input packet count in billions. Extends standard packet counters for high-speed interfaces.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Juniper-Acct-Input-Gigapackets = '5' representing 5 billion packets",
            "use_cases": [
                "Accurate accounting for high-speed subscribers",
                "Support billing systems requiring packet counts",
                "Network capacity planning and trending",
                "DDoS detection and mitigation",
                "Service quality monitoring"
            ],
            "implementation": [
                "Automatically included in accounting messages",
                "Supplements standard 32-bit packet counters",
                "Used when packet count exceeds 4.29 billion",
                "Important for 10G+ subscriber interfaces",
                "Parse in billing/OSS systems"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        },
        {
            "name": "Juniper-Policy-Name",
            "number": "130",
            "description": "Specifies a policy framework policy to apply to the subscriber. Provides a flexible way to apply complex service configurations.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-Policy-Name = 'PARENTAL-CONTROL-BASIC' for content filtering",
            "use_cases": [
                "Apply complex service policies",
                "Implement dynamic security controls",
                "Enable application-aware networking",
                "Support value-added services",
                "Facilitate policy-based routing"
            ],
            "implementation": [
                "Define policies in the policy framework",
                "Policies can include filters, CoS, and services",
                "Can be stacked for complex scenarios",
                "Changeable via CoA",
                "Monitor with 'show subscribers policy'"
            ],
            "reference": "https://www.juniper.net/documentation/us/en/software/junos/subscriber-mgmt-sessions/topics/topic-map/radius-std-attributes-vsas-support.html"
        }
    ]
}
EOF
            ;;
        "fortinet:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "fortinet",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Fortinet-Group-Name",
            "number": "1",
            "description": "Specifies the user group for policy enforcement and access control. Essential for implementing role-based security policies.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Group-Name = 'VPN_Admins' for VPN administrator group; Fortinet-Group-Name = 'Guest_WiFi' for guest wireless access",
            "use_cases": [
                "Assign users to firewall policy groups",
                "Control VPN access based on group membership",
                "Implement role-based network access control",
                "Apply different security profiles by group",
                "Support compliance requirements for access segregation"
            ],
            "implementation": [
                "Define user groups on FortiGate (User & Authentication > User Groups)",
                "Configure RADIUS server to return this VSA (Vendor ID: 12356)",
                "Group name is case-sensitive and must match exactly",
                "Groups can be used in firewall policies, VPN configs, and WiFi settings",
                "Multiple groups can be assigned using multiple instances of this attribute"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Client-IP-Address",
            "number": "2",
            "description": "Assigns a specific IP address to the connecting client. Primary method for fixed IP assignment in VPN scenarios.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Client-IP-Address = '192.168.100.50' for static VPN client IP",
            "use_cases": [
                "Assign static IPs to VPN users",
                "Implement IP-based access control",
                "Support applications requiring fixed IPs",
                "Enable user tracking by IP address",
                "Facilitate network troubleshooting"
            ],
            "implementation": [
                "Configure RADIUS to return this VSA with IP address",
                "Overrides IP pool assignment on FortiGate",
                "Ensure IP is not in DHCP range or already assigned",
                "Works with SSL VPN and IPsec VPN",
                "Monitor with 'diagnose vpn tunnel list'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Vdom-Name",
            "number": "3",
            "description": "Restricts user access to a specific Virtual Domain (VDOM). Critical for multi-tenant deployments and administrative segregation.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Vdom-Name = 'Customer_A' for tenant isolation",
            "use_cases": [
                "Implement multi-tenant firewall services",
                "Segregate administrative access by VDOM",
                "Support managed security service providers",
                "Isolate different business units",
                "Enable secure shared infrastructure"
            ],
            "implementation": [
                "Enable multi-VDOM mode on FortiGate",
                "Create VDOMs for different tenants/purposes",
                "Configure RADIUS to return VDOM name",
                "Name is case-sensitive",
                "Applies to both admin and user access"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Client-IPv6-Address",
            "number": "40",
            "description": "Assigns a specific IPv6 address to the client. Enables IPv6 connectivity for VPN and network access.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Client-IPv6-Address = '2001:db8:1234::100' for static IPv6 assignment",
            "use_cases": [
                "Enable IPv6 VPN connectivity",
                "Support dual-stack VPN deployments",
                "Implement IPv6-only access scenarios",
                "Facilitate IPv6 migration strategies",
                "Support next-generation network services"
            ],
            "implementation": [
                "Enable IPv6 on FortiGate interfaces",
                "Configure RADIUS to return IPv6 address",
                "Format as full IPv6 address",
                "Works with SSL VPN in dual-stack mode",
                "Verify with 'diagnose vpn tunnel list'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Access-Profile",
            "number": "6",
            "description": "Assigns administrative access profile for FortiGate management. Determines what features administrators can access and modify.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Access-Profile = 'super_admin' for full access; Fortinet-Access-Profile = 'network_operator' for limited access",
            "use_cases": [
                "Implement role-based administration",
                "Comply with security audit requirements",
                "Delegate specific administrative tasks",
                "Protect sensitive configuration areas",
                "Support multi-level administration hierarchy"
            ],
            "implementation": [
                "Create admin profiles (System > Admin Profiles)",
                "Define read/write permissions per feature",
                "Configure RADIUS to return profile name",
                "Profile name is case-sensitive",
                "Monitor with 'diagnose debug application radiusd'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-VSA-Type",
            "number": "8",
            "description": "Specifies the type of Fortinet vendor-specific attribute. Used for attribute interpretation and processing.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-VSA-Type = '1' for string type attributes",
            "use_cases": [
                "Ensure proper attribute processing",
                "Support different data types in VSAs",
                "Maintain compatibility across versions",
                "Enable extensible attribute framework",
                "Facilitate custom attribute development"
            ],
            "implementation": [
                "Automatically handled by most RADIUS servers",
                "Value depends on attribute data type",
                "Usually transparent to administrators",
                "Important for custom VSA development",
                "Verify with RADIUS debug logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Webfilter-Category-Allow",
            "number": "16",
            "description": "Specifies allowed FortiGuard web filtering categories. Enables user-specific web access policies.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Webfilter-Category-Allow = 'News,Sports' to allow specific categories",
            "use_cases": [
                "Implement user-based web filtering",
                "Override default web filter profiles",
                "Provide temporary access to blocked categories",
                "Support different access levels by time",
                "Enable content-based access control"
            ],
            "implementation": [
                "Enable FortiGuard web filtering",
                "Configure RADIUS to return category names",
                "Multiple categories separated by commas",
                "Categories must match FortiGuard definitions",
                "Can be changed via CoA"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Webfilter-Category-Block",
            "number": "17",
            "description": "Specifies blocked FortiGuard web filtering categories. Enables user-specific content restrictions.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Webfilter-Category-Block = 'Gambling,Adult' to block specific categories",
            "use_cases": [
                "Enforce acceptable use policies",
                "Implement parental controls",
                "Comply with regulatory requirements",
                "Protect against malicious content",
                "Support time-based restrictions"
            ],
            "implementation": [
                "Enable FortiGuard web filtering",
                "Configure RADIUS to return category names",
                "Takes precedence over allow lists",
                "Can be updated via CoA",
                "Monitor with web filter logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Wireless-SSID",
            "number": "24",
            "description": "Specifies the wireless SSID for the user connection. Used for SSID-based policy enforcement.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "wireless",
            "example": "Fortinet-Wireless-SSID = 'Corporate-WiFi' for employee access",
            "use_cases": [
                "Apply SSID-specific security policies",
                "Track user connections by network",
                "Implement network segmentation",
                "Support multiple service tiers",
                "Enable location-based services"
            ],
            "implementation": [
                "Configure SSIDs on FortiAP/FortiWiFi",
                "RADIUS server receives SSID during auth",
                "Can be used in firewall policies",
                "Supports both 2.4GHz and 5GHz networks",
                "Monitor with WiFi event logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Wireless-AP-Name",
            "number": "25",
            "description": "Identifies the wireless access point name. Enables location-aware policies and troubleshooting.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Fortinet-Wireless-AP-Name = 'Building-A-Floor-2-AP-1' for location tracking",
            "use_cases": [
                "Implement location-based access control",
                "Troubleshoot connectivity issues",
                "Generate location-based reports",
                "Support emergency services",
                "Enable proximity-based applications"
            ],
            "implementation": [
                "Configure AP names on FortiGate",
                "RADIUS receives AP name during auth",
                "Can be used for policy decisions",
                "Useful for large deployments",
                "Monitor with WiFi client details"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Firewall-Address",
            "number": "11",
            "description": "Specifies firewall address objects to apply to the user session. Enables dynamic security policy application.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Firewall-Address = 'Restricted_Servers' to limit server access",
            "use_cases": [
                "Apply user-specific firewall rules",
                "Implement dynamic security policies",
                "Control access to sensitive resources",
                "Support zero-trust architectures",
                "Enable micro-segmentation"
            ],
            "implementation": [
                "Define address objects on FortiGate",
                "Configure RADIUS to return address names",
                "Objects must exist on FortiGate",
                "Can be updated via CoA",
                "Monitor with policy logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Bandwidth-Max-Upload",
            "number": "29",
            "description": "Sets maximum upload bandwidth for the user session. Enables traffic shaping and QoS implementation.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Bandwidth-Max-Upload = '50000' for 50 Mbps upload limit",
            "use_cases": [
                "Implement fair usage policies",
                "Control bandwidth by user type",
                "Prevent network congestion",
                "Support tiered service offerings",
                "Enable dynamic bandwidth allocation"
            ],
            "implementation": [
                "Value in kilobits per second",
                "Configure RADIUS to return bandwidth value",
                "Can be changed via CoA",
                "Works with traffic shaping policies",
                "Monitor with traffic logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Bandwidth-Max-Download",
            "number": "30",
            "description": "Sets maximum download bandwidth for the user session. Critical for service tier implementation.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Bandwidth-Max-Download = '100000' for 100 Mbps download limit",
            "use_cases": [
                "Implement service level agreements",
                "Control bandwidth costs",
                "Provide different service tiers",
                "Support bandwidth-on-demand",
                "Enable promotional offerings"
            ],
            "implementation": [
                "Value in kilobits per second",
                "Configure RADIUS to return bandwidth value",
                "Can be updated via CoA",
                "Applied per user session",
                "Monitor with FortiView"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-User-Quarantine",
            "number": "35",
            "description": "Places user in quarantine state. Used for security incident response and compliance enforcement.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-User-Quarantine = '1' to enable quarantine",
            "use_cases": [
                "Isolate infected devices",
                "Enforce compliance checks",
                "Implement remediation procedures",
                "Support incident response",
                "Enable automated security responses"
            ],
            "implementation": [
                "Set to '1' to enable quarantine",
                "Restricts user to quarantine VLAN/policy",
                "Can be triggered via CoA",
                "Usually includes redirect to remediation portal",
                "Monitor with security event logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Host-Port-AVPair",
            "number": "42",
            "description": "Specifies host and port restrictions. Enables granular access control to specific services.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Host-Port-AVPair = '192.168.1.100:443' to allow specific host/port",
            "use_cases": [
                "Restrict access to specific services",
                "Implement application-level controls",
                "Support zero-trust networking",
                "Enable precise security policies",
                "Control IoT device communications"
            ],
            "implementation": [
                "Format: 'host:port' or 'network/mask:port'",
                "Multiple pairs can be specified",
                "Can be updated via CoA",
                "Works with firewall policies",
                "Monitor with session logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Client-Timeout",
            "number": "4",
            "description": "Sets session timeout for the client. Controls how long a session remains active without re-authentication.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Client-Timeout = '3600' for 1-hour timeout",
            "use_cases": [
                "Enforce security timeout policies",
                "Support different session durations by user type",
                "Implement compliance requirements",
                "Control resource usage",
                "Enable time-based access control"
            ],
            "implementation": [
                "Value in seconds",
                "Configure RADIUS to return timeout value",
                "Overrides system default timeout",
                "Applies to VPN and wireless sessions",
                "Monitor with session logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Member-Of",
            "number": "14",
            "description": "Indicates group membership for the user. Alternative to Fortinet-Group-Name for group assignment.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Member-Of = 'CN=Admins,OU=Groups,DC=company,DC=com' for AD group membership",
            "use_cases": [
                "Integrate with Active Directory groups",
                "Support LDAP group mappings",
                "Enable dynamic group assignment",
                "Implement role-based access control",
                "Support complex group hierarchies"
            ],
            "implementation": [
                "Usually contains LDAP/AD distinguished name",
                "Can specify multiple groups",
                "FortiGate maps to local groups",
                "Used for policy matching",
                "Monitor with authentication logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Accept-Host-Check",
            "number": "46",
            "description": "Controls host compliance checking. Determines if endpoint security checks are enforced.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Accept-Host-Check = '1' to enforce compliance checking",
            "use_cases": [
                "Enforce endpoint security policies",
                "Ensure antivirus compliance",
                "Check for security patches",
                "Validate FortiClient installation",
                "Support BYOD security requirements"
            ],
            "implementation": [
                "Set to '1' to enable host checking",
                "Requires FortiClient or FSSO",
                "Can check AV, firewall, patches",
                "Non-compliant hosts can be quarantined",
                "Monitor with compliance reports"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-AVPair",
            "number": "255",
            "description": "Generic attribute-value pair for extensible configurations. Supports various Fortinet-specific settings.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": true,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Fortinet-AVPair = 'session-timeout=3600' for custom timeout setting",
            "use_cases": [
                "Configure advanced features",
                "Support new functionality",
                "Implement custom settings",
                "Enable vendor extensions",
                "Support backward compatibility"
            ],
            "implementation": [
                "Format: 'attribute=value'",
                "Multiple AVPairs can be sent",
                "Processed sequentially",
                "Can override other attributes",
                "Monitor with debug logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        }
    ]
}
EOF
            ;;
        "fortinet:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "fortinet",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "admin_prof",
            "number": "N/A",
            "description": "Assigns administrative access profile for FortiGate management. Overrides local admin profile settings and determines feature access permissions.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "admin_prof=super_admin for full access; admin_prof=network_operator for limited network configuration access",
            "use_cases": [
                "Implement role-based administration (RBAC)",
                "Delegate specific administrative functions",
                "Comply with security audit requirements",
                "Support multi-level administrative hierarchy",
                "Protect sensitive configuration areas"
            ],
            "implementation": [
                "Create admin profiles on FortiGate (System > Admin Profiles)",
                "Configure TACACS+ server to return this attribute",
                "Enable 'set admin-prof-override enable' in FortiGate config",
                "Profile name must match exactly (case-sensitive)",
                "Works with both service=fortigate and service=shell"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "vdom_override",
            "number": "N/A",
            "description": "Enables VDOM override functionality. When set, allows the memberof attribute to specify which VDOMs an administrator can access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "vdom_override=enable to activate VDOM restriction",
            "use_cases": [
                "Enable VDOM-specific administrative access",
                "Support multi-tenant environments",
                "Isolate administrative domains",
                "Implement security boundaries",
                "Control access in MSP environments"
            ],
            "implementation": [
                "Set vdom_override=enable in TACACS+ response",
                "Must be used with memberof attribute",
                "Configure 'set vdom-override enable' in FortiGate",
                "Applies to administrative sessions only",
                "Monitor with 'diagnose debug application tacacsd'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "memberof",
            "number": "N/A",
            "description": "Specifies VDOM membership when vdom_override is enabled. Controls which VDOMs an administrator can access and manage.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "memberof=root for global access; memberof=customer_a,customer_b for multi-VDOM access",
            "use_cases": [
                "Restrict admin access to specific VDOMs",
                "Support multi-tenant administration",
                "Implement delegated administration",
                "Enable MSP service delivery",
                "Maintain security isolation"
            ],
            "implementation": [
                "Use with vdom_override=enable",
                "Specify single VDOM or comma-separated list",
                "VDOM names must exist on FortiGate",
                "Case-sensitive VDOM names",
                "Verify with 'show system admin'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Sets privilege level for administrative access. Standard TACACS+ attribute for controlling access levels.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for full administrative access",
            "use_cases": [
                "Map to standard privilege levels",
                "Support legacy TACACS+ integration",
                "Enable gradual access control",
                "Integrate with other network devices",
                "Maintain consistent access levels"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Values 0-15 (15 highest)",
                "Mapped to FortiGate permissions",
                "Works with command authorization",
                "Used when admin_prof not specified"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the TACACS+ service type. FortiGate supports both 'fortigate' and 'shell' services for different authorization modes.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=fortigate for Fortinet-specific attributes; service=shell for standard shell access",
            "use_cases": [
                "Select authorization mode",
                "Enable Fortinet-specific features",
                "Support standard TACACS+ clients",
                "Maintain compatibility",
                "Control attribute processing"
            ],
            "implementation": [
                "Use service=fortigate for VSAs",
                "Use service=shell for compatibility",
                "Configure in TACACS+ server rules",
                "Affects which attributes are processed",
                "Monitor with authentication logs"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Controls command authorization. Specifies which CLI commands are allowed or denied for the administrator.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=get * {permit .+} for allowing all 'get' commands; cmd=config * {deny .*} for denying all config commands",
            "use_cases": [
                "Implement granular command control",
                "Restrict configuration changes",
                "Allow monitoring-only access",
                "Support compliance requirements",
                "Create custom admin roles"
            ],
            "implementation": [
                "Configure command authorization on FortiGate",
                "Use regex patterns for matching",
                "Specify permit or deny actions",
                "Process in order of configuration",
                "Test with 'diagnose debug application tacacsd'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "Fortinet-Vdom-Name",
            "number": "N/A",
            "description": "Alternative method to specify VDOM access. Can be used instead of memberof attribute for VDOM restriction.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Vdom-Name=customer_vdom for single VDOM access",
            "use_cases": [
                "Simplify VDOM assignment",
                "Support single VDOM scenarios",
                "Maintain backward compatibility",
                "Enable quick VDOM switching",
                "Support automated provisioning"
            ],
            "implementation": [
                "Alternative to vdom_override/memberof",
                "Specify single VDOM name",
                "VDOM must exist on FortiGate",
                "Case-sensitive matching",
                "Works with both service types"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "Fortinet-Access-Profile",
            "number": "N/A",
            "description": "Alternative attribute name for admin_prof. Provides same functionality for administrative profile assignment.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Access-Profile=read_only for monitoring access",
            "use_cases": [
                "Alternative to admin_prof attribute",
                "Maintain naming consistency",
                "Support different TACACS+ servers",
                "Enable profile-based access",
                "Simplify configuration"
            ],
            "implementation": [
                "Same as admin_prof functionality",
                "Profile name must match exactly",
                "Enable profile override in FortiGate",
                "Works with both service types",
                "Monitor with debug commands"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "Fortinet-Group-Name",
            "number": "N/A",
            "description": "Assigns user to a FortiGate user group. Used for group-based policy enforcement in administrative contexts.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Group-Name=network_admins for network administrator group",
            "use_cases": [
                "Group administrators by function",
                "Apply group-based policies",
                "Simplify access management",
                "Support organizational structure",
                "Enable audit tracking"
            ],
            "implementation": [
                "Group must exist on FortiGate",
                "Configure in User & Authentication",
                "Used for policy matching",
                "Case-sensitive group names",
                "Verify with 'show user group'"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Provides arguments for command authorization. Used with cmd attribute for detailed command control.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd-arg=system admin for checking 'config system admin' authorization",
            "use_cases": [
                "Enable fine-grained command control",
                "Support complex authorization rules",
                "Implement security policies",
                "Control configuration scope",
                "Enable audit compliance"
            ],
            "implementation": [
                "Used with cmd authorization",
                "Contains command arguments",
                "Matched against authorization rules",
                "Supports regex patterns",
                "Debug with TACACS+ logging"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.4.4/administration-guide/756731/remote-administrators-with-tacacs-vsa-attributes"
        }
    ]
}
EOF
            ;;
        "paloalto:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "paloalto",
    "protocol": "radius",
    "attributes": [
        {
            "name": "PaloAlto-Admin-Role",
            "number": "1",
            "description": "Assigns an administrative role to the user for Palo Alto Networks firewall management access. Critical for implementing role-based access control for administrators.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Admin-Role = 'superuser' for full administrative access; PaloAlto-Admin-Role = 'devicereader' for read-only access",
            "use_cases": [
                "Implement role-based administration",
                "Delegate specific administrative functions",
                "Comply with security audit requirements",
                "Support multi-level admin hierarchy",
                "Enable least-privilege access"
            ],
            "implementation": [
                "Configure RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure PAN-OS device to use RADIUS authentication",
                "Standard roles: superuser, superreader, deviceadmin, devicereader",
                "Custom roles must be pre-defined on the firewall",
                "Case-sensitive role names must match exactly"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Admin-Access-Domain",
            "number": "2",
            "description": "Specifies the access domain for firewall administrators. Used in multi-virtual system environments to control which vsys an administrator can manage.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Admin-Access-Domain = 'vsys1,vsys2' for multi-vsys access; PaloAlto-Admin-Access-Domain = '*' for all vsys",
            "use_cases": [
                "Restrict admin access to specific vsys",
                "Support multi-tenant environments",
                "Implement security boundaries",
                "Enable delegated administration",
                "Maintain regulatory compliance"
            ],
            "implementation": [
                "Configure access domains on PAN-OS (Device > Access Domains)",
                "Configure RADIUS server with access domain VSA",
                "Use comma-separated list for multiple vsys",
                "Use '*' for access to all virtual systems",
                "Works with both firewall and Panorama"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Role",
            "number": "3",
            "description": "Assigns an administrative role for Panorama management access. Controls access rights in the centralized management system.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Panorama-Admin-Role = 'panorama-admin' for full Panorama access",
            "use_cases": [
                "Control Panorama administrative access",
                "Implement centralized management RBAC",
                "Delegate device group management",
                "Support compliance requirements",
                "Enable hierarchical administration"
            ],
            "implementation": [
                "Configure RADIUS server with Panorama VSAs",
                "Configure Panorama to use RADIUS authentication",
                "Standard roles include panorama-admin, custom roles supported",
                "Must match roles defined in Panorama",
                "Combine with access domains for granular control"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-User-Group",
            "number": "5",
            "description": "Specifies user group membership for policy enforcement. Used to assign users to groups without local user database entries.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-User-Group = 'VPN-Users' for VPN access control; PaloAlto-User-Group = 'Domain Users\\Sales' for AD integration",
            "use_cases": [
                "Assign VPN users to policy groups",
                "Implement user-based security policies",
                "Support dynamic group assignment",
                "Enable identity-based access control",
                "Integrate with external directories"
            ],
            "implementation": [
                "Create user groups on PAN-OS firewall",
                "Configure RADIUS to return group names",
                "Use in security policies for access control",
                "Supports nested groups and multiple assignments",
                "Case-sensitive group names"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Client-Source-IP",
            "number": "8",
            "description": "Specifies the source IP address of the VPN client. Used for tracking and policy enforcement.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Client-Source-IP = '192.168.1.100' for client tracking",
            "use_cases": [
                "Track VPN client connections",
                "Support geo-location policies",
                "Enable source-based routing",
                "Implement access restrictions",
                "Facilitate troubleshooting"
            ],
            "implementation": [
                "Automatically sent during VPN authentication",
                "Used for logging and reporting",
                "Can be used in security policies",
                "Supports both GlobalProtect and IPSec",
                "IPv4 address format"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Gp-Client-Ip-Pool",
            "number": "9",
            "description": "Specifies the IP address pool for GlobalProtect VPN clients. Determines which pool to use for client address assignment.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Gp-Client-Ip-Pool = 'VPN-Pool-Sales' for sales department VPN users",
            "use_cases": [
                "Segregate VPN clients by department",
                "Implement IP-based access policies",
                "Support multiple VPN gateways",
                "Enable geographic IP allocation",
                "Facilitate network planning"
            ],
            "implementation": [
                "Define IP pools in GlobalProtect configuration",
                "Configure RADIUS to return pool name",
                "Pool must exist on the firewall",
                "Case-sensitive pool names",
                "Monitor with 'show global-protect-gateway statistics'"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-GP-Client-IPv6-Pool",
            "number": "18",
            "description": "Specifies the IPv6 address pool for GlobalProtect VPN clients. Essential for IPv6 VPN deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-GP-Client-IPv6-Pool = 'IPv6-VPN-Pool' for IPv6 address assignment",
            "use_cases": [
                "Enable IPv6 VPN connectivity",
                "Support dual-stack VPN deployments",
                "Implement IPv6-only VPN access",
                "Future-proof VPN infrastructure",
                "Comply with IPv6 mandates"
            ],
            "implementation": [
                "Configure IPv6 pools in GlobalProtect",
                "Enable IPv6 on GP gateway",
                "Configure RADIUS to return IPv6 pool name",
                "Supports both /64 and /128 assignments",
                "Monitor with GP gateway statistics"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-Gp-Client-Config",
            "number": "20",
            "description": "Specifies the GlobalProtect client configuration to apply. Enables dynamic client configuration based on user identity.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Gp-Client-Config = 'Remote-Worker-Config' for remote employee settings",
            "use_cases": [
                "Apply different client settings by user role",
                "Control split tunneling configurations",
                "Manage client security settings",
                "Enable/disable client features",
                "Support BYOD vs corporate devices"
            ],
            "implementation": [
                "Define client configs in GlobalProtect portal",
                "Configure RADIUS to return config name",
                "Config must exist on GP portal",
                "Supports dynamic configuration switching",
                "Case-sensitive configuration names"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-GP-Portal-Name",
            "number": "21",
            "description": "Specifies which GlobalProtect portal configuration to use. Enables portal selection based on user authentication.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-GP-Portal-Name = 'External-Portal' for external users",
            "use_cases": [
                "Direct users to specific portals",
                "Support multiple portal configurations",
                "Enable geographic portal selection",
                "Implement portal-based policies",
                "Support different user populations"
            ],
            "implementation": [
                "Configure multiple GP portals",
                "Configure RADIUS to return portal name",
                "Portal must exist on firewall",
                "Used during initial client connection",
                "Case-sensitive portal names"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-GP-Gateway-Name",
            "number": "22",
            "description": "Specifies which GlobalProtect gateway to use. Enables gateway selection based on user identity or group.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-GP-Gateway-Name = 'US-East-Gateway' for regional gateway assignment",
            "use_cases": [
                "Direct users to nearest gateway",
                "Implement geographic redundancy",
                "Load balance VPN connections",
                "Support disaster recovery",
                "Enable gateway maintenance"
            ],
            "implementation": [
                "Configure multiple GP gateways",
                "Configure RADIUS to return gateway name",
                "Gateway must be defined in portal config",
                "Supports automatic gateway selection",
                "Monitor gateway utilization"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-GP-Client-Allowed-Resources",
            "number": "25",
            "description": "Specifies allowed resources for GlobalProtect clients. Controls which internal resources VPN users can access.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-GP-Client-Allowed-Resources = '10.0.0.0/8,192.168.0.0/16' for internal network access",
            "use_cases": [
                "Implement split tunneling policies",
                "Restrict access to sensitive resources",
                "Control bandwidth usage",
                "Support compliance requirements",
                "Enable application-specific access"
            ],
            "implementation": [
                "Define resource lists in GP configuration",
                "Configure RADIUS to return resource list",
                "Supports IP ranges and FQDNs",
                "Can include/exclude specific resources",
                "Works with both IPv4 and IPv6"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/globalprotect-user-authentication"
        },
        {
            "name": "PaloAlto-Auth-Profile",
            "number": "30",
            "description": "Specifies the authentication profile to use. Enables profile-based authentication settings.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Auth-Profile = 'MFA-Required' for multi-factor authentication",
            "use_cases": [
                "Enforce different authentication methods",
                "Implement MFA requirements",
                "Support multiple auth protocols",
                "Enable certificate-based auth",
                "Control authentication timeouts"
            ],
            "implementation": [
                "Define auth profiles on firewall",
                "Configure RADIUS to return profile name",
                "Profile determines auth requirements",
                "Supports multi-factor authentication",
                "Case-sensitive profile names"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Quarantine-Action",
            "number": "35",
            "description": "Specifies quarantine action for non-compliant endpoints. Used with GlobalProtect HIP checks.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Quarantine-Action = 'block' for non-compliant devices",
            "use_cases": [
                "Enforce endpoint compliance",
                "Implement NAC policies",
                "Support BYOD security",
                "Enable remediation workflows",
                "Protect against infected devices"
            ],
            "implementation": [
                "Configure HIP profiles on firewall",
                "Set up quarantine zones",
                "Configure RADIUS for compliance checks",
                "Actions: block, notify, or quarantine",
                "Integrate with endpoint protection"
            ],
            "reference": "https://docs.paloaltonetworks.com/globalprotect/10-1/globalprotect-admin/host-information/host-information-profile"
        },
        {
            "name": "PaloAlto-User-Domain",
            "number": "40",
            "description": "Specifies the domain for user authentication. Used for multi-domain environments and user identification.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-User-Domain = 'CORP' for corporate domain users",
            "use_cases": [
                "Support multi-domain authentication",
                "Enable domain-based policies",
                "Facilitate user identification",
                "Support domain trust relationships",
                "Enable cross-domain access"
            ],
            "implementation": [
                "Configure User-ID for domain mapping",
                "Set up domain controllers",
                "Configure RADIUS to return domain",
                "Used with User-ID features",
                "Case-sensitive domain names"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/user-id"
        },
        {
            "name": "PaloAlto-Custom-Field1",
            "number": "50",
            "description": "Custom field for additional user attributes. Enables extensible user identification and policy enforcement.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Custom-Field1 = 'Department=HR' for department identification",
            "use_cases": [
                "Store additional user metadata",
                "Support custom policy requirements",
                "Enable flexible user classification",
                "Integrate with external systems",
                "Support compliance tagging"
            ],
            "implementation": [
                "Configure custom fields in User-ID",
                "Configure RADIUS to populate fields",
                "Use in custom reports and policies",
                "String format, max 63 characters",
                "Available fields 1-5"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/user-id"
        },
        {
            "name": "PaloAlto-Security-Rule",
            "number": "60",
            "description": "Specifies security rules to apply to the user session. Enables dynamic rule assignment based on authentication.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Security-Rule = 'Allow-Internet-Limited' for restricted access",
            "use_cases": [
                "Apply user-specific security policies",
                "Implement dynamic access control",
                "Support time-based restrictions",
                "Enable temporary access grants",
                "Facilitate incident response"
            ],
            "implementation": [
                "Create security rules on firewall",
                "Configure RADIUS to return rule names",
                "Rules must exist in security policy",
                "Can be updated via RADIUS CoA",
                "Monitor with traffic logs"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/policy/security-policy"
        }
    ]
}
EOF
            ;;
        "paloalto:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "paloalto",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "PaloAlto-Admin-Role",
            "number": "N/A",
            "description": "Assigns an administrative role to the user for Palo Alto Networks firewall management access. Requires service=PaloAlto and protocol=firewall in TACACS+ configuration.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Admin-Role=superuser for full administrative access; PaloAlto-Admin-Role=devicereader for read-only access",
            "use_cases": [
                "Implement role-based administration",
                "Delegate specific management functions",
                "Support compliance requirements",
                "Create custom admin roles",
                "Enable least-privilege access"
            ],
            "implementation": [
                "Configure TACACS+ server with service=PaloAlto",
                "Set protocol=firewall in TACACS+ config",
                "Standard roles: superuser, superreader, deviceadmin, devicereader",
                "Custom roles must be pre-defined on firewall",
                "Enable admin role override in PAN-OS settings"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Admin-Access-Domain",
            "number": "N/A",
            "description": "Specifies the access domain for administrators in multi-vsys environments. Controls which virtual systems an admin can manage.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Admin-Access-Domain=vsys1,vsys2 for specific vsys access; PaloAlto-Admin-Access-Domain=* for all vsys",
            "use_cases": [
                "Restrict admin access to specific vsys",
                "Support multi-tenant environments",
                "Implement security isolation",
                "Enable delegated vsys management",
                "Comply with regulatory requirements"
            ],
            "implementation": [
                "Configure access domains on firewall",
                "Use with service=PaloAlto, protocol=firewall",
                "Comma-separated list for multiple vsys",
                "Use '*' for access to all virtual systems",
                "Case-sensitive vsys names"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Role",
            "number": "N/A",
            "description": "Assigns an administrative role for Panorama management. Requires service=PaloAlto and protocol=panorama in TACACS+ configuration.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Panorama-Admin-Role=panorama-admin for full Panorama access",
            "use_cases": [
                "Control Panorama admin access",
                "Implement centralized management RBAC",
                "Delegate device group management",
                "Support hierarchical administration",
                "Enable audit compliance"
            ],
            "implementation": [
                "Configure TACACS+ with service=PaloAlto",
                "Set protocol=panorama for Panorama",
                "Standard roles: panorama-admin, custom roles supported",
                "Roles must be pre-defined in Panorama",
                "Enable role override in Panorama settings"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Access-Domain",
            "number": "N/A",
            "description": "Specifies access domains for Panorama administrators. Controls which device groups and templates an admin can manage.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Panorama-Admin-Access-Domain=DG-Branch,DG-HQ for specific device groups",
            "use_cases": [
                "Restrict access to device groups",
                "Support multi-tenant management",
                "Delegate template management",
                "Implement administrative boundaries",
                "Enable granular access control"
            ],
            "implementation": [
                "Configure access domains in Panorama",
                "Use with service=PaloAlto, protocol=panorama",
                "Define device groups and template stacks",
                "Comma-separated list for multiple domains",
                "Case-sensitive names must match exactly"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level. Used when Palo Alto-specific attributes are not configured.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for superuser access; priv-lvl=5 for read-only access",
            "use_cases": [
                "Fallback for standard TACACS+ auth",
                "Support legacy configurations",
                "Enable basic privilege mapping",
                "Maintain compatibility",
                "Simple access control"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Maps to PAN-OS roles: 15=superuser, 5=superreader",
                "Used when VSAs not available",
                "Configure privilege level mapping",
                "Works with standard TACACS+ servers"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the TACACS+ service type. Must be set to 'PaloAlto' for Palo Alto-specific attributes to work.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=PaloAlto for vendor-specific attributes",
            "use_cases": [
                "Enable Palo Alto VSAs",
                "Differentiate from standard TACACS+",
                "Support vendor extensions",
                "Control attribute processing",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure in TACACS+ server policy",
                "Required for PaloAlto-* attributes",
                "Use with appropriate protocol attribute",
                "Alternative: service=shell for standard",
                "Case-sensitive service name"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "Specifies the protocol context. Set to 'firewall' for PAN-OS or 'panorama' for Panorama management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol=firewall for PAN-OS management; protocol=panorama for Panorama",
            "use_cases": [
                "Differentiate management contexts",
                "Enable appropriate VSAs",
                "Support dual-mode authentication",
                "Control attribute interpretation",
                "Facilitate troubleshooting"
            ],
            "implementation": [
                "Use with service=PaloAlto",
                "firewall: PAN-OS device management",
                "panorama: Panorama management",
                "Determines which VSAs are processed",
                "Configure in TACACS+ authorization rules"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization attribute. Controls which CLI commands an administrator can execute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show * {permit .*} for allowing all show commands; cmd=configure {deny .*} for denying configuration",
            "use_cases": [
                "Implement command-level authorization",
                "Restrict configuration changes",
                "Allow monitoring-only access",
                "Create custom command profiles",
                "Support audit requirements"
            ],
            "implementation": [
                "Enable command authorization on PAN-OS",
                "Configure TACACS+ command auth rules",
                "Use regex for command matching",
                "Specify permit or deny actions",
                "Test with 'debug cli on'"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Device-Group",
            "number": "N/A",
            "description": "Specifies device group for Panorama-managed devices. Controls policy and object visibility.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Device-Group=Branch-Offices for branch device management",
            "use_cases": [
                "Organize managed devices",
                "Apply group-specific policies",
                "Delegate device management",
                "Support hierarchical management",
                "Enable template inheritance"
            ],
            "implementation": [
                "Define device groups in Panorama",
                "Use with Panorama authentication",
                "Controls policy inheritance",
                "Supports nested device groups",
                "Case-sensitive group names"
            ],
            "reference": "https://docs.paloaltonetworks.com/panorama/10-1/panorama-admin/manage-firewalls/device-groups"
        },
        {
            "name": "PaloAlto-Template-Stack",
            "number": "N/A",
            "description": "Specifies template stack access for Panorama administrators. Controls network and device configuration templates.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Template-Stack=Base-Template,Regional-Template for template access",
            "use_cases": [
                "Control template configuration access",
                "Delegate network configuration",
                "Support template inheritance",
                "Enable regional management",
                "Maintain configuration consistency"
            ],
            "implementation": [
                "Create template stacks in Panorama",
                "Assign administrators to stacks",
                "Controls network/device settings access",
                "Supports multiple template assignment",
                "Works with access domains"
            ],
            "reference": "https://docs.paloaltonetworks.com/panorama/10-1/panorama-admin/manage-firewalls/templates"
        },
        {
            "name": "PaloAlto-Collector-Group",
            "number": "N/A",
            "description": "Specifies log collector group access. Controls which log collectors an administrator can manage.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Collector-Group=Regional-Collectors for regional log management",
            "use_cases": [
                "Delegate log collector management",
                "Support distributed logging",
                "Control log access by region",
                "Enable compliance separation",
                "Manage log retention policies"
            ],
            "implementation": [
                "Define collector groups in Panorama",
                "Assign log collectors to groups",
                "Use with Panorama access domains",
                "Controls log visibility and management",
                "Supports multiple collector groups"
            ],
            "reference": "https://docs.paloaltonetworks.com/panorama/10-1/panorama-admin/panorama-log-collection-and-forwarding"
        },
        {
            "name": "PaloAlto-WildFire-Cluster",
            "number": "N/A",
            "description": "Specifies WildFire cluster access for administrators. Controls malware analysis infrastructure management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-WildFire-Cluster=Private-Cloud for private WildFire management",
            "use_cases": [
                "Manage private WildFire clusters",
                "Control malware analysis access",
                "Support regional compliance",
                "Delegate security operations",
                "Enable threat research access"
            ],
            "implementation": [
                "Deploy WildFire private cloud",
                "Configure cluster access in Panorama",
                "Assign administrators to clusters",
                "Controls analysis and reporting access",
                "Supports multiple cluster assignment"
            ],
            "reference": "https://docs.paloaltonetworks.com/wildfire/10-1/wildfire-admin/wildfire-private-cloud"
        },
        {
            "name": "PaloAlto-Admin-Session-Timeout",
            "number": "N/A",
            "description": "Sets administrative session timeout in minutes. Controls how long an admin session remains active.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "PaloAlto-Admin-Session-Timeout=30 for 30-minute timeout",
            "use_cases": [
                "Enforce security timeout policies",
                "Support compliance requirements",
                "Prevent unauthorized access",
                "Control resource utilization",
                "Enable differentiated timeout policies"
            ],
            "implementation": [
                "Configure in TACACS+ response",
                "Value in minutes (0-1440)",
                "Overrides system default timeout",
                "Set to 0 for no timeout",
                "Monitor with session logs"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-admin/authentication/authentication-types/tacacs"
        }
    ]
}
EOF
            ;;
        "aruba:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "aruba",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Aruba-User-Role",
            "number": "1",
            "description": "Assigns a user role to the authenticated user. User roles on Aruba devices define comprehensive access control policies including ACLs, QoS, VLAN assignment, and other parameters. This is the primary method for implementing role-based access control.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-User-Role = 'employee' for corporate access; Aruba-User-Role = 'guest' for limited internet access",
            "use_cases": [
                "Implement comprehensive RBAC for wireless users",
                "Apply different policies for employees vs guests",
                "Control network access based on device type",
                "Support BYOD with appropriate restrictions",
                "Enable dynamic policy changes via CoA"
            ],
            "implementation": [
                "Define user roles on Aruba controller (Configuration > Roles & Policies)",
                "Configure firewall policies, QoS, and VLAN assignments for each role",
                "Configure RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Ensure role names match exactly (case-sensitive)",
                "Test with 'show user-table' and 'show rights <role-name>'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/security/roles-policies.htm"
        },
        {
            "name": "Aruba-User-Vlan",
            "number": "2",
            "description": "Assigns a VLAN to an authenticated user. Can be used independently or in conjunction with user roles for dynamic VLAN assignment.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-User-Vlan = '100' for VLAN 100; Aruba-User-Vlan = 'employees' for named VLAN",
            "use_cases": [
                "Dynamic VLAN assignment based on user identity",
                "Network segmentation for security",
                "Support for multi-tenant environments",
                "IoT device isolation",
                "Guest network segregation"
            ],
            "implementation": [
                "Configure VLANs on Aruba controller",
                "VLAN must exist on the controller and upstream switches",
                "Can use VLAN ID (1-4094) or VLAN name",
                "Override VLAN specified in user role if both are present",
                "Verify with 'show user-table verbose'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/security/vlan-assignment.htm"
        },
        {
            "name": "Aruba-Admin-Role",
            "number": "3",
            "description": "Assigns a specific admin role for management access to Aruba devices. Controls what administrative functions a user can perform.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Admin-Role = 'root' for full access; Aruba-Admin-Role = 'network-operations' for limited admin",
            "use_cases": [
                "Implement administrative RBAC",
                "Delegate specific management functions",
                "Support compliance requirements",
                "Enable multi-level administration",
                "Restrict configuration changes"
            ],
            "implementation": [
                "Configure admin roles on controller (Configuration > System > Admin Roles)",
                "Standard roles: root, read-only, network-operations, location-api-mgmt",
                "Custom admin roles can be created with specific permissions",
                "Enable external authentication for management users",
                "Test with 'show rights' and 'show mgmt-user'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/admin-auth.htm"
        },
        {
            "name": "Aruba-Template-User",
            "number": "4",
            "description": "Specifies a template user profile to apply. Inherits all settings from the template user.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Template-User = 'corp-template' for corporate user template",
            "use_cases": [
                "Simplify user provisioning",
                "Maintain consistent user settings",
                "Support complex configurations",
                "Enable rapid deployment",
                "Facilitate troubleshooting"
            ],
            "implementation": [
                "Create template users on controller",
                "Configure all desired settings on template",
                "Template must exist before authentication",
                "Settings are copied at authentication time",
                "Monitor with 'show user-table verbose'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/users/template-users.htm"
        },
        {
            "name": "Aruba-PPort-Bounce-Host",
            "number": "5",
            "description": "Enables port bounce (link down/up) for wired 802.1X ports. Forces client to re-authenticate.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wired",
            "example": "Aruba-PPort-Bounce-Host = '1' to bounce the port",
            "use_cases": [
                "Force client re-authentication",
                "Apply new security policies",
                "Resolve connectivity issues",
                "Implement security responses",
                "Support troubleshooting"
            ],
            "implementation": [
                "Used with wired 802.1X authentication",
                "Set to '1' to trigger port bounce",
                "Can be sent via RADIUS CoA",
                "Port goes down briefly then back up",
                "Monitor with 'show port-access clients'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/wired/port-access.htm"
        },
        {
            "name": "Aruba-Bandwidth-Max-User",
            "number": "6",
            "description": "Sets the maximum bandwidth for a user session. Applies bidirectional rate limiting.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Bandwidth-Max-User = '10240' for 10 Mbps limit",
            "use_cases": [
                "Implement fair usage policies",
                "Control bandwidth by user type",
                "Prevent network congestion",
                "Support tiered services",
                "Enable bandwidth management"
            ],
            "implementation": [
                "Value in Kbps (kilobits per second)",
                "Applies to both upstream and downstream",
                "Can be changed via CoA",
                "Overrides role-based bandwidth settings",
                "Monitor with 'show datapath session'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/firewall/bandwidth-contracts.htm"
        },
        {
            "name": "Aruba-Bandwidth-Max-User-Upstream",
            "number": "7",
            "description": "Sets the maximum upstream bandwidth for a user. Enables asymmetric bandwidth control.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Bandwidth-Max-User-Upstream = '5120' for 5 Mbps upstream",
            "use_cases": [
                "Control upload bandwidth separately",
                "Prevent upstream congestion",
                "Support asymmetric services",
                "Manage video conferencing impact",
                "Enable granular bandwidth control"
            ],
            "implementation": [
                "Value in Kbps",
                "Use with downstream attribute for full control",
                "Can be updated via CoA",
                "Overrides symmetric bandwidth limits",
                "Verify with 'show rights' and traffic tests"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/firewall/bandwidth-contracts.htm"
        },
        {
            "name": "Aruba-Bandwidth-Max-User-Downstream",
            "number": "8",
            "description": "Sets the maximum downstream bandwidth for a user. Pairs with upstream for asymmetric control.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Bandwidth-Max-User-Downstream = '20480' for 20 Mbps downstream",
            "use_cases": [
                "Control download bandwidth",
                "Implement service tiers",
                "Manage streaming impact",
                "Support fair usage policies",
                "Enable bandwidth-on-demand"
            ],
            "implementation": [
                "Value in Kbps",
                "Often higher than upstream limit",
                "Dynamic updates via CoA",
                "Works with QoS policies",
                "Monitor with bandwidth reports"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/firewall/bandwidth-contracts.htm"
        },
        {
            "name": "Aruba-ACL-Name",
            "number": "10",
            "description": "Specifies a named ACL to apply to the user session. Provides granular traffic control.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-ACL-Name = 'GUEST-ACL' for guest restrictions",
            "use_cases": [
                "Apply specific security policies",
                "Override role-based ACLs",
                "Implement temporary restrictions",
                "Support compliance requirements",
                "Enable dynamic security"
            ],
            "implementation": [
                "ACL must be pre-configured on controller",
                "Can specify session or standard ACL",
                "Overrides ACLs in user role",
                "Supports both IPv4 and IPv6 rules",
                "Verify with 'show rights' and 'show acl'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/firewall/acl-policies.htm"
        },
        {
            "name": "Aruba-Captive-Portal-Profile",
            "number": "11",
            "description": "Specifies which captive portal profile to use for the session. Enables customized portal experiences.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Captive-Portal-Profile = 'guest-portal' for guest authentication",
            "use_cases": [
                "Provide branded login experiences",
                "Support multiple portal types",
                "Enable terms acceptance",
                "Implement guest registration",
                "Support payment gateways"
            ],
            "implementation": [
                "Create captive portal profiles on controller",
                "Configure portal pages and authentication",
                "Profile must exist before use",
                "Can be changed dynamically",
                "Monitor with 'show captive-portal'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/captive-portal/captive-portal.htm"
        },
        {
            "name": "Aruba-NAP-Id",
            "number": "12",
            "description": "Specifies the Network Access Profile ID. Used for advanced policy decisions.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-NAP-Id = 'BYOD-Profile' for BYOD devices",
            "use_cases": [
                "Implement device-based policies",
                "Support BYOD classifications",
                "Enable posture assessment",
                "Control access by device type",
                "Support NAC integration"
            ],
            "implementation": [
                "Define NAP profiles on controller",
                "Used with ClearPass integration",
                "Supports device profiling",
                "Works with enforcement policies",
                "Monitor with 'show user-table'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/security/nap-profiles.htm"
        },
        {
            "name": "Aruba-Framed-IPv6-Address",
            "number": "15",
            "description": "Assigns a specific IPv6 address to the user. Supports IPv6-only or dual-stack deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Framed-IPv6-Address = '2001:db8::1234/128' for static IPv6",
            "use_cases": [
                "Assign static IPv6 addresses",
                "Support IPv6-only networks",
                "Enable dual-stack operations",
                "Facilitate IPv6 migration",
                "Support specific applications"
            ],
            "implementation": [
                "Enable IPv6 on controller and VLANs",
                "Configure IPv6 addressing",
                "Use with IPv6 router advertisements",
                "Monitor with 'show user-table ipv6'",
                "Verify with 'show datapath session ipv6'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/ipv6/ipv6-deployment.htm"
        },
        {
            "name": "Aruba-API-Role",
            "number": "20",
            "description": "Assigns an API access role for REST API authentication. Controls programmatic access to the controller.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-API-Role = 'api-read-only' for monitoring access",
            "use_cases": [
                "Enable REST API access",
                "Support automation tools",
                "Implement monitoring systems",
                "Control API permissions",
                "Enable integration platforms"
            ],
            "implementation": [
                "Define API roles on controller",
                "Configure REST API access",
                "Enable HTTPS/API on management interface",
                "Use with API authentication",
                "Monitor with 'show api_acl_stats'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/rest-api.htm"
        },
        {
            "name": "Aruba-Device-Type",
            "number": "21",
            "description": "Specifies the device type for policy decisions. Enables device-specific access control.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Device-Type = 'iPhone' for Apple devices",
            "use_cases": [
                "Apply device-specific policies",
                "Support BYOD initiatives",
                "Control IoT device access",
                "Implement device-based QoS",
                "Enable device visibility"
            ],
            "implementation": [
                "Usually set by device profiling",
                "Can be manually specified",
                "Used in policy conditions",
                "Works with fingerprinting",
                "Verify with 'show user-table verbose'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/device/device-fingerprinting.htm"
        },
        {
            "name": "Aruba-AP-Group",
            "number": "22",
            "description": "Assigns the user to a specific AP group. Enables location-based policies and services.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Aruba-AP-Group = 'Building-A' for location-specific policies",
            "use_cases": [
                "Implement location-based access",
                "Support multi-site deployments",
                "Enable regional policies",
                "Control RF settings by location",
                "Support emergency services"
            ],
            "implementation": [
                "Create AP groups on controller",
                "Assign APs to groups",
                "Configure group-specific settings",
                "Use in policy decisions",
                "Monitor with 'show ap-group'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/rf/ap-groups.htm"
        },
        {
            "name": "Aruba-ESSID",
            "number": "25",
            "description": "Specifies the ESSID (SSID) for the wireless connection. Used for SSID-specific policies.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Aruba-ESSID = 'Corporate-WiFi' for corporate network",
            "use_cases": [
                "Apply SSID-specific policies",
                "Support multiple wireless networks",
                "Enable service differentiation",
                "Track usage by SSID",
                "Support guest networks"
            ],
            "implementation": [
                "Configure SSIDs on controller",
                "Set in RADIUS during authentication",
                "Used for policy matching",
                "Available in session information",
                "Monitor with 'show user-table essid'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/wlan-config/ssid-profiles.htm"
        },
        {
            "name": "Aruba-Location-Id",
            "number": "27",
            "description": "Specifies the location identifier for the user. Enables location-aware services and policies.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Location-Id = 'Floor2-East' for building locations",
            "use_cases": [
                "Enable location services",
                "Support wayfinding applications",
                "Implement geo-fencing",
                "Track user locations",
                "Support emergency response"
            ],
            "implementation": [
                "Configure location hierarchy",
                "Enable location services",
                "Use with ALE or Meridian",
                "Integrate with third-party systems",
                "Monitor with location APIs"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/location/location-services.htm"
        },
        {
            "name": "Aruba-Port-Id",
            "number": "28",
            "description": "Identifies the physical port for wired connections. Used for port-based policies and troubleshooting.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wired",
            "example": "Aruba-Port-Id = '1/1/5' for specific switch port",
            "use_cases": [
                "Track wired connections",
                "Apply port-specific policies",
                "Support troubleshooting",
                "Enable port security",
                "Implement device tracking"
            ],
            "implementation": [
                "Automatically populated for wired auth",
                "Used in policy conditions",
                "Available in session logs",
                "Supports port-based ACLs",
                "Monitor with 'show port-access clients'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/wired/wired-authentication.htm"
        },
        {
            "name": "Aruba-Template-User",
            "number": "30",
            "description": "Specifies a template user whose attributes should be copied to this session. Simplifies user provisioning.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Template-User = 'employee-template' for standard employee settings",
            "use_cases": [
                "Standardize user configurations",
                "Simplify RADIUS server setup",
                "Support complex role combinations",
                "Enable quick deployments",
                "Maintain consistent policies"
            ],
            "implementation": [
                "Create template users in local database",
                "Configure all desired attributes",
                "Reference template in RADIUS response",
                "Template settings applied at auth time",
                "Verify with 'show user-table verbose'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/users/user-templates.htm"
        },
        {
            "name": "Aruba-MPSK-Passphrase",
            "number": "31",
            "description": "Specifies a unique pre-shared key for the user. Enables Multi-PSK (MPSK) deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Aruba-MPSK-Passphrase = 'UniqueKey123!' for per-user PSK",
            "use_cases": [
                "Enable per-user PSK authentication",
                "Support IoT device onboarding",
                "Improve WPA2-PSK security",
                "Enable key rotation per user",
                "Support BYOD without certificates"
            ],
            "implementation": [
                "Configure MPSK authentication method",
                "Create unique keys per user/device",
                "Minimum 8 characters required",
                "Can be changed via CoA",
                "Monitor with 'show user-table mpsk'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mpsk/mpsk-overview.htm"
        },
        {
            "name": "Aruba-MPSK-Passphrase-Type",
            "number": "32",
            "description": "Specifies the type/format of the MPSK passphrase. Determines how the key is processed.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Aruba-MPSK-Passphrase-Type = '0' for ASCII passphrase",
            "use_cases": [
                "Support different key formats",
                "Enable hex key input",
                "Maintain compatibility",
                "Support legacy systems",
                "Enable automated provisioning"
            ],
            "implementation": [
                "0 = ASCII passphrase",
                "1 = Hex string (64 characters)",
                "Use with MPSK-Passphrase attribute",
                "Must match key format",
                "Verify with authentication logs"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mpsk/mpsk-configuration.htm"
        },
        {
            "name": "Aruba-WorkSpace-App-Name",
            "number": "35",
            "description": "Specifies Aruba Workspace application name. Used for application-aware policies.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-WorkSpace-App-Name = 'Microsoft-Teams' for Teams policies",
            "use_cases": [
                "Enable application-specific QoS",
                "Support unified communications",
                "Prioritize business applications",
                "Control application access",
                "Monitor application usage"
            ],
            "implementation": [
                "Configure AppRF on controller",
                "Define application policies",
                "Integrate with UCC features",
                "Monitor with AppRF dashboard",
                "Use with DPI engine"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/dpi/apprf-overview.htm"
        }
    ]
}
EOF
            ;;
        "aruba:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "aruba",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "role",
            "number": "N/A",
            "description": "Assigns an administrative role on Aruba controllers. Primary method for implementing role-based access control for device management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "role = root for full administrative access; role = network-operations for limited management",
            "use_cases": [
                "Implement administrative RBAC",
                "Delegate specific management tasks",
                "Support compliance requirements",
                "Enable multi-level administration",
                "Restrict configuration changes"
            ],
            "implementation": [
                "Configure TACACS+ server with Aruba attributes",
                "Enable TACACS+ authentication on Aruba device",
                "Standard roles: root, read-only, network-operations",
                "Custom admin roles can be created on controller",
                "Test with 'show mgmt-user' command"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level. Mapped to Aruba administrative roles when role attribute is not specified.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl = 15 for root access; priv-lvl = 1 for read-only access",
            "use_cases": [
                "Support standard TACACS+ implementations",
                "Maintain compatibility with other vendors",
                "Provide fallback authorization method",
                "Enable gradual migration to role-based",
                "Support legacy TACACS+ servers"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Level 15 maps to root role",
                "Level 1 maps to read-only role",
                "Configure privilege level mapping on controller",
                "Used when Aruba-specific role not available"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "Aruba-Admin-Role",
            "number": "N/A",
            "description": "Alternative attribute name for specifying administrative role. Provides same functionality as 'role' attribute.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Admin-Role = root for full access",
            "use_cases": [
                "Alternative to role attribute",
                "Support different TACACS+ servers",
                "Maintain naming consistency",
                "Enable vendor-specific configuration",
                "Support multiple attribute formats"
            ],
            "implementation": [
                "Same functionality as role attribute",
                "Configure on TACACS+ server",
                "Role must exist on controller",
                "Case-sensitive role names",
                "Verify with 'show rights' command"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "shell:roles",
            "number": "N/A",
            "description": "Cisco-style attribute for role assignment. Supported for compatibility with ACS and ISE.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "shell:roles = \"network-admin\" for network administrator access",
            "use_cases": [
                "Integration with Cisco ACS/ISE",
                "Support multi-vendor environments",
                "Enable centralized TACACS+ management",
                "Maintain compatibility with Cisco configs",
                "Support shared TACACS+ infrastructure"
            ],
            "implementation": [
                "Used with Cisco TACACS+ servers",
                "Maps to Aruba admin roles",
                "Requires proper parser configuration",
                "Enable VSA support on controller",
                "Test with Cisco TACACS+ integration"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization attribute. Controls which CLI commands an administrator can execute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd = show for allowing show commands; cmd = configure for allowing configuration",
            "use_cases": [
                "Implement command-level authorization",
                "Restrict specific CLI commands",
                "Create custom command profiles",
                "Support audit requirements",
                "Enable granular access control"
            ],
            "implementation": [
                "Enable command authorization on controller",
                "Configure command lists on TACACS+ server",
                "Use regular expressions for matching",
                "Supports permit and deny actions",
                "Debug with 'debug security process authmgr'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/cmd-authorization.htm"
        },
        {
            "name": "Aruba-CPPM-Role",
            "number": "N/A",
            "description": "ClearPass Policy Manager role assignment. Used when TACACS+ is proxied through CPPM.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-CPPM-Role = \"Network-Admin\" for CPPM-based authorization",
            "use_cases": [
                "Integrate with ClearPass Policy Manager",
                "Centralize policy management",
                "Support CPPM TACACS+ proxy",
                "Enable advanced policy decisions",
                "Leverage CPPM authentication sources"
            ],
            "implementation": [
                "Configure CPPM as TACACS+ proxy",
                "Define roles in CPPM",
                "Map to controller admin roles",
                "Use CPPM enforcement policies",
                "Monitor with CPPM access tracker"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ClearPass/6.7/PolicyManager/Content/CPPM_UserGuide/Admin/TacacsAuthentication.htm"
        },
        {
            "name": "admin-role",
            "number": "N/A",
            "description": "Generic admin role attribute. Alternative format supported by some TACACS+ servers.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "admin-role = root for administrative access",
            "use_cases": [
                "Support various TACACS+ servers",
                "Provide attribute flexibility",
                "Enable custom implementations",
                "Maintain backward compatibility",
                "Support third-party integrations"
            ],
            "implementation": [
                "Configure based on TACACS+ server type",
                "Same functionality as role attribute",
                "Check server documentation for format",
                "Test with specific TACACS+ implementation",
                "Verify with authentication logs"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "Aruba-Location",
            "number": "N/A",
            "description": "Restricts admin access to specific controller locations or clusters.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Location = \"/md/Building-A\" for specific location access",
            "use_cases": [
                "Implement location-based admin access",
                "Support distributed deployments",
                "Restrict regional administrators",
                "Enable hierarchical management",
                "Support multi-site operations"
            ],
            "implementation": [
                "Define location hierarchy on controller",
                "Configure in Mobility Master/Conductor",
                "Use with multi-controller deployments",
                "Specify path in configuration hierarchy",
                "Test with 'show configuration effective'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mobility-master/mm-overview.htm"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "TACACS+ service type. Should be set to appropriate value for Aruba authentication.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service = shell for CLI access; service = system for system authentication",
            "use_cases": [
                "Specify authentication context",
                "Support different access methods",
                "Enable proper attribute processing",
                "Maintain TACACS+ compliance",
                "Support multiple services"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Usually set to 'shell' for CLI",
                "Configure in TACACS+ server policy",
                "Required for proper authorization",
                "Different services may use different attributes"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "TACACS+ protocol type. Typically set for service context.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol = ip for standard access",
            "use_cases": [
                "Specify protocol context",
                "Support service differentiation",
                "Enable proper authorization",
                "Maintain protocol compliance",
                "Support various access types"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Often set to 'ip' or 'shell'",
                "Used with service attribute",
                "Configure in server policy",
                "Check server documentation"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_86_Web_Help/Content/arubaos-solutions/mgmt/tacacs-auth.htm"
        }
    ]
}
EOF
            ;;
        "cisco:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "cisco",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Cisco-AVPair",
            "number": "1",
            "description": "Multi-purpose attribute used for various functions including shell privilege levels, ACL assignments, VLAN assignments, SGT assignments, QoS policies, bandwidth control, VPN parameters, and more. The most versatile Cisco VSA.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": true,
                "captive": true,
                "sgt": true,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": true,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Cisco-AVPair = 'shell:priv-lvl=15' for admin access; Cisco-AVPair = 'cts:security-group-tag=100' for SGT; Cisco-AVPair = 'ip:inacl#10=permit ip any any' for ACL",
            "use_cases": [
                "Assign administrator privilege levels",
                "Apply downloadable ACLs (dACLs)",
                "Configure TrustSec Security Group Tags",
                "Set QoS policies and bandwidth limits",
                "Specify VPN pool and DNS settings",
                "Enable URL redirection for captive portals",
                "Configure interface templates",
                "Set session timeout values",
                "Apply IPv6-specific settings"
            ],
            "implementation": [
                "Configure RADIUS server to return this VSA",
                "Format varies by function: 'type:parameter=value'",
                "Multiple AVPairs can be sent for different functions",
                "For ACLs: ip:inacl#<num>=<ace> format",
                "For shell access: shell:priv-lvl=<0-15>",
                "For SGT: cts:security-group-tag=<tag-value>",
                "For QoS: ip:sub-qos-policy-in=<policy-name>",
                "Monitor with 'show aaa user all' or 'show access-session'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/xe-16/sec-usr-rad-xe-16-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-Account-Info",
            "number": "2",
            "description": "Provides accounting information for billing and auditing purposes. Can include custom accounting data.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Account-Info = 'S12345/Premium' for subscriber account info",
            "use_cases": [
                "Track subscriber account information",
                "Support billing integration",
                "Enable service provider accounting",
                "Maintain audit trails",
                "Support compliance reporting"
            ],
            "implementation": [
                "Configure in RADIUS accounting records",
                "Used primarily for ISP/carrier deployments",
                "Can contain arbitrary string data",
                "Processed by billing systems",
                "Available in accounting start/stop messages"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/xe-16/sec-usr-rad-xe-16-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-Command",
            "number": "3",
            "description": "Contains the command being executed. Used for command authorization and accounting.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Command = 'show running-config' for command authorization",
            "use_cases": [
                "Implement command authorization",
                "Audit administrative actions",
                "Control configuration access",
                "Support compliance requirements",
                "Enable command logging"
            ],
            "implementation": [
                "Enable 'aaa authorization commands' on device",
                "RADIUS server evaluates command against policy",
                "Used with shell:priv-lvl for complete control",
                "Supports regular expressions for matching",
                "Monitor with 'debug aaa authorization'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_aaa/configuration/xe-16/sec-usr-aaa-xe-16-book/sec-author-cmd.html"
        },
        {
            "name": "Cisco-NAS-Port",
            "number": "4",
            "description": "Identifies the physical port of the NAS where the user is connected. Enhanced version of standard NAS-Port.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-NAS-Port = 'GigabitEthernet1/0/1' for specific interface",
            "use_cases": [
                "Identify connection interface",
                "Support port-based policies",
                "Enable location tracking",
                "Facilitate troubleshooting",
                "Support port security"
            ],
            "implementation": [
                "Automatically populated by NAS",
                "Format varies by platform",
                "Used for session identification",
                "Available in authentication requests",
                "Can be used in policy decisions"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/xe-16/sec-usr-rad-xe-16-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-IP-Pool",
            "number": "217",
            "description": "Specifies the IP address pool to use for address allocation. Commonly used for VPN client addressing.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-IP-Pool = 'VPN_POOL_SALES' for sales department VPN users",
            "use_cases": [
                "Assign VPN client addresses",
                "Implement department-based pools",
                "Support multiple address ranges",
                "Enable IP management",
                "Facilitate network planning"
            ],
            "implementation": [
                "Define IP pools on NAS device",
                "Configure RADIUS to return pool name",
                "Pool must exist on authenticating device",
                "Used primarily with VPN deployments",
                "Monitor with 'show ip local pool'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/security/asa/asa96/configuration/vpn/asa-96-vpn-config/vpn-aaa.html"
        },
        {
            "name": "Cisco-IPv6-Pool",
            "number": "218",
            "description": "Specifies the IPv6 address pool for client allocation. Essential for IPv6 VPN deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-IPv6-Pool = 'IPv6_VPN_POOL' for IPv6 VPN addressing",
            "use_cases": [
                "Enable IPv6 VPN connectivity",
                "Support dual-stack VPN clients",
                "Implement IPv6-only access",
                "Future-proof VPN infrastructure",
                "Support IPv6 transition"
            ],
            "implementation": [
                "Configure IPv6 pools on device",
                "Enable IPv6 on VPN gateway",
                "Configure RADIUS for IPv6 pool selection",
                "Supports prefix delegation",
                "Monitor with 'show ipv6 local pool'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/security/asa/asa96/configuration/vpn/asa-96-vpn-config/vpn-aaa.html"
        },
        {
            "name": "Cisco-VPN-Group-Policy",
            "number": "25",
            "description": "Specifies the group policy to apply to a VPN session. Controls VPN client settings and access rights.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-VPN-Group-Policy = 'SALES_POLICY' for sales VPN users",
            "use_cases": [
                "Apply VPN-specific settings",
                "Control split tunneling",
                "Set session timeouts",
                "Configure DNS settings",
                "Apply access restrictions"
            ],
            "implementation": [
                "Create group policies on ASA/router",
                "Configure RADIUS to return policy name",
                "Policy defines VPN parameters",
                "Overrides default group policy",
                "Monitor with 'show vpn-sessiondb'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/security/asa/asa96/configuration/vpn/asa-96-vpn-config/vpn-groups.html"
        },
        {
            "name": "Cisco-DHCP-Relay-IP-Address",
            "number": "226",
            "description": "Specifies DHCP relay server addresses. Used in broadband and enterprise deployments.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-DHCP-Relay-IP-Address = '192.168.1.10' for DHCP server",
            "use_cases": [
                "Configure per-user DHCP relay",
                "Support dynamic DHCP services",
                "Enable subscriber management",
                "Facilitate IP address assignment",
                "Support broadband deployments"
            ],
            "implementation": [
                "Used with broadband access",
                "Configure on BNG/BRAS devices",
                "Overrides global DHCP relay settings",
                "Can specify multiple servers",
                "Monitor with DHCP debugging"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipaddr_dhcp/configuration/xe-16/dhcp-xe-16-book/dhcp-relay-agent.html"
        },
        {
            "name": "Cisco-Primary-DNS",
            "number": "229",
            "description": "Specifies the primary DNS server for the user session. Commonly used in VPN and broadband scenarios.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Primary-DNS = '8.8.8.8' for Google DNS",
            "use_cases": [
                "Provide DNS services to clients",
                "Support split-DNS scenarios",
                "Enable content filtering",
                "Facilitate internal name resolution",
                "Support managed DNS services"
            ],
            "implementation": [
                "Configure RADIUS to return DNS server",
                "Used with VPN and PPP sessions",
                "Can be updated via CoA",
                "Works with secondary DNS attribute",
                "Applied to client configuration"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/xe-16/sec-usr-rad-xe-16-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-Secondary-DNS",
            "number": "230",
            "description": "Specifies the secondary DNS server for redundancy. Paired with primary DNS attribute.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Secondary-DNS = '8.8.4.4' for secondary Google DNS",
            "use_cases": [
                "Provide DNS redundancy",
                "Support failover scenarios",
                "Enable load balancing",
                "Ensure name resolution availability",
                "Support high-availability requirements"
            ],
            "implementation": [
                "Use with Cisco-Primary-DNS",
                "Configure backup DNS server",
                "Applied to client configuration",
                "Supports both IPv4 and IPv6",
                "Can be updated dynamically"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/xe-16/sec-usr-rad-xe-16-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-Policing-Rate",
            "number": "250",
            "description": "Specifies traffic policing rate in bits per second. Used for bandwidth management and QoS.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Policing-Rate = '10000000' for 10 Mbps policing",
            "use_cases": [
                "Implement bandwidth control",
                "Enforce traffic contracts",
                "Support tiered services",
                "Prevent bandwidth abuse",
                "Enable fair usage policies"
            ],
            "implementation": [
                "Value in bits per second",
                "Applied to user traffic",
                "Can be updated via CoA",
                "Works with QoS policies",
                "Monitor with 'show policy-map interface'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/qos_plcshp/configuration/xe-16/qos-plcshp-xe-16-book/qos-plcshp-class-plc.html"
        },
        {
            "name": "Cisco-Context-Name",
            "number": "31",
            "description": "Specifies VRF or context name for the session. Used in multi-tenant and VPN scenarios.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Context-Name = 'CUSTOMER_A' for VRF assignment",
            "use_cases": [
                "Implement network virtualization",
                "Support multi-tenant services",
                "Enable VRF-based routing",
                "Provide service isolation",
                "Support MPLS VPN services"
            ],
            "implementation": [
                "VRF must exist on device",
                "Used with VRF-aware services",
                "Supports both VRF and VRF-lite",
                "Case-sensitive context name",
                "Monitor with 'show vrf'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/mp_l3_vpns/configuration/xe-16/mp-l3-vpns-xe-16-book/mp-vrf-aware-aaa.html"
        },
        {
            "name": "Cisco-Subscriber-ACL-In",
            "number": "45",
            "description": "Downloadable ACL for inbound traffic control. Provides dynamic security policy application.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Subscriber-ACL-In = 'permit tcp any any eq 80' for web access",
            "use_cases": [
                "Apply user-specific ACLs",
                "Implement dynamic security",
                "Control traffic per subscriber",
                "Support zero-trust networking",
                "Enable granular access control"
            ],
            "implementation": [
                "ACL downloaded from RADIUS",
                "Applied to user session",
                "Supports extended ACL syntax",
                "Can be updated via CoA",
                "Monitor with 'show access-list'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_aaa/configuration/xe-16/sec-usr-aaa-xe-16-book/aaa-dynamic-author.html"
        },
        {
            "name": "Cisco-Subscriber-ACL-Out",
            "number": "46",
            "description": "Downloadable ACL for outbound traffic control. Complements inbound ACL for full traffic control.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Subscriber-ACL-Out = 'deny tcp any any eq 25' to block SMTP",
            "use_cases": [
                "Control outbound traffic",
                "Prevent malicious activity",
                "Implement egress filtering",
                "Support security policies",
                "Enable content restrictions"
            ],
            "implementation": [
                "Applied to outbound user traffic",
                "Downloaded from RADIUS",
                "Extended ACL syntax supported",
                "Dynamic updates via CoA",
                "Verify with 'show ip access-list'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_aaa/configuration/xe-16/sec-usr-aaa-xe-16-book/aaa-dynamic-author.html"
        },
        {
            "name": "Cisco-URL-Redirect",
            "number": "132",
            "description": "Specifies URL for HTTP redirect. Used for captive portals and guest access.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-URL-Redirect = 'https://portal.company.com/login' for guest portal",
            "use_cases": [
                "Implement captive portals",
                "Redirect to authentication pages",
                "Display terms of service",
                "Support guest networking",
                "Enable payment gateways"
            ],
            "implementation": [
                "Requires HTTP redirect capability",
                "Works with URL-Redirect-ACL",
                "Applied to web traffic",
                "Can be cleared via CoA",
                "Monitor with 'show authentication sessions'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst9300/software/release/16-12/configuration_guide/sec/b_1612_sec_9300_cg/configuring_web_based_authentication.html"
        },
        {
            "name": "Cisco-URL-Redirect-ACL",
            "number": "133",
            "description": "Specifies ACL that triggers URL redirection. Works with URL-Redirect attribute.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-URL-Redirect-ACL = 'REDIRECT_ACL' to trigger redirects",
            "use_cases": [
                "Define redirect conditions",
                "Control which traffic is redirected",
                "Exempt certain destinations",
                "Support selective redirection",
                "Enable portal bypass rules"
            ],
            "implementation": [
                "ACL must exist on device",
                "Defines traffic to redirect",
                "Used with URL-Redirect attribute",
                "Typically permits HTTP/HTTPS",
                "Can include deny rules for exemptions"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst9300/software/release/16-12/configuration_guide/sec/b_1612_sec_9300_cg/configuring_web_based_authentication.html"
        }
    ]
}
EOF
            ;;
        "cisco:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "cisco",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Specifies the privilege level for the user. Standard TACACS+ attribute for controlling administrative access levels.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for full administrative access; priv-lvl=1 for read-only",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based CLI access",
                "Support standard privilege levels",
                "Enable graduated access control",
                "Maintain compatibility across platforms"
            ],
            "implementation": [
                "Configure TACACS+ server to return priv-lvl",
                "Enable TACACS+ on Cisco device",
                "Levels 0-15 (15 highest privilege)",
                "Level 1: User EXEC mode",
                "Level 15: Privileged EXEC mode",
                "Custom levels 2-14 can be configured"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Used for command authorization to control which commands a user can execute. Core TACACS+ authorization attribute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands; cmd=configure for config mode",
            "use_cases": [
                "Implement command-level authorization",
                "Restrict specific commands",
                "Create custom command profiles",
                "Support audit requirements",
                "Enable granular access control"
            ],
            "implementation": [
                "Enable 'aaa authorization commands' on device",
                "Configure command lists on TACACS+ server",
                "Use with cmd-arg for complete command",
                "Supports permit and deny actions",
                "Can use wildcards and regex"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_aaa/configuration/xe-16/sec-usr-aaa-xe-16-book/sec-cfg-author.html"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Provides command arguments for authorization. Used with cmd attribute for complete command authorization.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=interface cmd-arg='GigabitEthernet0/1' for interface commands",
            "use_cases": [
                "Authorize complete commands with arguments",
                "Control access to specific interfaces",
                "Restrict configuration scope",
                "Support fine-grained authorization",
                "Enable audit trails"
            ],
            "implementation": [
                "Used with cmd attribute",
                "Contains command parameters",
                "TACACS+ server evaluates full command",
                "Supports regex matching",
                "Debug with 'debug aaa authorization'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_aaa/configuration/xe-16/sec-usr-aaa-xe-16-book/sec-cfg-author.html"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the service for which authorization is being performed. Core TACACS+ attribute.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=shell for CLI access; service=ppp for PPP; service=exec for EXEC",
            "use_cases": [
                "Specify authorization context",
                "Support multiple service types",
                "Enable service-specific policies",
                "Control access methods",
                "Maintain protocol compliance"
            ],
            "implementation": [
                "Common services: shell, exec, ppp, slip",
                "Shell service most common for admin",
                "Different services have different attributes",
                "Configure in TACACS+ server policy",
                "Required for proper authorization flow"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "Specifies the protocol context for authorization. Used with service attribute.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol=ip for IP services; protocol=ipx for IPX",
            "use_cases": [
                "Specify protocol context",
                "Support multi-protocol environments",
                "Enable protocol-specific policies",
                "Control service authorization",
                "Maintain backward compatibility"
            ],
            "implementation": [
                "Common protocols: ip, ipx, atalk, vines",
                "Used primarily with PPP/SLIP services",
                "Less relevant for modern networks",
                "Configure in TACACS+ authorization",
                "IP most commonly used"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "acl",
            "number": "N/A",
            "description": "Specifies an ACL number or name to apply to the user session. Used for traffic filtering.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "acl=101 for numbered ACL; acl=ADMIN_ACL for named ACL",
            "use_cases": [
                "Apply user-specific ACLs",
                "Control traffic for VPN users",
                "Implement security policies",
                "Support compliance requirements",
                "Enable dynamic filtering"
            ],
            "implementation": [
                "ACL must exist on device",
                "Can use numbered or named ACLs",
                "Applied to user session/interface",
                "Works with VTY and physical interfaces",
                "Verify with 'show access-lists'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "inacl",
            "number": "N/A",
            "description": "Downloadable inbound ACL definition. Allows dynamic ACL creation without pre-configuration.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "inacl#1=permit tcp any any eq 80; inacl#2=deny ip any any",
            "use_cases": [
                "Deploy dynamic ACLs",
                "Eliminate pre-configured ACLs",
                "Support user-specific policies",
                "Enable centralized ACL management",
                "Simplify security implementation"
            ],
            "implementation": [
                "Use format inacl#<num>=<ace>",
                "Multiple entries create complete ACL",
                "Downloaded during authentication",
                "Applied to user session",
                "No pre-configuration required"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "outacl",
            "number": "N/A",
            "description": "Downloadable outbound ACL definition. Controls egress traffic dynamically.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "outacl#1=deny tcp any any eq 25; outacl#2=permit ip any any",
            "use_cases": [
                "Control outbound traffic",
                "Prevent data exfiltration",
                "Implement egress filtering",
                "Support security policies",
                "Enable content restrictions"
            ],
            "implementation": [
                "Format: outacl#<num>=<ace>",
                "Multiple entries supported",
                "Applied to egress traffic",
                "Downloaded during auth",
                "Works with inacl for full control"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "addr-pool",
            "number": "N/A",
            "description": "Specifies the IP address pool for user allocation. Common in VPN and dial-up scenarios.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "addr-pool=VPN_POOL for VPN client addressing",
            "use_cases": [
                "Assign VPN client addresses",
                "Support dial-up users",
                "Implement dynamic addressing",
                "Enable pool-based allocation",
                "Support multiple address ranges"
            ],
            "implementation": [
                "Pool must exist on device",
                "Used with PPP/VPN services",
                "Configure local IP pools",
                "Monitor with 'show ip local pool'",
                "Supports named pools"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "route",
            "number": "N/A",
            "description": "Installs routes for the user session. Used for VPN client routing and network access.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "route='192.168.1.0 255.255.255.0' for network route",
            "use_cases": [
                "Install VPN client routes",
                "Enable split tunneling",
                "Support network access",
                "Configure static routes",
                "Enable subnet access"
            ],
            "implementation": [
                "Format: 'network mask [gateway]'",
                "Multiple routes supported",
                "Applied to routing table",
                "Removed on session end",
                "Monitor with 'show ip route'"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "timeout",
            "number": "N/A",
            "description": "Sets the session timeout value in minutes. Controls how long a session remains active.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "timeout=60 for 1-hour timeout",
            "use_cases": [
                "Control session duration",
                "Implement security policies",
                "Manage resource usage",
                "Support compliance requirements",
                "Enable automatic disconnection"
            ],
            "implementation": [
                "Value in minutes",
                "Applied to user session",
                "Overrides default timeout",
                "0 means no timeout",
                "Monitor active sessions"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "idletime",
            "number": "N/A",
            "description": "Sets the idle timeout in minutes. Disconnects inactive sessions to free resources.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "idletime=10 for 10-minute idle timeout",
            "use_cases": [
                "Disconnect idle sessions",
                "Free system resources",
                "Improve security posture",
                "Manage concurrent sessions",
                "Support resource policies"
            ],
            "implementation": [
                "Value in minutes",
                "Monitors session activity",
                "Disconnects after idle period",
                "Can be disabled with 0",
                "Works with absolute timeout"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "autocmd",
            "number": "N/A",
            "description": "Specifies a command to execute automatically after user login. Used for automation and user experience.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "autocmd='show version' to display version after login",
            "use_cases": [
                "Display login messages",
                "Run diagnostic commands",
                "Start user applications",
                "Configure user environment",
                "Automate routine tasks"
            ],
            "implementation": [
                "Command runs after authentication",
                "User must have permission for command",
                "Can chain multiple commands",
                "Supports command scripts",
                "Exit behavior configurable"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "noescape",
            "number": "N/A",
            "description": "Prevents users from escaping to command line. Used with autocmd for restricted access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "noescape=true with autocmd for menu-only access",
            "use_cases": [
                "Create restricted shells",
                "Implement menu systems",
                "Prevent CLI access",
                "Support kiosk mode",
                "Enable application-only access"
            ],
            "implementation": [
                "Used with autocmd attribute",
                "Prevents escape sequences",
                "User locked into autocmd",
                "Session ends when command exits",
                "Useful for restricted environments"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        },
        {
            "name": "callback-number",
            "number": "N/A",
            "description": "Specifies the phone number for callback authentication. Used in dial-up scenarios.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "callback-number='18005551234' for callback authentication",
            "use_cases": [
                "Implement callback security",
                "Reduce toll charges",
                "Verify user location",
                "Support legacy dial systems",
                "Enable cost control"
            ],
            "implementation": [
                "Used with dial-up connections",
                "System calls back to authenticate",
                "Number must be pre-authorized",
                "Legacy feature for PSTN",
                "Less relevant in modern networks"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/xe-16/sec-usr-tacacs-xe-16-book/sec-cfg-tacacs.html"
        }
    ]
}
EOF
            ;;
        "hp:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "hp",
    "protocol": "radius",
    "attributes": [
        {
            "name": "HP-Privilege-Level",
            "number": "1",
            "description": "Specifies the privilege level for administrative access to HP devices. Controls what commands and features administrators can access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Privilege-Level = 15 for manager access; HP-Privilege-Level = 0 for operator",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based management",
                "Delegate specific functions",
                "Support compliance requirements",
                "Enable multi-level administration"
            ],
            "implementation": [
                "Configure RADIUS server with HP VSAs",
                "Values typically 0-15",
                "Level 15: Full manager access",
                "Level 1: Limited operator access",
                "Level 0: Basic read-only access"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Command-String",
            "number": "2",
            "description": "Specifies allowed or denied commands for the user. Enables granular command authorization.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Command-String = 'permit:show.*;deny:config.*' for read-only with show commands",
            "use_cases": [
                "Implement command authorization",
                "Create custom access profiles",
                "Restrict configuration changes",
                "Allow specific diagnostics",
                "Support audit requirements"
            ],
            "implementation": [
                "Use permit/deny syntax",
                "Supports regular expressions",
                "Multiple patterns separated by semicolon",
                "Applied during command execution",
                "Works with privilege levels"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Management-Protocol",
            "number": "26",
            "description": "Specifies which management protocols the user can access (HTTP, HTTPS, SSH, Telnet, SNMP).",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Management-Protocol = 'SSH+HTTPS' for secure management only",
            "use_cases": [
                "Control management access methods",
                "Enforce secure protocols only",
                "Disable insecure access methods",
                "Support security policies",
                "Enable protocol-specific access"
            ],
            "implementation": [
                "Combine protocols with '+' separator",
                "Options: HTTP, HTTPS, SSH, Telnet, SNMP",
                "Case-sensitive protocol names",
                "Overrides global settings",
                "Applied per user session"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-User-Role",
            "number": "25",
            "description": "Assigns a predefined user role to the authenticated user. Comprehensive role-based access control.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-User-Role = 'network-admin' for network administrator role",
            "use_cases": [
                "Implement role-based access control",
                "Simplify user management",
                "Apply consistent permissions",
                "Support compliance requirements",
                "Enable delegated administration"
            ],
            "implementation": [
                "Roles must be predefined on switch",
                "Configure custom roles as needed",
                "Standard roles: admin, operator, monitor",
                "Role includes all permissions",
                "Simplifies RADIUS configuration"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Bandwidth-Max-Ingress",
            "number": "40",
            "description": "Sets the maximum ingress (inbound) bandwidth for the user's port in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Bandwidth-Max-Ingress = 100000 for 100 Mbps ingress limit",
            "use_cases": [
                "Implement per-user bandwidth limits",
                "Control network resource usage",
                "Support tiered service levels",
                "Prevent bandwidth abuse",
                "Enable fair usage policies"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Applied to switch port",
                "Can be changed via CoA",
                "Works with 802.1X authentication",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Bandwidth-Max-Egress",
            "number": "41",
            "description": "Sets the maximum egress (outbound) bandwidth for the user's port in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Bandwidth-Max-Egress = 50000 for 50 Mbps egress limit",
            "use_cases": [
                "Control upload bandwidth",
                "Implement asymmetric limits",
                "Manage server traffic",
                "Support QoS policies",
                "Enable traffic shaping"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Independent from ingress limit",
                "Dynamic updates via CoA",
                "Per-port enforcement",
                "Monitor with interface statistics"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Port-Priority",
            "number": "42",
            "description": "Sets the port priority for QoS. Higher priority traffic gets preferential treatment.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "HP-Port-Priority = 7 for highest priority (voice/video)",
            "use_cases": [
                "Prioritize critical applications",
                "Support voice/video traffic",
                "Implement QoS policies",
                "Enable service differentiation",
                "Support real-time applications"
            ],
            "implementation": [
                "Values typically 0-7",
                "Higher values = higher priority",
                "Applied to switch port",
                "Affects queuing behavior",
                "Works with CoS/DSCP marking"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Cos",
            "number": "45",
            "description": "Sets the Class of Service value for the user's traffic. Used for QoS marking.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "HP-Cos = 5 for voice traffic marking",
            "use_cases": [
                "Mark traffic for QoS",
                "Support end-to-end QoS",
                "Prioritize applications",
                "Enable VLAN priority tagging",
                "Support service classes"
            ],
            "implementation": [
                "802.1p CoS values 0-7",
                "Applied to Ethernet frames",
                "Preserved across network",
                "Maps to internal queues",
                "Interoperates with DSCP"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Rate-Limit",
            "number": "46",
            "description": "Generic rate limiting attribute. Can specify various rate limit parameters.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Rate-Limit = '10m/5m' for 10Mbps down/5Mbps up",
            "use_cases": [
                "Implement bandwidth policies",
                "Control traffic rates",
                "Support various limit types",
                "Enable flexible QoS",
                "Manage network resources"
            ],
            "implementation": [
                "Format varies by switch model",
                "Can include multiple parameters",
                "Supports various units",
                "Applied per port/user",
                "Check model-specific docs"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Ip-Filter-Raw",
            "number": "61",
            "description": "Specifies raw IP filter rules to apply to the user's traffic. Downloadable ACL functionality.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Ip-Filter-Raw = 'permit tcp any any eq 80;deny ip any any'",
            "use_cases": [
                "Apply dynamic ACLs",
                "Implement security policies",
                "Control user access",
                "Support zero-trust networking",
                "Enable granular filtering"
            ],
            "implementation": [
                "Extended ACL syntax",
                "Multiple rules separated by semicolon",
                "Applied to user session",
                "No pre-configuration needed",
                "Can be updated via CoA"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Time-Of-Day",
            "number": "70",
            "description": "Specifies time-based access restrictions. Controls when users can access the network.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Time-Of-Day = 'Mon-Fri:08:00-17:00' for business hours access",
            "use_cases": [
                "Implement time-based access",
                "Control after-hours access",
                "Support shift workers",
                "Enable maintenance windows",
                "Enforce security policies"
            ],
            "implementation": [
                "Day and time range format",
                "Multiple ranges supported",
                "Local switch time used",
                "Automatic enforcement",
                "Session terminated outside hours"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-NAS-Filter-Rule",
            "number": "400",
            "description": "Specifies filter rules for network access. Enhanced ACL functionality with more options.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HP-NAS-Filter-Rule = 'permit in tcp from any to 10.0.0.0/8 80'",
            "use_cases": [
                "Advanced traffic filtering",
                "Direction-specific rules",
                "Support complex policies",
                "Enable stateful filtering",
                "Implement security zones"
            ],
            "implementation": [
                "Enhanced ACL syntax",
                "Includes direction (in/out)",
                "Supports advanced matching",
                "Multiple rules per user",
                "Applied dynamically"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Port-Auth-Mode",
            "number": "50",
            "description": "Specifies the port authentication mode (single, multi-host, multi-auth).",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wired",
            "example": "HP-Port-Auth-Mode = 'multi-auth' for multiple device authentication",
            "use_cases": [
                "Control port authentication behavior",
                "Support multiple devices per port",
                "Enable IP phones with PCs",
                "Implement security policies",
                "Support various deployments"
            ],
            "implementation": [
                "Modes: single, multi-host, multi-auth",
                "Applied to switch port",
                "Changes authentication behavior",
                "Affects MAC address limits",
                "Works with 802.1X/MAB"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Captive-Portal-Profile",
            "number": "55",
            "description": "Assigns a captive portal profile to the user session. Used for guest authentication.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Captive-Portal-Profile = 'GUEST_PORTAL' for guest access",
            "use_cases": [
                "Enable guest authentication",
                "Display terms of service",
                "Implement web authentication",
                "Support temporary access",
                "Enable self-registration"
            ],
            "implementation": [
                "Profile must exist on switch",
                "Defines portal behavior",
                "Includes redirect URL",
                "Session limits configurable",
                "Can be cleared via CoA"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-User-Priority",
            "number": "56",
            "description": "Sets the user priority for various operations. Higher values indicate higher priority.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HP-User-Priority = 6 for high priority users",
            "use_cases": [
                "Prioritize user traffic",
                "Support VIP users",
                "Implement service tiers",
                "Control resource allocation",
                "Enable preferential treatment"
            ],
            "implementation": [
                "Numeric priority value",
                "Higher = more important",
                "Affects QoS decisions",
                "Applied per user session",
                "Can be updated dynamically"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        }
    ]
}
EOF
            ;;
        "hp:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "hp",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "hp-privilege-level",
            "number": "N/A",
            "description": "Sets the privilege level for administrative access to HP/HPE switches. Determines command access rights.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "hp-privilege-level=15 for manager access; hp-privilege-level=1 for operator",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based management",
                "Support compliance requirements",
                "Enable delegated administration",
                "Create custom privilege levels"
            ],
            "implementation": [
                "Configure TACACS+ server to return this attribute",
                "Enable TACACS+ authentication on HP switch",
                "Level 15: Manager (full access)",
                "Level 1: Operator (limited access)",
                "Levels 2-14 can be customized"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level attribute. Alternative to hp-privilege-level for compatibility.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for full access; priv-lvl=1 for read-only",
            "use_cases": [
                "Support standard TACACS+ implementations",
                "Maintain cross-vendor compatibility",
                "Enable centralized authentication",
                "Support legacy systems",
                "Implement basic access control"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Recognized by HP switches",
                "Same levels as hp-privilege-level",
                "Works with most TACACS+ servers",
                "Enable TACACS+ authorization"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization attribute. Controls which commands administrators can execute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands; cmd=configure for config mode",
            "use_cases": [
                "Implement command-level authorization",
                "Create custom command sets",
                "Restrict dangerous commands",
                "Support audit requirements",
                "Enable granular access control"
            ],
            "implementation": [
                "Enable 'aaa authorization commands' on switch",
                "Configure command lists on TACACS+ server",
                "Used with cmd-arg for complete command",
                "Supports permit/deny actions",
                "Regular expressions supported"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Command arguments for authorization. Used with cmd attribute for complete command authorization.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=interface cmd-arg='vlan 10' for specific interface commands",
            "use_cases": [
                "Authorize complete commands",
                "Control access to specific resources",
                "Implement fine-grained authorization",
                "Support complex command syntax",
                "Enable detailed audit trails"
            ],
            "implementation": [
                "Used together with cmd attribute",
                "Contains command parameters",
                "TACACS+ server evaluates full command",
                "Supports pattern matching",
                "Part of command authorization flow"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "TACACS+ service type. Specifies the service context for authorization.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=shell for CLI access",
            "use_cases": [
                "Specify authorization context",
                "Support different access methods",
                "Enable service-specific policies",
                "Maintain protocol compliance",
                "Control service authorization"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Usually set to 'shell' for CLI",
                "Required for proper authorization",
                "Different services may have different attributes",
                "Configure in TACACS+ server policy"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Member-Of-Role",
            "number": "N/A",
            "description": "Assigns user to a predefined role on HP switches. Alternative role assignment method.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Member-Of-Role=network-admin for network administrator role",
            "use_cases": [
                "Implement role-based access control",
                "Use predefined switch roles",
                "Simplify authorization management",
                "Support complex permissions",
                "Enable consistent access control"
            ],
            "implementation": [
                "Role must exist on switch",
                "Configure custom roles as needed",
                "Alternative to privilege levels",
                "Includes all role permissions",
                "Case-sensitive role names"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Management-Protocol",
            "number": "N/A",
            "description": "Controls which management protocols the user can access via TACACS+.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Management-Protocol=SSH for SSH-only access",
            "use_cases": [
                "Restrict management protocols",
                "Enforce secure access methods",
                "Disable insecure protocols",
                "Support security policies",
                "Control management access"
            ],
            "implementation": [
                "Specify allowed protocols",
                "Options: SSH, Telnet, HTTP, HTTPS",
                "Can combine multiple protocols",
                "Overrides global settings",
                "Applied per user session"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "HP-Command-Exception",
            "number": "N/A",
            "description": "Specifies command exceptions to standard privilege level restrictions.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "HP-Command-Exception='permit:show running-config' to allow config viewing",
            "use_cases": [
                "Create privilege level exceptions",
                "Allow specific commands outside normal rights",
                "Enable custom access profiles",
                "Support special requirements",
                "Fine-tune access control"
            ],
            "implementation": [
                "Format: 'permit:command' or 'deny:command'",
                "Multiple exceptions supported",
                "Applied after privilege level",
                "Supports regular expressions",
                "Creates custom authorization profiles"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "timeout",
            "number": "N/A",
            "description": "Sets the session timeout for administrative sessions. Controls idle timeout behavior.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "timeout=30 for 30-minute session timeout",
            "use_cases": [
                "Control session duration",
                "Implement security policies",
                "Manage resource usage",
                "Support compliance requirements",
                "Prevent unauthorized access"
            ],
            "implementation": [
                "Value in minutes",
                "Applied to admin sessions",
                "Overrides global timeout",
                "0 may mean no timeout",
                "Monitor active sessions"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "TACACS+ protocol type. Used with service attribute for proper authorization.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol=ip for standard access",
            "use_cases": [
                "Specify protocol context",
                "Support service differentiation",
                "Enable proper authorization",
                "Maintain protocol compliance",
                "Support various access types"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Often set to 'ip' or 'shell'",
                "Used with service attribute",
                "Configure in server policy",
                "Part of authorization flow"
            ],
            "reference": "https://support.hpe.com/hpesc/public/docDisplay?docId=a00114271en_us"
        }
    ]
}
EOF
            ;;
        "extreme:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "extreme",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Extreme-Security-Profile",
            "number": "1",
            "description": "Assigns a security profile to the authenticated user. Security profiles define comprehensive access control policies including dynamic ACLs, QoS settings, and VLAN assignments.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Security-Profile = 'Corporate-Users' for standard employee access",
            "use_cases": [
                "Implement comprehensive role-based access control",
                "Apply dynamic security policies",
                "Control network access based on user identity",
                "Support BYOD and guest access scenarios",
                "Enable policy-driven networking"
            ],
            "implementation": [
                "Configure security profiles on Extreme switch/controller",
                "Define ACLs, VLANs, QoS within the profile",
                "Configure RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Profile names are case-sensitive",
                "Monitor with 'show netlogin session' and 'show policy profile'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/netlogin.shtml"
        },
        {
            "name": "Extreme-CLI-Authorization",
            "number": "2",
            "description": "Controls CLI command authorization levels for administrative access to Extreme devices.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-CLI-Authorization = 'ReadWrite' for full administrative access",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based CLI access",
                "Delegate specific management functions",
                "Support compliance requirements",
                "Enable multi-level administration"
            ],
            "implementation": [
                "Standard values: None, ReadOnly, ReadWrite",
                "Configure RADIUS server to return this VSA",
                "Enable RADIUS authentication for management access",
                "Works with local command authorization",
                "Monitor with 'show session' and audit logs"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/aaa.shtml"
        },
        {
            "name": "Extreme-Policy-Profile",
            "number": "3",
            "description": "Assigns a policy profile to the user session. Policy profiles can include ACLs, QoS settings, mirroring, and other traffic handling rules.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Extreme-Policy-Profile = 'Guest-Access' for limited guest network access",
            "use_cases": [
                "Apply complex traffic policies",
                "Implement application-aware networking",
                "Control multicast access",
                "Enable user-based QoS",
                "Support IoT device policies"
            ],
            "implementation": [
                "Create policy profiles on switch",
                "Define rules and actions within profile",
                "Profile must exist before authentication",
                "Can be changed dynamically via CoA",
                "Verify with 'show policy detail'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/policy.shtml"
        },
        {
            "name": "Extreme-User-VLAN",
            "number": "4",
            "description": "Dynamically assigns VLAN to authenticated users. Overrides port VLAN configuration.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-User-VLAN = 'Employee-VLAN' or Extreme-User-VLAN = '100'",
            "use_cases": [
                "Dynamic VLAN assignment based on user identity",
                "Network segmentation for security",
                "Support for multi-tenant environments",
                "IoT device isolation",
                "Guest network segregation"
            ],
            "implementation": [
                "Can use VLAN name or tag ID",
                "VLAN must exist on switch",
                "Overrides static port configuration",
                "Works with both tagged and untagged VLANs",
                "Monitor with 'show vlan portinfo'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/vlans/dynamic_vlan.shtml"
        },
        {
            "name": "Extreme-Data-Rate-Limit",
            "number": "5",
            "description": "Sets bandwidth limits for user traffic. Can specify different rates for ingress and egress.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Data-Rate-Limit = '10000/5000' for 10Mbps down/5Mbps up",
            "use_cases": [
                "Implement per-user bandwidth control",
                "Support tiered service offerings",
                "Prevent bandwidth hogging",
                "Enable fair usage policies",
                "Control costs in shared environments"
            ],
            "implementation": [
                "Format: 'ingress-rate/egress-rate' in Kbps",
                "Can specify single value for both directions",
                "Applied to user's port/session",
                "Can be updated via CoA",
                "Monitor with 'show port utilization'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/qos/rate_limiting.shtml"
        },
        {
            "name": "Extreme-Guest-VLAN",
            "number": "6",
            "description": "Specifies the VLAN to use for unauthenticated or guest users. Fallback when authentication fails.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Guest-VLAN = 'Guest' for guest network assignment",
            "use_cases": [
                "Provide limited access for failed authentication",
                "Support guest onboarding processes",
                "Enable captive portal redirection",
                "Maintain network connectivity during issues",
                "Support BYOD registration workflows"
            ],
            "implementation": [
                "Applied when authentication fails or times out",
                "VLAN must exist on switch",
                "Often used with captive portal",
                "Can trigger remediation processes",
                "Configure with 'configure netlogin guest-vlan'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/guest_vlan.shtml"
        },
        {
            "name": "Extreme-Dynamic-ACL",
            "number": "7",
            "description": "Downloads and applies ACL rules dynamically. No pre-configuration required.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Dynamic-ACL = 'permit tcp any any eq 80;deny ip any any'",
            "use_cases": [
                "Apply user-specific access controls",
                "Implement zero-trust networking",
                "Support dynamic security policies",
                "Enable centralized ACL management",
                "Respond to security events quickly"
            ],
            "implementation": [
                "Multiple ACL entries separated by semicolon",
                "Uses Extreme ACL syntax",
                "Applied to user's port/session",
                "No pre-configuration needed",
                "Can be updated via CoA"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/dynamic_acl.shtml"
        },
        {
            "name": "Extreme-CoS",
            "number": "8",
            "description": "Sets Class of Service (CoS) value for user traffic. Used for QoS prioritization.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Extreme-CoS = '5' for voice traffic priority",
            "use_cases": [
                "Prioritize voice and video traffic",
                "Support unified communications",
                "Implement service-level agreements",
                "Enable application-based QoS",
                "Support real-time applications"
            ],
            "implementation": [
                "Values 0-7 (802.1p priority)",
                "Applied to user's traffic",
                "Maps to internal QoS queues",
                "Can be combined with DSCP marking",
                "Monitor with QoS statistics"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/qos/cos_marking.shtml"
        },
        {
            "name": "Extreme-DSCP",
            "number": "9",
            "description": "Sets DSCP value for IP packets. Enables end-to-end QoS marking.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": true
            },
            "network": "both",
            "example": "Extreme-DSCP = '46' for Expedited Forwarding (EF)",
            "use_cases": [
                "Mark traffic for QoS treatment",
                "Support DiffServ architectures",
                "Enable WAN QoS policies",
                "Prioritize business applications",
                "Implement voice/video QoS"
            ],
            "implementation": [
                "DSCP values 0-63",
                "Applied to IP packet headers",
                "Preserved across Layer 3 boundaries",
                "Maps to PHB (Per-Hop Behavior)",
                "Works with both IPv4 and IPv6"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/qos/dscp_marking.shtml"
        },
        {
            "name": "Extreme-Session-Timeout",
            "number": "10",
            "description": "Sets the maximum session duration in seconds. Forces re-authentication after timeout.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Session-Timeout = '3600' for 1-hour sessions",
            "use_cases": [
                "Enforce security policies",
                "Implement time-based access",
                "Support guest time limits",
                "Manage resource allocation",
                "Force periodic re-authentication"
            ],
            "implementation": [
                "Value in seconds",
                "Countdown starts at authentication",
                "Session terminated at expiry",
                "Requires re-authentication",
                "Can trigger CoA events"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/session_timeout.shtml"
        },
        {
            "name": "Extreme-Idle-Timeout",
            "number": "11",
            "description": "Sets idle timeout in seconds. Disconnects inactive sessions to free resources.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Idle-Timeout = '600' for 10-minute idle timeout",
            "use_cases": [
                "Free unused resources",
                "Improve security posture",
                "Manage concurrent sessions",
                "Support fair usage policies",
                "Optimize network utilization"
            ],
            "implementation": [
                "Value in seconds",
                "Monitors traffic activity",
                "Resets on any traffic",
                "Session ends after idle period",
                "Works with session timeout"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/idle_timeout.shtml"
        },
        {
            "name": "Extreme-Multiple-User-Auth",
            "number": "12",
            "description": "Controls multiple user authentication on the same port. Determines authentication behavior.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wired",
            "example": "Extreme-Multiple-User-Auth = 'enable' for multi-user support",
            "use_cases": [
                "Support multiple devices per port",
                "Enable hub/phone daisy-chaining",
                "Support conference room ports",
                "Allow printer sharing",
                "Enable flexible deployments"
            ],
            "implementation": [
                "Values: enable, disable",
                "Controls port authentication mode",
                "Affects MAC limit behavior",
                "Works with 802.1X and MAC auth",
                "Configure per-port settings"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/multi_user_auth.shtml"
        },
        {
            "name": "Extreme-Redirect-URL",
            "number": "13",
            "description": "Specifies URL for HTTP redirection. Used for captive portals and remediation.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Redirect-URL = 'https://portal.company.com/guest'",
            "use_cases": [
                "Implement captive portal authentication",
                "Display terms and conditions",
                "Enable guest self-registration",
                "Support device remediation",
                "Provide payment gateways"
            ],
            "implementation": [
                "Full URL including protocol",
                "Applied to HTTP/HTTPS traffic",
                "Works with DNS interception",
                "Can be cleared via CoA",
                "Requires web redirect feature"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/captive_portal.shtml"
        },
        {
            "name": "Extreme-CLI-Access-Level",
            "number": "14",
            "description": "Alternative attribute for CLI access levels. Provides granular command authorization.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-CLI-Access-Level = 'admin' for full access",
            "use_cases": [
                "Define custom access levels",
                "Support complex authorization",
                "Enable fine-grained control",
                "Create operator roles",
                "Implement least privilege"
            ],
            "implementation": [
                "Maps to internal access levels",
                "Can be numeric or named",
                "Affects available commands",
                "Works with command authorization",
                "Monitor with session info"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/cli_authorization.shtml"
        },
        {
            "name": "Extreme-Shell-Command",
            "number": "15",
            "description": "Controls individual CLI command authorization. Enables per-command access control.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Shell-Command = 'show' for read-only commands",
            "use_cases": [
                "Authorize specific commands",
                "Create custom command sets",
                "Restrict dangerous operations",
                "Support compliance needs",
                "Enable auditing"
            ],
            "implementation": [
                "Command or command pattern",
                "Can use wildcards",
                "Multiple instances allowed",
                "Evaluated in order",
                "Works with access levels"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/command_authorization.shtml"
        }
    ]
}
EOF
            ;;
        "extreme:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "extreme",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for administrative access to Extreme devices.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for administrator access; priv-lvl=1 for read-only",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based CLI access",
                "Support standard TACACS+ deployments",
                "Enable graduated access control",
                "Maintain cross-vendor compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server to return privilege level",
                "Enable TACACS+ on Extreme device",
                "Level 15: Full administrative access",
                "Level 1: Read-only access",
                "Custom levels can be configured"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "Extreme-CLI-Authorization",
            "number": "N/A",
            "description": "Controls CLI command authorization levels. Extreme-specific attribute for management access.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-CLI-Authorization=ReadWrite for full access",
            "use_cases": [
                "Define specific access rights",
                "Override privilege levels",
                "Create custom authorization profiles",
                "Support Extreme-specific features",
                "Enable granular access control"
            ],
            "implementation": [
                "Values: None, ReadOnly, ReadWrite",
                "Configure in TACACS+ server",
                "Takes precedence over priv-lvl",
                "Works with command authorization",
                "Monitor with 'show session detail'"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Standard TACACS+ command authorization attribute. Controls which commands can be executed.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands; cmd=configure for configuration mode",
            "use_cases": [
                "Implement command-level authorization",
                "Create command allow/deny lists",
                "Support audit requirements",
                "Enable granular command control",
                "Restrict dangerous operations"
            ],
            "implementation": [
                "Enable command authorization on switch",
                "Configure command lists on TACACS+ server",
                "Use with cmd-arg for complete commands",
                "Supports permit/deny actions",
                "Regular expressions supported"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/command_authorization.shtml"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Command arguments for TACACS+ authorization. Used with cmd attribute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=configure cmd-arg='vlan Corporate' for specific VLAN config",
            "use_cases": [
                "Authorize complete commands",
                "Control access to specific resources",
                "Enable parameter-level authorization",
                "Support complex command syntax",
                "Create detailed audit trails"
            ],
            "implementation": [
                "Contains command parameters",
                "Used together with cmd attribute",
                "TACACS+ server evaluates full command",
                "Pattern matching available",
                "Part of authorization flow"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/command_authorization.shtml"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "TACACS+ service type. Specifies the service context for authorization.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=shell for CLI access",
            "use_cases": [
                "Specify authorization context",
                "Support multiple services",
                "Enable service-specific policies",
                "Maintain protocol compliance",
                "Control service authorization"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Usually set to 'shell' for CLI",
                "Required for authorization",
                "Configure in server policy",
                "Part of TACACS+ protocol"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "TACACS+ protocol type. Used with service attribute.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol=ip for standard access",
            "use_cases": [
                "Specify protocol context",
                "Support service types",
                "Enable proper authorization",
                "Maintain compatibility",
                "Complete authorization flow"
            ],
            "implementation": [
                "Standard TACACS+ attribute",
                "Often set to 'ip'",
                "Used with service attribute",
                "Configure in server policy",
                "Part of authorization request"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "Extreme-Shell-Command",
            "number": "N/A",
            "description": "Extreme-specific command authorization. Alternative to standard cmd attribute.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Shell-Command='show *' for all show commands",
            "use_cases": [
                "Extreme-specific command control",
                "Override standard authorization",
                "Create vendor-specific policies",
                "Support advanced features",
                "Enable custom implementations"
            ],
            "implementation": [
                "Extreme VSA format",
                "Can use wildcards",
                "Multiple instances allowed",
                "Works with standard TACACS+",
                "Check compatibility"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "timeout",
            "number": "N/A",
            "description": "Session timeout value for administrative sessions.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "timeout=30 for 30-minute timeout",
            "use_cases": [
                "Control session duration",
                "Implement security policies",
                "Manage resource usage",
                "Support compliance requirements",
                "Force re-authentication"
            ],
            "implementation": [
                "Value in minutes",
                "Applied to CLI sessions",
                "Overrides global timeout",
                "0 may disable timeout",
                "Monitor active sessions"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        },
        {
            "name": "idletime",
            "number": "N/A",
            "description": "Idle timeout for administrative sessions. Disconnects inactive sessions.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "idletime=10 for 10-minute idle timeout",
            "use_cases": [
                "Free unused sessions",
                "Improve security posture",
                "Manage concurrent connections",
                "Support resource policies",
                "Enforce activity requirements"
            ],
            "implementation": [
                "Value in minutes",
                "Monitors session activity",
                "Disconnects after idle period",
                "Works with session timeout",
                "Can be disabled with 0"
            ],
            "reference": "https://documentation.extremenetworks.com/exos/EXOS_User_Guide/EXOS_UserGuide_32.1/security/tacacs.shtml"
        }
    ]
}
EOF
            ;;
        "dell:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "dell",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Dell-User-Role",
            "number": "1",
            "description": "Assigns a user role for Dell Networking switches. Controls administrative access and permissions.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-User-Role = 'sysadmin' for full administrative access",
            "use_cases": [
                "Implement role-based access control",
                "Control administrative privileges",
                "Support compliance requirements",
                "Enable delegated administration",
                "Create custom management roles"
            ],
            "implementation": [
                "Configure RADIUS server with Dell VSAs (Vendor ID: 674)",
                "Standard roles: sysadmin, operator, netadmin",
                "Custom roles can be defined on switch",
                "Enable RADIUS authentication on Dell switch",
                "Monitor with 'show authentication methods'"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "Dell-Privilege-Level",
            "number": "2",
            "description": "Sets privilege level for CLI access on Dell switches.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-Privilege-Level = 15 for full access",
            "use_cases": [
                "Control command execution rights",
                "Implement graduated access levels",
                "Support standard privilege model",
                "Enable read-only access",
                "Create operator-level access"
            ],
            "implementation": [
                "Values 0-15 (15 is highest)",
                "Level 15: Full administrative access",
                "Level 1: User EXEC mode",
                "Level 0: Limited access",
                "Maps to CLI command availability"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "Dell-Admin-Role",
            "number": "3",
            "description": "Alternative attribute for admin role assignment on Dell EMC switches.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-Admin-Role = 'admin' for administrator access",
            "use_cases": [
                "Define administrative access levels",
                "Support Dell EMC switches",
                "Enable role-based management",
                "Control configuration access",
                "Implement security policies"
            ],
            "implementation": [
                "Used on newer Dell EMC models",
                "Configure custom roles on switch",
                "Role must exist before authentication",
                "Case-sensitive role names",
                "Verify with 'show users roles'"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "Dell-VLAN-ID",
            "number": "4",
            "description": "Assigns VLAN ID to authenticated users on Dell switches.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-VLAN-ID = 100 for VLAN 100 assignment",
            "use_cases": [
                "Dynamic VLAN assignment",
                "Network segmentation",
                "Support 802.1X authentication",
                "Implement security zones",
                "Enable user-based VLANs"
            ],
            "implementation": [
                "VLAN must exist on switch",
                "Used with 802.1X or MAB",
                "Numeric VLAN ID (1-4094)",
                "Can be updated via CoA",
                "Monitor with 'show dot1x interface'"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "Dell-AVPair",
            "number": "5",
            "description": "Multi-purpose attribute-value pair for various Dell-specific functions.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-AVPair = 'shell:roles=network-admin' for role assignment",
            "use_cases": [
                "Assign roles and privileges",
                "Apply ACLs dynamically",
                "Configure QoS parameters",
                "Set bandwidth limits",
                "Multiple configurations in one attribute"
            ],
            "implementation": [
                "Format: type:parameter=value",
                "Multiple AVPairs can be sent",
                "Common types: shell, acl, qos",
                "Flexible configuration method",
                "Check Dell documentation for formats"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        }
    ]
}
EOF
            ;;
        "dell:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "dell",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for Dell switches. Controls administrative access level.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for full administrative access",
            "use_cases": [
                "Control CLI access levels",
                "Implement role-based access",
                "Support standard TACACS+",
                "Enable graduated privileges",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable TACACS+ on Dell switch",
                "Level 15: Full admin access",
                "Level 1: User EXEC mode",
                "Levels 2-14 customizable"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "Dell-Role",
            "number": "N/A",
            "description": "Dell-specific role assignment for TACACS+ authentication.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Dell-Role=sysadmin for system administrator",
            "use_cases": [
                "Assign predefined roles",
                "Override privilege levels",
                "Support Dell-specific features",
                "Enable custom roles",
                "Simplify management"
            ],
            "implementation": [
                "Configure in TACACS+ server",
                "Role must exist on switch",
                "Standard roles: sysadmin, netadmin, operator",
                "Case-sensitive names",
                "Takes precedence over priv-lvl"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization attribute for Dell switches.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands; cmd=configure for config mode",
            "use_cases": [
                "Control command execution",
                "Implement command authorization",
                "Create custom command sets",
                "Support audit requirements",
                "Enable granular control"
            ],
            "implementation": [
                "Enable command authorization",
                "Configure on TACACS+ server",
                "Use with cmd-arg for full commands",
                "Supports permit/deny",
                "Regular expressions allowed"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Command arguments for TACACS+ authorization on Dell switches.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=interface cmd-arg='vlan 10' for specific interface commands",
            "use_cases": [
                "Authorize complete commands",
                "Control resource access",
                "Support complex syntax",
                "Enable detailed authorization",
                "Create audit trails"
            ],
            "implementation": [
                "Used with cmd attribute",
                "Contains command parameters",
                "Evaluated by TACACS+ server",
                "Pattern matching supported",
                "Part of authorization flow"
            ],
            "reference": "https://www.dell.com/support/manuals/en-us/networking-s4100-series/s4100_cl_guide/"
        }
    ]
}
EOF
            ;;
        "checkpoint:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "checkpoint",
    "protocol": "radius",
    "attributes": [
        {
            "name": "CP-Group",
            "number": "1",
            "description": "Assigns a user group for Check Point firewall access. Used for Identity Awareness and access control.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Group = 'VPN_Users' for VPN access; CP-Group = 'IT_Admins' for administrative access",
            "use_cases": [
                "Implement Identity Awareness policies",
                "Control VPN access based on groups",
                "Apply firewall rules by user group",
                "Support role-based access control",
                "Enable centralized group management"
            ],
            "implementation": [
                "Configure RADIUS server with Check Point VSAs (Vendor ID: 2620)",
                "Group must exist in Check Point user database or AD",
                "Used with Identity Awareness blade",
                "Can assign multiple groups with semicolon separator",
                "Monitor with 'pdp monitor user all'"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_IdentityAwareness_AdminGuide/Topics-IDAG/RADIUS-Attributes.htm"
        },
        {
            "name": "CP-Gaia-User-Role",
            "number": "2",
            "description": "Assigns administrative role for Gaia management access. Controls what administrators can configure.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Gaia-User-Role = 'adminRole' for full administrative access",
            "use_cases": [
                "Control Gaia OS administrative access",
                "Implement role-based administration",
                "Delegate specific management tasks",
                "Support compliance requirements",
                "Enable multi-level administration"
            ],
            "implementation": [
                "Configure roles in Gaia (Users and Roles)",
                "Standard roles: adminRole, monitorRole",
                "Custom roles can be created",
                "Case-sensitive role names",
                "Verify with 'show users' in Gaia"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_Gaia_AdminGuide/Topics-GAG/Working-with-Users.htm"
        },
        {
            "name": "CP-Gaia-SuperUser-Access",
            "number": "3",
            "description": "Grants expert mode (bash shell) access in Gaia OS. Required for advanced troubleshooting.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Gaia-SuperUser-Access = 1 to enable expert mode",
            "use_cases": [
                "Enable expert mode access",
                "Support advanced troubleshooting",
                "Allow system-level configuration",
                "Provide shell access when needed",
                "Control privileged access"
            ],
            "implementation": [
                "Set to 1 to enable, 0 to disable",
                "User also needs appropriate role",
                "Requires 'expert' password configuration",
                "Audit expert mode usage",
                "Monitor with system logs"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_Gaia_AdminGuide/Topics-GAG/Expert-Mode.htm"
        },
        {
            "name": "CP-Role",
            "number": "4",
            "description": "Generic role assignment for Check Point products. Used across different Check Point components.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Role = 'Security_Admin' for security management access",
            "use_cases": [
                "Assign roles in SmartConsole",
                "Control management server access",
                "Support multi-domain environments",
                "Enable role-based permissions",
                "Centralize role management"
            ],
            "implementation": [
                "Role must be defined in SmartConsole",
                "Works with Permission Profiles",
                "Used in Multi-Domain Security Management",
                "Case-sensitive role names",
                "Monitor with SmartLog"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_SecurityManagement_AdminGuide/Topics-SECMG/Administrators.htm"
        },
        {
            "name": "CP-VPN-Group",
            "number": "5",
            "description": "Assigns VPN group membership. Controls VPN access and applies group-specific policies.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-VPN-Group = 'Office_VPN' for office worker VPN access",
            "use_cases": [
                "Control VPN access by group",
                "Apply group-specific VPN policies",
                "Implement split tunneling rules",
                "Set group-based encryption domains",
                "Support Mobile Access blade"
            ],
            "implementation": [
                "Define VPN groups in SmartConsole",
                "Configure group properties",
                "Set office mode IP pools per group",
                "Apply security policies by group",
                "Monitor with 'cpview' utility"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_RemoteAccess_AdminGuide/Topics-RA/Remote-Access-VPN-Configurations.htm"
        },
        {
            "name": "CP-Max-Aggregated-Session-Time",
            "number": "6",
            "description": "Sets maximum total session time for VPN connections. Enforces time-based access policies.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Max-Aggregated-Session-Time = 28800 for 8-hour maximum",
            "use_cases": [
                "Enforce daily VPN time limits",
                "Support contractor access policies",
                "Implement compliance requirements",
                "Control resource usage",
                "Manage concurrent sessions"
            ],
            "implementation": [
                "Value in seconds",
                "Tracks cumulative session time",
                "Enforced across multiple sessions",
                "Resets based on policy",
                "Monitor with VPN logs"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_RemoteAccess_AdminGuide/Topics-RA/Configuring-Session-Timeout.htm"
        },
        {
            "name": "CP-IP-Pool",
            "number": "7",
            "description": "Specifies IP address pool for VPN client addressing. Enables group-based IP allocation.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-IP-Pool = 'VPN_Pool_Sales' for sales department VPN IPs",
            "use_cases": [
                "Segregate VPN clients by department",
                "Apply IP-based firewall rules",
                "Support overlapping IP scenarios",
                "Enable detailed tracking",
                "Manage IP address allocation"
            ],
            "implementation": [
                "Define IP pools in gateway object",
                "Configure Office Mode settings",
                "Pool must exist on security gateway",
                "Supports multiple pools per gateway",
                "Monitor with 'vpn tu'"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_RemoteAccess_AdminGuide/Topics-RA/Office-Mode.htm"
        },
        {
            "name": "CP-Expiration-Date",
            "number": "8",
            "description": "Sets account expiration date for temporary access. Used for contractors and temporary users.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Expiration-Date = '2024-12-31' for year-end expiration",
            "use_cases": [
                "Manage temporary user access",
                "Support contractor accounts",
                "Implement access reviews",
                "Ensure timely access removal",
                "Support compliance requirements"
            ],
            "implementation": [
                "Format: YYYY-MM-DD",
                "Checked during authentication",
                "Access denied after expiration",
                "Can be updated via RADIUS",
                "Audit with user reports"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_IdentityAwareness_AdminGuide/Topics-IDAG/User-Management.htm"
        },
        {
            "name": "CP-VDOM",
            "number": "9",
            "description": "Assigns user to a Virtual System (VS) or Domain. Used in VSX and Multi-Domain environments.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-VDOM = 'VS2' for Virtual System 2 assignment",
            "use_cases": [
                "Support multi-tenant environments",
                "Assign users to virtual systems",
                "Implement domain segregation",
                "Control access in VSX deployments",
                "Enable virtual firewall management"
            ],
            "implementation": [
                "VS/Domain must exist on device",
                "Used with VSX gateways",
                "Supports Provider-1/Multi-Domain",
                "Case-sensitive names",
                "Monitor with 'vsx stat'"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_VSX_AdminGuide/Topics-VSXG/Introduction-to-VSX.htm"
        },
        {
            "name": "CP-User-Encrypt-Alg",
            "number": "10",
            "description": "Specifies encryption algorithms allowed for user VPN connections.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-User-Encrypt-Alg = 'AES-256,AES-128' for strong encryption",
            "use_cases": [
                "Enforce encryption standards",
                "Support compliance requirements",
                "Control VPN security levels",
                "Enable algorithm negotiation",
                "Implement security policies"
            ],
            "implementation": [
                "Comma-separated algorithm list",
                "Common values: AES-256, AES-128, 3DES",
                "Must match gateway capabilities",
                "Applied during IKE negotiation",
                "Monitor with VPN debug"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_VPN_AdminGuide/Topics-VPNG/Configuring-Encryption.htm"
        },
        {
            "name": "CP-User-Auth-Method",
            "number": "11",
            "description": "Specifies authentication methods allowed for the user. Controls authentication requirements.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-User-Auth-Method = 'Certificate,Password' for multi-factor auth",
            "use_cases": [
                "Enforce multi-factor authentication",
                "Control authentication methods",
                "Support different security levels",
                "Enable certificate authentication",
                "Implement authentication policies"
            ],
            "implementation": [
                "Comma-separated method list",
                "Options: Password, Certificate, SecurID, etc.",
                "Must be configured on gateway",
                "Applied during authentication",
                "Audit with authentication logs"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_IdentityAwareness_AdminGuide/Topics-IDAG/Authentication-Methods.htm"
        },
        {
            "name": "CP-User-Access-Hours",
            "number": "12",
            "description": "Defines time-based access restrictions for users. Controls when users can connect.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-User-Access-Hours = 'Mon-Fri:08:00-18:00' for business hours",
            "use_cases": [
                "Implement business hours access",
                "Control contractor access times",
                "Support shift-based policies",
                "Enforce security policies",
                "Manage resource availability"
            ],
            "implementation": [
                "Day and time range format",
                "Multiple ranges supported",
                "Gateway local time used",
                "Checked at connection time",
                "Sessions terminated outside hours"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_IdentityAwareness_AdminGuide/Topics-IDAG/Time-Based-Access.htm"
        }
    ]
}
EOF
            ;;
        "checkpoint:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "checkpoint",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "CP-Role",
            "number": "N/A",
            "description": "Assigns administrative role for Check Point management access via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Role=Super User for full administrative access",
            "use_cases": [
                "Control SmartConsole access",
                "Implement role-based administration",
                "Support Multi-Domain management",
                "Enable delegated administration",
                "Maintain audit compliance"
            ],
            "implementation": [
                "Configure TACACS+ server for Check Point",
                "Role must exist in SmartConsole",
                "Standard roles: Super User, Read Only, etc.",
                "Enable TACACS+ in SmartConsole",
                "Monitor with SmartLog"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_SecurityManagement_AdminGuide/Topics-SECMG/TACACS-Authentication.htm"
        },
        {
            "name": "CP-Gaia-User-Role",
            "number": "N/A",
            "description": "Assigns Gaia OS administrative role via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Gaia-User-Role=adminRole for full Gaia access",
            "use_cases": [
                "Control Gaia OS access",
                "Implement OS-level permissions",
                "Support compliance requirements",
                "Enable expert mode access",
                "Manage system configuration"
            ],
            "implementation": [
                "Configure Gaia for TACACS+",
                "Standard roles: adminRole, monitorRole",
                "Custom roles supported",
                "Enable in Gaia Portal",
                "Verify with 'show users'"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_Gaia_AdminGuide/Topics-GAG/TACACS-Authentication.htm"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level. Maps to Check Point roles.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for superuser access",
            "use_cases": [
                "Support standard TACACS+",
                "Map to Check Point roles",
                "Enable cross-vendor management",
                "Maintain compatibility",
                "Simplify configuration"
            ],
            "implementation": [
                "Level 15: Super User",
                "Level 1: Read Only",
                "Configure privilege mapping",
                "Standard TACACS+ attribute",
                "Works with Gaia and SmartConsole"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_SecurityManagement_AdminGuide/Topics-SECMG/TACACS-Authentication.htm"
        },
        {
            "name": "CP-Gaia-SuperUser-Access",
            "number": "N/A",
            "description": "Enables expert mode access in Gaia OS via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "CP-Gaia-SuperUser-Access=1 to enable expert mode",
            "use_cases": [
                "Enable expert shell access",
                "Support advanced troubleshooting",
                "Allow system modifications",
                "Control privileged access",
                "Audit expert mode usage"
            ],
            "implementation": [
                "Set to 1 to enable",
                "Requires appropriate role",
                "User must know expert password",
                "Audit all expert access",
                "Monitor with system logs"
            ],
            "reference": "https://sc1.checkpoint.com/documents/R81/WebAdminGuides/EN/CP_R81_Gaia_AdminGuide/Topics-GAG/TACACS-Authentication.htm"
        }
    ]
}
EOF
            ;;
        "f5:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "f5",
    "protocol": "radius",
    "attributes": [
        {
            "name": "F5-LTM-User-Role",
            "number": "1",
            "description": "Assigns administrative role for F5 BIG-IP Local Traffic Manager access. Controls management permissions.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Role = Administrator for full administrative access",
            "use_cases": [
                "Control BIG-IP administrative access",
                "Implement role-based management",
                "Support compliance requirements",
                "Enable delegated administration",
                "Create custom management roles"
            ],
            "implementation": [
                "Configure RADIUS server with F5 VSAs (Vendor ID: 3375)",
                "Standard roles: Administrator, Resource Administrator, User Manager, etc.",
                "Custom roles can be created on BIG-IP",
                "Enable external authentication on BIG-IP",
                "Monitor with audit logs"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Info-1",
            "number": "2",
            "description": "Primary user information field. Often used for role assignment or custom attributes.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Info-1 = 'administrator' for role information",
            "use_cases": [
                "Pass custom user attributes",
                "Support legacy configurations",
                "Enable flexible authentication",
                "Map external groups to roles",
                "Support complex deployments"
            ],
            "implementation": [
                "Generic string attribute",
                "Interpretation depends on configuration",
                "Can be used for role mapping",
                "Processed by authentication module",
                "Check F5 configuration for usage"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Info-2",
            "number": "3",
            "description": "Secondary user information field. Used for additional attributes or metadata.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Info-2 = 'partition=Common' for partition assignment",
            "use_cases": [
                "Specify administrative partition",
                "Pass additional metadata",
                "Support multi-tenant setups",
                "Enable custom configurations",
                "Extend authentication data"
            ],
            "implementation": [
                "Secondary attribute field",
                "Used with User-Info-1",
                "Application-specific interpretation",
                "Configure based on requirements",
                "Document usage patterns"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Partition",
            "number": "4",
            "description": "Specifies the administrative partition for the user. Controls resource visibility and access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Partition = 'Finance' for finance partition access",
            "use_cases": [
                "Implement multi-tenant administration",
                "Control resource visibility",
                "Support departmental isolation",
                "Enable delegated management",
                "Maintain configuration separation"
            ],
            "implementation": [
                "Partition must exist on BIG-IP",
                "Controls object visibility",
                "Works with role assignments",
                "Default is 'Common' partition",
                "Case-sensitive partition names"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Shell",
            "number": "5",
            "description": "Specifies the shell type for terminal access. Controls CLI environment.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Shell = 'tmsh' for TMSH shell; 'bash' for bash shell",
            "use_cases": [
                "Control terminal environment",
                "Restrict shell access",
                "Enable advanced troubleshooting",
                "Support different workflows",
                "Implement security policies"
            ],
            "implementation": [
                "Common values: tmsh, bash, disable",
                "tmsh: Traffic Management Shell",
                "bash: Advanced shell (if permitted)",
                "disable: No shell access",
                "Requires appropriate role"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Context",
            "number": "6",
            "description": "Sets the user context for advanced configurations. Used in specific deployment scenarios.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Context = 'system' for system-level access",
            "use_cases": [
                "Set operational context",
                "Support complex deployments",
                "Enable specific features",
                "Control access scope",
                "Implement custom behaviors"
            ],
            "implementation": [
                "Context-specific attribute",
                "Usage varies by deployment",
                "Check F5 documentation",
                "May affect command scope",
                "Test thoroughly"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Console",
            "number": "7",
            "description": "Controls console access permissions. Determines if user can access serial console.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Console = 1 to enable console access",
            "use_cases": [
                "Control physical console access",
                "Enable emergency access",
                "Support data center operations",
                "Implement security policies",
                "Manage out-of-band access"
            ],
            "implementation": [
                "1 = Enable console access",
                "0 = Disable console access",
                "Applies to serial console",
                "Requires appropriate role",
                "Audit console usage"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Remote-Role",
            "number": "10",
            "description": "Maps remote groups to local roles. Used for group-based role assignment.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Remote-Role = 'AD-Group=Admins:Administrator' for AD group mapping",
            "use_cases": [
                "Map AD/LDAP groups to roles",
                "Support group-based access",
                "Simplify user management",
                "Enable SSO configurations",
                "Maintain central identity"
            ],
            "implementation": [
                "Format: 'group=role' pairs",
                "Multiple mappings supported",
                "Semicolon separated",
                "Case-sensitive matching",
                "Process in order"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        }
    ]
}
EOF
            ;;
        "f5:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "f5",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "F5-LTM-User-Role",
            "number": "N/A",
            "description": "Assigns administrative role for F5 BIG-IP access via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Role=Administrator for full access",
            "use_cases": [
                "Control BIG-IP administrative access",
                "Implement role-based management",
                "Support compliance requirements",
                "Enable delegated administration",
                "Create custom management roles"
            ],
            "implementation": [
                "Configure TACACS+ server for F5",
                "Standard roles: Administrator, Manager, User, etc.",
                "Enable TACACS+ authentication on BIG-IP",
                "Configure in System > Users > Authentication",
                "Monitor with audit logs"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level. Maps to F5 roles.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for administrator access",
            "use_cases": [
                "Support standard TACACS+",
                "Map to F5 roles",
                "Enable compatibility",
                "Simplify configuration",
                "Support legacy systems"
            ],
            "implementation": [
                "Level 15: Administrator",
                "Level 1: Guest",
                "Configure role mapping",
                "Standard TACACS+ attribute",
                "Works with tmsh and GUI"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Shell",
            "number": "N/A",
            "description": "Specifies shell access type via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Shell=tmsh for TMSH access",
            "use_cases": [
                "Control shell environment",
                "Restrict advanced access",
                "Enable troubleshooting",
                "Support automation",
                "Implement security policies"
            ],
            "implementation": [
                "Values: tmsh, bash, disable",
                "Configure in TACACS+ server",
                "Requires appropriate role",
                "tmsh is default for admins",
                "Audit shell access"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        },
        {
            "name": "F5-LTM-User-Partition",
            "number": "N/A",
            "description": "Assigns administrative partition via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "F5-LTM-User-Partition=Common for common partition",
            "use_cases": [
                "Support multi-tenant management",
                "Control resource visibility",
                "Enable partition isolation",
                "Implement RBAC",
                "Maintain separation"
            ],
            "implementation": [
                "Partition must exist",
                "Default is Common",
                "Case-sensitive names",
                "Works with roles",
                "Configure per user"
            ],
            "reference": "https://techdocs.f5.com/en-us/bigip-15-1-0/big-ip-systems-user-account-administration/external-authentication.html"
        }
    ]
}
EOF
            ;;
        "meraki:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "meraki",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Meraki:organizationID",
            "number": "1",
            "description": "Specifies the Meraki organization ID for dashboard access. Required for multi-org deployments.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:organizationID = '123456' for specific organization access",
            "use_cases": [
                "Control dashboard access by organization",
                "Support MSP multi-tenant environments",
                "Enable organization-specific policies",
                "Restrict administrative scope",
                "Support centralized authentication"
            ],
            "implementation": [
                "Configure RADIUS server to return this VSA",
                "Organization ID found in Dashboard",
                "Required for multi-org setups",
                "Case-sensitive ID",
                "Configure in Dashboard > Organization > Configure > Settings"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Meraki:organizationName",
            "number": "2",
            "description": "Alternative to organizationID using organization name for dashboard access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:organizationName = 'Corporate HQ' for named organization access",
            "use_cases": [
                "Use friendly names instead of IDs",
                "Simplify RADIUS configuration",
                "Support human-readable assignments",
                "Enable easier troubleshooting",
                "Alternative to numeric IDs"
            ],
            "implementation": [
                "Organization name must match exactly",
                "Case-sensitive matching",
                "Spaces and special characters allowed",
                "Alternative to organizationID",
                "Configure in RADIUS server"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Meraki:role",
            "number": "3",
            "description": "Assigns dashboard administrative role. Controls permissions within Meraki dashboard.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:role = 'full' for organization administrator",
            "use_cases": [
                "Control dashboard permissions",
                "Implement role-based access",
                "Support compliance requirements",
                "Enable delegated administration",
                "Create custom access levels"
            ],
            "implementation": [
                "Standard roles: full, read-only, none",
                "Custom roles supported",
                "Role must exist in organization",
                "Case-sensitive role names",
                "Configure in Organization > Administrators"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Meraki:tag",
            "number": "4",
            "description": "Assigns network tags for scoped administrative access. Limits visibility to tagged networks.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:tag = 'branch-offices' for branch network access only",
            "use_cases": [
                "Limit access to specific networks",
                "Implement location-based administration",
                "Support distributed management",
                "Enable network segmentation",
                "Create administrative boundaries"
            ],
            "implementation": [
                "Tags must exist in organization",
                "Multiple tags supported (comma-separated)",
                "Applied to networks in dashboard",
                "Case-sensitive tag names",
                "Configure in Network-wide > General"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Meraki:network",
            "number": "5",
            "description": "Specifies individual networks for administrative access. More granular than tags.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:network = 'L_123456789012345678' for specific network",
            "use_cases": [
                "Grant access to specific networks",
                "Support fine-grained permissions",
                "Enable per-network administration",
                "Implement least privilege access",
                "Support complex org structures"
            ],
            "implementation": [
                "Use network ID from dashboard",
                "Multiple networks comma-separated",
                "Network must exist in organization",
                "More specific than tags",
                "Find ID in Network-wide > General"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Meraki:accessType",
            "number": "6",
            "description": "Defines the type of access granted (dashboard, API, etc.). Controls access methods.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki:accessType = 'api-only' for API access without dashboard",
            "use_cases": [
                "Control access methods",
                "Enable API-only accounts",
                "Support automation tools",
                "Implement security policies",
                "Separate human and machine access"
            ],
            "implementation": [
                "Values: dashboard, api-only, both",
                "Default is dashboard access",
                "API-only prevents dashboard login",
                "Useful for service accounts",
                "Configure based on use case"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Filter-Id",
            "number": "11",
            "description": "Standard RADIUS attribute used by Meraki for group policy assignment.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Filter-Id = 'GroupPolicy:Employees' for employee policy",
            "use_cases": [
                "Apply group policies to wireless clients",
                "Control bandwidth and firewall rules",
                "Implement device-type policies",
                "Support BYOD initiatives",
                "Enable dynamic policy assignment"
            ],
            "implementation": [
                "Format: 'GroupPolicy:PolicyName'",
                "Policy must exist in dashboard",
                "Applied to wireless clients",
                "Configure in Wireless > Group policies",
                "Monitor in Clients page"
            ],
            "reference": "https://documentation.meraki.com/MR/Encryption_and_Authentication/Configuring_RADIUS_Authentication"
        },
        {
            "name": "Tunnel-Type",
            "number": "64",
            "description": "Standard RADIUS attribute for VLAN assignment. Set to VLAN (13) for Meraki.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Type = VLAN for dynamic VLAN assignment",
            "use_cases": [
                "Dynamic VLAN assignment",
                "Network segmentation",
                "Support 802.1X authentication",
                "Implement security zones",
                "Enable user-based networking"
            ],
            "implementation": [
                "Must be set to value 13 (VLAN)",
                "Used with Tunnel-Private-Group-ID",
                "Part of standard VLAN assignment",
                "Required for dynamic VLANs",
                "Works with wired and wireless"
            ],
            "reference": "https://documentation.meraki.com/MS/Access_Control/Dynamic_VLAN_Assignment"
        },
        {
            "name": "Tunnel-Medium-Type",
            "number": "65",
            "description": "Standard RADIUS attribute for VLAN assignment. Set to 802 (6) for Meraki.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Medium-Type = 802 for Ethernet VLANs",
            "use_cases": [
                "Complete VLAN assignment",
                "Support standard RADIUS",
                "Enable dynamic networking",
                "Work with 802.1X",
                "Maintain compatibility"
            ],
            "implementation": [
                "Must be set to value 6 (802)",
                "Used with Tunnel-Type",
                "Part of VLAN assignment trio",
                "Standard RADIUS requirement",
                "Supported on all Meraki devices"
            ],
            "reference": "https://documentation.meraki.com/MS/Access_Control/Dynamic_VLAN_Assignment"
        },
        {
            "name": "Tunnel-Private-Group-ID",
            "number": "81",
            "description": "Specifies the VLAN ID for dynamic assignment. The actual VLAN identifier.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Private-Group-ID = 100 for VLAN 100",
            "use_cases": [
                "Assign specific VLANs",
                "Support dynamic networking",
                "Enable user segmentation",
                "Implement security policies",
                "Support IoT networks"
            ],
            "implementation": [
                "Can be VLAN ID or name",
                "VLAN must exist on switch",
                "Works with Tunnel-Type/Medium-Type",
                "Supports tagged VLANs",
                "Monitor in switch port details"
            ],
            "reference": "https://documentation.meraki.com/MS/Access_Control/Dynamic_VLAN_Assignment"
        },
        {
            "name": "Airespace-Interface-Name",
            "number": "5",
            "description": "Used by Meraki for SSID steering in specific scenarios. Legacy Cisco attribute.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Airespace-Interface-Name = 'corporate' for SSID selection",
            "use_cases": [
                "SSID steering for clients",
                "Support legacy integrations",
                "Enable SSID-based policies",
                "Maintain compatibility",
                "Advanced wireless configurations"
            ],
            "implementation": [
                "Limited use in Meraki",
                "Mainly for compatibility",
                "Prefer native Meraki attributes",
                "Check specific use cases",
                "Test thoroughly"
            ],
            "reference": "https://documentation.meraki.com/MR/Encryption_and_Authentication/RADIUS_Vendor-specific_Attributes"
        }
    ]
}
EOF
            ;;
        "meraki:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "meraki",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "Meraki-Role",
            "number": "N/A",
            "description": "Assigns dashboard administrative role via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki-Role=full for organization administrator",
            "use_cases": [
                "Control dashboard access levels",
                "Implement role-based administration",
                "Support compliance requirements",
                "Enable delegated management",
                "Create custom access profiles"
            ],
            "implementation": [
                "Configure TACACS+ server for Meraki",
                "Standard roles: full, read-only, none",
                "Custom roles supported",
                "Enable TACACS+ in Dashboard",
                "Monitor with event logs"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_TACACS+_Authentication"
        },
        {
            "name": "Meraki-OrganizationID",
            "number": "N/A",
            "description": "Specifies organization ID for multi-org deployments via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki-OrganizationID=123456 for specific org",
            "use_cases": [
                "Multi-organization access control",
                "MSP customer isolation",
                "Enterprise division management",
                "Support multi-tenant setups",
                "Enable org-specific policies"
            ],
            "implementation": [
                "Organization ID from dashboard",
                "Required for multi-org",
                "Numeric ID format",
                "Case-sensitive",
                "Configure per user"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_TACACS+_Authentication"
        },
        {
            "name": "Meraki-Networks",
            "number": "N/A",
            "description": "Limits access to specific networks via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki-Networks=L_123456789012345678 for network access",
            "use_cases": [
                "Network-level access control",
                "Support distributed administration",
                "Implement least privilege",
                "Enable location-based management",
                "Create administrative boundaries"
            ],
            "implementation": [
                "Network IDs from dashboard",
                "Comma-separated for multiple",
                "Exact ID matching",
                "Overrides organization access",
                "Test access thoroughly"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_TACACS+_Authentication"
        },
        {
            "name": "Meraki-Tags",
            "number": "N/A",
            "description": "Assigns network tags for scoped access via TACACS+.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Meraki-Tags=branch-offices for tagged networks",
            "use_cases": [
                "Tag-based access control",
                "Simplify network grouping",
                "Support dynamic permissions",
                "Enable flexible management",
                "Scale administrative access"
            ],
            "implementation": [
                "Tags must exist in org",
                "Comma-separated list",
                "Case-sensitive matching",
                "Applied to networks",
                "Easier than network IDs"
            ],
            "reference": "https://documentation.meraki.com/General_Administration/Managing_Dashboard_Access/Configuring_TACACS+_Authentication"
        }
    ]
}
EOF
            ;;
        "sonicwall:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "sonicwall",
    "protocol": "radius",
    "attributes": [
        {
            "name": "SonicWall-User-Group",
            "number": "1",
            "description": "Assigns a user group for SonicWall firewall policies. Used for group-based access control.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-User-Group = 'VPN Users' for VPN access control",
            "use_cases": [
                "Implement group-based firewall rules",
                "Control VPN access by group",
                "Apply content filtering policies",
                "Support user-based networking",
                "Enable policy-based routing"
            ],
            "implementation": [
                "Configure RADIUS server with SonicWall VSAs (Vendor ID: 8741)",
                "Group must exist on SonicWall device",
                "Used with firewall access rules",
                "Case-sensitive group names",
                "Monitor with user status page"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-radius-authentication/170503796508490/"
        },
        {
            "name": "SonicWall-User-Privileges",
            "number": "2",
            "description": "Sets administrative privileges for SonicWall management access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-User-Privileges = 'ADMIN' for full administrative access",
            "use_cases": [
                "Control management access levels",
                "Implement role-based administration",
                "Support compliance requirements",
                "Enable delegated management",
                "Create custom admin roles"
            ],
            "implementation": [
                "Standard values: ADMIN, LIMITED_ADMIN, GUEST",
                "Configure on RADIUS server",
                "Enable admin authentication",
                "Maps to SonicOS admin levels",
                "Audit admin access"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-radius-authentication/170503796508490/"
        },
        {
            "name": "SonicWall-AVPair",
            "number": "3",
            "description": "Multi-purpose attribute-value pair for various SonicWall-specific functions.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-AVPair = 'ip:addr-pool=VPN_POOL' for VPN address assignment",
            "use_cases": [
                "Configure multiple parameters",
                "Assign VPN IP pools",
                "Set firewall zones",
                "Apply bandwidth limits",
                "Enable specific features"
            ],
            "implementation": [
                "Format: type:parameter=value",
                "Multiple AVPairs supported",
                "Common types: ip, zone, bw",
                "Used for advanced configs",
                "Check SonicOS version compatibility"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-radius-authentication/170503796508490/"
        },
        {
            "name": "SonicWall-VPN-Group",
            "number": "4",
            "description": "Assigns VPN group membership for SonicWall VPN policies.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-VPN-Group = 'Remote_Workers' for remote access VPN",
            "use_cases": [
                "Control VPN access policies",
                "Apply group-specific VPN settings",
                "Implement split tunneling rules",
                "Set bandwidth limits per group",
                "Enable group-based routing"
            ],
            "implementation": [
                "VPN group must exist in SonicOS",
                "Configure in VPN settings",
                "Applied during VPN authentication",
                "Controls VPN policy application",
                "Monitor with VPN statistics"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-ssl-vpn-radius-authentication/170503432254072/"
        },
        {
            "name": "SonicWall-Zone",
            "number": "5",
            "description": "Assigns user to a specific security zone for policy application.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-Zone = 'DMZ' for DMZ zone assignment",
            "use_cases": [
                "Control firewall zone placement",
                "Apply zone-based policies",
                "Implement security segmentation",
                "Support dynamic zone assignment",
                "Enable zone-specific rules"
            ],
            "implementation": [
                "Zone must exist on firewall",
                "Applied to user sessions",
                "Affects policy evaluation",
                "Common zones: LAN, WAN, DMZ, VPN",
                "Monitor in connection monitor"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/understanding-zones-interfaces-and-security/170503988583283/"
        }
    ]
}
EOF
            ;;
        "sonicwall:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "sonicwall",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for SonicWall administrative access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for full administrative access",
            "use_cases": [
                "Control SonicOS admin access",
                "Implement standard TACACS+",
                "Support privilege levels",
                "Enable graduated access",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable TACACS+ on SonicWall",
                "Level 15: Full admin",
                "Level 1: Read-only",
                "Maps to SonicOS privileges"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-tacacs-authentication/170504210153667/"
        },
        {
            "name": "SonicWall-Admin-Role",
            "number": "N/A",
            "description": "Assigns specific administrative role for SonicOS management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "SonicWall-Admin-Role=ADMIN for full access",
            "use_cases": [
                "Define specific admin rights",
                "Override privilege levels",
                "Support custom roles",
                "Enable role-based access",
                "Implement least privilege"
            ],
            "implementation": [
                "Roles: ADMIN, LIMITED_ADMIN, GUEST",
                "Configure in TACACS+ server",
                "SonicWall-specific attribute",
                "Takes precedence over priv-lvl",
                "Audit role assignments"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-tacacs-authentication/170504210153667/"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization for SonicWall CLI access.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands",
            "use_cases": [
                "Control CLI command access",
                "Implement command authorization",
                "Create custom command sets",
                "Support audit requirements",
                "Enable granular control"
            ],
            "implementation": [
                "Enable command authorization",
                "Configure on TACACS+ server",
                "Limited CLI in SonicOS",
                "Mainly for show commands",
                "Used with cmd-arg"
            ],
            "reference": "https://www.sonicwall.com/support/knowledge-base/how-to-configure-tacacs-authentication/170504210153667/"
        }
    ]
}
EOF
            ;;
        "ruckus:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "ruckus",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Ruckus-User-Role",
            "number": "1",
            "description": "Assigns a user role for Ruckus wireless controllers and APs. Controls user access and permissions.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-User-Role = 'Employee' for corporate user access",
            "use_cases": [
                "Implement role-based access control",
                "Apply different policies per user type",
                "Control wireless network access",
                "Support BYOD initiatives",
                "Enable guest access management"
            ],
            "implementation": [
                "Configure RADIUS server with Ruckus VSAs (Vendor ID: 25053)",
                "Define roles on controller/vSZ",
                "Roles include ACLs, QoS, VLAN settings",
                "Case-sensitive role names",
                "Monitor with 'show wlan all' and client details"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-WLAN-Profile-ID",
            "number": "2",
            "description": "Specifies the WLAN profile to apply to the user session. Overrides default SSID settings.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Ruckus-WLAN-Profile-ID = '5' for specific WLAN profile",
            "use_cases": [
                "Apply custom WLAN settings per user",
                "Override default SSID configuration",
                "Support dynamic service selection",
                "Enable per-user encryption settings",
                "Implement service differentiation"
            ],
            "implementation": [
                "Profile ID must exist on controller",
                "Numeric ID (typically 1-32)",
                "Applied during authentication",
                "Can change user experience dynamically",
                "Verify with 'show wlan all'"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-Dynamic-VLAN-ID",
            "number": "3",
            "description": "Assigns dynamic VLAN to authenticated users. Alternative to standard Tunnel attributes.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-Dynamic-VLAN-ID = '100' for VLAN 100 assignment",
            "use_cases": [
                "Dynamic VLAN assignment",
                "Network segmentation",
                "Support 802.1X authentication",
                "User/device isolation",
                "Implement security policies"
            ],
            "implementation": [
                "VLAN must exist on switch",
                "Alternative to standard VLAN attributes",
                "Numeric VLAN ID",
                "Applied per user session",
                "Monitor with client details"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-Data-Rate-Limit-Down",
            "number": "4",
            "description": "Sets the downstream bandwidth limit for the user in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-Data-Rate-Limit-Down = '10240' for 10 Mbps downstream",
            "use_cases": [
                "Control per-user bandwidth",
                "Implement fair usage policies",
                "Support tiered services",
                "Manage network congestion",
                "Enable bandwidth-based plans"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Applied to user traffic",
                "0 means unlimited",
                "Can be updated via CoA",
                "Monitor with traffic statistics"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-Data-Rate-Limit-Up",
            "number": "5",
            "description": "Sets the upstream bandwidth limit for the user in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-Data-Rate-Limit-Up = '5120' for 5 Mbps upstream",
            "use_cases": [
                "Control upload bandwidth",
                "Implement asymmetric limits",
                "Prevent upload congestion",
                "Support video conferencing limits",
                "Enable tiered upload speeds"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Independent from downstream",
                "Applied per user session",
                "Dynamic updates supported",
                "Works with QoS policies"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-TCP-MSS-Threshold",
            "number": "6",
            "description": "Sets the TCP Maximum Segment Size threshold for the user's traffic.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-TCP-MSS-Threshold = '1350' for MTU optimization",
            "use_cases": [
                "Optimize TCP performance",
                "Prevent fragmentation",
                "Support VPN traffic",
                "Handle MTU issues",
                "Improve application performance"
            ],
            "implementation": [
                "Value in bytes",
                "Adjusts TCP MSS dynamically",
                "Helps with tunnel overhead",
                "Applied to TCP sessions",
                "Monitor packet captures"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-Smart-Mesh-Enable",
            "number": "7",
            "description": "Enables or disables mesh networking features for the client.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Ruckus-Smart-Mesh-Enable = '1' to enable mesh participation",
            "use_cases": [
                "Control mesh network participation",
                "Enable dynamic mesh formation",
                "Support extended coverage",
                "Implement mesh policies",
                "Control network topology"
            ],
            "implementation": [
                "1 = Enable, 0 = Disable",
                "Applied to capable clients",
                "Affects mesh behavior",
                "Used in SmartMesh deployments",
                "Check device capabilities"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        },
        {
            "name": "Ruckus-UE-Inactivity-Timeout",
            "number": "8",
            "description": "Sets the client inactivity timeout in seconds.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Ruckus-UE-Inactivity-Timeout = '600' for 10-minute timeout",
            "use_cases": [
                "Free up resources from idle clients",
                "Improve security posture",
                "Manage client sessions",
                "Optimize wireless capacity",
                "Support guest time limits"
            ],
            "implementation": [
                "Value in seconds",
                "Monitors client activity",
                "Disconnects after timeout",
                "Requires re-authentication",
                "Per-user setting"
            ],
            "reference": "https://docs.commscope.com/bundle/vscg-61-aaa-configuration-reference-guide/page/GUID-B9C8C474-FC5C-4EA5-9B5C-C4C3D7612F62.html"
        }
    ]
}
EOF
            ;;
        "ruckus:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "ruckus",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for Ruckus administrative access.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for super-user access",
            "use_cases": [
                "Control administrative access levels",
                "Implement role-based management",
                "Support standard TACACS+",
                "Enable graduated privileges",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable TACACS+ on Ruckus device",
                "Level 15: Super-user (full access)",
                "Level 0: Read-only access",
                "Monitor with 'show aaa'"
            ],
            "reference": "https://docs.commscope.com/bundle/fastiron-08095-securityguide/page/GUID-F6434C9B-D9CF-4997-A3B5-A5C3C45D5997.html"
        },
        {
            "name": "Ruckus-User-Role",
            "number": "N/A",
            "description": "Assigns specific administrative role for Ruckus management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Ruckus-User-Role=super-user for full administrative rights",
            "use_cases": [
                "Define specific access rights",
                "Override privilege levels",
                "Support Ruckus-specific roles",
                "Enable custom administration",
                "Implement least privilege"
            ],
            "implementation": [
                "Roles: super-user, port-config, read-only",
                "Configure in TACACS+ server",
                "Takes precedence over priv-lvl",
                "Case-sensitive role names",
                "Verify with 'show users'"
            ],
            "reference": "https://docs.commscope.com/bundle/fastiron-08095-securityguide/page/GUID-F6434C9B-D9CF-4997-A3B5-A5C3C45D5997.html"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization for Ruckus CLI access.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show for show commands; cmd=configure for config mode",
            "use_cases": [
                "Control command execution",
                "Implement command authorization",
                "Create custom command sets",
                "Support audit requirements",
                "Enable granular control"
            ],
            "implementation": [
                "Enable command authorization",
                "Configure on TACACS+ server",
                "Use with cmd-arg for full commands",
                "Supports permit/deny",
                "Regular expressions allowed"
            ],
            "reference": "https://docs.commscope.com/bundle/fastiron-08095-securityguide/page/GUID-F6434C9B-D9CF-4997-A3B5-A5C3C45D5997.html"
        }
    ]
}
EOF
            ;;
        "huawei:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "huawei",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Huawei-User-Priority",
            "number": "8",
            "description": "Sets the user priority level for QoS and service differentiation.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-User-Priority = '6' for high priority users",
            "use_cases": [
                "Implement QoS per user",
                "Prioritize VIP customers",
                "Support service tiers",
                "Control resource allocation",
                "Enable differentiated services"
            ],
            "implementation": [
                "Values 0-7 (higher is better)",
                "Configure RADIUS server with Huawei VSAs (Vendor ID: 2011)",
                "Applied to user sessions",
                "Affects queue scheduling",
                "Monitor with 'display qos'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-User-Privilege",
            "number": "29",
            "description": "Sets administrative privilege level for Huawei device management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-User-Privilege = '15' for level-15 administrator",
            "use_cases": [
                "Control administrative access",
                "Implement privilege levels",
                "Support role-based management",
                "Enable graduated access rights",
                "Maintain security compliance"
            ],
            "implementation": [
                "Values 0-15 (15 highest)",
                "Enable RADIUS authentication",
                "Maps to command levels",
                "Configure on AAA server",
                "Verify with 'display local-user'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-Input-Peak-Rate",
            "number": "2",
            "description": "Sets the peak ingress bandwidth for the user in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-Input-Peak-Rate = '102400' for 100 Mbps peak ingress",
            "use_cases": [
                "Control inbound bandwidth",
                "Implement burst rates",
                "Support tiered services",
                "Manage network congestion",
                "Enable fair usage policies"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Applied to user traffic",
                "Works with average rate",
                "Can be updated via CoA",
                "Monitor with traffic statistics"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-Output-Peak-Rate",
            "number": "3",
            "description": "Sets the peak egress bandwidth for the user in Kbps.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-Output-Peak-Rate = '51200' for 50 Mbps peak egress",
            "use_cases": [
                "Control outbound bandwidth",
                "Implement upload limits",
                "Support asymmetric rates",
                "Manage server traffic",
                "Enable QoS policies"
            ],
            "implementation": [
                "Value in Kilobits per second",
                "Independent from ingress",
                "Applied per user session",
                "Dynamic updates supported",
                "Works with QoS profiles"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-VPN-Instance",
            "number": "41",
            "description": "Specifies the VPN instance for the user session. Used for VRF assignment.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-VPN-Instance = 'Customer_A' for VRF assignment",
            "use_cases": [
                "Support multi-tenant networks",
                "Implement VRF isolation",
                "Enable L3VPN services",
                "Control routing domains",
                "Support overlapping IPs"
            ],
            "implementation": [
                "VPN instance must exist",
                "Applied to user session",
                "Affects routing table",
                "Case-sensitive name",
                "Monitor with 'display ip vpn-instance'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-User-Group",
            "number": "82",
            "description": "Assigns user to a specific group for policy application.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-User-Group = 'VPN_Users' for VPN group assignment",
            "use_cases": [
                "Implement group-based policies",
                "Control access rights",
                "Apply firewall rules",
                "Support user categorization",
                "Enable policy-based routing"
            ],
            "implementation": [
                "Group must exist on device",
                "Configure in user management",
                "Applied during authentication",
                "Used in policy matching",
                "Monitor with 'display aaa'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-Acct-IPv6-Input-Octets",
            "number": "105",
            "description": "Reports IPv6 input octets for accounting purposes.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-Acct-IPv6-Input-Octets = '1024000' for 1MB received",
            "use_cases": [
                "IPv6 traffic accounting",
                "Support billing systems",
                "Monitor IPv6 usage",
                "Generate usage reports",
                "Enable quota management"
            ],
            "implementation": [
                "Automatically sent in accounting",
                "64-bit counter value",
                "Cumulative byte count",
                "IPv6-specific accounting",
                "Parse in billing systems"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-Domain-Name",
            "number": "138",
            "description": "Specifies the authentication domain for the user.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-Domain-Name = 'corporate' for corporate domain",
            "use_cases": [
                "Support multiple auth domains",
                "Implement domain-based policies",
                "Enable multi-tenant authentication",
                "Control access by domain",
                "Support ISP services"
            ],
            "implementation": [
                "Domain must exist on device",
                "Applied during authentication",
                "Affects policy application",
                "Case-sensitive domain name",
                "Configure in AAA settings"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        }
    ]
}
EOF
            ;;
        "huawei:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "huawei",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for Huawei device administration.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for level-15 administrator",
            "use_cases": [
                "Control administrative access",
                "Implement standard TACACS+",
                "Support privilege levels",
                "Enable graduated access",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable HWTACACS on device",
                "Level 15: Full admin",
                "Level 0: Monitor level",
                "Monitor with 'display hwtacacs'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "Huawei-Exec-Privilege",
            "number": "N/A",
            "description": "Huawei-specific privilege level for command execution.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Huawei-Exec-Privilege=15 for full access",
            "use_cases": [
                "Define Huawei-specific privileges",
                "Override standard levels",
                "Support custom roles",
                "Enable vendor features",
                "Implement granular control"
            ],
            "implementation": [
                "Huawei VSA format",
                "Takes precedence over priv-lvl",
                "Configure in TACACS+ server",
                "Maps to command levels",
                "Verify with 'display local-user'"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization for Huawei device CLI.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=display for display commands",
            "use_cases": [
                "Control command execution",
                "Implement command authorization",
                "Create custom command sets",
                "Support audit requirements",
                "Enable detailed control"
            ],
            "implementation": [
                "Enable command authorization",
                "Configure on TACACS+ server",
                "Use with cmd-arg",
                "Supports permit/deny",
                "Monitor with debug commands"
            ],
            "reference": "https://support.huawei.com/enterprise/en/doc/EDOC1100278189"
        }
    ]
}
EOF
            ;;
        "microsoftnas:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "microsoftnas",
    "protocol": "radius",
    "attributes": [
        {
            "name": "MS-CHAP-Response",
            "number": "1",
            "description": "Contains the MS-CHAP response for authentication. Used in MS-CHAP v1 authentication.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-CHAP-Response = <binary data> for CHAP authentication",
            "use_cases": [
                "Support MS-CHAP authentication",
                "Enable Windows VPN connectivity",
                "Support legacy authentication",
                "Integrate with Active Directory",
                "Enable PPTP connections"
            ],
            "implementation": [
                "Binary attribute value",
                "Generated by client",
                "Verified by RADIUS server",
                "Used with MS-CHAP-Challenge",
                "Part of MS-CHAP protocol"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-CHAP2-Response",
            "number": "25",
            "description": "Contains the MS-CHAP v2 response. More secure than v1.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-CHAP2-Response = <binary data> for CHAPv2",
            "use_cases": [
                "Support MS-CHAP v2 authentication",
                "Enable secure Windows authentication",
                "Support modern VPN protocols",
                "Integrate with NPS/IAS",
                "Enable EAP-MS-CHAPv2"
            ],
            "implementation": [
                "Binary attribute value",
                "More secure than v1",
                "Mutual authentication",
                "Used with PEAP",
                "Standard Windows auth"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-MPPE-Send-Key",
            "number": "16",
            "description": "Contains the MPPE send key for encryption. Used for securing VPN connections.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-MPPE-Send-Key = <encrypted key> for VPN encryption",
            "use_cases": [
                "Enable MPPE encryption",
                "Secure VPN connections",
                "Support Windows VPN clients",
                "Provide encryption keys",
                "Enable secure tunneling"
            ],
            "implementation": [
                "Encrypted attribute",
                "Used with PPTP/L2TP",
                "Generated by RADIUS server",
                "Applied to VPN session",
                "Works with MS-MPPE-Recv-Key"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-MPPE-Recv-Key",
            "number": "17",
            "description": "Contains the MPPE receive key for encryption. Pairs with send key.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-MPPE-Recv-Key = <encrypted key> for VPN decryption",
            "use_cases": [
                "Complete MPPE key pair",
                "Enable bidirectional encryption",
                "Support VPN protocols",
                "Secure data reception",
                "Enable full tunnel encryption"
            ],
            "implementation": [
                "Encrypted attribute",
                "Paired with Send-Key",
                "Applied to VPN session",
                "Required for MPPE",
                "Generated by server"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-MPPE-Encryption-Policy",
            "number": "7",
            "description": "Specifies the MPPE encryption policy. Controls encryption requirements.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-MPPE-Encryption-Policy = 2 for encryption required",
            "use_cases": [
                "Enforce encryption policies",
                "Control VPN security",
                "Support compliance requirements",
                "Define encryption requirements",
                "Enable flexible security"
            ],
            "implementation": [
                "0: Encryption allowed",
                "1: Encryption disabled",
                "2: Encryption required",
                "Applied to PPP session",
                "Works with MPPE keys"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-MPPE-Encryption-Types",
            "number": "8",
            "description": "Specifies allowed MPPE encryption types. Controls encryption strength.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-MPPE-Encryption-Types = 6 for 40 and 128-bit",
            "use_cases": [
                "Control encryption strength",
                "Support various clients",
                "Enable backward compatibility",
                "Implement security policies",
                "Support international versions"
            ],
            "implementation": [
                "Bit flags for types",
                "1: 40-bit encryption",
                "2: 128-bit encryption",
                "4: 56-bit encryption",
                "Combine values for multiple"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-Primary-DNS-Server",
            "number": "28",
            "description": "Specifies the primary DNS server for the client.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-Primary-DNS-Server = 192.168.1.1 for internal DNS",
            "use_cases": [
                "Configure VPN client DNS",
                "Support split DNS",
                "Enable internal name resolution",
                "Control DNS settings",
                "Support corporate networks"
            ],
            "implementation": [
                "IPv4 address format",
                "Applied to client config",
                "Used with VPN connections",
                "Overrides client settings",
                "Works with secondary DNS"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-Secondary-DNS-Server",
            "number": "29",
            "description": "Specifies the secondary DNS server for redundancy.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-Secondary-DNS-Server = 192.168.1.2 for backup DNS",
            "use_cases": [
                "Provide DNS redundancy",
                "Enable failover",
                "Support high availability",
                "Complete DNS configuration",
                "Ensure name resolution"
            ],
            "implementation": [
                "IPv4 address format",
                "Backup DNS server",
                "Used with primary DNS",
                "Applied to client",
                "Failover support"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-Quarantine-State",
            "number": "36",
            "description": "Indicates the quarantine state of the client. Used with NAP.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": true,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-Quarantine-State = 1 for quarantined client",
            "use_cases": [
                "Implement NAP policies",
                "Quarantine non-compliant devices",
                "Support health checks",
                "Enable remediation",
                "Enforce security compliance"
            ],
            "implementation": [
                "0: Full access",
                "1: Quarantine",
                "2: Probation",
                "Used with NAP",
                "Requires SHV configuration"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        },
        {
            "name": "MS-Network-Access-Server-Type",
            "number": "47",
            "description": "Specifies the type of network access server.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "MS-Network-Access-Server-Type = 2 for VPN server",
            "use_cases": [
                "Identify NAS type",
                "Apply type-specific policies",
                "Support different access methods",
                "Enable proper authentication",
                "Control access by NAS type"
            ],
            "implementation": [
                "Numeric values",
                "0: Unspecified",
                "1: Terminal Server",
                "2: Remote Access Server",
                "5: VPN Server"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        }
    ]
}
EOF
            ;;
        "microsoftnas:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "microsoftnas",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level. Limited support in Microsoft NAS.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for administrative access",
            "use_cases": [
                "Basic privilege control",
                "Support standard TACACS+",
                "Enable compatibility",
                "Simple authorization",
                "Legacy support"
            ],
            "implementation": [
                "Limited TACACS+ support",
                "Mainly for compatibility",
                "Prefer RADIUS for full features",
                "Basic implementation only",
                "Check specific Windows version"
            ],
            "reference": "https://docs.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-radius-attributes"
        }
    ]
}
EOF
            ;;
        "zyxel:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "zyxel",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Zyxel-Privilege-AVPair",
            "number": "1",
            "description": "Sets administrative privilege level for Zyxel device management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Zyxel-Privilege-AVPair = 'shell:priv-lvl=14' for admin access",
            "use_cases": [
                "Control administrative access",
                "Implement privilege levels",
                "Support role-based management",
                "Enable graduated access rights",
                "Maintain security compliance"
            ],
            "implementation": [
                "Configure RADIUS server with Zyxel VSAs (Vendor ID: 890)",
                "Format: shell:priv-lvl=X",
                "Levels 0-14 (14 highest)",
                "Enable RADIUS authentication",
                "Monitor with 'show users'"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001285313"
        },
        {
            "name": "Zyxel-Callback-Phone-Num",
            "number": "2",
            "description": "Specifies callback phone number for dial-in connections.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Zyxel-Callback-Phone-Num = '+1234567890' for callback",
            "use_cases": [
                "Enable callback authentication",
                "Support dial-in users",
                "Reduce toll charges",
                "Improve security",
                "Legacy modem support"
            ],
            "implementation": [
                "Phone number format",
                "Used with dial-in services",
                "Legacy feature",
                "Requires modem support",
                "Less common in modern networks"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001285313"
        },
        {
            "name": "Zyxel-Callback-Option",
            "number": "3",
            "description": "Controls callback behavior for dial-in connections.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Zyxel-Callback-Option = 1 for mandatory callback",
            "use_cases": [
                "Configure callback behavior",
                "Support different callback modes",
                "Enable security options",
                "Control connection flow",
                "Legacy compatibility"
            ],
            "implementation": [
                "Numeric values for options",
                "Works with callback number",
                "Dial-in specific feature",
                "Legacy implementation",
                "Check device support"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001285313"
        },
        {
            "name": "Zyxel-ACS-URL",
            "number": "4",
            "description": "Specifies Auto Configuration Server URL for device management.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": true,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Zyxel-ACS-URL = 'https://acs.company.com/tr069' for TR-069",
            "use_cases": [
                "Enable remote management",
                "Support TR-069/CWMP",
                "Configure auto-provisioning",
                "Centralize device management",
                "Enable firmware updates"
            ],
            "implementation": [
                "Full URL format",
                "Used with TR-069 clients",
                "Applied during authentication",
                "Enables remote config",
                "Monitor with ACS logs"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001285313"
        }
    ]
}
EOF
            ;;
        "zyxel:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "zyxel",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for Zyxel device administration.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=14 for administrative access",
            "use_cases": [
                "Control administrative access",
                "Implement standard TACACS+",
                "Support privilege levels",
                "Enable graduated access",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable TACACS+ on Zyxel",
                "Level 14: Admin access",
                "Level 0: Read-only",
                "Monitor with 'show aaa'"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001287813"
        },
        {
            "name": "Zyxel-Privilege",
            "number": "N/A",
            "description": "Zyxel-specific privilege attribute for enhanced control.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Zyxel-Privilege=admin for full access",
            "use_cases": [
                "Define specific privileges",
                "Override standard levels",
                "Support custom roles",
                "Enable vendor features",
                "Implement fine control"
            ],
            "implementation": [
                "Zyxel VSA format",
                "Configure in TACACS+ server",
                "Takes precedence over priv-lvl",
                "Check device documentation",
                "Test thoroughly"
            ],
            "reference": "https://support.zyxel.eu/hc/en-us/articles/360001287813"
        }
    ]
}
EOF
            ;;
        "watchguard:radius")
            cat > "$output_file" << 'EOF'
{
    "vendor": "watchguard",
    "protocol": "radius",
    "attributes": [
        {
            "name": "WatchGuard-User-Group",
            "number": "3",
            "description": "Assigns user to a WatchGuard firewall group for policy application.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "WatchGuard-User-Group = 'VPN-Users' for VPN access",
            "use_cases": [
                "Implement group-based policies",
                "Control VPN access",
                "Apply firewall rules by group",
                "Support user authentication",
                "Enable policy-based security"
            ],
            "implementation": [
                "Configure RADIUS server with WatchGuard VSAs (Vendor ID: 3097)",
                "Group must exist in Firebox",
                "Used in firewall policies",
                "Case-sensitive group names",
                "Monitor with Policy Manager"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/authentication_radius_about_c.html"
        },
        {
            "name": "WatchGuard-User-Privilege",
            "number": "4",
            "description": "Sets administrative privilege level for WatchGuard management.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "WatchGuard-User-Privilege = 'Admin' for full access",
            "use_cases": [
                "Control management access",
                "Implement admin roles",
                "Support compliance",
                "Enable delegated admin",
                "Create custom privileges"
            ],
            "implementation": [
                "Standard values: Admin, Read-Only",
                "Configure on RADIUS server",
                "Enable admin authentication",
                "Maps to Firebox privileges",
                "Audit admin access"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/authentication_radius_about_c.html"
        },
        {
            "name": "WatchGuard-Authgroup-Name",
            "number": "1",
            "description": "Specifies the authentication group for the user session.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "WatchGuard-Authgroup-Name = 'Remote-Access' for remote users",
            "use_cases": [
                "Define authentication groups",
                "Apply group-specific settings",
                "Support different user types",
                "Enable policy mapping",
                "Control access methods"
            ],
            "implementation": [
                "Group must exist in Firebox",
                "Applied during authentication",
                "Used for policy decisions",
                "Alternative to User-Group",
                "Configure in Policy Manager"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/authentication_radius_about_c.html"
        },
        {
            "name": "WatchGuard-User-Restrictions",
            "number": "5",
            "description": "Specifies user access restrictions and limitations.",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "WatchGuard-User-Restrictions = 'no-web-access' for web blocking",
            "use_cases": [
                "Apply access restrictions",
                "Control user capabilities",
                "Implement security policies",
                "Limit resource access",
                "Enable custom restrictions"
            ],
            "implementation": [
                "String-based restrictions",
                "Multiple values supported",
                "Applied to user session",
                "Custom restriction definitions",
                "Monitor with traffic logs"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/authentication_radius_about_c.html"
        }
    ]
}
EOF
            ;;
        "watchguard:tacacs")
            cat > "$output_file" << 'EOF'
{
    "vendor": "watchguard",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Standard TACACS+ privilege level for WatchGuard administration.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15 for admin access",
            "use_cases": [
                "Control admin access",
                "Standard TACACS+ support",
                "Enable privilege levels",
                "Graduated access rights",
                "Maintain compatibility"
            ],
            "implementation": [
                "Configure TACACS+ server",
                "Enable on WatchGuard",
                "Level 15: Admin",
                "Level 1: Read-only",
                "Monitor with logs"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/tacacs_authentication_c.html"
        },
        {
            "name": "WatchGuard-Admin-Role",
            "number": "N/A",
            "description": "WatchGuard-specific admin role assignment.",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "WatchGuard-Admin-Role=Administrator for full access",
            "use_cases": [
                "Define specific roles",
                "Override standard levels",
                "Support custom roles",
                "Enable vendor features",
                "Granular control"
            ],
            "implementation": [
                "WatchGuard VSA format",
                "Configure in TACACS+",
                "Takes precedence",
                "Role-based access",
                "Test thoroughly"
            ],
            "reference": "https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/tacacs_authentication_c.html"
        }
    ]
}
EOF
            ;;
        *)
            echo "Warning: Unknown vendor/protocol combination: $vendor:$protocol"
            ;;
    esac
}

# Generate all attribute files
echo "Generating RADIUS/TACACS attribute files..."
for vendor in juniper fortinet paloalto dell hp aruba cisco extreme brocade meraki ruckus checkpoint sonicwall f5 huawei microsoftnas zyxel watchguard; do
    for protocol in radius tacacs; do
        create_attribute_json "$vendor" "$protocol"
    done
done

# Create standard RADIUS attributes
echo "Creating standard RADIUS attributes..."
cat > "attributes/standard_radius_attributes.json" << 'EOF'
{
    "vendor": "standard",
    "protocol": "radius",
    "attributes": [
        {
            "name": "User-Name",
            "number": "1",
            "description": "The name of the user to be authenticated",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "User-Name = john.doe",
            "implementation": [
                "Required attribute for authentication",
                "Must be present in Access-Request packets",
                "Used as primary identifier for the user session",
                "Can be in various formats (username, email, phone, etc.)",
                "Case sensitivity depends on backend authentication system"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.1"
        },
        {
            "name": "NAS-IP-Address",
            "number": "4",
            "description": "The IP address of the Network Access Server",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "NAS-IP-Address = 192.168.1.1",
            "implementation": [
                "Identifies the device requesting authentication",
                "Used for NAS identification and policy decisions",
                "Either NAS-IP-Address or NAS-Identifier must be present",
                "Typically the management IP of the network device",
                "Used in RADIUS proxy scenarios"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.4"
        },
        {
            "name": "Framed-IP-Address",
            "number": "8",
            "description": "The IP address to be assigned to the user",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Framed-IP-Address = 10.0.0.100",
            "implementation": [
                "Used to assign static IP addresses to users",
                "Common in VPN and PPP scenarios",
                "Can be used to override DHCP assignment",
                "Value 255.255.255.254 indicates NAS should select address",
                "Value 255.255.255.255 indicates user should negotiate address"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.8"
        },
        {
            "name": "Filter-Id",
            "number": "11",
            "description": "The name of a filter list to apply to the user",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Filter-Id = students_acl",
            "implementation": [
                "References a pre-configured ACL on the NAS",
                "Name must match exactly with NAS configuration",
                "Can be used for both ingress and egress filtering",
                "Multiple Filter-Id attributes can be included",
                "Vendor-specific formats may apply"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.11"
        },
        {
            "name": "Session-Timeout",
            "number": "27",
            "description": "Maximum number of seconds before session termination",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Session-Timeout = 3600",
            "implementation": [
                "Value in seconds",
                "Forces re-authentication after timeout",
                "Commonly used for guest access",
                "Can be updated via CoA",
                "Value 0 may mean no timeout (vendor-specific)"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.27"
        },
        {
            "name": "Idle-Timeout",
            "number": "28",
            "description": "Maximum idle time before session termination",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Idle-Timeout = 900",
            "implementation": [
                "Value in seconds",
                "Terminates session after inactivity period",
                "Helps free up resources",
                "Can be updated via CoA",
                "Definition of 'idle' is vendor-specific"
            ],
            "reference": "https://tools.ietf.org/html/rfc2865#section-5.28"
        },
        {
            "name": "Acct-Session-Id",
            "number": "44",
            "description": "Unique identifier for the accounting session",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Acct-Session-Id = 0000B25F",
            "implementation": [
                "Unique per session on the NAS",
                "Used to match accounting records",
                "Required in all accounting packets",
                "Format is NAS-specific",
                "Used for CoA session identification"
            ],
            "reference": "https://tools.ietf.org/html/rfc2866#section-5.5"
        },
        {
            "name": "Tunnel-Type",
            "number": "64",
            "description": "The tunneling protocol to be used",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Type = VLAN",
            "implementation": [
                "Value 13 (VLAN) most common for 802.1X",
                "Must be used with Tunnel-Medium-Type",
                "Can have a tag for grouping related attributes",
                "Required for dynamic VLAN assignment",
                "Multiple tunnel attributes can be sent"
            ],
            "reference": "https://tools.ietf.org/html/rfc2868#section-3.1"
        },
        {
            "name": "Tunnel-Medium-Type",
            "number": "65",
            "description": "The transport medium to use for the tunnel",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Medium-Type = IEEE-802",
            "implementation": [
                "Value 6 (802) for Ethernet VLANs",
                "Must be used with Tunnel-Type",
                "Tag must match Tunnel-Type tag",
                "Required for dynamic VLAN assignment",
                "Defines the layer 2 transport"
            ],
            "reference": "https://tools.ietf.org/html/rfc2868#section-3.2"
        },
        {
            "name": "Tunnel-Private-Group-ID",
            "number": "81",
            "description": "The group ID for a particular tunneled session",
            "features": {
                "acl": false,
                "role": false,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Private-Group-ID = 100",
            "implementation": [
                "Contains the VLAN ID for 802.1X",
                "Can be numeric or string VLAN name",
                "String format may vary by vendor",
                "Tag must match other tunnel attributes",
                "Used for dynamic VLAN assignment"
            ],
            "reference": "https://tools.ietf.org/html/rfc2868#section-3.6"
        }
    ]
}
EOF

# Create standard TACACS attributes
echo "Creating standard TACACS attributes..."
cat > "attributes/standard_tacacs_attributes.json" << 'EOF'
{
    "vendor": "standard",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Sets the privilege level for the user session",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "priv-lvl=15",
            "implementation": [
                "Values range from 0-15",
                "Level 15 typically provides full administrative access",
                "Level 1 usually provides basic user access",
                "Levels 2-14 can be customized per device",
                "Most commonly used authorization attribute"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the service type for authorization",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "service=shell",
            "implementation": [
                "Common values: shell, ppp, slip, arap, exec",
                "Shell service most common for device administration",
                "Must match the service requested by NAS",
                "Used to determine applicable authorization attributes",
                "Different services may have different attribute sets"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "protocol",
            "number": "N/A",
            "description": "Specifies the protocol for the service",
            "features": {
                "acl": false,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "protocol=ip",
            "implementation": [
                "Common values: ip, ipx, atalk, vines, lat",
                "IP protocol most common in modern networks",
                "Required for services like PPP",
                "May be omitted for shell service",
                "Determines protocol-specific attributes"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command to be authorized for execution",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd=show",
            "implementation": [
                "Used with cmd-arg for full command",
                "Enables command authorization",
                "Can be permitted or denied",
                "Supports regular expressions on some systems",
                "Critical for granular access control"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "cmd-arg",
            "number": "N/A",
            "description": "Arguments for the command being authorized",
            "features": {
                "acl": true,
                "role": true,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "cmd-arg=running-config",
            "implementation": [
                "Used together with cmd attribute",
                "Contains command parameters and arguments",
                "Can include the full command line after the command",
                "May use wildcards or regular expressions",
                "Essential for detailed command control"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "acl",
            "number": "N/A",
            "description": "Access control list to apply to the user session",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "acl=101",
            "implementation": [
                "References pre-configured ACL on device",
                "Can be numeric or named ACL",
                "Applied to user's session or interface",
                "Common in VPN scenarios",
                "Must exist on the NAS device"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "inacl",
            "number": "N/A",
            "description": "Inbound access control list definition",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "inacl#1=permit tcp any any eq 80",
            "implementation": [
                "Downloadable ACL for inbound traffic",
                "Uses extended ACL syntax",
                "Multiple entries with #1, #2, etc.",
                "Applied dynamically to session",
                "No pre-configuration required"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "outacl",
            "number": "N/A",
            "description": "Outbound access control list definition",
            "features": {
                "acl": true,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": true,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "outacl#1=permit tcp any any eq 443",
            "implementation": [
                "Downloadable ACL for outbound traffic",
                "Uses extended ACL syntax",
                "Multiple entries with #1, #2, etc.",
                "Applied dynamically to session",
                "Complements inacl for full control"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "addr",
            "number": "N/A",
            "description": "IP address to assign to the user",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "addr=10.0.0.100",
            "implementation": [
                "Static IP address assignment",
                "Common in PPP and VPN scenarios",
                "Overrides dynamic assignment",
                "Must be from valid pool",
                "Single IPv4 address"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "timeout",
            "number": "N/A",
            "description": "Session timeout value in minutes",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "timeout=60",
            "implementation": [
                "Value in minutes",
                "Forces session termination",
                "Common for administrative sessions",
                "0 may mean no timeout",
                "Absolute session limit"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        },
        {
            "name": "idletime",
            "number": "N/A",
            "description": "Idle timeout value in minutes",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": false,
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "idletime=10",
            "implementation": [
                "Value in minutes",
                "Terminates inactive sessions",
                "Helps free resources",
                "Definition of idle varies by vendor",
                "Common for VTY sessions"
            ],
            "reference": "https://tools.ietf.org/html/draft-grant-tacacs-02"
        }
    ]
}
EOF

# Generate directory listing
echo "Generating directory listing..."
generate_directory_listing() {
    cat > "directory.json" << 'EOF'
{
    "vendors": [
        {
            "name": "Cisco",
            "id": "cisco",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Juniper",
            "id": "juniper",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Aruba",
            "id": "aruba",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Fortinet",
            "id": "fortinet",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Palo Alto",
            "id": "paloalto",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "HP/HPE",
            "id": "hp",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Extreme Networks",
            "id": "extreme",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Dell",
            "id": "dell",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Brocade",
            "id": "brocade",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Meraki",
            "id": "meraki",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Ruckus",
            "id": "ruckus",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Check Point",
            "id": "checkpoint",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "SonicWall",
            "id": "sonicwall",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "F5",
            "id": "f5",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Huawei",
            "id": "huawei",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Microsoft NAS",
            "id": "microsoftnas",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Zyxel",
            "id": "zyxel",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "WatchGuard",
            "id": "watchguard",
            "protocols": ["radius", "tacacs"]
        },
        {
            "name": "Standard",
            "id": "standard",
            "protocols": ["radius", "tacacs"]
        }
    ]
}
EOF
}

generate_directory_listing

# Update HTML files to fix directory.json reference
echo "Updating index.html..."
cat > "index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RADIUS/TACACS+ Attribute Reference</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #0066cc;
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .vendor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .vendor-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .vendor-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .vendor-card h3 {
            margin-top: 0;
            color: #0066cc;
        }
        .protocol-links {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .protocol-link {
            display: inline-block;
            padding: 8px 16px;
            background-color: #e9ecef;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        .protocol-link:hover {
            background-color: #0066cc;
            color: white;
        }
        .search-box {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .about h2 {
            color: #0066cc;
            margin-top: 0;
        }
        .about ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        .about li {
            margin-bottom: 5px;
        }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .feature-item {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
        }
        .feature-item h4 {
            margin-top: 0;
            color: #0066cc;
        }
        .footer {
            text-align: center;
            padding: 20px;
            margin-top: 30px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>RADIUS/TACACS+ Attribute Reference</h1>
        <p>Comprehensive documentation for vendor-specific and standard attributes</p>
    </div>

    <div class="section">
        <input type="text" class="search-box" placeholder="Search vendors..." id="searchBox">
    </div>

    <div class="section about">
        <h2>About This Reference</h2>
        <p>This reference provides comprehensive documentation for RADIUS and TACACS+ attributes across multiple vendors. Each attribute entry includes:</p>
        <ul>
            <li>Detailed description and use cases</li>
            <li>Implementation guidelines</li>
            <li>Configuration examples</li>
            <li>Feature flags (ACL, Role, VLAN, QoS, etc.)</li>
            <li>Reference links to vendor documentation</li>
        </ul>
    </div>

    <div class="vendor-grid" id="vendorGrid">
        <!-- Vendors will be populated here by JavaScript -->
    </div>

    <div class="section">
        <h2>Features</h2>
        <div class="feature-grid">
            <div class="feature-item">
                <h4>Vendor Coverage</h4>
                <p>Includes attributes from major networking vendors including Cisco, Juniper, Aruba, Fortinet, and many more.</p>
            </div>
            <div class="feature-item">
                <h4>Protocol Support</h4>
                <p>Complete coverage of both RADIUS and TACACS+ protocols with vendor-specific implementations.</p>
            </div>
            <div class="feature-item">
                <h4>Search & Filter</h4>
                <p>Quickly find attributes by name, description, feature, or vendor with advanced search capabilities.</p>
            </div>
            <div class="feature-item">
                <h4>Implementation Guides</h4>
                <p>Practical implementation details and configuration examples for each attribute.</p>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>RADIUS/TACACS+ Attribute Reference | Generated on <span id="genDate"></span></p>
    </div>

    <script>
        document.getElementById('genDate').textContent = new Date().toLocaleDateString();

        fetch('directory.json')
            .then(response => response.json())
            .then(data => {
                const grid = document.getElementById('vendorGrid');
                const searchBox = document.getElementById('searchBox');
                
                function renderVendors(vendors) {
                    grid.innerHTML = '';
                    vendors.forEach(vendor => {
                        const card = document.createElement('div');
                        card.className = 'vendor-card';
                        
                        const protocols = vendor.protocols.map(protocol => 
                            `<a href="viewer.html?vendor=${vendor.id}&protocol=${protocol}" class="protocol-link">${protocol.toUpperCase()}</a>`
                        ).join('');
                        
                        card.innerHTML = `
                            <h3>${vendor.name}</h3>
                            <p>View ${vendor.name} attributes:</p>
                            <div class="protocol-links">
                                ${protocols}
                            </div>
                        `;
                        
                        grid.appendChild(card);
                    });
                }
                
                renderVendors(data.vendors);
                
                searchBox.addEventListener('input', (e) => {
                    const searchTerm = e.target.value.toLowerCase();
                    const filtered = data.vendors.filter(vendor => 
                        vendor.name.toLowerCase().includes(searchTerm)
                    );
                    renderVendors(filtered);
                });
            })
            .catch(error => {
                console.error('Error loading vendor directory:', error);
                document.getElementById('vendorGrid').innerHTML = '<p>Error loading vendor directory</p>';
            });
    </script>
</body>
</html>
EOF

echo "Updating viewer.html..."
cat > "viewer.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attribute Viewer</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .header {
            border-bottom: 2px solid #0066cc;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            color: #0066cc;
        }
        .navigation {
            margin-bottom: 20px;
        }
        .nav-link {
            color: #0066cc;
            text-decoration: none;
            margin-right: 15px;
        }
        .nav-link:hover {
            text-decoration: underline;
        }
        .controls {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .search-box {
            flex: 1;
            min-width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .filter-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .attributes-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .attributes-table th,
        .attributes-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .attributes-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        .attributes-table tr:hover {
            background-color: #f5f5f5;
        }
        .attribute-name {
            font-weight: 500;
            color: #0066cc;
        }
        .attribute-features {
            display: flex;
            gap: 5px;
        }
        .feature-badge {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 500;
        }
        .feature-active {
            background-color: #28a745;
            color: white;
        }
        .expandable-row {
            cursor: pointer;
        }
        .expandable-row:hover {
            background-color: #e9ecef;
        }
        .details-row {
            display: none;
            background-color: #f8f9fa;
        }
        .details-content {
            padding: 20px;
        }
        .details-section {
            margin-bottom: 15px;
        }
        .details-section h4 {
            margin: 0 0 5px 0;
            color: #0066cc;
        }
        .details-section ul {
            margin: 5px 0;
            padding-left: 20px;
        }
        .example-code {
            background-color: #f1f3f4;
            padding: 10px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
        }
        .loading {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .error {
            text-align: center;
            padding: 50px;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 id="pageTitle">Loading...</h1>
            <p id="pageDescription">Loading attribute information...</p>
        </div>
        
        <div class="navigation">
            <a href="index.html" class="nav-link">← Back to Vendors</a>
            <a href="#" id="otherProtocol" class="nav-link">View RADIUS Attributes</a>
        </div>
        
        <div class="controls">
            <input type="text" class="search-box" placeholder="Search attributes..." id="searchBox">
            <select class="filter-select" id="featureFilter">
                <option value="">All Features</option>
                <option value="acl">ACL</option>
                <option value="role">Role</option>
                <option value="vlan">VLAN</option>
                <option value="url">URL</option>
                <option value="captive">Captive Portal</option>
                <option value="sgt">SGT</option>
                <option value="dacl">dACL</option>
                <option value="qos">QoS</option>
                <option value="bandwidth">Bandwidth</option>
                <option value="coa">CoA</option>
                <option value="vpn">VPN</option>
                <option value="ipv6">IPv6</option>
                <option value="multicast">Multicast</option>
            </select>
            <select class="filter-select" id="networkFilter">
                <option value="">All Networks</option>
                <option value="wired">Wired</option>
                <option value="wireless">Wireless</option>
                <option value="both">Both</option>
            </select>
        </div>
        
        <div id="attributesList" class="loading">
            Loading attributes...
        </div>
    </div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const vendor = urlParams.get('vendor');
        const protocol = urlParams.get('protocol');
        let attributesData = [];

        // Update page title and navigation
        function updatePageInfo(data) {
            const vendorName = data.vendor.charAt(0).toUpperCase() + data.vendor.slice(1);
            const protocolName = data.protocol.toUpperCase();
            
            document.getElementById('pageTitle').textContent = `${vendorName} ${protocolName} Attributes`;
            document.getElementById('pageDescription').textContent = `Comprehensive reference for ${vendorName} ${protocolName} attributes`;
            
            // Update other protocol link
            const otherProtocol = protocol === 'radius' ? 'tacacs' : 'radius';
            const otherProtocolLink = document.getElementById('otherProtocol');
            otherProtocolLink.href = `viewer.html?vendor=${vendor}&protocol=${otherProtocol}`;
            otherProtocolLink.textContent = `View ${otherProtocol.toUpperCase()} Attributes`;
        }

        // Create attribute table
        function createAttributeTable(attributes) {
            if (attributes.length === 0) {
                return '<p>No attributes found matching your criteria.</p>';
            }

            let html = `
                <table class="attributes-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Number</th>
                            <th>Description</th>
                            <th>Features</th>
                            <th>Network</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            attributes.forEach((attr, index) => {
                // Create feature badges
                const featureBadges = Object.entries(attr.features)
                    .filter(([key, value]) => value)
                    .map(([key]) => `<span class="feature-badge feature-active">${key.toUpperCase()}</span>`)
                    .join('');

                html += `
                    <tr class="expandable-row" onclick="toggleDetails(${index})">
                        <td class="attribute-name">${attr.name}</td>
                        <td>${attr.number}</td>
                        <td>${attr.description}</td>
                        <td class="attribute-features">${featureBadges}</td>
                        <td>${attr.network}</td>
                    </tr>
                    <tr id="details-${index}" class="details-row">
                        <td colspan="5">
                            <div class="details-content">
                                <div class="details-section">
                                    <h4>Example</h4>
                                    <div class="example-code">${attr.example}</div>
                                </div>
                                
                                <div class="details-section">
                                    <h4>Use Cases</h4>
                                    <ul>
                                        ${(attr.use_cases || []).map(uc => `<li>${uc}</li>`).join('')}
                                    </ul>
                                </div>
                                
                                <div class="details-section">
                                    <h4>Implementation</h4>
                                    <ul>
                                        ${attr.implementation.map(impl => `<li>${impl}</li>`).join('')}
                                    </ul>
                                </div>
                                
                                <div class="details-section">
                                    <h4>Reference</h4>
                                    <a href="${attr.reference}" target="_blank">${attr.reference}</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                `;
            });

            html += '</tbody></table>';
            return html;
        }

        // Toggle attribute details
        function toggleDetails(index) {
            const detailsRow = document.getElementById(`details-${index}`);
            detailsRow.style.display = detailsRow.style.display === 'table-row' ? 'none' : 'table-row';
        }

        // Filter attributes
        function filterAttributes() {
            const searchTerm = document.getElementById('searchBox').value.toLowerCase();
            const featureFilter = document.getElementById('featureFilter').value;
            const networkFilter = document.getElementById('networkFilter').value;

            const filtered = attributesData.filter(attr => {
                // Search filter
                const matchesSearch = !searchTerm || 
                    attr.name.toLowerCase().includes(searchTerm) ||
                    attr.description.toLowerCase().includes(searchTerm) ||
                    (attr.use_cases && attr.use_cases.some(uc => uc.toLowerCase().includes(searchTerm)));

                // Feature filter
                const matchesFeature = !featureFilter || attr.features[featureFilter];

                // Network filter
                const matchesNetwork = !networkFilter || attr.network === networkFilter;

                return matchesSearch && matchesFeature && matchesNetwork;
            });

            document.getElementById('attributesList').innerHTML = createAttributeTable(filtered);
        }

        // Load attributes
        if (vendor && protocol) {
            fetch(`attributes/${vendor}/${protocol}_attributes.json`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('File not found');
                    }
                    return response.json();
                })
                .then(data => {
                    updatePageInfo(data);
                    attributesData = data.attributes;
                    document.getElementById('attributesList').innerHTML = createAttributeTable(attributesData);
                    
                    // Set up event listeners
                    document.getElementById('searchBox').addEventListener('input', filterAttributes);
                    document.getElementById('featureFilter').addEventListener('change', filterAttributes);
                    document.getElementById('networkFilter').addEventListener('change', filterAttributes);
                })
                .catch(error => {
                    console.error('Error loading attributes:', error);
                    document.getElementById('attributesList').className = 'error';
                    document.getElementById('attributesList').innerHTML = 
                        `<p>Error loading attributes for ${vendor} ${protocol}.</p>
                         <p>Please check the URL or return to the <a href="index.html">vendor list</a>.</p>`;
                });
        } else {
            document.getElementById('attributesList').className = 'error';
            document.getElementById('attributesList').innerHTML = 
                '<p>Invalid URL parameters. Please return to the <a href="index.html">vendor list</a>.</p>';
        }
    </script>
</body>
</html>
EOF

# Create README for GitHub
echo "Creating README..."
cat > "README.md" << 'EOF'
# RADIUS/TACACS+ Attribute Reference

A comprehensive, searchable reference for RADIUS and TACACS+ vendor-specific attributes (VSAs) across major networking vendors.

## Features

- **Multi-vendor support**: Cisco, Juniper, Aruba, Fortinet, Palo Alto, and more
- **Protocol coverage**: Both RADIUS and TACACS+ attributes
- **Advanced search**: Filter by name, feature, or network type
- **Detailed documentation**: Implementation guides, examples, and use cases
- **Feature flags**: ACL, Role, VLAN, QoS, CoA, and more

## Usage

Visit the GitHub Pages site to browse and search attributes:
https://[your-username].github.io/radius-tacacs-attributes/

## Structure
/
├── index.html              # Main landing page
├── viewer.html             # Attribute viewer page
├── directory.json          # Vendor directory
└── attributes/            # Attribute data files
├── cisco/
│   ├── radius_attributes.json
│   └── tacacs_attributes.json
├── juniper/
│   ├── radius_attributes.json
│   └── tacacs_attributes.json
└── ...
## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or update attribute files
4. Submit a pull request

## License

MIT License - see LICENSE file for details
EOF

# Create LICENSE file
echo "Creating LICENSE..."
cat > "LICENSE" << 'EOF'
MIT License

Copyright (c) 2024 RADIUS/TACACS+ Attribute Reference

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create .gitignore
echo "Creating .gitignore..."
cat > ".gitignore" << 'EOF'
# Backup files
backup_*/
*.bak
*.swp
*.tmp

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
EOF

# Create deployment script
echo "Creating deploy.sh..."
cat > "deploy.sh" << 'EOF'
#!/bin/bash

# Simple deployment script for GitHub Pages

echo "Preparing for deployment..."

# Ensure all files are generated
if [ ! -f "directory.json" ]; then
    echo "Error: directory.json not found. Run the generation script first."
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit"
fi

# Create gh-pages branch if it doesn't exist
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Creating gh-pages branch..."
    git checkout -b gh-pages
else
    echo "Switching to gh-pages branch..."
    git checkout gh-pages
fi

# Add all files
git add .
git commit -m "Update RADIUS/TACACS+ attributes $(date)"

echo "Deployment prepared. To deploy to GitHub Pages:"
echo "1. Add your GitHub repository as origin:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "2. Push to GitHub:"
echo "   git push -u origin gh-pages"
echo "3. Enable GitHub Pages in your repository settings"
echo "4. Your site will be available at: https://YOUR_USERNAME.github.io/YOUR_REPO/"
EOF

chmod +x deploy.sh

# Generate example configuration files
echo "Creating example configurations..."
mkdir -p examples

cat > "examples/cisco_radius.conf" << 'EOF'
! Cisco RADIUS Configuration Example
aaa new-model
aaa authentication login default group radius local
aaa authorization exec default group radius local
aaa accounting exec default start-stop group radius

radius server RADIUS1
 address ipv4 192.168.1.10 auth-port 1812 acct-port 1813
 key cisco123

! Enable dynamic VLAN assignment
interface GigabitEthernet0/1
 switchport mode access
 authentication host-mode multi-auth
 authentication port-control auto
 dot1x pae authenticator
 mab

! Enable CoA
aaa server radius dynamic-author
 client 192.168.1.10 server-key cisco123
EOF

cat > "examples/juniper_tacacs.conf" << 'EOF'
# Juniper TACACS+ Configuration Example
set system authentication-order [tacplus password]
set system tacplus-server 192.168.1.20 {
    secret "juniper123";
    timeout 5;
    single-connection;
}

# Map TACACS+ to local permissions
set system login class super-users-remote permissions all
set system login user remote full-name "Remote TACACS+ User"
set system login user remote class super-users-remote

# Enable command authorization
set system authorization tacplus
set system accounting events login
set system accounting events change-log
set system accounting destination tacplus
EOF

echo "Script completed successfully!"
echo ""
echo "Generated files:"
echo "- HTML interface (index.html, viewer.html)"
echo "- Directory listing (directory.json)"
echo "- Attribute files for all vendors/protocols"
echo "- README and LICENSE"
echo "- Deployment script (deploy.sh)"
echo "- Example configurations"
echo ""
echo "To deploy to GitHub Pages:"
echo "1. Create a GitHub repository"
echo "2. Run ./deploy.sh and follow the instructions"
echo "3. Enable GitHub Pages in repository settings"
echo ""
echo "Backup created in: $BACKUP_DIR"
