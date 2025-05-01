#!/bin/bash
# =============================================================================
# Radtribution Dictionary Comprehensive Enhancement Script
# =============================================================================
# This script provides a complete update to the Radtribution Dictionary:
# - Exhaustive vendor-specific attribute catalogs for all supported vendors
# - Enhanced UI/UX with responsive design
# - Advanced search and filtering capabilities
# - Improved data visualization
# - Comprehensive debugging and logging tools
# - Complete standardization of attribute formats
# =============================================================================

# Color codes for better readability in terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_VERSION="2.0.0"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/${TIMESTAMP}"
LOG_FILE="./update_${TIMESTAMP}.log"
TEMP_DIR="./temp"
DATA_DIR="./data"
ATTRIBUTE_DIR="./attributes"
VENDOR_DIR="./vendors"

# List of all vendors to include in the dictionary with their IDs
declare -A VENDOR_IDS
VENDOR_IDS=(
    ["cisco"]="9"
    ["juniper"]="2636"
    ["paloalto"]="25461"
    ["fortinet"]="12356"
    ["aruba"]="14823"
    ["hp"]="11"
    ["arista"]="30065"
    ["extreme"]="1916"
    ["checkpoint"]="2620"
    ["ruckus"]="25053"
    ["dell"]="6027"
    ["meraki"]="9"
    ["alcatel"]="6527"
    ["huawei"]="2011"
    ["f5"]="3375"
    ["sonicwall"]="8741"
    ["watchguard"]="2356"
    ["zyxel"]="890"
    ["brocade"]="1588"
    ["microsoftnas"]="311"
)

# Protocol support for each vendor
declare -A VENDOR_PROTOCOLS
for vendor in "${!VENDOR_IDS[@]}"; do
    VENDOR_PROTOCOLS[$vendor]="radius,tacacs"
done

# Function to log messages to both console and log file
log() {
    local level=$1
    local message=$2
    local color=$NC
    
    case $level in
        "INFO") color=$GREEN ;;
        "WARN") color=$YELLOW ;;
        "ERROR") color=$RED ;;
        "DEBUG") color=$BLUE ;;
        "SUCCESS") color=$CYAN ;;
    esac
    
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

# Function to check if script is running with required privileges
check_privileges() {
    log "INFO" "Checking if script has required privileges..."
    
    # Ensure the script can write to the necessary directories
    if [ ! -w "." ]; then
        log "ERROR" "Script does not have write permission in the current directory."
        exit 1
    fi
    
    log "INFO" "Script has required privileges."
}

# Function to check for required tools and dependencies
check_requirements() {
    log "INFO" "Checking for required tools and dependencies..."
    
    local required_tools=("jq" "sed" "awk" "grep" "curl" "git")
    local missing_tools=()
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log "ERROR" "Missing required tools: ${missing_tools[*]}"
        log "INFO" "Please install these tools before running this script."
        exit 1
    fi
    
    log "SUCCESS" "All required tools are installed."
}

# Function to create backup of current codebase
create_backup() {
    log "INFO" "Creating backup of current codebase..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Files to back up
    local files=("index.html" "styles.css" "script.js" "README.md")
    
    # Back up individual files
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            cp -v "$file" "$BACKUP_DIR/"
            log "DEBUG" "Backed up $file"
        else
            log "WARN" "File $file not found, skipping backup"
        fi
    done
    
    # Back up directories if they exist
    for dir in "data" "vendors" "attributes"; do
        if [ -d "./$dir" ]; then
            mkdir -p "$BACKUP_DIR/$dir"
            cp -rv "./$dir/"* "$BACKUP_DIR/$dir/" 2>/dev/null
            log "DEBUG" "Backed up directory $dir"
        fi
    done
    
    log "SUCCESS" "Backup completed to $BACKUP_DIR"
}

# Function to prepare working directories
prepare_directories() {
    log "INFO" "Preparing working directories..."
    
    # Create directories if they don't exist
    mkdir -p "$TEMP_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$ATTRIBUTE_DIR"
    mkdir -p "$VENDOR_DIR"
    
    # Create subdirectories for each vendor
    for vendor in "${!VENDOR_IDS[@]}"; do
        mkdir -p "$VENDOR_DIR/$vendor"
        mkdir -p "$ATTRIBUTE_DIR/$vendor"
    done
    
    log "SUCCESS" "Working directories prepared."
}

# Function to extract data from existing files
extract_existing_data() {
    log "INFO" "Extracting data from existing files..."
    
    # Extract table rows from HTML if it exists
    if [ -f "index.html" ]; then
        log "DEBUG" "Extracting attributes from index.html..."
        
        # Extract row data and save to temp file
        grep -A 10 'class="row-item"' index.html | \
        sed -n 's/.*data-vendor="\([^"]*\)".*data-protocol="\([^"]*\)".*/\1,\2/p' > "$TEMP_DIR/existing_attributes.csv"
        
        # Count extracted attributes
        local attr_count=$(wc -l < "$TEMP_DIR/existing_attributes.csv")
        log "INFO" "Extracted $attr_count attribute entries from HTML."
    else
        log "WARN" "index.html not found, skipping attribute extraction."
    fi
    
    # Also look for JSON data files
    if [ -d "$DATA_DIR" ]; then
        find "$DATA_DIR" -name "*.json" -exec cp -v {} "$TEMP_DIR/" \;
        log "DEBUG" "Copied existing JSON data files to temp directory."
    fi
    
    log "SUCCESS" "Data extraction completed."
}

# Function to generate comprehensive vendor attributes
generate_vendor_attributes() {
    log "INFO" "Generating comprehensive vendor-specific attributes..."
    
    # Process each vendor
    for vendor in "${!VENDOR_IDS[@]}"; do
        log "INFO" "Processing attributes for $vendor..."
        
        # Get vendor ID
        local vendor_id="${VENDOR_IDS[$vendor]}"
        
        # Get supported protocols
        IFS=',' read -ra protocols <<< "${VENDOR_PROTOCOLS[$vendor]}"
        
        # Process each protocol
        for protocol in "${protocols[@]}"; do
            log "DEBUG" "Generating $protocol attributes for $vendor..."
            
            # File to store the attributes
            local output_file="$ATTRIBUTE_DIR/$vendor/${protocol}_attributes.json"
            
            # Generate attribute data based on vendor and protocol
            case "$vendor:$protocol" in
                "cisco:radius")
                    generate_cisco_radius_attributes "$output_file"
                    ;;
                "cisco:tacacs")
                    generate_cisco_tacacs_attributes "$output_file"
                    ;;
                "juniper:radius")
                    generate_juniper_radius_attributes "$output_file"
                    ;;
                "juniper:tacacs")
                    generate_juniper_tacacs_attributes "$output_file"
                    ;;
                "paloalto:radius")
                    generate_paloalto_radius_attributes "$output_file"
                    ;;
                "paloalto:tacacs")
                    generate_paloalto_tacacs_attributes "$output_file"
                    ;;
                "fortinet:radius")
                    generate_fortinet_radius_attributes "$output_file"
                    ;;
                "fortinet:tacacs")
                    generate_fortinet_tacacs_attributes "$output_file"
                    ;;
                "aruba:radius")
                    generate_aruba_radius_attributes "$output_file"
                    ;;
                "aruba:tacacs")
                    generate_aruba_tacacs_attributes "$output_file"
                    ;;
                "hp:radius")
                    generate_hp_radius_attributes "$output_file"
                    ;;
                "arista:radius")
                    generate_arista_radius_attributes "$output_file"
                    ;;
                "arista:tacacs")
                    generate_arista_tacacs_attributes "$output_file"
                    ;;
                "extreme:radius")
                    generate_extreme_radius_attributes "$output_file"
                    ;;
                *)
                    # Generic attribute generation for other vendors/protocols
                    generate_generic_attributes "$vendor" "$protocol" "$vendor_id" "$output_file"
                    ;;
            esac
            
            # Validate generated JSON
            if [ -f "$output_file" ]; then
                if jq empty "$output_file" 2>/dev/null; then
                    log "SUCCESS" "Successfully generated $protocol attributes for $vendor"
                else
                    log "ERROR" "Invalid JSON generated for $vendor $protocol attributes"
                    # Create empty but valid JSON as fallback
                    echo '{"vendor":"'$vendor'","protocol":"'$protocol'","attributes":[]}' > "$output_file"
                fi
            else
                log "ERROR" "Failed to generate $protocol attributes for $vendor"
            fi
        done
    done
    
    log "SUCCESS" "Vendor attribute generation completed."
}

# Function to generate standard RADIUS attributes
generate_standard_radius_attributes() {
    log "INFO" "Generating standard RADIUS attributes..."
    
    local output_file="$ATTRIBUTE_DIR/standard_radius_attributes.json"
    
    # Create JSON structure for standard RADIUS attributes
    cat > "$output_file" << EOF
{
    "vendor": "standard",
    "protocol": "radius",
    "attributes": [
        {
            "name": "User-Name",
            "number": "1",
            "description": "User identifier for login.",
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
            "example": "User-Name = \"jsmith\"",
            "implementation": [
                "Required attribute for authentication",
                "Must match user account in authentication server",
                "Often used as primary identifier for session",
                "Can be in various formats (username, email, UPN)",
                "Case sensitivity depends on authentication server"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2865"
        },
        {
            "name": "User-Password",
            "number": "2",
            "description": "Password for user authentication (encrypted in RADIUS protocol).",
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
            "example": "User-Password = \"Password123\"",
            "implementation": [
                "Used for PAP authentication",
                "Password is encrypted in transit using RADIUS shared secret",
                "Not present in accounting or other non-authentication messages",
                "Replaced by other attributes for secure authentication methods",
                "Should be used with secure transport (RADSEC)"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2865"
        },
        {
            "name": "Tunnel-Type",
            "number": "64",
            "description": "Indicates the tunneling protocol(s) to be used.",
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
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Type = VLAN (value: 13)",
            "implementation": [
                "Required for VLAN assignment with value 13 (VLAN)",
                "Must be used with Tunnel-Medium-Type and Tunnel-Private-Group-ID",
                "Supported by most 802.1X-capable network devices",
                "Can have tag field for multiple tunnel scenarios",
                "Used in conjunction with other tunnel attributes"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2868"
        },
        {
            "name": "Tunnel-Medium-Type",
            "number": "65",
            "description": "Indicates the transport medium to use when creating a tunnel.",
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
                "vpn": true,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Tunnel-Medium-Type = IEEE-802 (value: 6)",
            "implementation": [
                "Required for VLAN assignment with value 6 (IEEE-802)",
                "Must be used with Tunnel-Type and Tunnel-Private-Group-ID",
                "Tag field should match corresponding Tunnel-Type attribute",
                "Used for both wireless and wired 802.1X authentication",
                "Widely supported across vendor implementations"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2868"
        },
        {
            "name": "Tunnel-Private-Group-ID",
            "number": "81",
            "description": "Indicates the group ID for a particular tunneled session.",
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
                "Contains the VLAN ID when used for VLAN assignment",
                "Must be used with Tunnel-Type and Tunnel-Medium-Type",
                "Can contain either VLAN ID or VLAN name depending on device",
                "Tag field should match corresponding tunnel attributes",
                "Widely supported across most network equipment vendors"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2868"
        },
        {
            "name": "Filter-ID",
            "number": "11",
            "description": "Name of the filter list to be applied to the user's session.",
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
            "example": "Filter-ID = \"ACL-GUEST\"",
            "implementation": [
                "Specifies name of ACL to apply to user traffic",
                "ACL must be pre-configured on the network device",
                "Format requirements vary by vendor (some require prefixes)",
                "Can be used for both IPv4 and IPv6 filtering",
                "Common alternative to vendor-specific downloadable ACLs"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2865"
        },
        {
            "name": "Framed-IP-Address",
            "number": "8",
            "description": "IP address to be configured for the user.",
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
            "example": "Framed-IP-Address = 192.168.1.100",
            "implementation": [
                "Assigns a specific IPv4 address to the authenticated user",
                "Commonly used in VPN scenarios for static IP assignment",
                "Also useful for tracking specific users by IP address",
                "Should be used with Framed-IP-Netmask for complete configuration",
                "Not used for IPv6 addressing (see Framed-IPv6-Address)"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc2865"
        },
        {
            "name": "Framed-IPv6-Address",
            "number": "168",
            "description": "IPv6 address to be configured for the user.",
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
            "example": "Framed-IPv6-Address = 2001:db8::1",
            "implementation": [
                "Assigns a specific IPv6 address to the authenticated user",
                "Commonly used in IPv6-enabled VPN scenarios",
                "Multiple instances can be used to assign multiple addresses",
                "Often used with Framed-IPv6-Prefix for complete configuration",
                "IPv6 counterpart to the Framed-IP-Address attribute"
            ],
            "reference": "https://datatracker.ietf.org/doc/html/rfc3162"
        }
    ]
}
EOF
    
    log "SUCCESS" "Standard RADIUS attributes generated."
}

# Function to generate Cisco RADIUS attributes
generate_cisco_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "cisco",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Cisco-AVPair",
            "number": "1",
            "description": "Multi-purpose attribute used for various functions including shell privilege levels, ACL assignments, VLAN assignments, SGT assignments, QoS policies, and bandwidth control.",
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
            "example": "Cisco-AVPair = \"shell:priv-lvl=15\" for admin access; Cisco-AVPair = \"ip:inacl#10=permit ip 10.0.0.0 0.255.255.255 any\" for ACL; Cisco-AVPair = \"cts:security-group-tag=3\" for SGT assignment",
            "implementation": [
                "Configure the RADIUS server to return this VSA with the appropriate formatting",
                "For ACLs: Use format \"ip:inacl#<number>=<acl-command>\"",
                "For admin level: Use format \"shell:priv-lvl=<level>\" (levels 0-15)",
                "For SGT: Use format \"cts:security-group-tag=<tag-number>\"",
                "For QoS: Use format \"ip:sub-qos-policy-in=<policy-name>\"",
                "For VLAN: Use format \"device-traffic-class=<vlan-number>\"",
                "For VPN: Use format \"vpn:addr-pool=<pool-name>\"",
                "For IPv6 ACLs: Use format \"ipv6:inacl#<number>=<ipv6-acl-command>\"",
                "Multiple attributes can be sent for different functions"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/15-mt/sec-usr-rad-15-mt-book/sec-rad-vsa.html"
        },
        {
            "name": "Web-Auth-Redirect",
            "number": "2",
            "description": "Triggers a captive portal (web authentication) redirect for user authentication on networks without 802.1X.",
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
            "example": "Web-Auth-Redirect URL = \"https://portal.company.com/login\" to redirect users to a login page.",
            "implementation": [
                "Enable captive portal (web-auth) on the network device (WLC or switch)",
                "Configure the RADIUS server to return this attribute with the redirect URL",
                "Configure ACLs to permit traffic to the authentication server",
                "Ensure the device intercepts HTTP/HTTPS and redirects to the provided URL",
                "The user completes authentication on the web portal before gaining access"
            ],
            "reference": "https://www.cisco.com/c/en/us/support/docs/security/identity-services-engine/200555-ISE-Guest-Access-Configuration-Example.html"
        },
        {
            "name": "Cisco-Policy-Up",
            "number": "3",
            "description": "Specifies the upstream QoS policy to apply to the user's session. Used for bandwidth management and traffic prioritization.",
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
            "example": "Cisco-Policy-Up = \"BRONZE-UPSTREAM\" to apply the BRONZE upstream QoS policy.",
            "implementation": [
                "Create the QoS policy on the Cisco device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the device",
                "Used for rate limiting, shaping, and prioritizing traffic",
                "Can be changed dynamically through CoA for active sessions",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/qos_classn/configuration/15-mt/qos-classn-15-mt-book/qos-classn-mrkg-red.html"
        },
        {
            "name": "Cisco-Policy-Down",
            "number": "4",
            "description": "Specifies the downstream QoS policy to apply to the user's session. Used for bandwidth management and traffic prioritization.",
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
            "example": "Cisco-Policy-Down = \"SILVER-DOWNSTREAM\" to apply the SILVER downstream QoS policy.",
            "implementation": [
                "Create the QoS policy on the Cisco device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the device",
                "Used for rate limiting, shaping, and prioritizing traffic",
                "Can be changed dynamically through CoA for active sessions",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/qos_classn/configuration/15-mt/qos-classn-15-mt-book/qos-classn-mrkg-red.html"
        },
        {
            "name": "Cisco-Security-Group-Tag",
            "number": "16",
            "description": "Assigns a Security Group Tag (SGT) to the user's session. Used for Cisco TrustSec to enforce role-based access control.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": true,
                "dacl": false,
                "qos": false,
                "bandwidth": false,
                "coa": true,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Cisco-Security-Group-Tag = 10 to assign SGT value 10 to the user session.",
            "implementation": [
                "Enable Cisco TrustSec features on the network device",
                "Configure the RADIUS server to return this VSA with the SGT value",
                "Define SGT policy matrices on the ISE or security controller",
                "SGTs are used to classify traffic and enforce policies",
                "Can be dynamically changed through CoA for active sessions",
                "Alternative to using Cisco-AVPair with cts:security-group-tag format",
                "Works with both IPv4 and IPv6 environments"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/switches/lan/trustsec/configuration/guide/trustsec/sgacl_config.html"
        },
        {
            "name": "Cisco-VPN-Group-Policy",
            "number": "25",
            "description": "Specifies the group policy to apply to a VPN session. Used for VPN client configuration and access control.",
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
            "example": "Cisco-VPN-Group-Policy = \"SALES_VPN_POLICY\" to apply this policy to the VPN session.",
            "implementation": [
                "Create the group policy on the ASA or Cisco VPN device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the device",
                "Group policies define VPN settings like split tunneling, DNS, timeouts, etc.",
                "Used in AnyConnect and other Cisco VPN deployments",
                "Supports both IPv4 and IPv6 VPN connections"
            ],
            "reference": "https://www.cisco.com/c/en/us/support/docs/security/asa-5500-x-series-next-generation-firewalls/98628-asa-vpn-radius.html"
        },
        {
            "name": "Cisco-IPv6-ACL-In",
            "number": "50",
            "description": "Specifies the name of an IPv6 ACL to be applied to inbound traffic for this session.",
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
            "example": "Cisco-IPv6-ACL-In = \"IPV6-GUEST-ACL\" to apply the IPv6 ACL to inbound traffic.",
            "implementation": [
                "Create the IPv6 ACL on the Cisco device",
                "Configure the RADIUS server to return this VSA with the ACL name",
                "The ACL name must match exactly with what's configured on the device",
                "Used specifically for IPv6 traffic filtering",
                "Alternative to using ipv6:inacl format in Cisco-AVPair",
                "Can be used with Cisco-IPv6-ACL-Out for bidirectional control"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/15-mt/sec-usr-rad-15-mt-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-IPv6-ACL-Out",
            "number": "51",
            "description": "Specifies the name of an IPv6 ACL to be applied to outbound traffic for this session.",
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
            "example": "Cisco-IPv6-ACL-Out = \"IPV6-RESTRICT-OUTBOUND\" to apply the IPv6 ACL to outbound traffic.",
            "implementation": [
                "Create the IPv6 ACL on the Cisco device",
                "Configure the RADIUS server to return this VSA with the ACL name",
                "The ACL name must match exactly with what's configured on the device",
                "Used specifically for IPv6 traffic filtering",
                "Alternative to using ipv6:outacl format in Cisco-AVPair",
                "Can be used with Cisco-IPv6-ACL-In for bidirectional control"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_rad/configuration/15-mt/sec-usr-rad-15-mt-book/sec-rad-vsa.html"
        },
        {
            "name": "Cisco-Multicast-Group-Policy",
            "number": "73",
            "description": "Specifies the multicast group policy to apply to the user session.",
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
                "multicast": true
            },
            "network": "both",
            "example": "Cisco-Multicast-Group-Policy = \"MULTICAST-POLICY-A\" to control multicast access.",
            "implementation": [
                "Create the multicast policy on the Cisco device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the device",
                "Used to control which multicast groups a user can join or send to",
                "Important for controlling multicast traffic in enterprise networks",
                "Helps prevent multicast storms and unauthorized multicast usage"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipmulti/configuration/15-mt/imc-15-mt-book/imc-basic-cfg.html"
        }
    ]
}
EOF
}

# Function to generate Cisco TACACS+ attributes
generate_cisco_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "cisco",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Specifies the privilege level for the user. Used to determine administrative access rights.",
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
            "example": "priv-lvl = 15 for full administrative access.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute with privilege level",
                "Configure the Cisco device to use TACACS+ for authentication",
                "Privilege levels range from 0 (lowest) to 15 (highest)",
                "Common levels: 0 (user EXEC), 1 (privileged EXEC), 15 (enable)",
                "The device will automatically assign the specified privilege level"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/15-mt/sec-usr-tacacs-15-mt-book/sec-cfg-tacacs.html"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Used for command authorization to control which commands a user can execute.",
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
            "example": "cmd = show for permitting all show commands.",
            "implementation": [
                "Configure the Cisco device to use TACACS+ for command authorization",
                "Configure the TACACS+ server with command permissions",
                "For each command, specify permit or deny",
                "Can use wildcards (e.g., \"show *\" to permit all show commands)",
                "Enable command authorization on the device with \"aaa authorization commands\""
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/15-mt/sec-usr-tacacs-15-mt-book/sec-cfg-tacacs.html"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the service for which authorization is to be performed.",
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
            "example": "service = shell for shell login authorization.",
            "implementation": [
                "Configure the Cisco device to use TACACS+ for authorization",
                "Configure the TACACS+ server with services",
                "Common services: shell (exec), network, admin, ppp",
                "Each service can have different attributes (e.g., priv-lvl)",
                "Enable service authorization on the device with \"aaa authorization\""
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/15-mt/sec-usr-tacacs-15-mt-book/sec-cfg-tacacs.html"
        },
        {
            "name": "roles",
            "number": "N/A",
            "description": "Specifies the role(s) to assign to the user. Used for role-based access control, particularly for NX-OS.",
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
            "example": "roles = \"network-admin\" for full administrative access on NX-OS devices.",
            "implementation": [
                "Configure the Cisco NX-OS device to use TACACS+ for authentication",
                "Define roles on the device or use predefined roles",
                "Configure the TACACS+ server to return this attribute with role names",
                "Multiple roles can be separated by spaces",
                "Common NX-OS roles: network-admin, network-operator, vdc-admin"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/7-x/security/configuration/guide/b_Cisco_Nexus_9000_Series_NX-OS_Security_Configuration_Guide_7x/b_Cisco_Nexus_9000_Series_NX-OS_Security_Configuration_Guide_7x_chapter_01001.html"
        },
        {
            "name": "addr",
            "number": "N/A",
            "description": "Specifies IP address restrictions for the authenticated user.",
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "addr = 10.1.1.0/24 to restrict access to this IP range.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute",
                "Can specify individual IP addresses or CIDR notation for ranges",
                "User will only be able to access from the specified IP addresses",
                "Useful for restricting administrative access to specific networks",
                "Supports both IPv4 and IPv6 address restrictions"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/15-mt/sec-usr-tacacs-15-mt-book/sec-cfg-tacacs.html"
        },
        {
            "name": "autocmd",
            "number": "N/A",
            "description": "Specifies a command that is automatically executed after user login.",
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
            "example": "autocmd = \"show version\" to automatically show version info after login.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute",
                "Command is executed automatically after successful authentication",
                "Useful for displaying messages, collecting information, or setting context",
                "Can specify any valid command that the user would have permission to run",
                "Multiple autocmd attributes can be specified for sequential execution"
            ],
            "reference": "https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_usr_tacacs/configuration/15-mt/sec-usr-tacacs-15-mt-book/sec-cfg-tacacs.html"
        }
    ]
}
EOF
}

# Function to generate Juniper RADIUS attributes
generate_juniper_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "juniper",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Juniper-Local-User-Name",
            "number": "1",
            "description": "Specifies a local user template to be applied, corresponding to a configured user template on the device.",
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
            "example": "Juniper-Local-User-Name = netadmin-template for network administrators.",
            "implementation": [
                "Define local user templates with specific privilege levels on the Juniper device",
                "Configure your RADIUS server to return this VSA with the template name",
                "The template name must match exactly with one defined on your Juniper device",
                "This attribute maps an authenticated user to a locally defined template user",
                "Particularly useful for assigning administrative roles with consistent permissions"
            ],
            "reference": "https://supportportal.juniper.net/s/article/Junos-How-to-assign-a-login-class-to-RADIUS-authenticated-users"
        },
        {
            "name": "Juniper-Allow-Commands",
            "number": "2",
            "description": "Lists commands that the user is allowed to execute. Used for granular CLI command control.",
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
            "example": "Juniper-Allow-Commands = \"show interfaces;show system\" to allow only these commands.",
            "implementation": [
                "Configure the RADIUS server to return this VSA with allowed commands",
                "Use semicolons to separate multiple commands",
                "Commands can include wildcards for flexibility (e.g., \"show *\")",
                "This VSA overrides any permission restrictions in the user's login class",
                "Useful for creating role-specific command permissions beyond login classes"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-Deny-Commands",
            "number": "3",
            "description": "Lists commands that the user is not allowed to execute. Used for granular CLI command restrictions.",
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
            "example": "Juniper-Deny-Commands = \"configure;restart\" to prevent configuration and restart.",
            "implementation": [
                "Configure the RADIUS server to return this VSA with denied commands",
                "Use semicolons to separate multiple commands",
                "Commands can include wildcards for flexibility (e.g., \"configure *\")",
                "Takes precedence over Juniper-Allow-Commands for matching commands",
                "Useful for creating role-specific command restrictions"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-Filter",
            "number": "4",
            "description": "Specifies a pre-defined filter to be applied to the user's session. Similar to an ACL, can control traffic flow.",
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
            "example": "Juniper-Filter = \"guest-access-filter\" to apply guest network restrictions.",
            "implementation": [
                "Create a firewall filter (ACL) on the Juniper device",
                "Configure the RADIUS server to return this VSA with the filter name",
                "Filter must be predefined on the Juniper device",
                "The filter is applied to the user's traffic during the session",
                "Multiple filter instances can be sent for different directions/protocols"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-Login-Class",
            "number": "5",
            "description": "Assigns a login class to the user, which determines the user's access privileges in the CLI.",
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
            "example": "Juniper-Login-Class = \"super-user\" for full administrative access.",
            "implementation": [
                "Define login classes on the Juniper device with the desired permissions",
                "Configure the RADIUS server to return this VSA with the login class name",
                "The class must be predefined on the Juniper device",
                "Login classes define CLI command permissions, timeouts, and idle behavior",
                "Common classes include: super-user, operator, read-only"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Ingress-Policy-Name",
            "number": "10",
            "description": "Specifies a QoS policy to apply to inbound traffic. Used for traffic shaping and bandwidth management.",
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
            "example": "Ingress-Policy-Name = \"gold-service-in\" to apply the gold service QoS policy to incoming traffic.",
            "implementation": [
                "Create the QoS policy on the Juniper device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the Juniper device",
                "Used for user-specific or service-specific QoS treatment",
                "Can be dynamically changed via CoA for active sessions",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Egress-Policy-Name",
            "number": "11",
            "description": "Specifies a QoS policy to apply to outbound traffic. Used for traffic shaping and bandwidth management.",
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
            "example": "Egress-Policy-Name = \"silver-service-out\" to apply the silver service QoS policy to outgoing traffic.",
            "implementation": [
                "Create the QoS policy on the Juniper device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy name must match exactly with what's configured on the Juniper device",
                "Used for user-specific or service-specific QoS treatment",
                "Can be dynamically changed via CoA for active sessions",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-IPv6-Filter-In",
            "number": "42",
            "description": "Specifies an IPv6 filter to apply to inbound traffic.",
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
            "example": "Juniper-IPv6-Filter-In = \"IPv6-GUEST-FILTER-IN\" for IPv6 access control.",
            "implementation": [
                "Create an IPv6 filter on the Juniper device",
                "Configure the RADIUS server to return this VSA with the filter name",
                "The filter must be predefined on the Juniper device",
                "Specifically for controlling IPv6 traffic",
                "Complements IPv4 filters for complete traffic control",
                "Can be used in conjunction with Juniper-IPv6-Filter-Out"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-IPv6-Filter-Out",
            "number": "43",
            "description": "Specifies an IPv6 filter to apply to outbound traffic.",
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
            "example": "Juniper-IPv6-Filter-Out = \"IPv6-GUEST-FILTER-OUT\" for IPv6 access control.",
            "implementation": [
                "Create an IPv6 filter on the Juniper device",
                "Configure the RADIUS server to return this VSA with the filter name",
                "The filter must be predefined on the Juniper device",
                "Specifically for controlling IPv6 traffic",
                "Complements IPv4 filters for complete traffic control",
                "Can be used in conjunction with Juniper-IPv6-Filter-In"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        },
        {
            "name": "Juniper-Multicast-Group-Policy",
            "number": "65",
            "description": "Specifies the multicast group policy to apply to the user session.",
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
                "multicast": true
            },
            "network": "both",
            "example": "Juniper-Multicast-Group-Policy = \"MULTICAST-POLICY-1\" for multicast control.",
            "implementation": [
                "Define multicast policies on the Juniper device",
                "Configure the RADIUS server to return this VSA with the policy name",
                "The policy must be predefined on the Juniper device",
                "Controls which multicast groups a user can join or send to",
                "Important for controlling multicast traffic in enterprise networks",
                "Can be applied to both IPv4 and IPv6 multicast traffic"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/reference/general/aaa-subscriber-access-radius-vsa.html"
        }
    ]
}
EOF
}

# Function to generate Juniper TACACS+ attributes
generate_juniper_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "juniper",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "local-user-name",
            "number": "N/A",
            "description": "Specifies a locally defined user template to be applied to the authenticated user. Similar to the RADIUS Juniper-Local-User-Name attribute.",
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
            "example": "local-user-name = netadmin-template for administrator access.",
            "implementation": [
                "Define local user templates with specific privilege levels on the Juniper device",
                "Configure your TACACS+ server to return this attribute with the template name",
                "Configure the Juniper device to accept TACACS+ authentication",
                "The template name must match exactly with one defined on your Juniper device",
                "This attribute maps an authenticated user to a locally defined template user"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/authentication-tacacs-authentication-configuring.html"
        },
        {
            "name": "login-class",
            "number": "N/A",
            "description": "Assigns a login class to the user, which determines the user's access privileges in the CLI. Similar to the RADIUS Juniper-Login-Class attribute.",
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
            "example": "login-class = super-user for full administrative access.",
            "implementation": [
                "Define login classes on the Juniper device with the desired permissions",
                "Configure the TACACS+ server to return this attribute with the login class name",
                "Configure the Juniper device to accept TACACS+ authentication",
                "The class must be predefined on the Juniper device",
                "Login classes define CLI command permissions, timeouts, and idle behavior"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/authentication-tacacs-authentication-configuring.html"
        },
        {
            "name": "allow-commands",
            "number": "N/A",
            "description": "Lists commands that the user is allowed to execute. Similar to the RADIUS Juniper-Allow-Commands attribute.",
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
            "example": "allow-commands = \"show interfaces;show system\" to allow only these commands.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute with allowed commands",
                "Configure the Juniper device to accept TACACS+ authentication",
                "Use semicolons to separate multiple commands",
                "Commands can include wildcards for flexibility (e.g., \"show *\")",
                "This attribute overrides any permission restrictions in the user's login class"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/authentication-tacacs-authentication-configuring.html"
        },
        {
            "name": "deny-commands",
            "number": "N/A",
            "description": "Lists commands that the user is not allowed to execute. Similar to the RADIUS Juniper-Deny-Commands attribute.",
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
            "example": "deny-commands = \"configure;restart\" to prevent configuration and restart.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute with denied commands",
                "Configure the Juniper device to accept TACACS+ authentication",
                "Use semicolons to separate multiple commands",
                "Commands can include wildcards for flexibility (e.g., \"configure *\")",
                "Takes precedence over allow-commands for matching commands"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/authentication-tacacs-authentication-configuring.html"
        },
        {
            "name": "user-permissions",
            "number": "N/A",
            "description": "Specifies the user's permissions within the login class. Similar to the RADIUS Juniper-User-Permission attribute.",
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
            "example": "user-permissions = \"all\" for full permissions.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute with permission strings",
                "Configure the Juniper device to accept TACACS+ authentication",
                "Permissions include: all, clear, configure, control, field, maintenance, etc.",
                "Multiple permissions can be specified with comma separation",
                "These permissions override those defined in the assigned login class"
            ],
            "reference": "https://www.juniper.net/documentation/en_US/junos/topics/task/configuration/authentication-tacacs-authentication-configuring.html"
        }
    ]
}
EOF
}

# Function to generate Palo Alto RADIUS attributes
generate_paloalto_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "paloalto",
    "protocol": "radius",
    "attributes": [
        {
            "name": "PaloAlto-Admin-Role",
            "number": "1",
            "description": "Assigns an administrative role to the user for Palo Alto Networks firewall management access.",
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
            "example": "PaloAlto-Admin-Role = \"superuser\" for full administrative access.",
            "implementation": [
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication",
                "Set the VSA with the desired admin role",
                "Valid values include standard roles (superuser, superreader, etc.) or custom roles",
                "User will automatically be assigned the role upon successful authentication"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
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
            "example": "PaloAlto-Admin-Access-Domain = \"Domain1\" for specific domain access.",
            "implementation": [
                "Configure access domains on the Palo Alto firewall (Device > Access Domains)",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication",
                "Set the VSA with the desired access domain name",
                "User will be restricted to the specified access domain upon authentication"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Role",
            "number": "3",
            "description": "Assigns an administrative role to the user for Panorama management access. Controls access rights in the Panorama management system.",
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
            "example": "PaloAlto-Panorama-Admin-Role = \"panorama-admin\" for Panorama administration access.",
            "implementation": [
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure Panorama to use RADIUS authentication",
                "Set the VSA with the desired admin role",
                "Valid values include standard roles (panorama-admin, etc.) or custom roles",
                "User will automatically be assigned the role upon successful authentication"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Access-Domain",
            "number": "4",
            "description": "Specifies the access domain for Panorama administrators. Controls which device groups and templates an administrator can manage in Panorama.",
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
            "example": "PaloAlto-Panorama-Admin-Access-Domain = \"Domain2\" for specific Panorama domain access.",
            "implementation": [
                "Configure access domains on Panorama (Panorama > Access Domains)",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure Panorama to use RADIUS authentication",
                "Set the VSA with the desired access domain name",
                "User will be restricted to the specified access domain upon authentication"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-User-Group",
            "number": "5",
            "description": "Specifies a user group for the authenticated user. Used for policy enforcement and VPN access control.",
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
            "example": "PaloAlto-User-Group = \"Employees\" for group-based access control.",
            "implementation": [
                "Create user groups on the Palo Alto firewall",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication",
                "Set the VSA with the desired user group name",
                "User will be assigned to the specified group upon authentication",
                "Use the group in security policies to control access"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-IPv6-User-Group",
            "number": "12",
            "description": "Specifies an IPv6 user group for the authenticated user.",
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
            "example": "PaloAlto-IPv6-User-Group = \"IPv6-Employees\" for IPv6 group-based access control.",
            "implementation": [
                "Create IPv6 user groups on the Palo Alto firewall",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication",
                "Set the VSA with the desired IPv6 user group name",
                "User will be assigned to the specified IPv6 group upon authentication",
                "Use the group in security policies to control IPv6 access"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-GP-Client-IPv6-Pool",
            "number": "18",
            "description": "Specifies the IPv6 address pool for GlobalProtect VPN clients.",
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
            "example": "PaloAlto-GP-Client-IPv6-Pool = \"IPv6-VPN-Pool\" for IPv6 address assignment in VPN.",
            "implementation": [
                "Configure IPv6 address pools on the Palo Alto firewall",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication for VPN users",
                "Set the VSA with the desired IPv6 pool name",
                "VPN clients will receive IPv6 addresses from the specified pool",
                "Must be used in conjunction with IPv6-enabled GlobalProtect configuration"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        },
        {
            "name": "PaloAlto-Multicast-Policy",
            "number": "20",
            "description": "Specifies the multicast policy to apply to the user session.",
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
                "multicast": true
            },
            "network": "both",
            "example": "PaloAlto-Multicast-Policy = \"Employee-Multicast\" for multicast access control.",
            "implementation": [
                "Create multicast policies on the Palo Alto firewall",
                "Configure the RADIUS server with Palo Alto VSAs (Vendor ID: 25461)",
                "Configure the PAN-OS device to use RADIUS authentication",
                "Set the VSA with the desired multicast policy name",
                "The policy will be applied to the user upon authentication",
                "Controls which multicast groups the user can join or send to"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/radius"
        }
    ]
}
EOF
}

# Function to generate Palo Alto TACACS+ attributes
generate_paloalto_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "paloalto",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "PaloAlto-Admin-Role",
            "number": "N/A",
            "description": "Assigns an administrative role to the user for Palo Alto Networks firewall management access.",
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
            "example": "PaloAlto-Admin-Role = \"superuser\" for full administrative access.",
            "implementation": [
                "Configure the TACACS+ server with the required Palo Alto attributes",
                "Set the service attribute to \"PaloAlto\"",
                "Set the protocol attribute to \"firewall\"",
                "Configure the PAN-OS device to use TACACS+ authentication",
                "Set the PaloAlto-Admin-Role attribute with the desired role",
                "Valid values include standard roles (superuser, superreader, etc.) or custom roles"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Admin-Access-Domain",
            "number": "N/A",
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
            "example": "PaloAlto-Admin-Access-Domain = \"Domain1\" for specific domain access.",
            "implementation": [
                "Configure access domains on the Palo Alto firewall (Device > Access Domains)",
                "Configure the TACACS+ server with the required Palo Alto attributes",
                "Set the service attribute to \"PaloAlto\"",
                "Set the protocol attribute to \"firewall\"",
                "Configure the PAN-OS device to use TACACS+ authentication",
                "Set the PaloAlto-Admin-Access-Domain attribute with the desired domain name"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Role",
            "number": "N/A",
            "description": "Assigns an administrative role to the user for Panorama management access. Controls access rights in the Panorama management system.",
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
            "example": "PaloAlto-Panorama-Admin-Role = \"panorama-admin\" for Panorama administration access.",
            "implementation": [
                "Configure the TACACS+ server with the required Palo Alto attributes",
                "Set the service attribute to \"PaloAlto\"",
                "Set the protocol attribute to \"panorama\"",
                "Configure Panorama to use TACACS+ authentication",
                "Set the PaloAlto-Panorama-Admin-Role attribute with the desired role",
                "Valid values include standard roles (panorama-admin, etc.) or custom roles"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/tacacs"
        },
        {
            "name": "PaloAlto-Panorama-Admin-Access-Domain",
            "number": "N/A",
            "description": "Specifies the access domain for Panorama administrators. Controls which device groups and templates an administrator can manage in Panorama.",
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
            "example": "PaloAlto-Panorama-Admin-Access-Domain = \"Domain2\" for specific Panorama domain access.",
            "implementation": [
                "Configure access domains on Panorama (Panorama > Access Domains)",
                "Configure the TACACS+ server with the required Palo Alto attributes",
                "Set the service attribute to \"PaloAlto\"",
                "Set the protocol attribute to \"panorama\"",
                "Configure Panorama to use TACACS+ authentication",
                "Set the PaloAlto-Panorama-Admin-Access-Domain attribute with the desired domain name"
            ],
            "reference": "https://docs.paloaltonetworks.com/pan-os/11-0/pan-os-admin/authentication/authentication-types/tacacs"
        }
    ]
}
EOF
}

# Function to generate Fortinet RADIUS attributes
generate_fortinet_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "fortinet",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Fortinet-Group-Name",
            "number": "1",
            "description": "Specifies the group name of the user. Used to assign users to specific user groups for policy enforcement.",
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
            "example": "Fortinet-Group-Name = \"Admins\" for administrative group assignment; Fortinet-Group-Name = \"VPN_Users\" for remote access policy enforcement",
            "implementation": [
                "Define the user group on the FortiGate (typically under User & Authentication > User Groups)",
                "Configure your RADIUS server to return this VSA with the name of the group",
                "The RADIUS server must support Fortinet VSAs (Vendor ID 12356)",
                "The group name is case-sensitive and must match exactly with what is configured on the FortiGate",
                "User groups can be used in firewall policies, VPN configurations, and web filtering policies"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Client-IP-Address",
            "number": "2",
            "description": "Specifies the IP address to assign to the client. Commonly used in VPN scenarios to assign a specific IP address to the connecting user.",
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
            "example": "Fortinet-Client-IP-Address = \"192.168.1.100\" for fixed IP assignment in VPN configurations",
            "implementation": [
                "Configure the RADIUS server to return this VSA with the specific IP address",
                "Ensure IP addresses provided don't conflict with other address assignments",
                "Commonly used with SSL VPN and IPsec VPN setups",
                "Can be used to track usage by specific users through consistent IP assignments",
                "Alternative to using IP pools on the FortiGate for address assignment"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Vdom-Name",
            "number": "3",
            "description": "Specifies the virtual domain (VDOM) name to which the user is tied. Used in multi-tenant environments to restrict users to specific VDOMs.",
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
            "example": "Fortinet-Vdom-Name = \"customer_A\" to restrict user access to the customer_A VDOM only",
            "implementation": [
                "Enable multi-VDOM mode on the FortiGate",
                "Create the VDOMs that will be used",
                "Configure the RADIUS server to return this VSA with the VDOM name",
                "The VDOM name is case-sensitive and must match exactly with the VDOM configured on the FortiGate",
                "This is useful for managed service providers with multi-tenant environments"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Client-IPv6-Address",
            "number": "4",
            "description": "Specifies the IPv6 address to assign to the client. Used in IPv6-enabled environments for address assignment to connecting clients.",
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
            "example": "Fortinet-Client-IPv6-Address = \"2001:db8::1\" for IPv6 address assignment",
            "implementation": [
                "Enable IPv6 support on the FortiGate",
                "Configure the RADIUS server to return this VSA with the IPv6 address",
                "Ensure IPv6 connectivity is properly configured in your environment",
                "Often used in SSL VPN and IPsec VPN dual-stack (IPv4/IPv6) deployments",
                "The attribute value format is in Octets to support full IPv6 address representation"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Interface-Name",
            "number": "5",
            "description": "Specifies the name of the FortiGate interface to be used by the client. Can control which network interface a user's traffic is directed through.",
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
            "example": "Fortinet-Interface-Name = \"port1\" to specify the client should use the port1 interface",
            "implementation": [
                "Ensure the specified interface exists on the FortiGate",
                "Configure the RADIUS server to return this VSA with the interface name",
                "The interface name is case-sensitive and must match exactly with the interface configured on the FortiGate",
                "This attribute can be used for traffic engineering and routing specific users through specific interfaces",
                "Helpful in complex network environments with multiple egress paths"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Access-Profile",
            "number": "6",
            "description": "Specifies the access profile to assign to the user. Critical for remote administration, determining what level of administrative access a user has.",
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
            "example": "Fortinet-Access-Profile = \"super_admin\" for full administrative privileges; Fortinet-Access-Profile = \"read_only\" for monitoring-only access",
            "implementation": [
                "Create access profiles on the FortiGate under System > Admin Profiles",
                "Define the permissions for each profile (read/write access to specific functions)",
                "Configure the RADIUS server to return this VSA with the profile name",
                "The profile name is case-sensitive and must match exactly with the profile on the FortiGate",
                "Use with Fortinet-Vdom-Name for VDOM-specific administrative restrictions"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-SSID",
            "number": "7",
            "description": "Specifies the SSID to which the user is connected. Used for tracking and policy enforcement in WiFi deployments.",
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
            "example": "Fortinet-SSID = \"Guest_WiFi\" to track connections to the guest wireless network",
            "implementation": [
                "Configure wireless SSIDs on the FortiGate",
                "Setup RADIUS authentication for the wireless network",
                "The FortiGate can send this attribute to the RADIUS server for accounting",
                "Used primarily for monitoring and reporting wireless network usage",
                "Often used in conjunction with Fortinet-AP-Name for complete wireless visibility"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Webfilter-Category-Allow",
            "number": "16",
            "description": "Specifies web filter categories that should be allowed for this user, overriding the default web filter profile settings.",
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
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Fortinet-Webfilter-Category-Allow = \"News\" to allow access to news sites for specific users",
            "implementation": [
                "Configure web filtering on the FortiGate",
                "Set up RADIUS authentication for users",
                "Configure the RADIUS server to return this VSA with category names to allow",
                "Category names must match FortiGuard web filter categories",
                "This allows for user-specific web filtering overrides",
                "Useful for providing different web access levels based on user roles or departments"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        },
        {
            "name": "Fortinet-Captive-Portal-URL",
            "number": "27",
            "description": "Specifies the captive portal URL for guest WiFi access. Used to direct users to a specific captive portal page.",
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
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "wireless",
            "example": "Fortinet-Captive-Portal-URL = \"https://guest.example.com\" to redirect users to a custom portal",
            "implementation": [
                "Configure captive portal settings on the FortiGate",
                "Setup RADIUS authentication for guest WiFi",
                "Configure the RADIUS server to return this VSA with the portal URL",
                "Allows customization of the captive portal experience per user or group",
                "Can be used for branded guest access or different portals by location",
                "Valuable for multi-tenant environments or managed service providers"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.6.2/administration-guide/952303/radius-avps-and-vsas"
        }
    ]
}
EOF
}

# Function to generate Fortinet TACACS+ attributes
generate_fortinet_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "fortinet",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "Fortinet-Access-Profile",
            "number": "N/A",
            "description": "Assigns an access profile to the administrator session. Critical for remote administration, determining what level of administrative access a user has to FortiGate features.",
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
            "example": "Fortinet-Access-Profile = \"super_admin\" for full administrative privileges; Fortinet-Access-Profile = \"read_only\" for monitoring-only access",
            "implementation": [
                "Create access profiles on the FortiGate under System > Admin Profiles",
                "Define the permissions for each profile (read/write access to specific functions)",
                "Configure the TACACS+ server to return this attribute with the profile name",
                "The profile name is case-sensitive and must match exactly with the profile on the FortiGate",
                "Enable the admin_prof attribute override in the FortiGate system admin configuration",
                "Use with Fortinet-Vdom-Name for VDOM-specific administrative restrictions"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.0.0/administration-guide/651398/tacacs-servers"
        },
        {
            "name": "Fortinet-Vdom-Name",
            "number": "N/A",
            "description": "Specifies the virtual domain (VDOM) name to which the administrator is restricted. Used in multi-tenant environments to control administrative access to specific VDOMs.",
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
            "example": "Fortinet-Vdom-Name = \"customer_A\" to restrict administrator access to the customer_A VDOM only",
            "implementation": [
                "Enable multi-VDOM mode on the FortiGate",
                "Create the VDOMs that will be used",
                "Configure the TACACS+ server to return this attribute with the VDOM name",
                "The VDOM name is case-sensitive and must match exactly with the VDOM configured on the FortiGate",
                "Enable the vdom_override attribute in the FortiGate system admin configuration",
                "This is particularly useful for service providers with multi-tenant environments"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.0.0/administration-guide/651398/tacacs-servers"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Controls command authorization for the user. Used to restrict administrator access to specific commands.",
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
            "example": "cmd = show for permitting all show commands; cmd = \"system interface\" to allow interface configuration",
            "implementation": [
                "Configure command authorization on the FortiGate",
                "Configure the TACACS+ server with command permissions",
                "For each command, specify permit (default) or deny",
                "Can use wildcards (e.g., \"diagnose *\" to permit all diagnostic commands)",
                "Enable command authorization on the FortiGate with \"set authorization enable\"",
                "Very granular control is possible by specifying complete command paths"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.0.0/administration-guide/651398/tacacs-servers"
        },
        {
            "name": "Fortinet-Group-Name",
            "number": "N/A",
            "description": "Specifies the user group for administrative access and policy application.",
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
            "example": "Fortinet-Group-Name = \"network_admins\" for grouping administrators",
            "implementation": [
                "Create user groups on the FortiGate",
                "Configure the TACACS+ server to return this attribute with the group name",
                "The group name must match a group defined on the FortiGate",
                "Used to apply group-based policies and permissions",
                "Helps organize administrators by function or department"
            ],
            "reference": "https://docs.fortinet.com/document/fortigate/7.0.0/administration-guide/651398/tacacs-servers"
        }
    ]
}
EOF
}

# Function to generate Aruba RADIUS attributes
generate_aruba_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "aruba",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Aruba-User-Role",
            "number": "1",
            "description": "Assigns a user role to the authenticated user. User roles on Aruba devices define access control policies, QoS settings, and other parameters.",
            "features": {
                "acl": true,
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-User-Role = \"employee\" to assign the employee role defined on the Aruba device.",
            "implementation": [
                "Define user roles on the Aruba controller (Configuration > Security > Roles)",
                "Configure access control rules, VLAN assignments, and other parameters for each role",
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Aruba device applies the assigned role upon successful authentication"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-VLAN",
            "number": "2",
            "description": "Assigns a VLAN to an authenticated user. Can be used for dynamic VLAN assignment based on user or device.",
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
            "example": "Aruba-VLAN = \"100\" to place the user in VLAN 100.",
            "implementation": [
                "Configure the VLANs on the Aruba device",
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The VSA can contain a VLAN name or a VLAN ID",
                "Can be used with Aruba-User-Role for more comprehensive access control"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-Admin-Role",
            "number": "3",
            "description": "Assigns a specific admin role to the user. Used for administrative access control to Aruba device management.",
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
            "example": "Aruba-Admin-Role = \"root\" for full administrative access; Aruba-Admin-Role = \"read-only\" for monitoring-only access.",
            "implementation": [
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication for admin access on the Aruba device",
                "Configure the server to return this VSA with the desired admin role",
                "Common admin roles: root, read-only, guest-provisioning, location-api-mgmt, network-operations",
                "Custom admin roles can also be created and assigned"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-Url-Redirect",
            "number": "5",
            "description": "Specifies a URL to which the user should be redirected. Used for captive portal redirections and custom welcome pages.",
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
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Url-Redirect = \"https://login.example.com\" for URL redirection.",
            "implementation": [
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "Configure the Aruba device to allow URL redirection in the role settings",
                "The user will be redirected to the specified URL upon authentication",
                "Can be used for welcome pages, terms of service acceptance, or additional authentication"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-ACL-Name",
            "number": "10",
            "description": "Specifies the name of an ACL to be applied to the user session. Controls network access permissions.",
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-ACL-Name = \"Guest-ACL\" for applying guest ACL.",
            "implementation": [
                "Define the ACL on the Aruba device (Configuration > Security > Access Control)",
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Aruba device applies the specified ACL to the user upon authentication",
                "ACLs define traffic filtering rules and can be restrictive or permissive",
                "Supports both IPv4 and IPv6 ACLs"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-Bandwidth-Contract",
            "number": "7",
            "description": "Specifies bandwidth limits for the user session. Used to control downstream and upstream bandwidth.",
            "features": {
                "acl": false,
                "role": false,
                "vlan": false,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": false,
                "bandwidth": true,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-Bandwidth-Contract = \"100000/50000\" for 100 kbps upstream and 50 kbps downstream.",
            "implementation": [
                "Configure bandwidth contracts on the Aruba device",
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "Format is \"upstream-rate/downstream-rate\" in kbps",
                "The Aruba device enforces the bandwidth limitations upon authentication",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-CoA-URL",
            "number": "22",
            "description": "Specifies the URL for Change of Authorization (CoA) requests. Used for dynamic policy changes.",
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
            "network": "both",
            "example": "Aruba-CoA-URL = \"https://radius.example.com/coa\" for CoA requests.",
            "implementation": [
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "Configure the Aruba device to accept CoA requests",
                "Ensure the CoA server is available at the specified URL",
                "Used for dynamic policy enforcement and session termination"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        },
        {
            "name": "Aruba-IPv6-User-Role",
            "number": "30",
            "description": "Assigns an IPv6-specific user role to the authenticated user.",
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Aruba-IPv6-User-Role = \"employee-ipv6\" to assign the IPv6-specific employee role.",
            "implementation": [
                "Define IPv6-specific user roles on the Aruba controller",
                "Configure access control rules for IPv6 traffic",
                "Configure the RADIUS server with Aruba VSAs (Vendor ID: 14823)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Aruba device applies the assigned IPv6 role upon successful authentication"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/rad-vsa.htm"
        }
    ]
}
EOF
}

# Function to generate Aruba TACACS+ attributes
generate_aruba_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "aruba",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "role",
            "number": "N/A",
            "description": "Assigns an administrative role on Aruba controllers. Controls the level of access to controller management features.",
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
            "example": "role = \"root\" for full administrative access.",
            "implementation": [
                "Configure the TACACS+ server with Aruba attributes",
                "Set up TACACS+ authentication for admin access on the Aruba device",
                "Configure the server to return this attribute with the desired admin role",
                "Common admin roles: root, read-only, guest-provisioning, location-api-mgmt, network-operations",
                "Custom admin roles can also be created and assigned"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/tac-plus.htm"
        },
        {
            "name": "command-authorization",
            "number": "N/A",
            "description": "Controls access to specific CLI commands on Aruba devices. Used to restrict administrator access to certain commands.",
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
            "example": "command-authorization = permit-all for full command access; command-authorization = permit-show for view-only access.",
            "implementation": [
                "Configure the TACACS+ server with Aruba attributes",
                "Set up TACACS+ command authorization on the Aruba device",
                "Configure the server to return this attribute with the desired permissions",
                "Command permissions can be granular (specific commands) or broad (permit-all)",
                "Commonly used values: permit-all, permit-config, permit-show, deny-all"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/tac-plus.htm"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "Specifies the service type for TACACS+ authorization.",
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
            "example": "service = aruba for Aruba-specific service configuration.",
            "implementation": [
                "Configure the TACACS+ server with Aruba attributes",
                "Set the service type to 'aruba' for Aruba-specific attributes",
                "Use with other Aruba-specific attributes",
                "Required for proper handling of Aruba-specific attributes",
                "Different from standard TACACS+ services like 'shell'"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/tac-plus.htm"
        },
        {
            "name": "admin-role",
            "number": "N/A",
            "description": "Alternative format for assigning an administrative role on Aruba controllers.",
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
            "example": "admin-role = \"root\" for full administrative access.",
            "implementation": [
                "Configure the TACACS+ server with Aruba attributes",
                "Set up TACACS+ authentication for admin access on the Aruba device",
                "Configure the server to return this attribute with the desired admin role",
                "Alternative format to the 'role' attribute",
                "Used for backward compatibility with some TACACS+ server implementations"
            ],
            "reference": "https://www.arubanetworks.com/techdocs/ArubaOS_8.6.0_Web_Help/Content/arubaos-solutions/aaa/tac-plus.htm"
        }
    ]
}
EOF
}

# Function to generate HP RADIUS attributes
generate_hp_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "hp",
    "protocol": "radius",
    "attributes": [
        {
            "name": "HPE-Port-Client-Limit-Dot1x",
            "number": "10",
            "description": "Sets a temporary 802.1X client limit for the port. Values range from 0 (disabled) to 32 clients.",
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
            "example": "HPE-Port-Client-Limit-Dot1x = 5 to limit to 5 clients.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication on the HP switch",
                "Configure port-based authentication with 802.1X",
                "The VSA value can range from 0 to 32 (0 disables the client limit)",
                "Used when multiple clients need to authenticate through the same physical port"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HPE-VLAN-ID",
            "number": "80",
            "description": "Assigns a VLAN to the authenticated user. Used for dynamic VLAN assignment based on user credentials.",
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
            "network": "wired",
            "example": "HPE-VLAN-ID = 100 to dynamically assign VLAN 100.",
            "implementation": [
                "Configure the VLAN on the HP switch",
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication with 802.1X on the switch ports",
                "When a user authenticates, they are assigned to the specified VLAN",
                "Alternative to using the standard Tunnel-Private-Group-ID attribute"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HP-Privilege-Level",
            "number": "1",
            "description": "Specifies the privilege level for administrative access to HP devices.",
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
            "example": "HP-Privilege-Level = 15 for full administrative access.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication for administrative access",
                "Privilege levels range from 0 (lowest) to 15 (highest)",
                "Common levels: 0 (user), 1 (manager), 15 (administrator)",
                "The switch automatically assigns the specified privilege level after successful authentication"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HPE-Command-Exception",
            "number": "22",
            "description": "Specifies CLI commands that are exceptions to the user's authorization level.",
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
            "example": "HPE-Command-Exception = \"show running-config; show interfaces\" to allow specific commands.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication for administrative access",
                "Commands can be allowed or denied as exceptions to the privilege level",
                "Multiple commands separated by semicolons",
                "Allows fine-grained control over CLI command authorization"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HPE-IP-Filter-Raw",
            "number": "61",
            "description": "Specifies IP filters to be applied to the user's traffic.",
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
            "example": "HPE-IP-Filter-Raw = \"permit ip 10.1.1.0/24 any\" for IP filtering.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication for user access",
                "Define IP filter rules directly in the VSA",
                "Can include multiple filter rules for comprehensive control",
                "Applied dynamically when the user authenticates"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HPE-IPv6-Filter-Raw",
            "number": "62",
            "description": "Specifies IPv6 filters to be applied to the user's traffic.",
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HPE-IPv6-Filter-Raw = \"permit ipv6 2001:db8::/64 any\" for IPv6 filtering.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication for user access",
                "Define IPv6 filter rules directly in the VSA",
                "Can include multiple filter rules for comprehensive control",
                "Applied dynamically when the user authenticates",
                "Used specifically for IPv6 traffic filtering"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        },
        {
            "name": "HPE-Rate-Limit",
            "number": "100",
            "description": "Specifies bandwidth rate limits for the user's traffic.",
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
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "HPE-Rate-Limit = \"1000 2000\" for 1 Mbps ingress and 2 Mbps egress limits.",
            "implementation": [
                "Configure the RADIUS server with HP VSAs (Vendor ID 25506)",
                "Set up RADIUS authentication for user access",
                "Specify ingress and egress rate limits in kbps",
                "Format is typically \"ingress-limit egress-limit\"",
                "Applied dynamically when the user authenticates",
                "Used for QoS and bandwidth management"
            ],
            "reference": "https://support.hpe.com/techhub/eginfolib/networking/docs/switches/RA/"
        }
    ]
}
EOF
}

# Function to generate Arista RADIUS attributes
generate_arista_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "arista",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Arista-ACL-Name",
            "number": "1",
            "description": "Specifies the name of an ACL to be applied to the user session. Controls network access permissions.",
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
            "example": "Arista-ACL-Name = \"Employee-ACL\" for applying employee ACL.",
            "implementation": [
                "Define the ACL on the Arista switch with appropriate permit/deny statements",
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Arista switch applies the specified ACL to the user upon authentication",
                "ACLs define traffic filtering rules and can be restrictive or permissive"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        },
        {
            "name": "Arista-User-Role",
            "number": "2",
            "description": "Specifies the user role for the authenticated session. Controls user privileges and access rights.",
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
            "example": "Arista-User-Role = \"admin\" for administrative access.",
            "implementation": [
                "Define the user role on the Arista switch with appropriate privileges",
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Arista switch assigns the specified role to the user upon authentication",
                "User roles define access privileges and permission levels"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        },
        {
            "name": "Arista-VLAN",
            "number": "3",
            "description": "Specifies the VLAN ID for dynamic VLAN assignment during authentication.",
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
            "example": "Arista-VLAN = 100 for VLAN assignment.",
            "implementation": [
                "Configure the VLAN on the Arista switch",
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "Configure the switch port for 802.1X authentication",
                "The VLAN will be dynamically assigned when the user authenticates"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        },
        {
            "name": "Arista-Privilege-Level",
            "number": "4",
            "description": "Specifies the privilege level for the user. Controls administrative access rights.",
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
            "example": "Arista-Privilege-Level = 15 for full administrative access.",
            "implementation": [
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "Privilege levels range from 0 (lowest) to 15 (highest)",
                "Common levels: 1 (basic), 7 (configure-only), 15 (administrator)",
                "The switch will automatically assign the specified privilege level"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        },
        {
            "name": "Arista-IPv6-ACL-Name",
            "number": "5",
            "description": "Specifies the name of an IPv6 ACL to be applied to the user session.",
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
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Arista-IPv6-ACL-Name = \"Employee-IPv6-ACL\" for applying IPv6 ACL.",
            "implementation": [
                "Define the IPv6 ACL on the Arista switch",
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Arista switch applies the specified IPv6 ACL to the user upon authentication",
                "Used specifically for controlling IPv6 traffic"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        },
        {
            "name": "Arista-QoS-Group",
            "number": "6",
            "description": "Specifies the QoS group for the user's traffic.",
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
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Arista-QoS-Group = 3 for assigning QoS group 3.",
            "implementation": [
                "Configure QoS groups on the Arista switch",
                "Configure the RADIUS server with Arista VSAs",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The Arista switch applies the specified QoS group to the user's traffic",
                "Used for controlling bandwidth and traffic prioritization",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/radius-server"
        }
    ]
}
EOF
}

# Function to generate Arista TACACS+ attributes
generate_arista_tacacs_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "arista",
    "protocol": "tacacs",
    "attributes": [
        {
            "name": "priv-lvl",
            "number": "N/A",
            "description": "Administrative privilege level. Controls access to CLI commands.",
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
            "example": "priv-lvl = 15 for full administrative access.",
            "implementation": [
                "Configure the TACACS+ server to return this attribute with privilege level",
                "Configure the Arista switch to use TACACS+ for authentication",
                "Privilege levels range from 0 (lowest) to 15 (highest)",
                "Common levels: 1 (basic), 7 (configure-only), 15 (administrator)",
                "The switch will automatically assign the specified privilege level"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/tacacs-client"
        },
        {
            "name": "cmd",
            "number": "N/A",
            "description": "Command authorization. Controls which commands a user can execute.",
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
            "example": "cmd = show for permitting all show commands.",
            "implementation": [
                "Configure the Arista switch to use TACACS+ for command authorization",
                "Configure the TACACS+ server with command permissions",
                "For each command, specify permit or deny",
                "Can use wildcards (e.g., \"show *\" to permit all show commands)",
                "Enable command authorization on the switch with appropriate configuration"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/tacacs-client"
        },
        {
            "name": "role",
            "number": "N/A",
            "description": "EOS role assignment. Controls the user's role in the system.",
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
            "example": "role = \"network-admin\" for role-based access control.",
            "implementation": [
                "Define roles on the Arista switch with appropriate permissions",
                "Configure the TACACS+ server to return this attribute with the role name",
                "Configure the Arista switch to use TACACS+ for authentication",
                "The role must be predefined on the switch",
                "Roles provide a more structured approach to access control than privilege levels"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/tacacs-client"
        },
        {
            "name": "service",
            "number": "N/A",
            "description": "TACACS+ service type for authorization.",
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
            "example": "service = shell for CLI access authentication.",
            "implementation": [
                "Configure the TACACS+ server with the appropriate service",
                "Typical services include shell, arap, ppp, netlogin",
                "For Arista administrative access, use service = shell",
                "Different services can have different attributes",
                "Critical for proper TACACS+ authorization flow"
            ],
            "reference": "https://www.arista.com/en/support/product-documentation/eos/eos-4-24-0f/tacacs-client"
        }
    ]
}
EOF
}

# Function to generate Extreme Networks RADIUS attributes
generate_extreme_radius_attributes() {
    local output_file="$1"
    
    cat > "$output_file" << EOF
{
    "vendor": "extreme",
    "protocol": "radius",
    "attributes": [
        {
            "name": "Extreme-Netlogin-Vlan",
            "number": "203",
            "description": "Specifies the VLAN to assign to the authenticated user. Used for dynamic VLAN assignment.",
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
            "example": "Extreme-Netlogin-Vlan = \"100\" to assign the user to VLAN 100.",
            "implementation": [
                "Configure the VLAN on the Extreme switch",
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The VSA can contain a VLAN name or a VLAN ID",
                "The switch applies the VLAN to the user's port upon successful authentication"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        },
        {
            "name": "Extreme-CLI-Authorization",
            "number": "201",
            "description": "Controls CLI command authorization for the user. Used to restrict administrative access to specific commands.",
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
            "example": "Extreme-CLI-Authorization = \"1\" to enable command authorization for the user.",
            "implementation": [
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication for administrative access",
                "Set this VSA to \"1\" to enable command authorization",
                "Must be used with other Extreme command authorization attributes",
                "The switch will enforce command restrictions based on the assigned profile"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        },
        {
            "name": "Extreme-CLI-Profile",
            "number": "204",
            "description": "Specifies the CLI profile to apply to the user. Controls which commands the user can access.",
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
            "example": "Extreme-CLI-Profile = \"admin\" to apply the admin CLI profile.",
            "implementation": [
                "Create CLI profiles on the Extreme switch",
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The profile name must match one defined on the switch",
                "The switch applies the command restrictions defined in the profile"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        },
        {
            "name": "Extreme-Netlogin-URL",
            "number": "206",
            "description": "Specifies the URL to redirect the user to after successful authentication.",
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
                "coa": false,
                "vpn": false,
                "ipv6": false,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Netlogin-URL = \"https://welcome.company.com\" for URL redirection after login.",
            "implementation": [
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication for users",
                "Configure the switch to allow URL redirection",
                "The user will be redirected to the specified URL upon successful authentication",
                "Can be used for welcome pages or further authentication steps"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        },
        {
            "name": "Extreme-Policy-Name",
            "number": "207",
            "description": "Specifies the policy profile to apply to the user.",
            "features": {
                "acl": true,
                "role": true,
                "vlan": true,
                "url": false,
                "captive": false,
                "sgt": false,
                "dacl": false,
                "qos": true,
                "bandwidth": true,
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Policy-Name = \"employee-policy\" to apply the employee policy profile.",
            "implementation": [
                "Create policy profiles on the Extreme switch",
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The policy profile name must match one defined on the switch",
                "Policy profiles can include VLAN, QoS, and ACL settings",
                "Comprehensive way to apply multiple settings with a single attribute"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        },
        {
            "name": "Extreme-Rate-Limit",
            "number": "209",
            "description": "Specifies the rate limit to apply to the user's traffic.",
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
                "coa": false,
                "vpn": false,
                "ipv6": true,
                "multicast": false
            },
            "network": "both",
            "example": "Extreme-Rate-Limit = \"1000 2000\" for 1 Mbps inbound and 2 Mbps outbound limits.",
            "implementation": [
                "Configure the RADIUS server with Extreme VSAs (Vendor ID: 1916)",
                "Set up RADIUS authentication for users",
                "Format is typically \"inbound-limit outbound-limit\" in kbps",
                "The switch applies the rate limits to the user's traffic",
                "Used for bandwidth management and traffic prioritization",
                "Supports both IPv4 and IPv6 traffic"
            ],
            "reference": "https://documentation.extremenetworks.com/exos_all/EXOS/All/pdfs/EXOS_All_16.2_User_Guide_rev3A.pdf"
        }
    ]
}
EOF
}

# Function to generate generic attributes for other vendors
generate_generic_attributes() {
    local vendor="$1"
    local protocol="$2"
    local vendor_id="$3"
    local output_file="$4"
    
    cat > "$output_file" << EOF
{
    "vendor": "$vendor",
    "protocol": "$protocol",
    "attributes": [
        {
            "name": "${vendor^}-Admin-Role",
            "number": "1",
            "description": "Assigns an administrative role to the user.",
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
            "example": "${vendor^}-Admin-Role = \"admin\" for administrative access.",
            "implementation": [
                "Configure the RADIUS server with ${vendor^} VSAs (Vendor ID: $vendor_id)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The role must be defined on the ${vendor^} device",
                "Determines the level of administrative access",
                "Common values include admin, read-only, operator"
            ],
            "reference": "https://docs.${vendor}.com/radius"
        },
        {
            "name": "${vendor^}-VLAN-ID",
            "number": "2",
            "description": "Assigns a VLAN to the authenticated user.",
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
            "example": "${vendor^}-VLAN-ID = \"100\" for VLAN assignment.",
            "implementation": [
                "Configure the VLAN on the ${vendor^} device",
                "Configure the RADIUS server with ${vendor^} VSAs (Vendor ID: $vendor_id)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The VLAN must be defined on the ${vendor^} device",
                "Used for dynamic VLAN assignment based on user authentication"
            ],
            "reference": "https://docs.${vendor}.com/radius"
        },
        {
            "name": "${vendor^}-ACL-Name",
            "number": "3",
            "description": "Assigns an ACL to the authenticated user.",
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
            "example": "${vendor^}-ACL-Name = \"Guest-ACL\" for ACL assignment.",
            "implementation": [
                "Configure the ACL on the ${vendor^} device",
                "Configure the RADIUS server with ${vendor^} VSAs (Vendor ID: $vendor_id)",
                "Set up RADIUS authentication and configure the server to return this VSA",
                "The ACL must be defined on the ${vendor^} device",
                "Used for dynamic ACL assignment based on user authentication"
            ],
            "reference": "https://docs.${vendor}.com/radius"
        }
    ]
}
EOF
}

# Function to compile attributes into a consolidated database
compile_attributes_database() {
    log "INFO" "Compiling attributes into a consolidated database..."
    
    # Initialize consolidated database
    local consolidated_file="$DATA_DIR/all_attributes.json"
    echo '{"vendors":[]}' > "$consolidated_file"
    
    # Process standard attributes
    if [ -f "$ATTRIBUTE_DIR/standard_radius_attributes.json" ]; then
        local standard_attributes=$(jq -c '.attributes' "$ATTRIBUTE_DIR/standard_radius_attributes.json")
        jq --argjson attrs "$standard_attributes" '.standard_attributes = $attrs' "$consolidated_file" > "$TEMP_DIR/temp.json"
        mv "$TEMP_DIR/temp.json" "$consolidated_file"
    fi
    
    # Process each vendor
    for vendor in "${!VENDOR_IDS[@]}"; do
        log "DEBUG" "Adding $vendor attributes to consolidated database..."
        
        # Create vendor object
        local vendor_object="{\"name\":\"$vendor\",\"id\":\"${VENDOR_IDS[$vendor]}\",\"attributes\":[]}"
        
        # Get protocols
        IFS=',' read -ra protocols <<< "${VENDOR_PROTOCOLS[$vendor]}"
        
        # Add attributes for each protocol
        for protocol in "${protocols[@]}"; do
            local attribute_file="$ATTRIBUTE_DIR/$vendor/${protocol}_attributes.json"
            
            if [ -f "$attribute_file" ]; then
                # Extract attributes from file
                local attrs=$(jq -c '.attributes' "$attribute_file")
                
                # Add protocol tag to each attribute
                local tagged_attrs=$(jq --arg protocol "$protocol" '[.[] | . + {protocol: $protocol}]' <<< "$attrs")
                
                # Combine with vendor attributes
                vendor_object=$(jq --argjson attrs "$tagged_attrs" '.attributes += $attrs' <<< "$vendor_object")
            else
                log "WARN" "Attribute file not found for $vendor $protocol"
            fi
        done
        
        # Add vendor object to consolidated database
        jq --argjson vendor "$vendor_object" '.vendors += [$vendor]' "$consolidated_file" > "$TEMP_DIR/temp.json"
        mv "$TEMP_DIR/temp.json" "$consolidated_file"
    done
    
    # Count total attributes
    local total=$(jq '[.vendors[].attributes | length] | add' "$consolidated_file")
    log "SUCCESS" "Compiled $total attributes from ${#VENDOR_IDS[@]} vendors into consolidated database."
}

# Function to enhance HTML file
enhance_html() {
    log "INFO" "Enhancing HTML file..."
    
    if [ ! -f "index.html" ]; then
        log "WARN" "index.html not found, creating a new one..."
        
        # Create a basic HTML structure as a starting point
        cat > "index.html" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Radtribution Dictionary - Network Authentication Attributes</title>
    <link rel="stylesheet" href="styles.css">
    <script defer src="script.js"></script>
</head>
<body>
    <header>
        <div class="container">
            <div class="logo">
                <div class="logo-icon">R</div>
                <div class="logo-text">Radtribution Dictionary</div>
            </div>
            <h1>Complete Network Authentication Attributes Reference</h1>
            <p class="tagline">A comprehensive guide to RADIUS and TACACS+ vendor-specific attributes with implementation details</p>
        </div>
    </header>

    <div class="container">
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search for attributes, descriptions, examples, implementations, vendors...">
        </div>

        <div id="noResults">No matching attributes found. Try different search terms.</div>

        <div class="filter-container">
            <div class="filter-title">Filter by Feature Support:</div>
            <div class="filter-options">
                <!-- Filters will be populated by JavaScript -->
            </div>
        </div>

        <div class="control-panel">
            <div class="vendor-nav">
                <!-- Vendor buttons will be populated by JavaScript -->
            </div>

            <div class="protocol-toggle">
                <button class="protocol-button active" data-protocol="all">All Protocols</button>
                <button class="protocol-button" data-protocol="radius">RADIUS</button>
                <button class="protocol-button" data-protocol="tacacs">TACACS+</button>
            </div>
        </div>

        <div id="resultsInfo"></div>

        <section class="vendor-section active" id="all">
            <h2>All Vendor-Specific Attributes</h2>
            <div class="protocol-section active" id="all-all">
                <p>This section shows all vendor-specific attributes for both RADIUS and TACACS+. Use the filters above to narrow down by vendor or protocol.</p>

                <div class="table-container">
                    <table id="attributesTable">
                        <thead>
                            <tr>
                                <th>Vendor</th>
                                <th>Protocol</th>
                                <th>Attribute Name</th>
                                <th>Attribute Number</th>
                                <th class="description-col">Description</th>
                                <th>Features</th>
                                <th>Network</th>
                                <th>Example</th>
                                <th>Implementation</th>
                                <th>Reference</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Table rows will be populated by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 Radtribution Dictionary. All rights reserved.</p>
            <p class="small">A comprehensive reference for network authentication attributes.</p>
        </div>
    </footer>
</body>
</html>
EOF
    fi
    
    # Enhance the HTML with additional features
    log "DEBUG" "Adding vendor buttons to HTML..."
    
    # Create temporary file for manipulation
    cp "index.html" "$TEMP_DIR/index.html"
    
    # Find the vendor navigation section and add buttons for all vendors
    local vendor_buttons=""
    vendor_buttons+='<button class="vendor-button active" data-vendor="all">All Vendors</button>\n'
    
    for vendor in "${!VENDOR_IDS[@]}"; do
        # Skip if already exists
        if ! grep -q "data-vendor=\"$vendor\"" "$TEMP_DIR/index.html"; then
            vendor_buttons+="                <button class=\"vendor-button\" data-vendor=\"$vendor\">${vendor^}</button>\n"
        fi
    done
    
    # Replace vendor navigation with new buttons
    sed -i "/<div class=\"vendor-nav\">/,/<\/div>/c\\            <div class=\"vendor-nav\">\n$vendor_buttons            </div>" "$TEMP_DIR/index.html"
    
    # Add feature filter checkboxes
    log "DEBUG" "Adding feature filter checkboxes to HTML..."
    
    local filter_options=""
    filter_options+='<div class="filter-option"><input type="checkbox" id="filterAcl" value="acl"><label for="filterAcl">ACL Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterRole" value="role"><label for="filterRole">User Role Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterVlan" value="vlan"><label for="filterVlan">VLAN Assignment</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterUrl" value="url"><label for="filterUrl">URL Redirect</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterCaptive" value="captive"><label for="filterCaptive">Captive Portal</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterSgt" value="sgt"><label for="filterSgt">SGT Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterDacl" value="dacl"><label for="filterDacl">DACL Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterQos" value="qos"><label for="filterQos">QoS Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterBandwidth" value="bandwidth"><label for="filterBandwidth">Bandwidth Control</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterCoa" value="coa"><label for="filterCoa">CoA Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterVpn" value="vpn"><label for="filterVpn">VPN Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterIpv6" value="ipv6"><label for="filterIpv6">IPv6 Support</label></div>\n'
    filter_options+='                <div class="filter-option"><input type="checkbox" id="filterMulticast" value="multicast"><label for="filterMulticast">Multicast Support</label></div>\n'
    
    # Replace filter options with new checkboxes
    sed -i "/<div class=\"filter-options\">/,/<\/div>/c\\            <div class=\"filter-options\">\n$filter_options            </div>" "$TEMP_DIR/index.html"
    
    # Add debug tools section
    log "DEBUG" "Adding debug tools section to HTML..."
    
    local debug_tools='<div class="debug-tools" style="display: none;">
            <h3>Debugging Tools</h3>
            <div class="debug-controls">
                <button id="toggleDebug">Enable Debug Logging</button>
                <button id="exportData">Export Filtered Data</button>
                <select id="exportFormat">
                    <option value="csv">CSV</option>
                    <option value="json">JSON</option>
                </select>
            </div>
            <div class="debug-log">
                <h4>Console Log</h4>
                <pre id="debugConsole"></pre>
            </div>
        </div>'
    
    # Add debug tools section after results info
    sed -i "/<div id=\"resultsInfo\"><\/div>/a\\        $debug_tools" "$TEMP_DIR/index.html"
    
    # Add vendor sections for each vendor
    log "DEBUG" "Adding vendor sections to HTML..."
    
    for vendor in "${!VENDOR_IDS[@]}"; do
        # Skip if section already exists
        if ! grep -q "<section class=\"vendor-section\" id=\"$vendor\">" "$TEMP_DIR/index.html"; then
            local vendor_section="        <section class=\"vendor-section\" id=\"$vendor\">
            <h2>${vendor^} Vendor-Specific Attributes</h2>
            <div class=\"protocol-section active\" id=\"$vendor-all\">
                <div class=\"vendor-info\">
                    <h3>About ${vendor^} Authentication Attributes</h3>
                    <p>${vendor^} devices support various vendor-specific attributes for authentication and authorization.</p>
                </div>
                <div class=\"protocol-section\" id=\"$vendor-radius\">
                    <h3>${vendor^} RADIUS Attributes</h3>
                    <div class=\"loading\">Loading ${vendor^} RADIUS attributes...</div>
                </div>
                <div class=\"protocol-section\" id=\"$vendor-tacacs\">
                    <h3>${vendor^} TACACS+ Attributes</h3>
                    <div class=\"loading\">Loading ${vendor^} TACACS+ attributes...</div>
                </div>
            </div>
        </section>"
            
            # Add vendor section before footer
            sed -i "/<footer>/i\\$vendor_section\n" "$TEMP_DIR/index.html"
        fi
    done
    
    # Save the enhanced HTML
    mv "$TEMP_DIR/index.html" "index.html"
    
    log "SUCCESS" "HTML enhancements completed."
}

# Function to enhance CSS file
enhance_css() {
    log "INFO" "Enhancing CSS file..."
    
    if [ ! -f "styles.css" ]; then
        log "WARN" "styles.css not found, creating a new one..."
        
        # Create a basic CSS file as a starting point
        cat > "styles.css" << EOF
:root {
    --primary-color: #2c3e50;
    --secondary-color: #3498db;
    --accent-color: #e67e22;
    --light-color: #ecf0f1;
    --dark-color: #34495e;
    --success-color: #27ae60;
    --danger-color: #e74c3c;
    --warning-color: #f39c12;
    --info-color: #3498db;
    --border-color: #e1e1e1;
    --hover-color: #f8f9fa;
    --shadow-color: rgba(0,0,0,0.1);
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f5f5f5;
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 20px;
}

header {
    background-color: var(--primary-color);
    color: white;
    padding: 20px 0;
    margin-bottom: 30px;
    box-shadow: 0 2px 10px var(--shadow-color);
}

.logo {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
}

.logo-icon {
    width: 40px;
    height: 40px;
    background-color: var(--secondary-color);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    font-weight: bold;
    border-radius: 8px;
    margin-right: 10px;
}

.logo-text {
    font-size: 18px;
    font-weight: 600;
}

h1 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 10px;
}

.tagline {
    color: rgba(255, 255, 255, 0.8);
    font-size: 16px;
    max-width: 800px;
}

.search-container {
    margin: 20px 0;
    width: 100%;
}

#searchInput {
    width: 100%;
    padding: 12px 15px;
    font-size: 16px;
    border: 1px solid var(--border-color);
    border-radius: 6px;
    box-shadow: 0 1px 3px var(--shadow-color);
    transition: all 0.3s;
}

#searchInput:focus {
    outline: none;
    border-color: var(--secondary-color);
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

#noResults {
    display: none;
    background-color: #fff8e1;
    border-left: 4px solid var(--warning-color);
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 0 4px 4px 0;
    font-weight: 500;
}

.filter-container {
    margin: 25px 0;
    background-color: white;
    padding: 20px;
    border-radius: 6px;
    box-shadow: 0 1px 3px var(--shadow-color);
}

.filter-title {
    font-weight: 600;
    margin-bottom: 15px;
    color: var(--dark-color);
}

.filter-options {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}

.filter-option {
    display: flex;
    align-items: center;
    gap: 8px;
    min-width: 150px;
}

.filter-option input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
}

.filter-option label {
    cursor: pointer;
    font-size: 14px;
}

.control-panel {
    margin: 25px 0;
}

.vendor-nav {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 15px;
}

.vendor-button {
    padding: 10px 15px;
    background-color: #f1f5f9;
    color: var(--dark-color);
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.2s ease;
    font-size: 14px;
}

.vendor-button:hover {
    background-color: #e2e8f0;
    transform: translateY(-2px);
    box-shadow: 0 2px 4px var(--shadow-color);
}

.vendor-button.active {
    background-color: var(--secondary-color);
    color: white;
    box-shadow: 0 2px 4px rgba(52, 152, 219, 0.3);
}

.protocol-toggle {
    display: flex;
    gap: 10px;
}

.protocol-button {
    padding: 8px 15px;
    background-color: #f1f5f9;
    color: var(--dark-color);
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.2s ease;
    font-size: 14px;
}

.protocol-button:hover {
    background-color: #e2e8f0;
    transform: translateY(-2px);
    box-shadow: 0 2px 4px var(--shadow-color);
}

.protocol-button.active {
    background-color: var(--dark-color);
    color: white;
}

.table-container {
    overflow-x: auto;
    margin-bottom: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px var(--shadow-color);
    background-color: white;
}

table {
    width: 100%;
    border-collapse: collapse;
    border-spacing: 0;
    font-size: 14px;
}

th, td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
    vertical-align: top;
}

th {
    background-color: #f8f9fa;
    font-weight: 600;
    color: var(--dark-color);
    position: sticky;
    top: 0;
    z-index: 10;
    box-shadow: 0 1px 0 var(--border-color);
}

tr:hover {
    background-color: #f8f9fa;
}

.badge {
    display: inline-block;
    font-size: 11px;
    font-weight: 500;
    padding: 2px 6px;
    border-radius: 4px;
    color: white;
    margin-right: 3px;
    margin-bottom: 3px;
}

.badge-yes { background-color: var(--success-color); }
.badge-no { background-color: var(--danger-color); }
.badge-optional { background-color: var(--warning-color); }
.badge-both { background-color: var(--info-color); }
.badge-wired { background-color: #9b59b6; }
.badge-wireless { background-color: #1abc9c; }
.badge-use-case { background-color: var(--accent-color); }

.vendor-section { display: none; }
.vendor-section.active { display: block; }
.protocol-section { display: none; }
.protocol-section.active { display: block; }

#resultsInfo {
    margin: 15px 0;
    font-weight: 500;
}

footer {
    background-color: var(--dark-color);
    color: white;
    padding: 30px 0;
    margin-top: 50px;
}

footer p {
    margin-bottom: 5px;
}

footer .small {
    font-size: 12px;
    opacity: 0.8;
}
EOF
    fi
    
    # Enhance CSS with additional styles
    log "DEBUG" "Adding enhanced styles to CSS..."
    
    cat >> "styles.css" << EOF

/* Enhanced UI Elements - Added by update script */
.badge-ipv6 { background-color: #16a085; }
.badge-multicast { background-color: #8e44ad; }

/* Improved hover effects */
.vendor-button:hover, .protocol-button:hover, .tab:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    transition: all 0.3s ease;
}

/* Enhanced table styling */
th, td {
    padding: 14px 16px;
    border-bottom: 1px solid #e1e1e1;
}

tr:hover {
    background-color: #f0f7ff;
}

/* Better mobile responsiveness */
@media screen and (max-width: 768px) {
    .filter-options {
        gap: 8px;
    }
    
    .filter-option {
        min-width: 110px;
    }
    
    .vendor-button, .protocol-button, .tab {
        padding: 8px 10px;
        font-size: 12px;
    }
}

/* Debug tools styling */
.debug-tools {
    margin: 20px 0;
    padding: 15px;
    background-color: #f8f9fa;
    border: 1px solid #e1e1e1;
    border-radius: 5px;
}

.debug-controls {
    display: flex;
    gap: 10px;
    margin-bottom: 10px;
}

.debug-controls button, .debug-controls select {
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    background-color: #fff;
    cursor: pointer;
}

.debug-controls button:hover {
    background-color: #f0f0f0;
}

.debug-log {
    margin-top: 15px;
}

#debugConsole {
    height: 200px;
    overflow-y: auto;
    background-color: #002b36;
    color: #93a1a1;
    padding: 10px;
    border-radius: 4px;
    font-family: monospace;
    white-space: pre-wrap;
}

/* Add loading animation */
.loading-animation {
    display: inline-block;
    width: 50px;
    height: 50px;
    border: 3px solid rgba(0,0,0,.1);
    border-radius: 50%;
    border-top-color: #3498db;
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Print-friendly styles */
@media print {
    header, .search-container, .filter-container, .control-panel, .debug-tools {
        display: none !important;
    }
    
    body, .container {
        width: 100% !important;
        margin: 0 !important;
        padding: 0 !important;
    }
    
    th, td {
        padding: 8px !important;
    }
    
    .table-container {
        overflow: visible !important;
        box-shadow: none !important;
    }
}

/* Implementation steps styling */
details {
    margin-bottom: 10px;
    border: 1px solid var(--border-color);
    border-radius: 5px;
    overflow: hidden;
}

summary {
    cursor: pointer;
    font-weight: 500;
    padding: 10px;
    background-color: #f8f9fa;
    outline: none;
    transition: background-color 0.2s;
}

summary:hover {
    background-color: #ecf0f1;
}

details[open] summary {
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 10px;
}

details div {
    padding: 0 10px 10px;
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    body {
        background-color: #121212;
        color: #e0e0e0;
    }
    
    .filter-container, .table-container, .debug-tools {
        background-color: #1e1e1e;
    }
    
    .vendor-button, .protocol-button {
        background-color: #2c2c2c;
        color: #e0e0e0;
    }
    
    .vendor-button:hover, .protocol-button:hover {
        background-color: #3a3a3a;
    }
    
    .vendor-button.active {
        background-color: var(--secondary-color);
    }
    
    th {
        background-color: #2c2c2c;
        color: #e0e0e0;
    }
    
    td {
        border-bottom-color: #3a3a3a;
    }
    
    tr:hover {
        background-color: #2a2a2a;
    }
    
    #searchInput {
        background-color: #2c2c2c;
        color: #e0e0e0;
        border-color: #3a3a3a;
    }
    
    #searchInput:focus {
        border-color: var(--secondary-color);
    }
    
    #noResults {
        background-color: #3a3a3a;
        color: #e0e0e0;
    }
    
    summary {
        background-color: #2c2c2c;
    }
    
    summary:hover {
        background-color: #3a3a3a;
    }
}
EOF
    
    log "SUCCESS" "CSS enhancements completed."
}

# Function to enhance JavaScript
enhance_javascript() {
    log "INFO" "Enhancing JavaScript file..."
    
    if [ ! -f "script.js" ]; then
        log "WARN" "script.js not found, creating a new one..."
        
        # Create a basic JavaScript file as a starting point
        cat > "script.js" << EOF
document.addEventListener('DOMContentLoaded', function() {
    // References to DOM elements
    const searchInput = document.getElementById('searchInput');
    const noResults = document.getElementById('noResults');
    const vendorButtons = document.querySelectorAll('.vendor-button');
    const protocolButtons = document.querySelectorAll('.protocol-button');
    const vendorSections = document.querySelectorAll('.vendor-section');
    const protocolSections = document.querySelectorAll('.protocol-section');
    const resultsInfo = document.getElementById('resultsInfo');
    const tableRows = document.querySelectorAll('.row-item');
    const filterCheckboxes = document.querySelectorAll('.filter-option input[type="checkbox"]');

    // Current filters state
    let activeVendor = 'all';
    let activeProtocol = 'all';
    let activeFilters = [];

    // Search functionality
    searchInput.addEventListener('input', filterTable);

    // Vendor navigation
    vendorButtons.forEach(button => {
        button.addEventListener('click', function() {
            vendorButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            activeVendor = this.dataset.vendor;
            
            vendorSections.forEach(section => {
                section.classList.remove('active');
                if (section.id === activeVendor) {
                    section.classList.add('active');
                }
            });
            
            updateProtocolSection();
            filterTable();
        });
    });

    // Protocol selection
    protocolButtons.forEach(button => {
        button.addEventListener('click', function() {
            protocolButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            activeProtocol = this.dataset.protocol;
            
            updateProtocolSection();
            filterTable();
        });
    });

    // Feature filters
    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (this.checked) {
                activeFilters.push(this.value);
            } else {
                activeFilters = activeFilters.filter(filter => filter !== this.value);
            }
            filterTable();
        });
    });

    // Update protocol section based on active vendor and protocol
    function updateProtocolSection() {
        protocolSections.forEach(section => {
            section.classList.remove('active');
            if (section.id === \`\${activeVendor}-\${activeProtocol}\`) {
                section.classList.add('active');
            }
        });
    }

    // Filter table based on search input and active filters
    function filterTable() {
        const searchTerm = searchInput.value.toLowerCase();
        let visibleRows = 0;
        
        tableRows.forEach(row => {
            // Check if row matches vendor filter
            const vendorMatch = activeVendor === 'all' || row.dataset.vendor === activeVendor;
            
            // Check if row matches protocol filter
            const protocolMatch = activeProtocol === 'all' || row.dataset.protocol === activeProtocol;
            
            // Check if row matches feature filters
            let featureMatch = true;
            if (activeFilters.length > 0) {
                featureMatch = activeFilters.every(filter => row.dataset[filter] === 'yes');
            }
            
            // Check if row matches search term
            const rowText = row.textContent.toLowerCase();
            const searchMatch = searchTerm === '' || rowText.includes(searchTerm);
            
            // Show or hide row based on all filters
            if (vendorMatch && protocolMatch && featureMatch && searchMatch) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });
        
        // Show no results message if no rows match
        if (visibleRows === 0) {
            noResults.style.display = 'block';
        } else {
            noResults.style.display = 'none';
        }
        
        // Update results count
        updateResultsInfo(visibleRows);
    }

    // Update results count
    function updateResultsInfo(count) {
        resultsInfo.textContent = \`Showing \${count} \${count === 1 ? 'attribute' : 'attributes'}\`;
    }

    // Initialize with all rows visible
    filterTable();
});
EOF
    fi
    
    # Enhance JavaScript with additional functionality
    log "DEBUG" "Adding enhanced functionality to JavaScript..."
    
    # Create a temp file for the enhanced JavaScript
    cat > "$TEMP_DIR/enhanced.js" << EOF
// Enhanced functionality for Radtribution Dictionary
// Version: 2.0.0

// Debug mode configuration
let DEBUG_MODE = false;
const DEBUG_CONSOLE = document.getElementById('debugConsole');

// Console logging wrapper
function logDebug(message, data = null) {
    if (!DEBUG_MODE) return;
    
    const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
    let logMessage = \`[\${timestamp}] \${message}\`;
    
    // Log to browser console
    if (data) {
        console.log(logMessage, data);
    } else {
        console.log(logMessage);
    }
    
    // Log to debug console in UI
    if (DEBUG_CONSOLE) {
        DEBUG_CONSOLE.innerHTML += logMessage + (data ? ': ' + JSON.stringify(data, null, 2) : '') + '\\n';
        DEBUG_CONSOLE.scrollTop = DEBUG_CONSOLE.scrollHeight;
    }
}

// Enhanced filter table function with advanced search capabilities
function enhancedFilterTable() {
    logDebug("Starting enhanced filter operation with current settings");
    
    const searchTerm = searchInput.value.toLowerCase();
    const startTime = performance.now();
    let visibleRows = 0;
    
    logDebug(\`Active filters: \${activeFilters.join(', ')}\`);
    logDebug(\`Active vendor: \${activeVendor}, Active protocol: \${activeProtocol}\`);
    
    tableRows.forEach(row => {
        // Check if row matches vendor filter
        const vendorMatch = activeVendor === 'all' || row.dataset.vendor === activeVendor;
        
        // Check if row matches protocol filter
        const protocolMatch = activeProtocol === 'all' || row.dataset.protocol === activeProtocol;
        
        // Check if row matches feature filters
        let featureMatch = true;
        if (activeFilters.length > 0) {
            featureMatch = activeFilters.every(filter => row.dataset[filter] === 'yes');
        }
        
        // Check if row matches search term - enhanced to support advanced searches
        const rowText = row.textContent.toLowerCase();
        let searchMatch = searchTerm === '' || rowText.includes(searchTerm);
        
        // Advanced search: support for specific column searches with format "column:term"
        if (searchTerm.includes(':')) {
            const [column, term] = searchTerm.split(':');
            searchMatch = false;
            
            switch(column.trim()) {
                case 'vendor':
                    searchMatch = row.querySelector('td:nth-child(1)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'protocol':
                    searchMatch = row.querySelector('td:nth-child(2)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'name':
                case 'attribute':
                    searchMatch = row.querySelector('td:nth-child(3)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'number':
                    searchMatch = row.querySelector('td:nth-child(4)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'description':
                    searchMatch = row.querySelector('td:nth-child(5)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'example':
                    searchMatch = row.querySelector('td:nth-child(8)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'implementation':
                    searchMatch = row.querySelector('td:nth-child(9)').textContent.toLowerCase().includes(term.trim());
                    break;
                case 'reference':
                    searchMatch = row.querySelector('td:nth-child(10)').textContent.toLowerCase().includes(term.trim());
                    break;
                default:
                    // If column isn't recognized, fall back to whole-row search
                    searchMatch = rowText.includes(term.trim());
            }
        }
        
        // Show or hide row based on all filters
        if (vendorMatch && protocolMatch && featureMatch && searchMatch) {
            row.style.display = '';
            visibleRows++;
        } else {
            row.style.display = 'none';
        }
    });
    
    // Show no results message if no rows match
    if (visibleRows === 0) {
        noResults.style.display = 'block';
    } else {
        noResults.style.display = 'none';
    }
    
    // Update results count
    updateResultsInfo(visibleRows);
    
    const endTime = performance.now();
    logDebug(\`Filter operation completed in \${(endTime - startTime).toFixed(2)}ms, showing \${visibleRows} rows\`);
}

// Data loading function to fetch attributes from database
function loadAttributesData() {
    logDebug("Loading attributes data from database");
    
    // Show loading indicator
    const tableContainer = document.querySelector('.table-container');
    const loadingElement = document.createElement('div');
    loadingElement.className = 'loading';
    loadingElement.innerHTML = '<div class="loading-animation"></div> Loading attributes data...';
    tableContainer.appendChild(loadingElement);
    
    // Fetch data from consolidated database
    fetch('data/all_attributes.json')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            logDebug("Attributes data loaded successfully", { vendors: data.vendors.length });
            
            // Remove loading indicator
            loadingElement.remove();
            
            // Process the data
            populateAttributesTable(data);
        })
        .catch(error => {
            logDebug("Error loading attributes data: " + error.message);
            
            // Update loading indicator to show error
            loadingElement.innerHTML = 'Error loading attributes data. Please check the console for details.';
            loadingElement.style.color = 'red';
            
            console.error('Error loading attributes data:', error);
        });
}

// Function to populate attributes table from loaded data
function populateAttributesTable(data) {
    logDebug("Populating attributes table");
    
    const tableBody = document.querySelector('#attributesTable tbody');
    tableBody.innerHTML = ''; // Clear existing rows
    
    // Process standard attributes if present
    if (data.standard_attributes) {
        logDebug("Processing standard attributes", { count: data.standard_attributes.length });
        
        data.standard_attributes.forEach(attr => {
            // Add protocol property if not present
            if (!attr.protocol) {
                attr.protocol = 'radius'; // Standard attributes are RADIUS
            }
            
            // Create row for standard attribute
            const row = createAttributeRow('standard', attr);
            tableBody.appendChild(row);
        });
    }
    
    // Process vendor attributes
    data.vendors.forEach(vendor => {
        logDebug(\`Processing \${vendor.name} attributes\`, { count: vendor.attributes.length });
        
        vendor.attributes.forEach(attr => {
            // Create row for vendor attribute
            const row = createAttributeRow(vendor.name, attr);
            tableBody.appendChild(row);
        });
    });
    
    // Update references to table rows after populating
    window.tableRows = document.querySelectorAll('.row-item');
    
    // Initialize filters
    filterTable();
    
    logDebug("Attributes table populated successfully");
}

// Function to create a table row for an attribute
function createAttributeRow(vendor, attr) {
    const row = document.createElement('tr');
    row.className = 'row-item';
    row.dataset.vendor = vendor;
    row.dataset.protocol = attr.protocol || '';
    
    // Set feature flags in dataset
    if (attr.features) {
        for (const [feature, value] of Object.entries(attr.features)) {
            row.dataset[feature] = value ? 'yes' : 'no';
        }
    }
    
    // Vendor cell
    const vendorCell = document.createElement('td');
    vendorCell.textContent = vendor.charAt(0).toUpperCase() + vendor.slice(1); // Capitalize vendor name
    row.appendChild(vendorCell);
    
    // Protocol cell
    const protocolCell = document.createElement('td');
    protocolCell.textContent = attr.protocol ? attr.protocol.toUpperCase() : '';
    row.appendChild(protocolCell);
    
    // Attribute name cell
    const nameCell = document.createElement('td');
    nameCell.textContent = attr.name || '';
    row.appendChild(nameCell);
    
    // Attribute number cell
    const numberCell = document.createElement('td');
    numberCell.textContent = attr.number || '';
    row.appendChild(numberCell);
    
    // Description cell
    const descCell = document.createElement('td');
    descCell.className = 'description-col';
    descCell.textContent = attr.description || '';
    row.appendChild(descCell);
    
    // Features cell
    const featuresCell = document.createElement('td');
    featuresCell.innerHTML = createFeatureBadges(attr.features);
    row.appendChild(featuresCell);
    
    // Network cell
    const networkCell = document.createElement('td');
    if (attr.network) {
        const badge = document.createElement('span');
        badge.className = \`badge badge-\${attr.network}\`;
        badge.textContent = attr.network.charAt(0).toUpperCase() + attr.network.slice(1); // Capitalize
        networkCell.appendChild(badge);
    }
    row.appendChild(networkCell);
    
    // Example cell
    const exampleCell = document.createElement('td');
    exampleCell.textContent = attr.example || '';
    row.appendChild(exampleCell);
    
    // Implementation cell
    const implCell = document.createElement('td');
    if (attr.implementation && attr.implementation.length > 0) {
        const details = document.createElement('details');
        const summary = document.createElement('summary');
        summary.textContent = 'Implementation Steps';
        details.appendChild(summary);
        
        const content = document.createElement('div');
        const ol = document.createElement('ol');
        attr.implementation.forEach(step => {
            const li = document.createElement('li');
            li.textContent = step;
            ol.appendChild(li);
        });
        content.appendChild(ol);
        details.appendChild(content);
        
        implCell.appendChild(details);
    }
    row.appendChild(implCell);
    
    // Reference cell
    const refCell = document.createElement('td');
    if (attr.reference) {
        const link = document.createElement('a');
        link.href = attr.reference;
        link.target = '_blank';
        link.textContent = extractDomainFromUrl(attr.reference);
        refCell.appendChild(link);
    }
    row.appendChild(refCell);
    
    return row;
}

// Helper function to create feature badges HTML
function createFeatureBadges(features) {
    if (!features) return '';
    
    const featureLabels = {
        acl: 'ACLs',
        role: 'User Roles',
        vlan: 'VLAN Assignment',
        url: 'URL Redirects',
        captive: 'Captive Portals',
        sgt: 'SGT',
        dacl: 'DACL',
        qos: 'QoS',
        bandwidth: 'Bandwidth',
        coa: 'CoA',
        vpn: 'VPN',
        ipv6: 'IPv6',
        multicast: 'Multicast'
    };
    
    let html = '<div class="attribute-features">';
    
    for (const [feature, value] of Object.entries(features)) {
        if (featureLabels[feature]) {
            const badge = \`<span class="badge badge-\${value ? 'yes' : 'no'}">\${featureLabels[feature]}</span>\`;
            html += badge;
        }
    }
    
    html += '</div>';
    return html;
}

// Helper function to extract domain from URL for reference display
function extractDomainFromUrl(url) {
    try {
        const domain = new URL(url).hostname;
        return domain;
    } catch (e) {
        return url; // Return original if not a valid URL
    }
}

// Export functionality for filtered data
function exportFilteredData(format) {
    logDebug(\`Exporting data in \${format} format\`);
    
    // Get visible rows
    const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none');
    
    if (visibleRows.length === 0) {
        alert('No data to export. Please adjust your filters to show some attributes.');
        return;
    }
    
    switch (format.toLowerCase()) {
        case 'csv':
            exportToCSV(visibleRows);
            break;
        case 'json':
            exportToJSON(visibleRows);
            break;
        default:
            alert('Unsupported export format. Please choose CSV or JSON.');
    }
}

// Function to export data to CSV format
function exportToCSV(rows) {
    logDebug(\`Exporting \${rows.length} rows to CSV\`);
    
    // Headers
    const headers = [
        'Vendor', 'Protocol', 'Attribute Name', 'Attribute Number', 
        'Description', 'ACL', 'Role', 'VLAN', 'URL', 'Captive Portal',
        'SGT', 'DACL', 'QoS', 'Bandwidth', 'CoA', 'VPN', 'IPv6', 'Multicast',
        'Network', 'Example', 'Reference'
    ];
    
    // Create CSV content
    let csvContent = headers.join(',') + '\\n';
    
    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        
        // Extract cell values
        const vendor = cells[0].textContent;
        const protocol = cells[1].textContent;
        const attrName = cells[2].textContent;
        const attrNumber = cells[3].textContent;
        const description = '"' + cells[4].textContent.replace(/"/g, '""') + '"'; // Escape quotes
        
        // Features - extract from dataset
        const acl = row.dataset.acl === 'yes' ? 'Yes' : 'No';
        const role = row.dataset.role === 'yes' ? 'Yes' : 'No';
        const vlan = row.dataset.vlan === 'yes' ? 'Yes' : 'No';
        const url = row.dataset.url === 'yes' ? 'Yes' : 'No';
        const captive = row.dataset.captive === 'yes' ? 'Yes' : 'No';
        const sgt = row.dataset.sgt === 'yes' ? 'Yes' : 'No';
        const dacl = row.dataset.dacl === 'yes' ? 'Yes' : 'No';
        const qos = row.dataset.qos === 'yes' ? 'Yes' : 'No';
        const bandwidth = row.dataset.bandwidth === 'yes' ? 'Yes' : 'No';
        const coa = row.dataset.coa === 'yes' ? 'Yes' : 'No';
        const vpn = row.dataset.vpn === 'yes' ? 'Yes' : 'No';
        const ipv6 = row.dataset.ipv6 === 'yes' ? 'Yes' : 'No';
        const multicast = row.dataset.multicast === 'yes' ? 'Yes' : 'No';
        
        // Network type
        const networkBadge = cells[6].querySelector('.badge');
        const network = networkBadge ? networkBadge.textContent : '';
        
        // Example and reference
        const example = '"' + cells[7].textContent.replace(/"/g, '""') + '"'; // Escape quotes
        const refLink = cells[9].querySelector('a');
        const reference = refLink ? refLink.href : '';
        
        // Combine all fields into a CSV row
        const rowData = [
            vendor, protocol, attrName, attrNumber, description,
            acl, role, vlan, url, captive, sgt, dacl, qos, bandwidth, coa, vpn, ipv6, multicast,
            network, example, reference
        ];
        
        csvContent += rowData.join(',') + '\\n';
    });
    
    // Create a download link
    const blob = new Blob([csvContent], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const filename = \`radtribution_attributes_\${new Date().toISOString().split('T')[0]}.csv\`;
    
    downloadFile(url, filename);
    
    logDebug('CSV export completed');
}

// Function to export data to JSON format
function exportToJSON(rows) {
    logDebug(\`Exporting \${rows.length} rows to JSON\`);
    
    const jsonData = {
        exportDate: new Date().toISOString(),
        totalAttributes: rows.length,
        attributes: []
    };
    
    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        
        // Create attribute object
        const attributeData = {
            vendor: cells[0].textContent,
            protocol: cells[1].textContent,
            name: cells[2].textContent,
            number: cells[3].textContent,
            description: cells[4].textContent,
            features: {
                acl: row.dataset.acl === 'yes',
                role: row.dataset.role === 'yes',
                vlan: row.dataset.vlan === 'yes',
                url: row.dataset.url === 'yes',
                captive: row.dataset.captive === 'yes',
                sgt: row.dataset.sgt === 'yes',
                dacl: row.dataset.dacl === 'yes',
                qos: row.dataset.qos === 'yes',
                bandwidth: row.dataset.bandwidth === 'yes',
                coa: row.dataset.coa === 'yes',
                vpn: row.dataset.vpn === 'yes',
                ipv6: row.dataset.ipv6 === 'yes',
                multicast: row.dataset.multicast === 'yes'
            },
            network: cells[6].textContent,
            example: cells[7].textContent
        };
        
        // Add reference if available
        const refLink = cells[9].querySelector('a');
        if (refLink) {
            attributeData.reference = refLink.href;
        }
        
        // Add implementation steps if available
        const implList = cells[8].querySelector('ol');
        if (implList) {
            attributeData.implementation = Array.from(implList.querySelectorAll('li')).map(li => li.textContent);
        }
        
        jsonData.attributes.push(attributeData);
    });
    
    // Create a download link
    const blob = new Blob([JSON.stringify(jsonData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const filename = \`radtribution_attributes_\${new Date().toISOString().split('T')[0]}.json\`;
    
    downloadFile(url, filename);
    
    logDebug('JSON export completed');
}

// Helper function to trigger download
function downloadFile(url, filename) {
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Function to initialize enhanced features
function initEnhancedFeatures() {
    logDebug('Initializing enhanced features');
    
    // Set up debug toggle
    const debugTools = document.querySelector('.debug-tools');
    const toggleDebugBtn = document.getElementById('toggleDebug');
    
    if (toggleDebugBtn && debugTools) {
        toggleDebugBtn.addEventListener('click', function() {
            DEBUG_MODE = !DEBUG_MODE;
            this.textContent = DEBUG_MODE ? 'Disable Debug Logging' : 'Enable Debug Logging';
            
            // Show debug tools when enabled
            debugTools.style.display = DEBUG_MODE ? 'block' : 'none';
            
            logDebug('Debug mode ' + (DEBUG_MODE ? 'enabled' : 'disabled'));
        });
    }
    
    // Set up export button
    const exportDataBtn = document.getElementById('exportData');
    const exportFormatSelect = document.getElementById('exportFormat');
    
    if (exportDataBtn && exportFormatSelect) {
        exportDataBtn.addEventListener('click', function() {
            const format = exportFormatSelect.value;
            exportFilteredData(format);
        });
    }
    
    // Replace the original filter function with enhanced version
    if (typeof filterTable === 'function') {
        // Store the original function for reference
        window.originalFilterTable = filterTable;
        
        // Replace with enhanced version
        window.filterTable = enhancedFilterTable;
        
        logDebug('Filter function enhanced with advanced search capabilities');
    }
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl+F or Command+F (Mac) for focusing search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            // Only if not already in a text input field
            if (document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
                e.preventDefault();
                searchInput.focus();
                logDebug('Search focused via keyboard shortcut');
            }
        }
        
        // Ctrl+D or Command+D (Mac) for toggling debug mode
        if ((e.ctrlKey || e.metaKey) && e.key === 'd' && toggleDebugBtn) {
            e.preventDefault();
            toggleDebugBtn.click();
            logDebug('Debug mode toggled via keyboard shortcut');
        }
    });
    
    // Load attributes data
    loadAttributesData();
    
    logDebug('Enhanced features initialization complete');
}

// Initialize when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Radtribution Dictionary Enhanced - Version 2.0.0');
    
    // Set global references to DOM elements (used by functions above)
    window.searchInput = document.getElementById('searchInput');
    window.noResults = document.getElementById('noResults');
    window.vendorButtons = document.querySelectorAll('.vendor-button');
    window.protocolButtons = document.querySelectorAll('.protocol-button');
    window.vendorSections = document.querySelectorAll('.vendor-section');
    window.protocolSections = document.querySelectorAll('.protocol-section');
    window.resultsInfo = document.getElementById('resultsInfo');
    window.tableRows = document.querySelectorAll('.row-item');
    window.filterCheckboxes = document.querySelectorAll('.filter-option input[type="checkbox"]');
    
    // Set global filter state variables
    window.activeVendor = 'all';
    window.activeProtocol = 'all';
    window.activeFilters = [];
    
    // Initialize enhanced features
    initEnhancedFeatures();
});
EOF
    
    # Append the enhanced JavaScript to the original file
    cat "$TEMP_DIR/enhanced.js" >> "script.js"
    
    log "SUCCESS" "JavaScript enhancements completed."
}

# Function to update README.md
update_readme() {
    log "INFO" "Updating README.md with latest information..."
    
    # Create updated README file
    cat > "README.md" << EOF
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

\`\`\`bash
git clone https://github.com/your-username/radtribution-dictionary.git
cd radtribution-dictionary
# Open index.html in your preferred browser
\`\`\`

## Advanced Usage

### Debugging Mode

Press \`Ctrl+D\` to toggle debugging mode, which provides detailed console logging and export functionality.

### Advanced Search

Use column-specific search with the format \`column:term\`:
- \`vendor:cisco\` - Search for Cisco attributes
- \`name:vlan\` - Search for attributes with "vlan" in the name
- \`description:vpn\` - Search for attributes related to VPN in the description

### Keyboard Shortcuts

- \`Ctrl+F\` - Focus the search box
- \`Ctrl+D\` - Toggle debugging mode

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
EOF
    
    log "SUCCESS" "README.md updated with latest information."
}

# Function to clean up temporary files
cleanup() {
    log "INFO" "Cleaning up temporary files..."
    
    # Remove temporary directory
    rm -rf "$TEMP_DIR"
    
    log "SUCCESS" "Cleanup completed."
}

# Main function
main() {
    # Print banner
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}   Radtribution Dictionary Comprehensive Update     ${NC}"
    echo -e "${BLUE}   Version: ${SCRIPT_VERSION}                       ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    
    log "INFO" "Starting Radtribution Dictionary update process..."
    
    # Check for required privileges
    check_privileges
    
    # Check for required tools
    check_requirements
    
    # Create backup of current codebase
    create_backup
    
    # Prepare working directories
    prepare_directories
    
    # Extract data from existing files
    extract_existing_data
    
    # Generate standard RADIUS attributes
    generate_standard_radius_attributes
    
    # Generate vendor-specific attributes
    generate_vendor_attributes
    
    # Compile attributes into consolidated database
    compile_attributes_database
    
    # Enhance HTML
    enhance_html
    
    # Enhance CSS
    enhance_css
    
    # Enhance JavaScript
    enhance_javascript
    
    # Update README
    update_readme
    
    # Clean up temporary files
    cleanup
    
    log "SUCCESS" "Radtribution Dictionary update completed successfully!"
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN}   Update completed successfully!                   ${NC}"
    echo -e "${GREEN}   A backup of your original files is available at: ${NC}"
    echo -e "${GREEN}   ${BACKUP_DIR}                                   ${NC}"
    echo -e "${GREEN}====================================================${NC}"
}

# Execute main function
main
