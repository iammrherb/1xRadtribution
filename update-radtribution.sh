
#!/bin/bash

# Update index.html with more readable design
cat > "index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1Xer Radtribution - The Hitch Hiker's Guide to Vendor Specific Attributes</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Source+Code+Pro:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #dc2626;
            --accent-color: #0891b2;
            --success-color: #16a34a;
            --warning-color: #d97706;
            --bg-dark: #0f172a;
            --bg-light: #1e293b;
            --text-light: #e2e8f0;
            --text-dark: #f8fafc;
            --card-bg: #1e293b;
            --border-color: #334155;
        }

        [data-theme="light"] {
            --bg-dark: #ffffff;
            --bg-light: #f8fafc;
            --text-light: #1e293b;
            --text-dark: #0f172a;
            --card-bg: #ffffff;
            --border-color: #e2e8f0;
            --primary-color: #2563eb;
            --secondary-color: #dc2626;
            --accent-color: #0891b2;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-light);
            line-height: 1.6;
            transition: all 0.3s ease;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            padding: 40px 20px;
            background: var(--bg-light);
            border-radius: 12px;
            margin-bottom: 40px;
            border: 1px solid var(--border-color);
        }

        .main-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .subtitle {
            font-size: 1.25rem;
            color: var(--text-light);
            margin-bottom: 20px;
            font-weight: 500;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            width: 44px;
            height: 44px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .theme-toggle:hover {
            background: var(--primary-color);
            color: white;
        }

        .search-section {
            margin-bottom: 40px;
        }

        .search-box {
            width: 100%;
            padding: 14px 20px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .search-box:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .vendor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 60px;
        }

        .vendor-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 24px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .vendor-card:hover {
            transform: translateY(-2px);
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .vendor-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 12px;
            display: block;
        }

        .vendor-card h3 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .protocol-links {
            display: flex;
            gap: 12px;
            margin-top: 16px;
        }

        .protocol-link {
            flex: 1;
            padding: 10px 16px;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
        }

        .protocol-link:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .workflow-section {
            margin: 60px 0;
            padding: 32px;
            background: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .workflow-section h2 {
            font-size: 1.75rem;
            color: var(--primary-color);
            margin-bottom: 24px;
            text-align: center;
            font-weight: 600;
        }

        .workflow-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 24px;
        }

        .workflow-item {
            background: var(--bg-dark);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .workflow-item:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .workflow-item i {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 12px;
            display: block;
            text-align: center;
        }

        .workflow-item h4 {
            color: var(--text-dark);
            margin-bottom: 8px;
            text-align: center;
            font-weight: 600;
        }

        .workflow-item p {
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 24px;
        }

        .feature-item {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .feature-item:hover {
            border-color: var(--primary-color);
            transform: translateY(-1px);
        }

        .feature-item i {
            font-size: 1.5rem;
            color: var(--accent-color);
            margin-bottom: 12px;
            display: block;
        }

        .feature-item h4 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .footer {
            text-align: center;
            padding: 40px 20px;
            margin-top: 60px;
            border-top: 1px solid var(--border-color);
            color: var(--text-light);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: var(--card-bg);
            padding: 32px;
            border-radius: 12px;
            max-width: 900px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
            border: 1px solid var(--border-color);
        }

        .close-modal {
            position: absolute;
            top: 16px;
            right: 16px;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-light);
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .close-modal:hover {
            background: var(--bg-light);
            color: var(--primary-color);
        }

        .diagram-container {
            margin: 20px 0;
            text-align: center;
            background: var(--bg-dark);
            padding: 20px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .diagram-container svg {
            max-width: 100%;
            height: auto;
        }

        .code-block {
            background: var(--bg-dark);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 16px;
            margin: 16px 0;
            overflow-x: auto;
            font-family: 'Source Code Pro', monospace;
            font-size: 0.9rem;
        }

        .code-block code {
            color: var(--accent-color);
            white-space: pre;
            display: block;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-title {
                font-size: 2rem;
            }
            
            .subtitle {
                font-size: 1.1rem;
            }
            
            .vendor-grid, .workflow-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <button class="theme-toggle" onclick="toggleTheme()">
        <i class="fas fa-moon"></i>
    </button>

    <div class="container">
        <div class="header">
            <h1 class="main-title">1Xer Radtribution</h1>
            <p class="subtitle">The Hitch Hiker's Guide to Vendor Specific Attributes</p>
            <p>Your comprehensive reference for RADIUS and TACACS+ authentication attributes</p>
        </div>

        <div class="search-section">
            <input type="text" class="search-box" placeholder="Search for vendors..." id="searchBox">
        </div>

        <div class="vendor-grid" id="vendorGrid">
            <!-- Vendors will be populated here by JavaScript -->
        </div>

        <div class="workflow-section">
            <h2><i class="fas fa-network-wired"></i> Authentication Workflows</h2>
            <div class="workflow-grid">
                <div class="workflow-item" onclick="showWorkflow('radius-eap')">
                    <i class="fas fa-shield-alt"></i>
                    <h4>802.1X EAP</h4>
                    <p>Complete EAP-TLS/PEAP flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('tacacs-admin')">
                    <i class="fas fa-user-shield"></i>
                    <h4>TACACS+ Admin</h4>
                    <p>Device administration flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('vlan-assignment')">
                    <i class="fas fa-project-diagram"></i>
                    <h4>Dynamic VLAN</h4>
                    <p>VLAN assignment process</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('dacl')">
                    <i class="fas fa-filter"></i>
                    <h4>Dynamic ACL</h4>
                    <p>Downloadable ACL flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('guest-portal')">
                    <i class="fas fa-door-open"></i>
                    <h4>Guest Portal</h4>
                    <p>Web authentication flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('mab-profiling')">
                    <i class="fas fa-fingerprint"></i>
                    <h4>MAB & Profiling</h4>
                    <p>Device identification</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('coa-process')">
                    <i class="fas fa-sync"></i>
                    <h4>Change of Auth</h4>
                    <p>CoA/Disconnect flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('qos-bandwidth')">
                    <i class="fas fa-tachometer-alt"></i>
                    <h4>QoS/Bandwidth</h4>
                    <p>Traffic management</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('sgt-trustsec')">
                    <i class="fas fa-tag"></i>
                    <h4>SGT/TrustSec</h4>
                    <p>Security group tagging</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('posture-assessment')">
                    <i class="fas fa-heartbeat"></i>
                    <h4>Posture/NAC</h4>
                    <p>Endpoint compliance</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('vpn-auth')">
                    <i class="fas fa-key"></i>
                    <h4>VPN Auth</h4>
                    <p>Remote access flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('iot-auth')">
                    <i class="fas fa-microchip"></i>
                    <h4>IoT Authentication</h4>
                    <p>IoT device onboarding</p>
                </div>
            </div>
        </div>

        <div class="workflow-section">
            <h2><i class="fas fa-star"></i> Features</h2>
            <div class="feature-grid">
                <div class="feature-item">
                    <i class="fas fa-building"></i>
                    <h4>Multi-Vendor Support</h4>
                    <p>Complete coverage of major network vendors with detailed VSA documentation.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-code-branch"></i>
                    <h4>Protocol Coverage</h4>
                    <p>Both RADIUS and TACACS+ protocols with implementation examples.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-search"></i>
                    <h4>Advanced Search</h4>
                    <p>Quickly find attributes by name, feature, or description.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-book"></i>
                    <h4>Implementation Guides</h4>
                    <p>Detailed configuration examples and best practices.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-download"></i>
                    <h4>CSV Export</h4>
                    <p>Export attribute data for documentation and analysis.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-moon"></i>
                    <h4>Dark/Light Mode</h4>
                    <p>Comfortable viewing in any environment.</p>
                </div>
            </div>
        </div>

        <div class="footer">
            <p><i class="fas fa-rocket"></i> 1Xer Radtribution | Generated on <span id="genDate"></span></p>
            <p style="margin-top: 10px;">Comprehensive AAA reference for network engineers</p>
        </div>
    </div>

    <!-- Workflow Modal -->
    <div class="modal" id="workflowModal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeModal()">&times;</span>
            <div id="modalContent"></div>
        </div>
    </div>

    <script>
        // Theme toggle
        function toggleTheme() {
            const body = document.body;
            const themeToggle = document.querySelector('.theme-toggle i');
            
            if (body.getAttribute('data-theme') === 'light') {
                body.removeAttribute('data-theme');
                themeToggle.className = 'fas fa-moon';
                localStorage.setItem('theme', 'dark');
            } else {
                body.setAttribute('data-theme', 'light');
                themeToggle.className = 'fas fa-sun';
                localStorage.setItem('theme', 'light');
            }
        }

        // Check for saved theme
        if (localStorage.getItem('theme') === 'light') {
            document.body.setAttribute('data-theme', 'light');
            document.querySelector('.theme-toggle i').className = 'fas fa-sun';
        }

        // Generate date
        document.getElementById('genDate').textContent = new Date().toLocaleDateString();

        // Vendor icons mapping
        const vendorIcons = {
            'cisco': 'fas fa-network-wired',
            'juniper': 'fas fa-tree',
            'aruba': 'fas fa-wifi',
            'fortinet': 'fas fa-shield-alt',
            'paloalto': 'fas fa-fire',
            'hp': 'fas fa-h-square',
            'extreme': 'fas fa-mountain',
            'dell': 'fas fa-laptop',
            'meraki': 'fas fa-cloud',
            'ruckus': 'fas fa-broadcast-tower',
            'checkpoint': 'fas fa-check-circle',
            'sonicwall': 'fas fa-wall-brick',
            'f5': 'fas fa-server',
            'huawei': 'fas fa-globe-asia',
            'microsoftnas': 'fab fa-microsoft',
            'zyxel': 'fas fa-ethernet',
            'watchguard': 'fas fa-eye',
            'standard': 'fas fa-book'
        };

        // Load vendors
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
                        
                        const icon = vendorIcons[vendor.id] || 'fas fa-cube';
                        
                        const protocols = vendor.protocols.map(protocol => 
                            `<a href="viewer.html?vendor=${vendor.id}&protocol=${protocol}" class="protocol-link">
                                ${protocol.toUpperCase()}
                            </a>`
                        ).join('');
                        
                        card.innerHTML = `
                            <i class="${icon} vendor-icon"></i>
                            <h3>${vendor.name}</h3>
                            <p>View ${vendor.name} authentication attributes</p>
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

        // Enhanced workflow diagrams
        const workflows = {
            'radius-eap': {
                title: '802.1X EAP Authentication Flow',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 800" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .flow-label { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 12px; }
                                .section-box { fill: none; stroke: var(--border-color); stroke-width: 1; stroke-dasharray: 5,5; }
                            </style>
                            <defs>
                                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--primary-color)" />
                                </marker>
                            </defs>
                            
                            <!-- Supplicant -->
                            <rect x="50" y="100" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="135" text-anchor="middle" class="flow-text">Supplicant</text>
                            <text x="110" y="150" text-anchor="middle" class="flow-text" font-size="12">(Client)</text>
                            
                            <!-- Authenticator -->
                            <rect x="350" y="100" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="410" y="135" text-anchor="middle" class="flow-text">Authenticator</text>
                            <text x="410" y="150" text-anchor="middle" class="flow-text" font-size="12">(Switch)</text>
                            
                            <!-- RADIUS Server -->
                            <rect x="650" y="100" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="135" text-anchor="middle" class="flow-text">RADIUS</text>
                            <text x="710" y="150" text-anchor="middle" class="flow-text" font-size="12">(AAA Server)</text>
                            
                            <!-- Phase 1: Initiation -->
                            <rect x="40" y="200" width="740" height="150" class="section-box" rx="5"/>
                            <text x="410" y="220" text-anchor="middle" class="flow-text" font-weight="bold">Phase 1: Initiation</text>
                            
                            <path d="M110 250 L350 250" class="flow-arrow"/>
                            <text x="230" y="240" text-anchor="middle" class="flow-label">1. EAPOL-Start</text>
                            
                            <path d="M350 270 L110 270" class="flow-arrow"/>
                            <text x="230" y="260" text-anchor="middle" class="flow-label">2. EAP-Request/Identity</text>
                            
                            <path d="M110 290 L350 290" class="flow-arrow"/>
                            <text x="230" y="280" text-anchor="middle" class="flow-label">3. EAP-Response/Identity</text>
                            
                            <path d="M470 290 L650 290" class="flow-arrow"/>
                            <text x="560" y="280" text-anchor="middle" class="flow-label">4. Access-Request</text>
                            <text x="560" y="300" text-anchor="middle" class="flow-label" font-size="10">(User-Name, NAS-IP, NAS-Port)</text>
                            
                            <!-- Phase 2: Challenge -->
                            <rect x="40" y="370" width="740" height="200" class="section-box" rx="5"/>
                            <text x="410" y="390" text-anchor="middle" class="flow-text" font-weight="bold">Phase 2: Challenge/Authentication</text>
                            
                            <path d="M650 420 L470 420" class="flow-arrow"/>
                            <text x="560" y="410" text-anchor="middle" class="flow-label">5. Access-Challenge</text>
                            <text x="560" y="430" text-anchor="middle" class="flow-label" font-size="10">(EAP-Message)</text>
                            
                            <path d="M350 440 L110 440" class="flow-arrow"/>
                            <text x="230" y="430" text-anchor="middle" class="flow-label">6. EAP-Request</text>
                            
                            <path d="M110 460 L350 460" class="flow-arrow"/>
                            <text x="230" y="450" text-anchor="middle" class="flow-label">7. EAP-Response</text>
                            
                            <path d="M470 460 L650 460" class="flow-arrow"/>
                            <text x="560" y="450" text-anchor="middle" class="flow-label">8. Access-Request</text>
                            
                            <text x="410" y="510" text-anchor="middle" class="flow-text" font-style="italic">Multiple challenge-response exchanges</text>
                            <text x="410" y="530" text-anchor="middle" class="flow-text" font-style="italic">(PEAP/EAP-TLS/EAP-TTLS)</text>
                            
                            <!-- Phase 3: Success -->
                            <rect x="40" y="590" width="740" height="150" class="section-box" rx="5"/>
                            <text x="410" y="610" text-anchor="middle" class="flow-text" font-weight="bold">Phase 3: Success/Authorization</text>
                            
                            <path d="M650 640 L470 640" class="flow-arrow"/>
                            <text x="560" y="630" text-anchor="middle" class="flow-label">9. Access-Accept</text>
                            <text x="560" y="650" text-anchor="middle" class="flow-label" font-size="10">(VSAs: VLAN, ACL, QoS)</text>
                            
                            <path d="M350 670 L110 670" class="flow-arrow"/>
                            <text x="230" y="660" text-anchor="middle" class="flow-label">10. EAP-Success</text>
                            
                            <path d="M350 700 L350 720" class="flow-arrow"/>
                            <text x="350" y="735" text-anchor="middle" class="flow-label" font-size="10">Port Authorized</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Switch Configuration (Cisco)
interface GigabitEthernet0/1
 switchport mode access
 switchport access vlan 999
 authentication port-control auto
 authentication host-mode multi-auth
 authentication order dot1x mab
 authentication priority dot1x mab
 authentication event fail action next-method
 authentication event server dead action authorize vlan 999
 authentication event server alive action reinitialize
 dot1x pae authenticator
 dot1x timeout quiet-period 300
 dot1x timeout tx-period 10
 mab

! RADIUS Server Configuration
radius server ISE
 address ipv4 10.1.1.100 auth-port 1812 acct-port 1813
 key cisco123
 
aaa authentication dot1x default group ISE
aaa authorization network default group ISE
aaa accounting dot1x default start-stop group ISE

! RADIUS Access-Accept VSAs
User-Name = "john.doe@company.com"
Tunnel-Type = VLAN (13)
Tunnel-Medium-Type = IEEE-802 (6)
Tunnel-Private-Group-ID = "100"
Filter-Id = "Employee_ACL"
Cisco-AVPair = "ip:sub-qos-policy-in=EMPLOYEE_QOS"
Session-Timeout = 28800
Termination-Action = RADIUS-Request</code>
                    </div>
                    <div class="code-block">
                        <code>! Advanced EAP Configuration Examples
! EAP-TLS with Machine Authentication
eap profile EAP_TLS_PROFILE
 method tls
 
! PEAP with MSCHAPv2
eap profile PEAP_PROFILE
 method peap
 peap-method mschapv2
 
! EAP Chaining (User and Machine)
authentication policy POLICY1
 identity-group user-and-machine
 certificate-group CERT_GROUP
 
! Fast Reconnect/Session Resume
dot1x credentials MACHINE
 username host/machine.company.com
 pki-trustpoint MACHINE_CERT</code>
                    </div>
                `
            },
            'tacacs-admin': {
                title: 'TACACS+ Device Administration Flow',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 1000" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .flow-label { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 12px; }
                                .section-box { fill: none; stroke: var(--border-color); stroke-width: 1; stroke-dasharray: 5,5; }
                            </style>
                            
                            <!-- Admin -->
                            <rect x="50" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="85" text-anchor="middle" class="flow-text">Admin User</text>
                            
                            <!-- Network Device -->
                            <rect x="350" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="410" y="85" text-anchor="middle" class="flow-text">Network Device</text>
                            
                            <!-- TACACS+ Server -->
                            <rect x="650" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="85" text-anchor="middle" class="flow-text">TACACS+</text>
                            
                            <!-- Authentication Phase -->
                            <rect x="40" y="140" width="740" height="200" class="section-box" rx="5"/>
                            <text x="410" y="160" text-anchor="middle" class="flow-text" font-weight="bold">Phase 1: Authentication</text>
                            
                            <path d="M170 190 L350 190" class="flow-arrow"/>
                            <text x="260" y="180" text-anchor="middle" class="flow-label">1. Login Attempt</text>
                            
                            <path d="M470 190 L650 190" class="flow-arrow"/>
                            <text x="560" y="180" text-anchor="middle" class="flow-label">2. START (Auth)</text>
                            <text x="560" y="200" text-anchor="middle" class="flow-label" font-size="10">Type: ASCII/PAP/CHAP</text>
                            
                            <path d="M650 220 L470 220" class="flow-arrow"/>
                            <text x="560" y="210" text-anchor="middle" class="flow-label">3. REPLY (Username)</text>
                            
                            <path d="M470 250 L650 250" class="flow-arrow"/>
                            <text x="560" y="240" text-anchor="middle" class="flow-label">4. CONTINUE</text>
                            <text x="560" y="260" text-anchor="middle" class="flow-label" font-size="10">(Username)</text>
                            
                            <path d="M650 280 L470 280" class="flow-arrow"/>
                            <text x="560" y="270" text-anchor="middle" class="flow-label">5. REPLY (Password)</text>
                            
                            <path d="M470 310 L650 310" class="flow-arrow"/>
                            <text x="560" y="300" text-anchor="middle" class="flow-label">6. CONTINUE</text>
                            <text x="560" y="320" text-anchor="middle" class="flow-label" font-size="10">(Password)</text>
                            
                            <!-- Authorization Phase -->
                            <rect x="40" y="360" width="740" height="180" class="section-box" rx="5"/>
                            <text x="410" y="380" text-anchor="middle" class="flow-text" font-weight="bold">Phase 2: Authorization</text>
                            
                            <path d="M470 410 L650 410" class="flow-arrow"/>
                            <text x="560" y="400" text-anchor="middle" class="flow-label">7. REQUEST</text>
                            <text x="560" y="420" text-anchor="middle" class="flow-label" font-size="10">service=shell</text>
                            
                            <path d="M650 450 L470 450" class="flow-arrow"/>
                            <text x="560" y="440" text-anchor="middle" class="flow-label">8. RESPONSE</text>
                            <text x="560" y="460" text-anchor="middle" class="flow-label" font-size="10">priv-lvl=15</text>
                            <text x="560" y="475" text-anchor="middle" class="flow-label" font-size="10">shell:roles="network-admin"</text>
                            
                            <path d="M350 500 L110 500" class="flow-arrow"/>
                            <text x="230" y="490" text-anchor="middle" class="flow-label">9. Access Granted</text>
                            <text x="230" y="510" text-anchor="middle" class="flow-label" font-size="10">Privilege Level 15</text>
                            
                            <!-- Command Authorization -->
                            <rect x="40" y="560" width="740" height="280" class="section-box" rx="5"/>
                            <text x="410" y="580" text-anchor="middle" class="flow-text" font-weight="bold">Phase 3: Command Authorization</text>
                            
                            <path d="M170 620 L350 620" class="flow-arrow"/>
                            <text x="260" y="610" text-anchor="middle" class="flow-label">10. Command: "show run"</text>
                            
                            <path d="M470 620 L650 620" class="flow-arrow"/>
                            <text x="560" y="610" text-anchor="middle" class="flow-label">11. REQUEST</text>
                            <text x="560" y="630" text-anchor="middle" class="flow-label" font-size="10">cmd=show cmd-arg=run</text>
                            
                            <path d="M650 660 L470 660" class="flow-arrow"/>
                            <text x="560" y="650" text-anchor="middle" class="flow-label">12. RESPONSE</text>
                            <text x="560" y="670" text-anchor="middle" class="flow-label" font-size="10">Status: PASS</text>
                            
                            <path d="M350 700 L110 700" class="flow-arrow"/>
                            <text x="230" y="690" text-anchor="middle" class="flow-label">13. Execute Command</text>
                            
                            <path d="M170 750 L350 750" class="flow-arrow"/>
                            <text x="260" y="740" text-anchor="middle" class="flow-label">14. Command: "conf t"</text>
                            
                            <path d="M470 750 L650 750" class="flow-arrow"/>
                            <text x="560" y="740" text-anchor="middle" class="flow-label">15. REQUEST</text>
                            <text x="560" y="760" text-anchor="middle" class="flow-label" font-size="10">cmd=configure cmd-arg=terminal</text>
                            
                            <path d="M650 790 L470 790" class="flow-arrow"/>
                            <text x="560" y="780" text-anchor="middle" class="flow-label">16. RESPONSE</text>
                            <text x="560" y="800" text-anchor="middle" class="flow-label" font-size="10">Status: PASS/FAIL</text>
                            
                            <!-- Accounting Phase -->
                            <rect x="40" y="860" width="740" height="100" class="section-box" rx="5"/>
                            <text x="410" y="880" text-anchor="middle" class="flow-text" font-weight="bold">Phase 4: Accounting</text>
                            
                            <path d="M470 910 L650 910" class="flow-arrow"/>
                            <text x="560" y="900" text-anchor="middle" class="flow-label">17. Accounting Start/Update/Stop</text>
                            <text x="560" y="920" text-anchor="middle" class="flow-label" font-size="10">Commands executed, session info</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Cisco TACACS+ Configuration
aaa new-model
aaa authentication login default group tacacs+ local
aaa authentication enable default group tacacs+ enable
aaa authorization exec default group tacacs+ local
aaa authorization commands 15 default group tacacs+ local
aaa accounting exec default start-stop group tacacs+
aaa accounting commands 15 default start-stop group tacacs+

tacacs server ISE
 address ipv4 10.1.1.100
 key 0 cisco123
 timeout 5
 single-connection

! Command Authorization Examples
! Network Admin Profile (TACACS+ Server)
user = john.doe {
    login = cleartext "password123"
    service = shell {
        set priv-lvl = 15
        shell:roles="network-admin"
        cmd = show {
            permit .*
        }
        cmd = configure {
            permit terminal
        }
        cmd = interface {
            permit .*
        }
        cmd = no {
            permit shutdown
            deny .*
        }
    }
}

! Read-Only Profile
user = read.only {
    login = cleartext "readonly123"
    service = shell {
        set priv-lvl = 1
        shell:roles="network-operator"
        cmd = show {
            permit .*
        }
        cmd = * {
            deny .*
        }
    }
}</code>
                    </div>
                    <div class="code-block">
                        <code>! Advanced TACACS+ Features
! Custom Shell Profiles
username admin-shell
 privilege exec level 15
 autocommand show tech-support | redirect tftp://10.1.1.5/tech.txt

! Command Authorization with Regex
cmd = interface {
    permit "GigabitEthernet[0-9]/0/([1-9]|1[0-9]|2[0-4])$"
    deny "GigabitEthernet[0-9]/0/(25|2[6-9]|[3-9][0-9])$"
}

! Time-Based Access
time-range BUSINESS-HOURS
 periodic weekdays 08:00 to 18:00
 
username contractor
 access-class 10 in
 time-range BUSINESS-HOURS</code>
                    </div>
                `
            },
            'vlan-assignment': {
                title: 'Dynamic VLAN Assignment Process',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 700" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .vlan-box { fill: var(--bg-light); stroke: var(--accent-color); stroke-width: 2; stroke-dasharray: 5,5; }
                            </style>
                            
                            <!-- VLANs -->
                            <rect x="50" y="50" width="180" height="80" class="vlan-box" rx="5"/>
                            <text x="140" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Guest VLAN 10</text>
                            <text x="140" y="100" text-anchor="middle" class="flow-text" font-size="12">Unauthenticated</text>
                            <text x="140" y="115" text-anchor="middle" class="flow-text" font-size="12">Internet Only</text>
                            
                            <rect x="260" y="50" width="180" height="80" class="vlan-box" rx="5"/>
                            <text x="350" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Employee VLAN 20</text>
                            <text x="350" y="100" text-anchor="middle" class="flow-text" font-size="12">Full Access</text>
                            <text x="350" y="115" text-anchor="middle" class="flow-text" font-size="12">Corp Resources</text>
                            
                            <rect x="470" y="50" width="180" height="80" class="vlan-box" rx="5"/>
                            <text x="560" y="80" text-anchor="middle" class="flow-text" font-weight="bold">IoT VLAN 30</text>
                            <text x="560" y="100" text-anchor="middle" class="flow-text" font-size="12">Restricted</text>
                            <text x="560" y="115" text-anchor="middle" class="flow-text" font-size="12">Isolated</text>
                            
                            <rect x="680" y="50" width="180" height="80" class="vlan-box" rx="5"/>
                            <text x="770" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Voice VLAN 40</text>
                            <text x="770" y="100" text-anchor="middle" class="flow-text" font-size="12">QoS Priority</text>
                            <text x="770" y="115" text-anchor="middle" class="flow-text" font-size="12">VoIP Only</text>
                            
                            <!-- Flow Diagram -->
                            <rect x="100" y="200" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="160" y="235" text-anchor="middle" class="flow-text">Client Device</text>
                            
                            <rect x="350" y="200" width="200" height="60" class="flow-box" rx="5"/>
                            <text x="450" y="225" text-anchor="middle" class="flow-text">Switch Port</text>
                            <text x="450" y="245" text-anchor="middle" class="flow-text" font-size="12">Initial VLAN: Guest (10)</text>
                            
                            <rect x="650" y="200" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="235" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <!-- Authentication Flow -->
                            <path d="M220 230 L350 230" class="flow-arrow"/>
                            <text x="285" y="220" text-anchor="middle" class="flow-label">1. Connect</text>
                            
                            <path d="M550 230 L650 230" class="flow-arrow"/>
                            <text x="600" y="220" text-anchor="middle" class="flow-label">2. 802.1X/MAB</text>
                            
                            <!-- Decision Flow -->
                            <rect x="600" y="300" width="220" height="120" class="flow-box" rx="5"/>
                            <text x="710" y="330" text-anchor="middle" class="flow-text" font-weight="bold">Authentication Decision</text>
                            <text x="710" y="355" text-anchor="middle" class="flow-text" font-size="12">User: john.doe</text>
                            <text x="710" y="375" text-anchor="middle" class="flow-text" font-size="12">Group: Employees</text>
                            <text x="710" y="395" text-anchor="middle" class="flow-text" font-size="12">Device: Corporate Laptop</text>
                            
                            <path d="M650 250 L600 300" class="flow-arrow"/>
                            
                            <!-- VLAN Assignment -->
                            <path d="M600 360 L550 360" class="flow-arrow"/>
                            <text x="575" y="350" text-anchor="middle" class="flow-label">3. Access-Accept</text>
                            
                            <rect x="350" y="320" width="200" height="80" class="flow-box" rx="5"/>
                            <text x="450" y="345" text-anchor="middle" class="flow-text" font-weight="bold">RADIUS VSAs</text>
                            <text x="450" y="365" text-anchor="middle" class="flow-text" font-size="12">Tunnel-Type = VLAN</text>
                            <text x="450" y="380" text-anchor="middle" class="flow-text" font-size="12">Tunnel-Private-Group = "20"</text>
                            
                            <path d="M350 360 L220 360" class="flow-arrow"/>
                            <text x="285" y="350" text-anchor="middle" class="flow-label">4. VLAN Change</text>
                            
                            <!-- Result -->
                            <rect x="100" y="440" width="450" height="60" class="flow-box" rx="5"/>
                            <text x="325" y="465" text-anchor="middle" class="flow-text" font-weight="bold">Port Configuration Updated</text>
                            <text x="325" y="485" text-anchor="middle" class="flow-text" font-size="12">VLAN changed from 10 (Guest) to 20 (Employee)</text>
                            
                            <!-- Alternative Flows -->
                            <rect x="600" y="480" width="220" height="140" class="flow-box" rx="5"/>
                            <text x="710" y="505" text-anchor="middle" class="flow-text" font-weight="bold">Other Scenarios</text>
                            <text x="710" y="530" text-anchor="middle" class="flow-text" font-size="12">• MAC Bypass → IoT VLAN 30</text>
                            <text x="710" y="550" text-anchor="middle" class="flow-text" font-size="12">• Voice Device → Voice VLAN 40</text>
                            <text x="710" y="570" text-anchor="middle" class="flow-text" font-size="12">• Failed Auth → Guest VLAN 10</text>
                            <text x="710" y="590" text-anchor="middle" class="flow-text" font-size="12">• Critical VLAN → Emergency 99</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Switch Port Configuration for Dynamic VLAN
interface GigabitEthernet1/0/1
 description Dynamic VLAN Assignment Port
 switchport mode access
 switchport access vlan 10 ! Default/Guest VLAN
 authentication port-control auto
 authentication host-mode multi-auth
 authentication order dot1x mab
 authentication priority dot1x mab
 authentication event fail action next-method
 authentication event server dead action authorize vlan 999
 authentication event server alive action reinitialize
 authentication event no-response action authorize vlan 10
 authentication violation restrict
 mab
 dot1x pae authenticator
 dot1x timeout quiet-period 60
 dot1x timeout tx-period 10
 spanning-tree portfast

! VLAN Configuration
vlan 10
 name GUEST_VLAN
vlan 20  
 name EMPLOYEE_VLAN
vlan 30
 name IOT_VLAN
vlan 40
 name VOICE_VLAN
vlan 999
 name CRITICAL_AUTH_VLAN

! RADIUS Configuration
radius server ISE
 address ipv4 10.1.1.100 auth-port 1812 acct-port 1813
 key cisco123
 
aaa authentication dot1x default group ISE
aaa authorization network default group ISE  
aaa accounting dot1x default start-stop group ISE</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS Server Response Examples
! Employee Authentication
Access-Accept
  User-Name = "john.doe@company.com"
  Tunnel-Type:0 = VLAN
  Tunnel-Medium-Type:0 = IEEE-802
  Tunnel-Private-Group-ID:0 = "20"
  Filter-Id = "Employee_ACL"
  Cisco-AVPair = "device-traffic-class=voice"
  
! IoT Device (MAC Bypass)
Access-Accept
  User-Name = "001122334455"
  Tunnel-Type:0 = VLAN
  Tunnel-Medium-Type:0 = IEEE-802  
  Tunnel-Private-Group-ID:0 = "30"
  Filter-Id = "IOT_RESTRICT_ACL"
  Session-Timeout = 3600
  
! Guest User with Redirect
Access-Accept
  User-Name = "guest-user"
  Tunnel-Type:0 = VLAN
  Tunnel-Medium-Type:0 = IEEE-802
  Tunnel-Private-Group-ID:0 = "10"
  Cisco-AVPair = "url-redirect-acl=GUEST_REDIRECT"
  Cisco-AVPair = "url-redirect=https://guest.company.com"
  
! Voice Device
Access-Accept
  User-Name = "SEP001122334455"
  Tunnel-Type:0 = VLAN
  Tunnel-Medium-Type:0 = IEEE-802
  Tunnel-Private-Group-ID:0 = "40"
  Cisco-AVPair = "device-traffic-class=voice"
  Cisco-AVPair = "interface-template=VOICE_TEMPLATE"</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting Commands
show authentication sessions
show authentication sessions interface gi1/0/1 details
show dot1x all details
show vlan brief
show interfaces switchport
debug radius authentication
debug dot1x all
debug authentication all

! Common Issues and Solutions
! 1. VLAN doesn't exist on switch
! Solution: Create VLAN before assignment

! 2. VLAN name vs ID mismatch  
! Solution: Use VLAN ID or ensure name matches exactly

! 3. RADIUS timeout
! Solution: Increase timeout, check connectivity

! 4. Multi-auth vs single-host mode
! Solution: Use appropriate host-mode for environment</code>
                    </div>
                `
            },
            'dacl': {
                title: 'Dynamic/Downloadable ACL Implementation',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 800" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .acl-rule { fill: var(--bg-light); stroke: var(--accent-color); stroke-width: 1; }
                                .deny-rule { fill: #fee2e2; stroke: #dc2626; }
                                .permit-rule { fill: #dcfce7; stroke: #16a34a; }
                            </style>
                            
                            <!-- Components -->
                            <rect x="50" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="85" text-anchor="middle" class="flow-text">User Device</text>
                            
                            <rect x="300" y="50" width="200" height="60" class="flow-box" rx="5"/>
                            <text x="400" y="85" text-anchor="middle" class="flow-text">Switch/Controller</text>
                            
                            <rect x="650" y="50" width="150" height="60" class="flow-box" rx="5"/>
                            <text x="725" y="85" text-anchor="middle" class="flow-text">RADIUS Server</text>
                            
                            <!-- Authentication Flow -->
                            <path d="M170 80 L300 80" class="flow-arrow"/>
                            <text x="235" y="70" text-anchor="middle" class="flow-label">1. Connect</text>
                            
                            <path d="M500 80 L650 80" class="flow-arrow"/>
                            <text x="575" y="70" text-anchor="middle" class="flow-label">2. Auth Request</text>
                            
                            <!-- dACL Response -->
                            <rect x="600" y="150" width="250" height="200" class="flow-box" rx="5"/>
                            <text x="725" y="180" text-anchor="middle" class="flow-text" font-weight="bold">RADIUS Response</text>
                            <text x="725" y="205" text-anchor="middle" class="flow-text" font-size="12">Access-Accept with dACL</text>
                            <text x="725" y="230" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "ip:inacl#1=..."</text>
                            <text x="725" y="250" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "ip:inacl#2=..."</text>
                            <text x="725" y="270" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "ip:inacl#3=..."</text>
                            <text x="725" y="290" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "ip:inacl#4=..."</text>
                            <text x="725" y="310" text-anchor="middle" class="flow-text" font-size="11">Filter-Id = "Employee_ACL"</text>
                            
                            <path d="M600 250 L500 250" class="flow-arrow"/>
                            <text x="550" y="240" text-anchor="middle" class="flow-label">3. dACL Download</text>
                            
                            <!-- ACL Application -->
                            <rect x="250" y="180" width="300" height="300" class="flow-box" rx="5"/>
                            <text x="400" y="210" text-anchor="middle" class="flow-text" font-weight="bold">Dynamic ACL Applied</text>
                            
                            <!-- ACL Rules -->
                            <rect x="270" y="230" width="260" height="30" class="permit-rule" rx="3"/>
                            <text x="400" y="250" text-anchor="middle" class="flow-text" font-size="12">permit tcp any any eq 80</text>
                            
                            <rect x="270" y="270" width="260" height="30" class="permit-rule" rx="3"/>
                            <text x="400" y="290" text-anchor="middle" class="flow-text" font-size="12">permit tcp any any eq 443</text>
                            
                            <rect x="270" y="310" width="260" height="30" class="permit-rule" rx="3"/>
                            <text x="400" y="330" text-anchor="middle" class="flow-text" font-size="12">permit tcp any 10.0.0.0/8 eq 22</text>
                            
                            <rect x="270" y="350" width="260" height="30" class="permit-rule" rx="3"/>
                            <text x="400" y="370" text-anchor="middle" class="flow-text" font-size="12">permit udp any eq 68 any eq 67</text>
                            
                            <rect x="270" y="390" width="260" height="30" class="deny-rule" rx="3"/>
                            <text x="400" y="410" text-anchor="middle" class="flow-text" font-size="12">deny tcp any any eq 23</text>
                            
                            <rect x="270" y="430" width="260" height="30" class="deny-rule" rx="3"/>
                            <text x="400" y="450" text-anchor="middle" class="flow-text" font-size="12">deny ip any any (implicit)</text>
                            
                            <!-- Traffic Flow -->
                            <rect x="50" y="520" width="800" height="180" class="flow-box" rx="5"/>
                            <text x="450" y="550" text-anchor="middle" class="flow-text" font-weight="bold">Traffic Flow Examples</text>
                            
                            <text x="100" y="580" text-anchor="start" class="flow-text" font-size="12">✓ HTTP (80) → Allowed</text>
                            <text x="100" y="600" text-anchor="start" class="flow-text" font-size="12">✓ HTTPS (443) → Allowed</text>
                            <text x="100" y="620" text-anchor="start" class="flow-text" font-size="12">✓ SSH to Internal → Allowed</text>
                            <text x="100" y="640" text-anchor="start" class="flow-text" font-size="12">✓ DHCP → Allowed</text>
                            <text x="100" y="660" text-anchor="start" class="flow-text" font-size="12">✗ Telnet → Denied</text>
                            <text x="100" y="680" text-anchor="start" class="flow-text" font-size="12">✗ Other Traffic → Denied</text>
                            
                            <text x="500" y="580" text-anchor="start" class="flow-text" font-size="12">Different User Types:</text>
                            <text x="500" y="600" text-anchor="start" class="flow-text" font-size="12">• Guest → Limited Internet</text>
                            <text x="500" y="620" text-anchor="start" class="flow-text" font-size="12">• Employee → Full Access</text>
                            <text x="500" y="640" text-anchor="start" class="flow-text" font-size="12">• Contractor → Restricted</text>
                            <text x="500" y="660" text-anchor="start" class="flow-text" font-size="12">• IoT → Isolated</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Downloadable ACL Examples

! Cisco dACL Format (RADIUS VSA)
Cisco-AVPair = "ip:inacl#1=permit tcp any any eq 80"
Cisco-AVPair = "ip:inacl#2=permit tcp any any eq 443"
Cisco-AVPair = "ip:inacl#3=permit tcp any 10.0.0.0 0.255.255.255 eq 22"
Cisco-AVPair = "ip:inacl#4=permit udp any eq 68 any eq 67"
Cisco-AVPair = "ip:inacl#5=deny tcp any any eq 23"
Cisco-AVPair = "ip:inacl#6=deny ip any any"

! Alternative Format - Filter-Id with Named ACL
Filter-Id = "Employee_ACL"

! Extended ACL on Switch (pre-configured)
ip access-list extended Employee_ACL
 permit tcp any any eq 80
 permit tcp any any eq 443
 permit tcp any 10.0.0.0 0.255.255.255 eq 22
 permit udp any eq bootpc any eq bootps
 permit udp any any eq domain
 permit icmp any any
 deny ip any any

! Per-User ACL (Cisco)
aaa authorization network default group radius

interface GigabitEthernet1/0/1
 ip access-group ACL-DEFAULT in
 authentication port-control auto
 dot1x pae authenticator</code>
                    </div>
                    <div class="code-block">
                        <code>! ISE/RADIUS Server Configuration Examples

! Guest User dACL
Cisco-AVPair = "ip:inacl#1=permit udp any eq bootpc any eq bootps"
Cisco-AVPair = "ip:inacl#2=permit udp any any eq domain"
Cisco-AVPair = "ip:inacl#3=permit tcp any any eq 80"
Cisco-AVPair = "ip:inacl#4=permit tcp any any eq 443"
Cisco-AVPair = "ip:inacl#5=deny ip any 10.0.0.0 0.255.255.255"
Cisco-AVPair = "ip:inacl#6=deny ip any 172.16.0.0 0.15.255.255"
Cisco-AVPair = "ip:inacl#7=deny ip any 192.168.0.0 0.0.255.255"
Cisco-AVPair = "ip:inacl#8=permit ip any any"

! IoT Device dACL
Cisco-AVPair = "ip:inacl#1=permit udp any eq bootpc any eq bootps"
Cisco-AVPair = "ip:inacl#2=permit udp any host 10.1.1.10 eq 123"
Cisco-AVPair = "ip:inacl#3=permit tcp any host 10.1.1.20 eq 1883"
Cisco-AVPair = "ip:inacl#4=permit tcp any host 10.1.1.30 eq 8883"
Cisco-AVPair = "ip:inacl#5=deny ip any any"

! Contractor dACL
Cisco-AVPair = "ip:inacl#1=permit tcp any host 10.1.2.10 eq 3389"
Cisco-AVPair = "ip:inacl#2=permit tcp any host 10.1.2.20 eq 22"
Cisco-AVPair = "ip:inacl#3=permit tcp any any eq 80"
Cisco-AVPair = "ip:inacl#4=permit tcp any any eq 443"
Cisco-AVPair = "ip:inacl#5=deny ip any 10.0.0.0 0.255.255.255"
Cisco-AVPair = "ip:inacl#6=permit ip any any"</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting dACL
show authentication sessions interface gi1/0/1 details
show access-lists
show ip access-lists interface gi1/0/1
debug aaa authorization
debug radius

! Common Issues:
! 1. ACL syntax errors - Verify syntax matches platform
! 2. ACL numbering - Ensure sequential numbering
! 3. Direction - dACLs typically applied inbound
! 4. Platform differences - IOS vs IOS-XE vs NX-OS</code>
                    </div>
                `
            },
            'guest-portal': {
                title: 'Guest Portal / Web Authentication Flow',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 800" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .highlight-box { fill: #fef3c7; stroke: #d97706; stroke-width: 2; }
                            </style>
                            
                            <!-- Components -->
                            <rect x="50" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="85" text-anchor="middle" class="flow-text">Guest Device</text>
                            
                            <rect x="250" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="310" y="85" text-anchor="middle" class="flow-text">Wireless AP</text>
                            
                            <rect x="450" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="510" y="85" text-anchor="middle" class="flow-text">Controller</text>
                            
                            <rect x="650" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="85" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <!-- Initial Connection -->
                            <path d="M170 80 L250 80" class="flow-arrow"/>
                            <text x="210" y="70" text-anchor="middle" class="flow-label">1. Associate</text>
                            
                            <path d="M370 80 L450 80" class="flow-arrow"/>
                            <text x="410" y="70" text-anchor="middle" class="flow-label">2. CAPWAP</text>
                            
                            <!-- MAC Auth Bypass -->
                            <rect x="40" y="150" width="840" height="100" class="highlight-box" rx="5"/>
                            <text x="460" y="180" text-anchor="middle" class="flow-text" font-weight="bold">Step 1: MAC Auth Bypass (MAB)</text>
                            
                            <path d="M570 200 L650 200" class="flow-arrow"/>
                            <text x="610" y="190" text-anchor="middle" class="flow-label">3. MAB Request</text>
                            <text x="610" y="210" text-anchor="middle" class="flow-label" font-size="10">MAC: 00:11:22:33:44:55</text>
                            
                            <path d="M650 220 L570 220" class="flow-arrow"/>
                            <text x="610" y="235" text-anchor="middle" class="flow-label">4. Access-Accept</text>
                            <text x="610" y="250" text-anchor="middle" class="flow-label" font-size="10">Redirect URL + ACL</text>
                            
                            <!-- Pre-Auth ACL & Redirect -->
                            <rect x="40" y="280" width="840" height="140" class="highlight-box" rx="5"/>
                            <text x="460" y="310" text-anchor="middle" class="flow-text" font-weight="bold">Step 2: Pre-Auth ACL & Redirect</text>
                            
                            <rect x="300" y="320" width="320" height="80" class="flow-box" rx="5"/>
                            <text x="460" y="345" text-anchor="middle" class="flow-text" font-size="12">RADIUS Response:</text>
                            <text x="460" y="365" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "url-redirect-acl=PRE_AUTH_ACL"</text>
                            <text x="460" y="380" text-anchor="middle" class="flow-text" font-size="11">Cisco-AVPair = "url-redirect=https://guest.corp.com"</text>
                            <text x="460" y="395" text-anchor="middle" class="flow-text" font-size="11">Tunnel-Private-Group-ID = "10" (Guest VLAN)</text>
                            
                            <!-- Web Authentication -->
                            <rect x="40" y="450" width="840" height="150" class="highlight-box" rx="5"/>
                            <text x="460" y="480" text-anchor="middle" class="flow-text" font-weight="bold">Step 3: Web Authentication</text>
                            
                            <path d="M110 520 L250 520" class="flow-arrow"/>
                            <text x="180" y="510" text-anchor="middle" class="flow-label">5. HTTP Request</text>
                            
                            <path d="M310 520 L450 520" class="flow-arrow"/>
                            <text x="380" y="510" text-anchor="middle" class="flow-label">6. Redirect to Portal</text>
                            
                            <rect x="500" y="500" width="200" height="40" class="flow-box" rx="5"/>
                            <text x="600" y="525" text-anchor="middle" class="flow-text">Guest Portal Login</text>
                            
                            <path d="M600 540 L600 580" class="flow-arrow"/>
                            <text x="650" y="560" text-anchor="middle" class="flow-label">7. Credentials</text>
                            
                            <!-- Final Authorization -->
                            <rect x="40" y="620" width="840" height="120" class="highlight-box" rx="5"/>
                            <text x="460" y="650" text-anchor="middle" class="flow-text" font-weight="bold">Step 4: Final Authorization</text>
                            
                            <path d="M600 670 L710 670" class="flow-arrow"/>
                            <text x="655" y="660" text-anchor="middle" class="flow-label">8. Guest Auth</text>
                            
                            <path d="M710 700 L600 700" class="flow-arrow"/>
                            <text x="655" y="690" text-anchor="middle" class="flow-label">9. Access-Accept</text>
                            <text x="655" y="715" text-anchor="middle" class="flow-label" font-size="10">Remove redirect</text>
                            
                            <path d="M500 700 L350 700" class="flow-arrow"/>
                            <text x="425" y="690" text-anchor="middle" class="flow-label">10. CoA</text>
                            <text x="425" y="715" text-anchor="middle" class="flow-label" font-size="10">Full Access</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Wireless Controller Configuration (Cisco)
! Guest SSID Configuration
wlan GUEST_WIFI 10 GUEST_WIFI
 client vlan 10
 no security wpa
 no security wpa akm dot1x
 no security wpa wpa2
 no security wpa wpa2 ciphers aes
 security web-auth
 security web-auth authentication-list GUEST_AUTH
 security web-auth parameter-map GUEST_PORTAL
 session-timeout 3600
 no shutdown

! Guest Portal Parameter Map
parameter-map type webauth global
 virtual-ip ipv4 192.0.2.1
 
parameter-map type webauth GUEST_PORTAL
 type webauth
 redirect for-login https://guest.company.com/portal
 redirect portal ipv4 10.1.1.100
 logo file flash:company_logo.jpg
 consent email
 timeout init-state sec 120

! Pre-Auth ACL
ip access-list extended PRE_AUTH_ACL
 permit udp any eq bootpc any eq bootps
 permit udp any any eq domain
 permit tcp any host 10.1.1.100 eq 443
 permit tcp any host 10.1.1.100 eq 80
 permit tcp any any eq 443 established
 deny ip any any

! RADIUS Configuration
radius server GUEST_ISE
 address ipv4 10.1.1.200 auth-port 1812 acct-port 1813
 key guestradius123</code>
                    </div>
                    <div class="code-block">
                        <code>! ISE Guest Portal Configuration
! Initial MAB Response (Pre-Auth)
Access-Accept
  Cisco-AVPair = "url-redirect-acl=PRE_AUTH_ACL"
  Cisco-AVPair = "url-redirect=https://guest.company.com/portal/gateway?sessionId=12345&portal=Guest"
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "10"
  Session-Timeout = 120

! Post-Authentication Response
Access-Accept
  User-Name = "guest-user@email.com"
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "10"
  Filter-Id = "GUEST_INTERNET_ACL"
  Session-Timeout = 3600
  Termination-Action = RADIUS-Request
  
! Change of Authorization (CoA)
CoA-Request
  Cisco-AVPair = "subscriber:command=reauthenticate"
  Cisco-AVPair = "subscriber:reauthenticate-type=last"
  Calling-Station-Id = "00-11-22-33-44-55"
  
! Guest Internet ACL
ip access-list extended GUEST_INTERNET_ACL
 permit udp any eq bootpc any eq bootps
 permit udp any any eq domain
 permit tcp any any eq 80
 permit tcp any any eq 443
 permit tcp any any eq 587
 permit tcp any any eq 993
 deny ip any 10.0.0.0 0.255.255.255
 deny ip any 172.16.0.0 0.15.255.255
 deny ip any 192.168.0.0 0.0.255.255
 permit ip any any</code>
                    </div>
                `
            },
            'mab-profiling': {
                title: 'MAC Auth Bypass & Device Profiling',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 850" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .device-box { fill: #e0f2fe; stroke: #0284c7; stroke-width: 2; }
                            </style>
                            
                            <!-- Devices -->
                            <rect x="50" y="50" width="120" height="60" class="device-box" rx="5"/>
                            <text x="110" y="75" text-anchor="middle" class="flow-text" font-weight="bold">IP Phone</text>
                            <text x="110" y="95" text-anchor="middle" class="flow-text" font-size="12">00:11:22:AA:BB:CC</text>
                            
                            <rect x="200" y="50" width="120" height="60" class="device-box" rx="5"/>
                            <text x="260" y="75" text-anchor="middle" class="flow-text" font-weight="bold">Printer</text>
                            <text x="260" y="95" text-anchor="middle" class="flow-text" font-size="12">00:11:22:DD:EE:FF</text>
                            
                            <rect x="350" y="50" width="120" height="60" class="device-box" rx="5"/>
                            <text x="410" y="75" text-anchor="middle" class="flow-text" font-weight="bold">IP Camera</text>
                            <text x="410" y="95" text-anchor="middle" class="flow-text" font-size="12">00:11:22:11:22:33</text>
                            
                            <!-- Switch -->
                            <rect x="200" y="170" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="260" y="205" text-anchor="middle" class="flow-text">Switch</text>
                            
                            <!-- RADIUS/ISE -->
                            <rect x="500" y="170" width="150" height="60" class="flow-box" rx="5"/>
                            <text x="575" y="195" text-anchor="middle" class="flow-text">RADIUS/ISE</text>
                            <text x="575" y="215" text-anchor="middle" class="flow-text" font-size="12">with Profiling</text>
                            
                            <!-- MAB Flow -->
                            <path d="M110 110 L260 170" class="flow-arrow"/>
                            <path d="M260 110 L260 170" class="flow-arrow"/>
                            <path d="M410 110 L260 170" class="flow-arrow"/>
                            
                            <!-- Authentication Steps -->
                            <rect x="40" y="260" width="820" height="180" class="flow-box" rx="5"/>
                            <text x="450" y="290" text-anchor="middle" class="flow-text" font-weight="bold">MAB Authentication Process</text>
                            
                            <path d="M320 320 L500 320" class="flow-arrow"/>
                            <text x="410" y="310" text-anchor="middle" class="flow-label">1. MAC Auth Request</text>
                            <text x="410" y="330" text-anchor="middle" class="flow-label" font-size="10">User-Name = 001122aabbcc</text>
                            
                            <path d="M500 360 L320 360" class="flow-arrow"/>
                            <text x="410" y="350" text-anchor="middle" class="flow-label">2. Challenge (Optional)</text>
                            <text x="410" y="370" text-anchor="middle" class="flow-label" font-size="10">For profiling data</text>
                            
                            <path d="M320 400 L500 400" class="flow-arrow"/>
                            <text x="410" y="390" text-anchor="middle" class="flow-label">3. Additional Attributes</text>
                            <text x="410" y="410" text-anchor="middle" class="flow-label" font-size="10">DHCP, CDP/LLDP, HTTP</text>
                            
                            <!-- Profiling Data -->
                            <rect x="680" y="280" width="160" height="140" class="flow-box" rx="5"/>
                            <text x="760" y="305" text-anchor="middle" class="flow-text" font-weight="bold">Profiling Data</text>
                            <text x="760" y="330" text-anchor="middle" class="flow-text" font-size="12">• DHCP Options</text>
                            <text x="760" y="350" text-anchor="middle" class="flow-text" font-size="12">• CDP/LLDP Info</text>
                            <text x="760" y="370" text-anchor="middle" class="flow-text" font-size="12">• HTTP User-Agent</text>
                            <text x="760" y="390" text-anchor="middle" class="flow-text" font-size="12">• SNMP Data</text>
                            <text x="760" y="410" text-anchor="middle" class="flow-text" font-size="12">• NetFlow Data</text>
                            
                            <!-- Device Classification -->
                            <rect x="40" y="460" width="820" height="220" class="flow-box" rx="5"/>
                            <text x="450" y="490" text-anchor="middle" class="flow-text" font-weight="bold">Device Classification & Response</text>
                            
                            <!-- IP Phone -->
                            <rect x="60" y="510" width="240" height="120" class="device-box" rx="5"/>
                            <text x="180" y="535" text-anchor="middle" class="flow-text" font-weight="bold">IP Phone Detected</text>
                            <text x="180" y="555" text-anchor="middle" class="flow-text" font-size="12">DHCP Option 60: "Cisco CP-8841"</text>
                            <text x="180" y="575" text-anchor="middle" class="flow-text" font-size="12">CDP: Device-ID contains "SEP"</text>
                            <text x="180" y="595" text-anchor="middle" class="flow-text" font-size="12">Response: Voice VLAN 40</text>
                            <text x="180" y="615" text-anchor="middle" class="flow-text" font-size="12">QoS: DSCP EF (46)</text>
                            
                            <!-- Printer -->
                            <rect x="320" y="510" width="240" height="120" class="device-box" rx="5"/>
                            <text x="440" y="535" text-anchor="middle" class="flow-text" font-weight="bold">Printer Detected</text>
                            <text x="440" y="555" text-anchor="middle" class="flow-text" font-size="12">DHCP Hostname: "HP-LaserJet"</text>
                            <text x="440" y="575" text-anchor="middle" class="flow-text" font-size="12">HTTP User-Agent: "HP SNMP"</text>
                            <text x="440" y="595" text-anchor="middle" class="flow-text" font-size="12">Response: Printer VLAN 50</text>
                            <text x="440" y="615" text-anchor="middle" class="flow-text" font-size="12">ACL: Print Services Only</text>
                            
                            <!-- IP Camera -->
                            <rect x="580" y="510" width="240" height="120" class="device-box" rx="5"/>
                            <text x="700" y="535" text-anchor="middle" class="flow-text" font-weight="bold">IP Camera Detected</text>
                            <text x="700" y="555" text-anchor="middle" class="flow-text" font-size="12">MAC OUI: Axis Communications</text>
                            <text x="700" y="575" text-anchor="middle" class="flow-text" font-size="12">LLDP: System Desc "AXIS P3225"</text>
                            <text x="700" y="595" text-anchor="middle" class="flow-text" font-size="12">Response: Security VLAN 60</text>
                            <text x="700" y="615" text-anchor="middle" class="flow-text" font-size="12">ACL: NVR Access Only</text>
                            
                            <!-- Unknown Device -->
                            <rect x="100" y="700" width="700" height="100" class="flow-box" rx="5"/>
                            <text x="450" y="730" text-anchor="middle" class="flow-text" font-weight="bold">Unknown Device Handling</text>
                            <text x="450" y="755" text-anchor="middle" class="flow-text" font-size="12">Cannot profile → Guest VLAN with Internet-only access</text>
                            <text x="450" y="775" text-anchor="middle" class="flow-text" font-size="12">Continue profiling attempts → May reclassify with more data</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! Switch MAB Configuration
interface GigabitEthernet1/0/1
 description MAB Enabled Port
 switchport mode access
 switchport access vlan 999
 authentication port-control auto
 authentication host-mode multi-auth
 authentication order mab dot1x
 authentication priority mab dot1x
 authentication event fail action next-method
 authentication event server dead action authorize vlan 999
 authentication event no-response action authorize vlan 999
 authentication violation restrict
 mab
 mab eap
 dot1x pae authenticator
 dot1x timeout quiet-period 30
 dot1x timeout tx-period 10
 spanning-tree portfast
 ip dhcp snooping trust

! Enable Profiling Data Collection
interface GigabitEthernet1/0/1
 ip device tracking maximum 10
 device-sensor filter-list cdp list CDP_LIST
 device-sensor filter-list lldp list LLDP_LIST
 device-sensor filter-list dhcp list DHCP_LIST
 device-sensor notify all-changes

! Device Sensor Configuration
device-sensor filter-spec cdp CDP_LIST
 cdp tlv device-name
 cdp tlv platform-type
 cdp tlv capabilities-type
 
device-sensor filter-spec lldp LLDP_LIST
 lldp tlv system-name
 lldp tlv system-description
 lldp tlv system-capabilities
 
device-sensor filter-spec dhcp DHCP_LIST
 option 12 hostname
 option 60 vendor-class-identifier
 option 61 client-identifier</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS Responses for Different Device Types

! IP Phone (Cisco)
Access-Accept
  Cisco-AVPair = "device-traffic-class=voice"
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "40"
  Cisco-AVPair = "interface-template=VOICE_TEMPLATE"
  Filter-Id = "VOICE_DEVICE_ACL"
  
! Printer
Access-Accept
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "50"
  Filter-Id = "PRINTER_ACL"
  Session-Timeout = 86400
  
! IP Camera
Access-Accept
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "60"
  Filter-Id = "SECURITY_CAMERA_ACL"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=CAMERA_QOS"
  
! Unknown Device (Guest)
Access-Accept
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "10"
  Filter-Id = "GUEST_ACL"
  Session-Timeout = 3600
  Cisco-AVPair = "url-redirect-acl=GUEST_REDIRECT"
  Cisco-AVPair = "url-redirect=https://guest.company.com/"</code>
                    </div>
                    <div class="code-block">
                        <code>! Profiling Examples & ACLs

! Voice Device ACL
ip access-list extended VOICE_DEVICE_ACL
 permit udp any eq bootpc any eq bootps
 permit udp any any eq tftp
 permit tcp any any eq 2000
 permit udp any any range 16384 32767
 permit tcp any host 10.1.1.50 eq 2443
 deny ip any any

! Printer ACL  
ip access-list extended PRINTER_ACL
 permit udp any eq bootpc any eq bootps
 permit tcp any any eq 9100
 permit tcp any any eq 631
 permit tcp any any eq 80
 permit udp any any eq 161
 deny ip any any

! Security Camera ACL
ip access-list extended SECURITY_CAMERA_ACL
 permit udp any eq bootpc any eq bootps
 permit tcp any host 10.1.1.100 eq 554
 permit tcp any host 10.1.1.100 range 8000 8003
 permit udp any host 10.1.1.40 eq 123
 deny ip any any

! Interface Templates
template VOICE_TEMPLATE
 switchport mode access
 switchport voice vlan 40
 spanning-tree portfast
 spanning-tree bpduguard enable
 storm-control broadcast level 1.00
 storm-control multicast level 2.00
 mls qos trust dscp
 priority-queue out 
 srr-queue bandwidth share 1 25 70 5
 srr-queue bandwidth shape 10 0 0 0</code>
                    </div>
                `
            },
            'coa-process': {
                title: 'Change of Authorization (CoA) Process',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 850" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .highlight-box { fill: #fef3c7; stroke: #d97706; stroke-width: 2; }
                                .coa-box { fill: #dcfce7; stroke: #16a34a; stroke-width: 2; }
                            </style>
                            
                            <!-- Components -->
                            <rect x="50" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="85" text-anchor="middle" class="flow-text">Client Device</text>
                            
                            <rect x="300" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="360" y="85" text-anchor="middle" class="flow-text">NAD/Switch</text>
                            
                            <rect x="550" y="50" width="150" height="60" class="flow-box" rx="5"/>
                            <text x="625" y="85" text-anchor="middle" class="flow-text">RADIUS/ISE</text>
                            
                            <rect x="750" y="50" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="810" y="85" text-anchor="middle" class="flow-text">Admin/Event</text>
                            
                            <!-- Initial State -->
                            <rect x="40" y="140" width="820" height="100" class="highlight-box" rx="5"/>
                            <text x="450" y="170" text-anchor="middle" class="flow-text" font-weight="bold">Initial Authenticated State</text>
                            <text x="300" y="200" text-anchor="middle" class="flow-text" font-size="12">User: john.doe | VLAN: 20 | ACL: Employee_ACL</text>
                            <text x="300" y="220" text-anchor="middle" class="flow-text" font-size="12">Session Active | Full Access Granted</text>
                            
                            <!-- CoA Triggers -->
                            <rect x="40" y="260" width="820" height="180" class="highlight-box" rx="5"/>
                            <text x="450" y="290" text-anchor="middle" class="flow-text" font-weight="bold">CoA Trigger Events</text>
                            
                            <rect x="80" y="310" width="160" height="100" class="coa-box" rx="5"/>
                            <text x="160" y="335" text-anchor="middle" class="flow-text" font-weight="bold">Policy Change</text>
                            <text x="160" y="355" text-anchor="middle" class="flow-text" font-size="11">• User group change</text>
                            <text x="160" y="375" text-anchor="middle" class="flow-text" font-size="11">• Posture compliance</text>
                            <text x="160" y="395" text-anchor="middle" class="flow-text" font-size="11">• Time-based policy</text>
                            
                            <rect x="270" y="310" width="160" height="100" class="coa-box" rx="5"/>
                            <text x="350" y="335" text-anchor="middle" class="flow-text" font-weight="bold">Security Event</text>
                            <text x="350" y="355" text-anchor="middle" class="flow-text" font-size="11">• Threat detected</text>
                            <text x="350" y="375" text-anchor="middle" class="flow-text" font-size="11">• Violation logged</text>
                            <text x="350" y="395" text-anchor="middle" class="flow-text" font-size="11">• Admin action</text>
                            
                            <rect x="460" y="310" width="160" height="100" class="coa-box" rx="5"/>
                            <text x="540" y="335" text-anchor="middle" class="flow-text" font-weight="bold">Network Change</text>
                            <text x="540" y="355" text-anchor="middle" class="flow-text" font-size="11">• Bandwidth limit</text>
                            <text x="540" y="375" text-anchor="middle" class="flow-text" font-size="11">• QoS update</text>
                            <text x="540" y="395" text-anchor="middle" class="flow-text" font-size="11">• VLAN change</text>
                            
                            <rect x="650" y="310" width="160" height="100" class="coa-box" rx="5"/>
                            <text x="730" y="335" text-anchor="middle" class="flow-text" font-weight="bold">Session Control</text>
                            <text x="730" y="355" text-anchor="middle" class="flow-text" font-size="11">• Reauthenticate</text>
                            <text x="730" y="375" text-anchor="middle" class="flow-text" font-size="11">• Disconnect</text>
                            <text x="730" y="395" text-anchor="middle" class="flow-text" font-size="11">• Port bounce</text>
                            
                            <!-- CoA Flow -->
                            <path d="M810 110 L810 260" class="flow-arrow"/>
                            <text x="820" y="185" text-anchor="start" class="flow-label">1. Event</text>
                            
                            <path d="M700 180 L750 260" class="flow-arrow"/>
                            <text x="730" y="210" text-anchor="middle" class="flow-label">2. Trigger</text>
                            
                            <rect x="40" y="460" width="820" height="220" class="highlight-box" rx="5"/>
                            <text x="450" y="490" text-anchor="middle" class="flow-text" font-weight="bold">CoA Process Flow</text>
                            
                            <path d="M625 110 L625 520" class="flow-arrow"/>
                            <text x="635" y="315" text-anchor="start" class="flow-label">3. CoA Decision</text>
                            
                            <path d="M550 520 L420 520" class="flow-arrow"/>
                            <text x="485" y="510" text-anchor="middle" class="flow-label">4. CoA-Request</text>
                            
                            <rect x="480" y="540" width="200" height="80" class="flow-box" rx="5"/>
                            <text x="580" y="565" text-anchor="middle" class="flow-text" font-size="12">CoA Attributes:</text>
                            <text x="580" y="585" text-anchor="middle" class="flow-text" font-size="11">• Session-ID</text>
                            <text x="580" y="600" text-anchor="middle" class="flow-text" font-size="11">• New VLAN/ACL/QoS</text>
                            
                            <path d="M420 560 L550 560" class="flow-arrow"/>
                            <text x="485" y="550" text-anchor="middle" class="flow-label">5. CoA-ACK/NAK</text>
                            
                            <path d="M300 540 L170 540" class="flow-arrow"/>
                            <text x="235" y="530" text-anchor="middle" class="flow-label">6. Apply Changes</text>
                            
                            <!-- Results -->
                            <rect x="40" y="700" width="820" height="100" class="highlight-box" rx="5"/>
                            <text x="450" y="730" text-anchor="middle" class="flow-text" font-weight="bold">Post-CoA State</text>
                            <text x="300" y="760" text-anchor="middle" class="flow-text" font-size="12">User: john.doe | VLAN: 999 | ACL: Quarantine_ACL</text>
                            <text x="300" y="780" text-anchor="middle" class="flow-text" font-size="12">Session Modified | Restricted Access</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! NAD/Switch CoA Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
aaa accounting network default start-stop group radius

! Enable CoA support
aaa server radius dynamic-author
 client 10.1.1.100 server-key cisco123
 client 10.1.1.101 server-key cisco123
 port 3799
 
! RADIUS Server Configuration  
radius server ISE
 address ipv4 10.1.1.100 auth-port 1812 acct-port 1813
 key cisco123
 
! CoA Commands Available
! - Port Bounce
! - Port Shutdown
! - Session Reauthenticate
! - Session Terminate
! - Update Session Attributes</code>
                    </div>
                    <div class="code-block">
                        <code>! CoA Request Examples

! Session Reauthentication
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:command=reauthenticate"
  Cisco-AVPair = "subscriber:reauthenticate-type=last"
  
! VLAN Change
CoA-Request
  Acct-Session-Id = "00000123"
  Tunnel-Type = VLAN (13)
  Tunnel-Medium-Type = IEEE-802 (6)
  Tunnel-Private-Group-ID = "999"
  Filter-Id = "QUARANTINE_ACL"
  
! Port Bounce
CoA-Request
  Calling-Station-Id = "00-11-22-33-44-55"
  NAS-IP-Address = "192.168.1.1"
  Cisco-AVPair = "subscriber:command=bounce-host-port"
  
! Session Termination  
Disconnect-Request
  Acct-Session-Id = "00000123"
  User-Name = "john.doe"
  
! QoS Update
CoA-Request  
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=RESTRICT_BW"
  Cisco-AVPair = "subscriber:sub-qos-policy-out=RESTRICT_BW"</code>
                    </div>
                    <div class="code-block">
                        <code>! Advanced CoA Use Cases

! Posture Remediation
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "url-redirect-acl=POSTURE_REDIRECT"
  Cisco-AVPair = "url-redirect=https://remediation.company.com"
  Tunnel-Private-Group-ID = "99"
  
! Bandwidth Restriction (Security)
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=1MBPS_LIMIT"
  Filter-Id = "RESTRICTED_ACCESS"
  
! Guest Time Extension
CoA-Request
  Acct-Session-Id = "00000123"
  Session-Timeout = "7200"
  
! Multi-Attribute Update  
CoA-Request
  Acct-Session-Id = "00000123"
  Tunnel-Private-Group-ID = "200"
  Filter-Id = "ADVANCED_ACCESS"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=PRIORITY_QOS"
  Cisco-AVPair = "security-group-tag=100"</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting CoA

! Debug Commands
debug radius
debug aaa coa
debug authentication all
debug dot1x all

! Show Commands  
show aaa servers
show aaa server radius dynamic-author
show authentication sessions
show authentication sessions interface gi1/0/1 details
show radius server-group all

! Common CoA Issues:
! 1. Shared secret mismatch
! 2. Wrong CoA port (default 1700 vs 3799)  
! 3. Session identifier mismatch
! 4. Firewall blocking CoA packets
! 5. Unsupported attributes on platform</code>
                    </div>
                `
            },
            'qos-bandwidth': {
                title: 'QoS and Bandwidth Management',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 750" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .qos-box { fill: #e0f2fe; stroke: #0284c7; stroke-width: 2; }
                                .priority-high { fill: #fecaca; stroke: #dc2626; }
                                .priority-med { fill: #fef9c3; stroke: #d97706; }
                                .priority-low { fill: #dcfce7; stroke: #16a34a; }
                            </style>
                            
                            <!-- Service Types -->
                            <rect x="50" y="50" width="180" height="100" class="priority-high" rx="5"/>
                            <text x="140" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Voice Traffic</text>
                            <text x="140" y="100" text-anchor="middle" class="flow-text" font-size="12">DSCP EF (46)</text>
                            <text x="140" y="120" text-anchor="middle" class="flow-text" font-size="12">Priority Queue</text>
                            <text x="140" y="140" text-anchor="middle" class="flow-text" font-size="12">Low Latency</text>
                            
                            <rect x="260" y="50" width="180" height="100" class="priority-med" rx="5"/>
                            <text x="350" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Video/Business</text>
                            <text x="350" y="100" text-anchor="middle" class="flow-text" font-size="12">DSCP AF41 (34)</text>
                            <text x="350" y="120" text-anchor="middle" class="flow-text" font-size="12">Assured Forwarding</text>
                            <text x="350" y="140" text-anchor="middle" class="flow-text" font-size="12">Guaranteed BW</text>
                            
                            <rect x="470" y="50" width="180" height="100" class="priority-low" rx="5"/>
                            <text x="560" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Best Effort</text>
                            <text x="560" y="100" text-anchor="middle" class="flow-text" font-size="12">DSCP 0</text>
                            <text x="560" y="120" text-anchor="middle" class="flow-text" font-size="12">Default Queue</text>
                            <text x="560" y="140" text-anchor="middle" class="flow-text" font-size="12">Internet Traffic</text>
                            
                            <rect x="680" y="50" width="180" height="100" class="qos-box" rx="5"/>
                            <text x="770" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Scavenger</text>
                            <text x="770" y="100" text-anchor="middle" class="flow-text" font-size="12">DSCP CS1 (8)</text>
                            <text x="770" y="120" text-anchor="middle" class="flow-text" font-size="12">Limited Bandwidth</text>
                            <text x="770" y="140" text-anchor="middle" class="flow-text" font-size="12">P2P/Guest</text>
                            
                            <!-- Authentication Flow -->
                            <rect x="100" y="200" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="160" y="235" text-anchor="middle" class="flow-text">User/Device</text>
                            
                            <rect x="350" y="200" width="200" height="60" class="flow-box" rx="5"/>
                            <text x="450" y="235" text-anchor="middle" class="flow-text">Switch/Controller</text>
                            
                            <rect x="680" y="200" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="740" y="235" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <!-- QoS Assignment -->
                            <path d="M220 230 L350 230" class="flow-arrow"/>
                            <text x="285" y="220" text-anchor="middle" class="flow-label">1. Auth</text>
                            
                            <path d="M550 230 L680 230" class="flow-arrow"/>
                            <text x="615" y="220" text-anchor="middle" class="flow-label">2. Request</text>
                            
                            <path d="M680 250 L550 250" class="flow-arrow"/>
                            <text x="615" y="265" text-anchor="middle" class="flow-label">3. QoS Policy</text>
                            
                            <!-- Policy Examples -->
                            <rect x="40" y="300" width="820" height="370" class="flow-box" rx="5"/>
                            <text x="450" y="330" text-anchor="middle" class="flow-text" font-weight="bold">RADIUS QoS Response Examples</text>
                            
                            <!-- Voice Device -->
                            <rect x="60" y="350" width="380" height="130" class="priority-high" rx="5"/>
                            <text x="250" y="375" text-anchor="middle" class="flow-text" font-weight="bold">IP Phone Authentication</text>
                            <text x="250" y="395" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "device-traffic-class=voice"</text>
                            <text x="250" y="415" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "interface-template=VOICE_TEMPLATE"</text>
                            <text x="250" y="435" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "sub-qos-policy-in=VOICE_MARKING"</text>
                            <text x="250" y="455" text-anchor="middle" class="flow-text" font-size="12">Result: Trust DSCP, Priority Queue</text>
                            
                            <!-- Business User -->
                            <rect x="460" y="350" width="380" height="130" class="priority-med" rx="5"/>
                            <text x="650" y="375" text-anchor="middle" class="flow-text" font-weight="bold">Business User Authentication</text>
                            <text x="650" y="395" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "sub-qos-policy-in=BUSINESS_QOS"</text>
                            <text x="650" y="415" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "sub-qos-policy-out=BUSINESS_QOS"</text>
                            <text x="650" y="435" text-anchor="middle" class="flow-text" font-size="12">Filter-Id = "BUSINESS_ACL"</text>
                            <text x="650" y="455" text-anchor="middle" class="flow-text" font-size="12">Result: 50Mbps guaranteed, AF marking</text>
                            
                            <!-- Guest User -->
                            <rect x="60" y="490" width="380" height="130" class="priority-low" rx="5"/>
                            <text x="250" y="515" text-anchor="middle" class="flow-text" font-weight="bold">Guest User Authentication</text>
                            <text x="250" y="535" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "sub-qos-policy-in=GUEST_LIMIT"</text>
                            <text x="250" y="555" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "ip:sub-rate-limit=5000000"</text>
                            <text x="250" y="575" text-anchor="middle" class="flow-text" font-size="12">Tunnel-Private-Group-ID = "10"</text>
                            <text x="250" y="595" text-anchor="middle" class="flow-text" font-size="12">Result: 5Mbps limit, best effort</text>
                            
                            <!-- IoT Device -->
                            <rect x="460" y="490" width="380" height="130" class="qos-box" rx="5"/>
                            <text x="650" y="515" text-anchor="middle" class="flow-text" font-weight="bold">IoT Device Authentication</text>
                            <text x="650" y="535" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "sub-qos-policy-in=IOT_QOS"</text>
                            <text x="650" y="555" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "subscriber:sub-qos-policy-in=RATE_1M"</text>
                            <text x="650" y="575" text-anchor="middle" class="flow-text" font-size="12">Filter-Id = "IOT_RESTRICT"</text>
                            <text x="650" y="595" text-anchor="middle" class="flow-text" font-size="12">Result: 1Mbps limit, CS1 marking</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! QoS Policy Configuration Examples

! Voice QoS Policy
policy-map VOICE_MARKING
 class VOICE_CLASS
  set dscp ef
  priority percent 30
 class VOICE_SIGNALING
  set dscp cs3
  bandwidth percent 5
 class class-default
  fair-queue

! Business User QoS  
policy-map BUSINESS_QOS
 class BUSINESS_APPS
  set dscp af41
  bandwidth percent 40
  random-detect
 class WEB_TRAFFIC
  set dscp af21
  bandwidth percent 20
 class class-default
  bandwidth percent 25
  fair-queue

! Guest/Rate Limited QoS
policy-map GUEST_LIMIT
 class class-default
  police cir 5000000 bc 156250
   exceed-action drop
  set dscp default

! IoT Device QoS
policy-map IOT_QOS  
 class class-default
  police cir 1000000
   exceed-action drop
  set dscp cs1

! Class Maps
class-map match-any VOICE_CLASS
 match dscp ef
 match cos 5
 match access-group name VOICE_RTP

class-map match-any BUSINESS_APPS
 match protocol citrix
 match protocol sqlnet
 match protocol exchange</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS VSA Examples for QoS/Bandwidth

! Cisco VSAs
! Voice Device
Cisco-AVPair = "device-traffic-class=voice"
Cisco-AVPair = "interface-template=VOICE_TEMPLATE"
Cisco-AVPair = "sub-qos-policy-in=VOICE_MARKING"

! Bandwidth Limit (Rate Limiting)
Cisco-AVPair = "sub-qos-policy-in=RATE_LIMIT_10M"
Cisco-AVPair = "sub-qos-policy-out=RATE_LIMIT_10M"
Cisco-AVPair = "ip:sub-rate-limit=10000000"

! Per-User QoS Policy
Cisco-AVPair = "ip:sub-qos-policy-in=EMPLOYEE_QOS"
Cisco-AVPair = "ip:sub-qos-policy-out=EMPLOYEE_QOS"

! Juniper VSAs
Juniper-Cos-Traffic-Control-Profile = "PREMIUM-1GBPS"
Juniper-Cos-Shaping-Rate = "100m"
Juniper-Bandwidth-Max-Upload = "50000"
Juniper-Bandwidth-Max-Download = "100000"

! Aruba VSAs  
Aruba-Bandwidth-Max-User = "10240"
Aruba-Bandwidth-Max-User-Upstream = "5120"
Aruba-Bandwidth-Max-User-Downstream = "10240"

! HP VSAs
HP-Bandwidth-Max-Ingress = "100000"
HP-Bandwidth-Max-Egress = "50000"
HP-Port-Priority = "7"
HP-Cos = "5"</code>
                    </div>
                    <div class="code-block">
                        <code>! Interface Templates for Different Traffic Types

! Voice Interface Template
template VOICE_TEMPLATE
 switchport mode access
 switchport voice vlan 40
 spanning-tree portfast
 spanning-tree bpduguard enable
 mls qos trust dscp
 priority-queue out
 srr-queue bandwidth share 1 25 70 5
 srr-queue bandwidth shape 10 0 0 0
 storm-control broadcast level 1.00
 storm-control multicast level 2.00

! High-Performance User Template  
template HIGH_PERF_USER
 switchport mode access
 mls qos trust dscp
 service-policy input MARK_TRAFFIC
 service-policy output USER_QOS
 storm-control broadcast level 10.00
 storm-control multicast level 50.00

! Guest User Template
template GUEST_USER  
 switchport mode access
 service-policy input GUEST_LIMIT
 service-policy output GUEST_LIMIT
 storm-control broadcast level 1.00
 storm-control multicast level 1.00
 storm-control action trap</code>
                    </div>
                    <div class="code-block">
                        <code>! Dynamic QoS with CoA

! Upgrade User Bandwidth
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=PREMIUM_100M"
  Cisco-AVPair = "subscriber:sub-qos-policy-out=PREMIUM_100M"

! Apply Traffic Restriction  
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=RESTRICT_1M"
  Filter-Id = "QUARANTINE_ACL"

! Remove QoS Policy
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:sub-qos-policy-in=none"
  Cisco-AVPair = "subscriber:sub-qos-policy-out=none"

! Trust Settings Change
CoA-Request
  Acct-Session-Id = "00000123"  
  Cisco-AVPair = "device-traffic-class=voice"</code>
                    </div>
                `
            },
            'sgt-trustsec': {
                title: 'Security Group Tags and TrustSec',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 800" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .sgt-box { fill: #e0f2fe; stroke: #0284c7; stroke-width: 2; }
                                .policy-box { fill: #fef3c7; stroke: #d97706; stroke-width: 2; }
                            </style>
                            
                            <!-- SGT Groups -->
                            <rect x="50" y="50" width="160" height="80" class="sgt-box" rx="5"/>
                            <text x="130" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Employees</text>
                            <text x="130" y="100" text-anchor="middle" class="flow-text" font-size="12">SGT: 10</text>
                            <text x="130" y="115" text-anchor="middle" class="flow-text" font-size="12">HR, Finance, IT</text>
                            
                            <rect x="240" y="50" width="160" height="80" class="sgt-box" rx="5"/>
                            <text x="320" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Contractors</text>
                            <text x="320" y="100" text-anchor="middle" class="flow-text" font-size="12">SGT: 20</text>
                            <text x="320" y="115" text-anchor="middle" class="flow-text" font-size="12">External Staff</text>
                            
                            <rect x="430" y="50" width="160" height="80" class="sgt-box" rx="5"/>
                            <text x="510" y="80" text-anchor="middle" class="flow-text" font-weight="bold">IoT Devices</text>
                            <text x="510" y="100" text-anchor="middle" class="flow-text" font-size="12">SGT: 30</text>
                            <text x="510" y="115" text-anchor="middle" class="flow-text" font-size="12">Cameras, Sensors</text>
                            
                            <rect x="620" y="50" width="160" height="80" class="sgt-box" rx="5"/>
                            <text x="700" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Servers</text>
                            <text x="700" y="100" text-anchor="middle" class="flow-text" font-size="12">SGT: 100</text>
                            <text x="700" y="115" text-anchor="middle" class="flow-text" font-size="12">Web, DB, Apps</text>
                            
                            <!-- TrustSec Domain -->
                            <rect x="40" y="160" width="820" height="380" class="flow-box" rx="5"/>
                            <text x="450" y="190" text-anchor="middle" class="flow-text" font-weight="bold">Cisco TrustSec Domain</text>
                            
                            <!-- Authentication Flow -->
                            <rect x="100" y="210" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="160" y="245" text-anchor="middle" class="flow-text">User/Device</text>
                            
                            <rect x="350" y="210" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="410" y="245" text-anchor="middle" class="flow-text">Switch</text>
                            
                            <rect x="650" y="210" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="245" text-anchor="middle" class="flow-text">ISE</text>
                            
                            <path d="M220 240 L350 240" class="flow-arrow"/>
                            <text x="285" y="230" text-anchor="middle" class="flow-label">1. Auth</text>
                            
                            <path d="M470 240 L650 240" class="flow-arrow"/>
                            <text x="560" y="230" text-anchor="middle" class="flow-label">2. Request</text>
                            
                            <path d="M650 260 L470 260" class="flow-arrow"/>
                            <text x="560" y="275" text-anchor="middle" class="flow-label">3. SGT Assignment</text>
                            
                            <!-- SGT Assignment Examples -->
                            <rect x="100" y="300" width="280" height="100" class="sgt-box" rx="5"/>
                            <text x="240" y="325" text-anchor="middle" class="flow-text" font-weight="bold">Employee Auth Response</text>
                            <text x="240" y="345" text-anchor="middle" class="flow-text" font-size="12">User: john.doe</text>
                            <text x="240" y="365" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "cts:security-group-tag=10"</text>
                            <text x="240" y="385" text-anchor="middle" class="flow-text" font-size="12">Result: Tagged with SGT 10</text>
                            
                            <rect x="420" y="300" width="280" height="100" class="sgt-box" rx="5"/>
                            <text x="560" y="325" text-anchor="middle" class="flow-text" font-weight="bold">IoT Device Auth Response</text>
                            <text x="560" y="345" text-anchor="middle" class="flow-text" font-size="12">MAC: 00:11:22:33:44:55</text>
                            <text x="560" y="365" text-anchor="middle" class="flow-text" font-size="12">Cisco-AVPair = "cts:security-group-tag=30"</text>
                            <text x="560" y="385" text-anchor="middle" class="flow-text" font-size="12">Result: Tagged with SGT 30</text>
                            
                            <!-- Policy Matrix -->
                            <rect x="100" y="420" width="600" height="100" class="policy-box" rx="5"/>
                            <text x="400" y="445" text-anchor="middle" class="flow-text" font-weight="bold">SGT Policy Matrix</text>
                            <text x="200" y="470" text-anchor="start" class="flow-text" font-size="12">• Employees (10) → Servers (100): Allow specific ports</text>
                            <text x="200" y="490" text-anchor="start" class="flow-text" font-size="12">• Contractors (20) → Servers (100): Deny sensitive data</text>
                            <text x="200" y="510" text-anchor="start" class="flow-text" font-size="12">• IoT (30) → Internet: Allow NTP/MQTT only</text>
                            
                            <!-- SGT Propagation -->
                            <rect x="40" y="560" width="820" height="180" class="flow-box" rx="5"/>
                            <text x="450" y="590" text-anchor="middle" class="flow-text" font-weight="bold">SGT Propagation Methods</text>
                            
                            <rect x="80" y="610" width="180" height="100" class="sgt-box" rx="5"/>
                            <text x="170" y="635" text-anchor="middle" class="flow-text" font-weight="bold">Inline Tagging</text>
                            <text x="170" y="655" text-anchor="middle" class="flow-text" font-size="12">• Native support</text>
                            <text x="170" y="675" text-anchor="middle" class="flow-text" font-size="12">• Hardware based</text>
                            <text x="170" y="695" text-anchor="middle" class="flow-text" font-size="12">• Line rate</text>
                            
                            <rect x="280" y="610" width="180" height="100" class="sgt-box" rx="5"/>
                            <text x="370" y="635" text-anchor="middle" class="flow-text" font-weight="bold">SXP Protocol</text>
                            <text x="370" y="655" text-anchor="middle" class="flow-text" font-size="12">• Legacy devices</text>
                            <text x="370" y="675" text-anchor="middle" class="flow-text" font-size="12">• IP-SGT mapping</text>
                            <text x="370" y="695" text-anchor="middle" class="flow-text" font-size="12">• Peering based</text>
                            
                            <rect x="480" y="610" width="180" height="100" class="sgt-box" rx="5"/>
                            <text x="570" y="635" text-anchor="middle" class="flow-text" font-weight="bold">SGT Exchange</text>
                            <text x="570" y="655" text-anchor="middle" class="flow-text" font-size="12">• Via SXPv4</text>
                            <text x="570" y="675" text-anchor="middle" class="flow-text" font-size="12">• Scalable</text>
                            <text x="570" y="695" text-anchor="middle" class="flow-text" font-size="12">• Cloud ready</text>
                            
                            <rect x="680" y="610" width="160" height="100" class="sgt-box" rx="5"/>
                            <text x="760" y="635" text-anchor="middle" class="flow-text" font-weight="bold">EPG Translation</text>
                            <text x="760" y="655" text-anchor="middle" class="flow-text" font-size="12">• ACI integration</text>
                            <text x="760" y="675" text-anchor="middle" class="flow-text" font-size="12">• SGT ↔ EPG</text>
                            <text x="760" y="695" text-anchor="middle" class="flow-text" font-size="12">• Policy sync</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! TrustSec Configuration Examples

! Enable CTS on Switch
cts credentials id SWITCH1 password cisco123
cts role-based enforcement

! Configure PAC (Protected Access Credential)
cts authorization list CTS_LIST
aaa authorization network CTS_LIST group ISE_SERVERS

! SGT Manual Configuration  
cts role-based sgt-map 192.168.10.0/24 sgt 10
cts role-based sgt-map 192.168.20.0/24 sgt 20
cts role-based sgt-map vlan 100 sgt 30

! SXP Configuration for Legacy Devices
cts sxp enable
cts sxp default source-ip 10.1.1.1
cts sxp default password cisco123
cts sxp connection peer 10.1.1.100 password default mode local
cts sxp connection peer 10.1.1.101 password default mode peer

! RADIUS Configuration for SGT
aaa new-model
aaa authentication dot1x default group ISE_SERVERS
aaa authorization network default group ISE_SERVERS
aaa accounting network default start-stop group ISE_SERVERS

radius server ISE
 address ipv4 10.1.1.100 auth-port 1812 acct-port 1813
 key cisco123
 pac key cisco123</code>
                    </div>
                    <div class="code-block">
                        <code>! SGT Policy Configuration (SGACL)

! Employee to Server Access
cts role-based permissions from 10 to 100 ipv4
 permit tcp dst eq 80
 permit tcp dst eq 443
 permit tcp dst eq 22
 permit tcp dst eq 3389
 deny ip

! Contractor Limited Access
cts role-based permissions from 20 to 100 ipv4
 permit tcp dst eq 80
 permit tcp dst eq 443
 deny ip

! IoT to Internet Only
cts role-based permissions from 30 to 999 ipv4
 permit udp dst eq 123
 permit tcp dst eq 1883
 permit tcp dst eq 8883
 deny ip

! Default Deny Unknown
cts role-based permissions default ipv4
 deny ip</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS SGT Assignment Examples

! Employee Authentication
Access-Accept
  User-Name = "john.doe@corp.com"
  Cisco-AVPair = "cts:security-group-tag=10"
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "100"
  Filter-Id = "Employee_ACL"

! Contractor Authentication  
Access-Accept
  User-Name = "contractor@vendor.com"
  Cisco-AVPair = "cts:security-group-tag=20"
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "200"
  Session-Timeout = 28800

! IoT Device (MAB)
Access-Accept
  User-Name = "001122334455"
  Cisco-AVPair = "cts:security-group-tag=30"
  Cisco-AVPair = "device-traffic-class=iot"
  Filter-Id = "IOT_RESTRICT"

! Dynamic SGT Change via CoA
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "cts:security-group-tag=999"
  Filter-Id = "QUARANTINE_ACL"</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting TrustSec

! Show Commands
show cts status
show cts credentials
show cts environment-data
show cts role-based permissions
show cts role-based policy
show cts sxp connections
show cts interface
show cts rbacl

! Debug Commands  
debug cts all
debug cts authz
debug cts sxp
debug radius
debug aaa authorization

! Verify SGT Assignment
show authentication sessions interface gi1/0/1 details
show cts role-based counters
show cts role-based sgt-map all

! Common Issues:
! 1. PAC provisioning failures
! 2. Environment data download issues  
! 3. SGACL policy syntax errors
! 4. SXP peering problems
! 5. Hardware/software limitations</code>
                    </div>
                `
            },
            'posture-assessment': {
                title: 'Posture Assessment and NAC',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 900" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .compliant-box { fill: #dcfce7; stroke: #16a34a; stroke-width: 2; }
                                .non-compliant-box { fill: #fee2e2; stroke: #dc2626; stroke-width: 2; }
                                .remediation-box { fill: #fef9c3; stroke: #d97706; stroke-width: 2; }
                            </style>
                            
                            <!-- Posture States -->
                            <rect x="50" y="50" width="240" height="80" class="compliant-box" rx="5"/>
                            <text x="170" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Compliant Device</text>
                            <text x="170" y="100" text-anchor="middle" class="flow-text" font-size="12">✓ AV Updated ✓ Patches Current</text>
                            <text x="170" y="115" text-anchor="middle" class="flow-text" font-size="12">✓ Firewall On ✓ Encryption OK</text>
                            
                            <rect x="330" y="50" width="240" height="80" class="non-compliant-box" rx="5"/>
                            <text x="450" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Non-Compliant Device</text>
                            <text x="450" y="100" text-anchor="middle" class="flow-text" font-size="12">✗ AV Outdated ✗ Missing Patches</text>
                            <text x="450" y="115" text-anchor="middle" class="flow-text" font-size="12">✗ Firewall Off ✗ USB Enabled</text>
                            
                            <rect x="610" y="50" width="240" height="80" class="remediation-box" rx="5"/>
                            <text x="730" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Unknown Device</text>
                            <text x="730" y="100" text-anchor="middle" class="flow-text" font-size="12">? No Agent ? Not Assessed</text>
                            <text x="730" y="115" text-anchor="middle" class="flow-text" font-size="12">Requires Installation</text>
                            
                            <!-- Posture Flow -->
                            <rect x="100" y="180" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="160" y="215" text-anchor="middle" class="flow-text">Endpoint</text>
                            
                            <rect x="350" y="180" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="410" y="215" text-anchor="middle" class="flow-text">NAD</text>
                            
                            <rect x="600" y="180" width="150" height="60" class="flow-box" rx="5"/>
                            <text x="675" y="215" text-anchor="middle" class="flow-text">ISE/NAC Server</text>
                            
                            <!-- Initial Auth -->
                            <path d="M220 210 L350 210" class="flow-arrow"/>
                            <text x="285" y="200" text-anchor="middle" class="flow-label">1. Connect</text>
                            
                            <path d="M470 210 L600 210" class="flow-arrow"/>
                            <text x="535" y="200" text-anchor="middle" class="flow-label">2. Auth/MAB</text>
                            
                            <!-- Posture Assessment Process -->
                            <rect x="40" y="270" width="820" height="320" class="flow-box" rx="5"/>
                            <text x="450" y="300" text-anchor="middle" class="flow-text" font-weight="bold">Posture Assessment Process</text>
                            
                            <!-- Stage 1: Initial Access -->
                            <rect x="80" y="320" width="240" height="100" class="remediation-box" rx="5"/>
                            <text x="200" y="345" text-anchor="middle" class="flow-text" font-weight="bold">Stage 1: Initial Access</text>
                            <text x="200" y="365" text-anchor="middle" class="flow-text" font-size="12">• Limited network access</text>
                            <text x="200" y="380" text-anchor="middle" class="flow-text" font-size="12">• Redirect to agent download</text>
                            <text x="200" y="395" text-anchor="middle" class="flow-text" font-size="12">• DHCP, DNS, Remediation only</text>
                            <text x="200" y="410" text-anchor="middle" class="flow-text" font-size="12">Response: Posture_Redirect</text>
                            
                            <!-- Stage 2: Agent Check -->
                            <rect x="340" y="320" width="240" height="100" class="flow-box" rx="5"/>
                            <text x="460" y="345" text-anchor="middle" class="flow-text" font-weight="bold">Stage 2: Agent Discovery</text>
                            <text x="460" y="365" text-anchor="middle" class="flow-text" font-size="12">• Check for NAC agent</text>
                            <text x="460" y="380" text-anchor="middle" class="flow-text" font-size="12">• Temporal agent option</text>
                            <text x="460" y="395" text-anchor="middle" class="flow-text" font-size="12">• Client provisioning</text>
                            <text x="460" y="410" text-anchor="middle" class="flow-text" font-size="12">Response: Agent_Install</text>
                            
                            <!-- Stage 3: Assessment -->
                            <rect x="600" y="320" width="240" height="100" class="flow-box" rx="5"/>
                            <text x="720" y="345" text-anchor="middle" class="flow-text" font-weight="bold">Stage 3: Assessment</text>
                            <text x="720" y="365" text-anchor="middle" class="flow-text" font-size="12">• Check AV status</text>
                            <text x="720" y="380" text-anchor="middle" class="flow-text" font-size="12">• Verify patches</text>
                            <text x="720" y="395" text-anchor="middle" class="flow-text" font-size="12">• Validate compliance</text>
                            <text x="720" y="410" text-anchor="middle" class="flow-text" font-size="12">• Registry/file checks</text>
                            
                            <!-- Stage 4: Results -->
                            <rect x="80" y="440" width="240" height="120" class="compliant-box" rx="5"/>
                            <text x="200" y="465" text-anchor="middle" class="flow-text" font-weight="bold">Compliant Result</text>
                            <text x="200" y="485" text-anchor="middle" class="flow-text" font-size="12">• Full network access</text>
                            <text x="200" y="500" text-anchor="middle" class="flow-text" font-size="12">• Production VLAN</text>
                            <text x="200" y="515" text-anchor="middle" class="flow-text" font-size="12">• Remove restrictions</text>
                            <text x="200" y="530" text-anchor="middle" class="flow-text" font-size="12">• Apply employee ACL</text>
                            <text x="200" y="545" text-anchor="middle" class="flow-text" font-size="12">CoA: Full_Access</text>
                            
                            <rect x="340" y="440" width="240" height="120" class="non-compliant-box" rx="5"/>
                            <text x="460" y="465" text-anchor="middle" class="flow-text" font-weight="bold">Non-Compliant Result</text>
                            <text x="460" y="485" text-anchor="middle" class="flow-text" font-size="12">• Quarantine VLAN</text>
                            <text x="460" y="500" text-anchor="middle" class="flow-text" font-size="12">• Remediation access</text>
                            <text x="460" y="515" text-anchor="middle" class="flow-text" font-size="12">• Update servers only</text>
                            <text x="460" y="530" text-anchor="middle" class="flow-text" font-size="12">• Limited time window</text>
                            <text x="460" y="545" text-anchor="middle" class="flow-text" font-size="12">CoA: Quarantine</text>
                            
                            <rect x="600" y="440" width="240" height="120" class="remediation-box" rx="5"/>
                            <text x="720" y="465" text-anchor="middle" class="flow-text" font-weight="bold">Remediation Action</text>
                            <text x="720" y="485" text-anchor="middle" class="flow-text" font-size="12">• Auto-update AV</text>
                            <text x="720" y="500" text-anchor="middle" class="flow-text" font-size="12">• Install patches</text>
                            <text x="720" y="515" text-anchor="middle" class="flow-text" font-size="12">• Fix firewall settings</text>
                            <text x="720" y="530" text-anchor="middle" class="flow-text" font-size="12">• Reassess after fix</text>
                            <text x="720" y="545" text-anchor="middle" class="flow-text" font-size="12">Loop until compliant</text>
                            
                            <!-- Continuous Monitoring -->
                            <rect x="40" y="610" width="820" height="140" class="flow-box" rx="5"/>
                            <text x="450" y="640" text-anchor="middle" class="flow-text" font-weight="bold">Continuous Posture Monitoring</text>
                            
                            <rect x="100" y="660" width="220" height="70" class="flow-box" rx="5"/>
                            <text x="210" y="685" text-anchor="middle" class="flow-text" font-weight="bold">Periodic Check</text>
                            <text x="210" y="705" text-anchor="middle" class="flow-text" font-size="12">• Every 4-8 hours</text>
                            <text x="210" y="720" text-anchor="middle" class="flow-text" font-size="12">• Background assessment</text>
                            
                            <rect x="340" y="660" width="220" height="70" class="flow-box" rx="5"/>
                            <text x="450" y="685" text-anchor="middle" class="flow-text" font-weight="bold">Event Triggered</text>
                            <text x="450" y="705" text-anchor="middle" class="flow-text" font-size="12">• USB insertion</text>
                            <text x="450" y="720" text-anchor="middle" class="flow-text" font-size="12">• Software install/removal</text>
                            
                            <rect x="580" y="660" width="220" height="70" class="flow-box" rx="5"/>
                            <text x="690" y="685" text-anchor="middle" class="flow-text" font-weight="bold">Grace Period</text>
                            <text x="690" y="705" text-anchor="middle" class="flow-text" font-size="12">• Warning before action</text>
                            <text x="690" y="720" text-anchor="middle" class="flow-text" font-size="12">• Allow user remediation</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! NAC Posture Configuration

! Enable Device Sensor for Profiling
device-sensor filter-list dhcp list DHCP_SENSOR
 option name host-name
 option name requested-address
 option name parameter-request-list
 option name class-identifier
 option name client-identifier

! Switch Configuration for Posture
interface GigabitEthernet1/0/1
 description NAC Enabled Port
 switchport mode access
 authentication port-control auto
 authentication host-mode multi-auth
 authentication order dot1x mab
 authentication priority dot1x mab
 authentication periodic
 authentication timer reauthenticate server
 mab
 dot1x pae authenticator
 dot1x timeout tx-period 10
 spanning-tree portfast

! Redirect ACL for Posture  
ip access-list extended POSTURE_REDIRECT
 deny udp any eq bootpc any eq bootps
 deny udp any any eq domain
 deny tcp any host 10.1.1.100 eq 8443
 deny tcp any host 10.1.1.100 eq 8905
 deny tcp any host 10.1.1.100 eq 8909
 permit tcp any any eq 80
 permit tcp any any eq 443

! Quarantine ACL
ip access-list extended QUARANTINE_ACL
 permit udp any eq bootpc any eq bootps
 permit udp any any eq domain
 permit tcp any host 10.1.1.100 eq 8443
 permit tcp any host 10.1.1.100 eq 8905
 permit tcp any host 10.1.1.50 eq 80
 permit tcp any host 10.1.1.51 eq 80
 deny ip any any</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS Posture Responses

! Initial Access (Unknown Posture)
Access-Accept
  Cisco-AVPair = "url-redirect-acl=POSTURE_REDIRECT"
  Cisco-AVPair = "url-redirect=https://ise.company.com:8443/portal/gateway?sessionId=AC10013F00000030A8B84E4B&portal=Client_Provisioning_Portal"
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "99"
  Session-Timeout = 180

! Non-Compliant Device
Access-Accept
  Cisco-AVPair = "url-redirect-acl=QUARANTINE_REDIRECT"
  Cisco-AVPair = "url-redirect=https://ise.company.com:8443/portal/gateway?sessionId=AC10013F00000030A8B84E4B&portal=Remediation_Portal"
  Filter-Id = "QUARANTINE_ACL"
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "999"
  Session-Timeout = 3600
  
! Compliant Device  
Access-Accept
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "100"
  Filter-Id = "EMPLOYEE_FULL_ACCESS"
  Cisco-AVPair = "cts:security-group-tag=10"
  Session-Timeout = 28800

! Periodic Reassessment CoA
CoA-Request
  Acct-Session-Id = "00000123"
  Cisco-AVPair = "subscriber:command=reauthenticate"
  Cisco-AVPair = "subscriber:reauthenticate-type=last"</code>
                    </div>
                    <div class="code-block">
                        <code>! Posture Policy Examples (ISE)

! Windows Posture Conditions
- Antivirus:
  * Check if Windows Defender is enabled
  * Verify signature updates < 1 day old
  * Real-time protection must be active

- Windows Updates:
  * Critical updates installed
  * Security updates < 30 days old
  * No pending reboot for updates

- Firewall:
  * Windows Firewall enabled
  * Domain/Private/Public profiles active
  
- Registry Checks:
  * USB storage disabled
  * AutoRun disabled
  * BitLocker enabled on system drive

- File Existence:
  * Corporate AV agent installed
  * VPN client present
  * Encryption certificate valid

! macOS Posture Conditions  
- FileVault encryption enabled
- Gatekeeper enabled
- XProtect definitions current
- System Integrity Protection (SIP) enabled

! Remediation Actions
- Auto-update antivirus definitions
- Enable Windows Firewall
- Install missing patches
- Disable unauthorized services
- Install required applications</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting Posture

! Show Commands
show authentication sessions
show authentication sessions interface gi1/0/1 details
show access-session interface gi1/0/1 details
show ip access-lists
show ip device tracking all

! Debug Commands
debug radius authentication
debug aaa authentication
debug dot1x all
debug ip device tracking

! Common Issues:
1. Agent communication blocked
   - Check redirect ACL
   - Verify agent server reachability
   
2. Stuck in posture assessment
   - Session timeout too short
   - Network connectivity issues
   
3. False non-compliance
   - Posture policy too strict
   - Agent/server version mismatch
   
4. CoA failures
   - Session ID mismatch
   - Unsupported attributes
   
! ISE Live Logs
- Check RADIUS Live Logs
- Review Posture assessment results
- Verify client provisioning status</code>
                    </div>
                `
            },
            'vpn-auth': {
                title: 'VPN Authentication and Authorization',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 850" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .vpn-type { fill: #e0f2fe; stroke: #0284c7; stroke-width: 2; }
                                .auth-phase { fill: #fef3c7; stroke: #d97706; stroke-width: 2; }
                            </style>
                            
                            <!-- VPN Types -->
                            <rect x="50" y="50" width="200" height="80" class="vpn-type" rx="5"/>
                            <text x="150" y="80" text-anchor="middle" class="flow-text" font-weight="bold">SSL VPN</text>
                            <text x="150" y="100" text-anchor="middle" class="flow-text" font-size="12">AnyConnect/WebVPN</text>
                            <text x="150" y="115" text-anchor="middle" class="flow-text" font-size="12">Clientless/Full Tunnel</text>
                            
                            <rect x="280" y="50" width="200" height="80" class="vpn-type" rx="5"/>
                            <text x="380" y="80" text-anchor="middle" class="flow-text" font-weight="bold">IPSec VPN</text>
                            <text x="380" y="100" text-anchor="middle" class="flow-text" font-size="12">IKEv1/IKEv2</text>
                            <text x="380" y="115" text-anchor="middle" class="flow-text" font-size="12">Site-to-Site/RA</text>
                            
                            <rect x="510" y="50" width="180" height="80" class="vpn-type" rx="5"/>
                            <text x="600" y="80" text-anchor="middle" class="flow-text" font-weight="bold">L2TP/PPTP</text>
                            <text x="600" y="100" text-anchor="middle" class="flow-text" font-size="12">Legacy Protocols</text>
                            <text x="600" y="115" text-anchor="middle" class="flow-text" font-size="12">Basic Auth</text>
                            
                            <rect x="720" y="50" width="150" height="80" class="vpn-type" rx="5"/>
                            <text x="795" y="80" text-anchor="middle" class="flow-text" font-weight="bold">DMVPN</text>
                            <text x="795" y="100" text-anchor="middle" class="flow-text" font-size="12">Hub-Spoke</text>
                            <text x="795" y="115" text-anchor="middle" class="flow-text" font-size="12">Dynamic Routing</text>
                            
                            <!-- Authentication Flow -->
                            <rect x="40" y="160" width="820" height="490" class="flow-box" rx="5"/>
                            <text x="450" y="190" text-anchor="middle" class="flow-text" font-weight="bold">VPN Authentication Process (AnyConnect Example)</text>
                            
                            <!-- Phase 1: Initial Connection -->
                            <rect x="80" y="210" width="740" height="130" class="auth-phase" rx="5"/>
                            <text x="450" y="235" text-anchor="middle" class="flow-text" font-weight="bold">Phase 1: Initial Connection</text>
                            
                            <rect x="100" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="160" y="285" text-anchor="middle" class="flow-text">VPN Client</text>
                            
                            <rect x="380" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="440" y="285" text-anchor="middle" class="flow-text">ASA/FTD</text>
                            
                            <rect x="680" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="740" y="285" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <path d="M220 280 L380 280" class="flow-arrow"/>
                            <text x="300" y="270" text-anchor="middle" class="flow-label">1. Connect</text>
                            
                            <!-- Phase 2: Authentication -->
                            <rect x="80" y="360" width="740" height="170" class="auth-phase" rx="5"/>
                            <text x="450" y="385" text-anchor="middle" class="flow-text" font-weight="bold">Phase 2: User Authentication</text>
                            
                            <path d="M500 410 L680 410" class="flow-arrow"/>
                            <text x="590" y="400" text-anchor="middle" class="flow-label">2. Access-Request</text>
                            <text x="590" y="420" text-anchor="middle" class="flow-label" font-size="10">User-Name, Password</text>
                            
                            <path d="M680 450 L500 450" class="flow-arrow"/>
                            <text x="590" y="440" text-anchor="middle" class="flow-label">3. Access-Accept</text>
                            <text x="590" y="465" text-anchor="middle" class="flow-label" font-size="10">Group-Policy, IP Pool</text>
                            <text x="590" y="480" text-anchor="middle" class="flow-label" font-size="10">Split-Tunnel, DNS</text>
                            <text x="590" y="495" text-anchor="middle" class="flow-label" font-size="10">Session-Timeout</text>
                            
                            <path d="M380 470 L220 470" class="flow-arrow"/>
                            <text x="300" y="460" text-anchor="middle" class="flow-label">4. Access Granted</text>
                            
                            <!-- Phase 3: Authorization -->
                            <rect x="80" y="550" width="740" height="80" class="auth-phase" rx="5"/>
                            <text x="450" y="575" text-anchor="middle" class="flow-text" font-weight="bold">Phase 3: Apply Authorization</text>
                            
                            <rect x="300" y="585" width="320" height="35" class="flow-box" rx="5"/>
                            <text x="460" y="607" text-anchor="middle" class="flow-text" font-size="12">Apply: Group Policy, ACLs, Routes, IP Address</text>
                            
                            <!-- VPN Attributes -->
                            <rect x="40" y="670" width="820" height="130" class="flow-box" rx="5"/>
                            <text x="450" y="700" text-anchor="middle" class="flow-text" font-weight="bold">Common VPN RADIUS Attributes</text>
                            
                            <text x="100" y="730" text-anchor="start" class="flow-text" font-size="12">• Framed-IP-Address: Static IP assignment</text>
                            <text x="100" y="750" text-anchor="start" class="flow-text" font-size="12">• Framed-IP-Netmask: Client subnet mask</text>
                            <text x="100" y="770" text-anchor="start" class="flow-text" font-size="12">• Session-Timeout: Maximum session duration</text>
                            
                            <text x="500" y="730" text-anchor="start" class="flow-text" font-size="12">• Idle-Timeout: Disconnect after inactivity</text>
                            <text x="500" y="750" text-anchor="start" class="flow-text" font-size="12">• Filter-Id: ACL to apply to user</text>
                            <text x="500" y="770" text-anchor="start" class="flow-text" font-size="12">• Class: Group-policy assignment</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! ASA VPN Configuration with RADIUS

! RADIUS Server Configuration
aaa-server ISE protocol radius
aaa-server ISE (inside) host 10.1.1.100
 key cisco123
 authentication-port 1812
 accounting-port 1813
 
! AAA Configuration 
aaa authentication enable console ISE LOCAL
aaa authentication http console ISE LOCAL
aaa authentication ssh console ISE LOCAL
aaa authorization command ISE LOCAL
aaa accounting command ISE

! VPN Group Policy
group-policy EMPLOYEE_VPN internal
group-policy EMPLOYEE_VPN attributes
 vpn-tunnel-protocol ssl-client
 split-tunnel-policy tunnelspecified
 split-tunnel-network-list value SPLIT_TUNNEL_ACL
 address-pools value VPN_POOL
 dns-server value 10.1.1.10 10.1.1.11
 vpn-idle-timeout 30
 vpn-session-timeout 480
 vpn-filter value EMPLOYEE_ACL

! IP Pool for VPN Clients
ip local pool VPN_POOL 192.168.100.1-192.168.100.100 mask 255.255.255.0

! Tunnel Group Configuration
tunnel-group ANYCONNECT type remote-access
tunnel-group ANYCONNECT general-attributes
 authentication-server-group ISE
 authorization-server-group ISE
 accounting-server-group ISE
 default-group-policy EMPLOYEE_VPN
 address-pool VPN_POOL
 
tunnel-group ANYCONNECT webvpn-attributes
 group-alias "Employee VPN" enable</code>
                    </div>
                    <div class="code-block">
                        <code>! RADIUS VPN Responses

! Standard Employee VPN Access
Access-Accept
  User-Name = "john.doe"
  Framed-IP-Address = 192.168.100.50
  Framed-IP-Netmask = 255.255.255.0
  Class = "OU=EMPLOYEE_VPN;"
  Session-Timeout = 28800
  Idle-Timeout = 1800
  Filter-Id = "EMPLOYEE_VPN_ACL"
  Cisco-AVPair = "vpn-group-policy=EMPLOYEE_VPN"
  
! Admin VPN Access
Access-Accept
  User-Name = "admin.user"
  Framed-IP-Address = 192.168.100.10
  Class = "OU=ADMIN_VPN;"
  Session-Timeout = 14400
  Filter-Id = "ADMIN_FULL_ACCESS"
  Cisco-AVPair = "vpn-group-policy=ADMIN_VPN"
  Cisco-AVPair = "ipsec:user-vpn-group=ADMIN_VPN"
  
! Contractor Limited Access
Access-Accept
  User-Name = "contractor@vendor.com"
  Class = "OU=CONTRACTOR_VPN;"
  Session-Timeout = 3600
  Idle-Timeout = 900
  Filter-Id = "CONTRACTOR_LIMITED"
  Cisco-AVPair = "vpn-group-policy=CONTRACTOR_VPN"
  Cisco-AVPair = "webvpn:inacl=CONTRACTOR_WEBACL"
  
! Guest/Partner Access
Access-Accept
  User-Name = "partner.user"
  Class = "OU=PARTNER_VPN;"
  Session-Timeout = 7200
  Filter-Id = "PARTNER_RESTRICTED"
  Cisco-AVPair = "vpn-group-policy=PARTNER_VPN"
  Cisco-AVPair = "webvpn:url-list=PARTNER_BOOKMARKS"</code>
                    </div>
                    <div class="code-block">
                        <code>! Advanced VPN Attributes

! Cisco ASA/FTD VSAs
Cisco-AVPair = "vpn-simultaneous-logins=1"
Cisco-AVPair = "vpn-idle-timeout=1800"
Cisco-AVPair = "vpn-session-timeout=28800"
Cisco-AVPair = "vpn-tunnel-protocol=ssl-client"
Cisco-AVPair = "vpn-filter=ACL_STANDARD"
Cisco-AVPair = "split-dns=company.com,internal.local"
Cisco-AVPair = "banner=Welcome to Company VPN"
Cisco-AVPair = "always-on-vpn=true"
Cisco-AVPair = "vpn-framed-ip-address=192.168.100.50"
Cisco-AVPair = "vpn-framed-ipv6-address=2001:db8::50/128"

! Split Tunneling
Cisco-AVPair = "split-tunnel-policy=tunnelspecified"
Cisco-AVPair = "split-tunnel-network-list=SPLIT_TUNNEL_ACL"
Cisco-AVPair = "address-pools=VPN_POOL_SALES"

! WebVPN/Clientless Attributes
Cisco-AVPair = "webvpn:url-list=EMPLOYEE_BOOKMARKS"
Cisco-AVPair = "webvpn:inacl=WEBVPN_ACL"
Cisco-AVPair = "webvpn:homepage=https://intranet.company.com"
Cisco-AVPair = "webvpn:port-forward-name=INTERNAL_APPS"
Cisco-AVPair = "webvpn:smart-tunnel=SMART_TUNNEL_APPS"

! Per-App VPN (Mobile)
Cisco-AVPair = "anyconnect-mobile:per-app-vpn=true"
Cisco-AVPair = "anyconnect-mobile:mobile-platform=ios"
Cisco-AVPair = "anyconnect-mobile:mobile-device-type=smartphone"</code>
                    </div>
                    <div class="code-block">
                        <code>! Group Policies and ACLs

! Employee VPN ACL
access-list EMPLOYEE_VPN_ACL extended permit tcp any 10.0.0.0 255.0.0.0
access-list EMPLOYEE_VPN_ACL extended permit udp any 10.0.0.0 255.0.0.0
access-list EMPLOYEE_VPN_ACL extended permit icmp any 10.0.0.0 255.0.0.0
access-list EMPLOYEE_VPN_ACL extended deny ip any any

! Split Tunnel ACL
access-list SPLIT_TUNNEL_ACL standard permit 10.0.0.0 255.0.0.0
access-list SPLIT_TUNNEL_ACL standard permit 172.16.0.0 255.240.0.0
access-list SPLIT_TUNNEL_ACL standard permit 192.168.0.0 255.255.0.0

! WebVPN Portal Customization
webvpn
 enable outside
 tunnel-group-list enable
 
group-policy EMPLOYEE_VPN attributes
 webvpn
  url-list value EMPLOYEE_BOOKMARKS
  homepage value https://intranet.company.com
  html-content-filter cookies javascript activeX
  file-browsing enable
  file-entry enable
  url-entry enable
  
! Dynamic Access Policies (DAP)
dynamic-access-policy-record COMPLIANT_DEVICE
 action continue
 endpoint-attribute value-type endpoint.av.exists
 endpoint-attribute value AV-Program eq "CiscoAMP"</code>
                    </div>
                    <div class="code-block">
                        <code>! Troubleshooting VPN Authentication

! Debug Commands
debug aaa authentication
debug aaa authorization  
debug aaa accounting
debug radius all
debug crypto ikev1/ikev2
debug webvpn

! Show Commands
show vpn-sessiondb summary
show vpn-sessiondb anyconnect
show vpn-sessiondb ra-ikev2-ipsec
show vpn-sessiondb webvpn
show aaa-server ISE

! Common Issues:
1. Authentication failures
   - Check RADIUS connectivity
   - Verify shared secret
   - Review user credentials
   
2. Authorization problems
   - Group policy mapping
   - RADIUS attribute format
   - Missing VSAs
   
3. IP pool exhaustion
   - Expand pool size
   - Reduce session timeout
   - Check for stale sessions
   
4. Split tunneling issues
   - ACL configuration
   - Route conflicts
   - DNS problems</code>
                    </div>
                `
            },
            'iot-auth': {
                title: 'IoT Device Authentication',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 900 900" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'Inter', sans-serif; font-size: 14px; }
                                .flow-arrow { stroke: var(--primary-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .iot-device { fill: #e0f2fe; stroke: #0284c7; stroke-width: 2; }
                                .security-zone { fill: #fef3c7; stroke: #d97706; stroke-width: 2; stroke-dasharray: 5,5; }
                            </style>
                            
                            <!-- IoT Device Types -->
                            <rect x="50" y="50" width="160" height="80" class="iot-device" rx="5"/>
                            <text x="130" y="80" text-anchor="middle" class="flow-text" font-weight="bold">IP Cameras</text>
                            <text x="130" y="100" text-anchor="middle" class="flow-text" font-size="12">• ONVIF Protocol</text>
                            <text x="130" y="115" text-anchor="middle" class="flow-text" font-size="12">• RTSP Streams</text>
                            
                            <rect x="240" y="50" width="160" height="80" class="iot-device" rx="5"/>
                            <text x="320" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Smart Sensors</text>
                            <text x="320" y="100" text-anchor="middle" class="flow-text" font-size="12">• MQTT/CoAP</text>
                            <text x="320" y="115" text-anchor="middle" class="flow-text" font-size="12">• LoRaWAN</text>
                            
                            <rect x="430" y="50" width="160" height="80" class="iot-device" rx="5"/>
                            <text x="510" y="80" text-anchor="middle" class="flow-text" font-weight="bold">HVAC/BMS</text>
                            <text x="510" y="100" text-anchor="middle" class="flow-text" font-size="12">• BACnet</text>
                            <text x="510" y="115" text-anchor="middle" class="flow-text" font-size="12">• Modbus</text>
                            
                            <rect x="620" y="50" width="160" height="80" class="iot-device" rx="5"/>
                            <text x="700" y="80" text-anchor="middle" class="flow-text" font-weight="bold">Medical</text>
                            <text x="700" y="100" text-anchor="middle" class="flow-text" font-size="12">• HL7/DICOM</text>
                            <text x="700" y="115" text-anchor="middle" class="flow-text" font-size="12">• FDA Class II</text>
                            
                            <!-- Authentication Methods -->
                            <rect x="40" y="160" width="820" height="150" class="flow-box" rx="5"/>
                            <text x="450" y="190" text-anchor="middle" class="flow-text" font-weight="bold">IoT Authentication Methods</text>
                            
                            <rect x="80" y="210" width="180" height="80" class="iot-device" rx="5"/>
                            <text x="170" y="235" text-anchor="middle" class="flow-text" font-weight="bold">MAC Auth (MAB)</text>
                            <text x="170" y="255" text-anchor="middle" class="flow-text" font-size="12">• Most common</text>
                            <text x="170" y="270" text-anchor="middle" class="flow-text" font-size="12">• No supplicant</text>
                            
                            <rect x="280" y="210" width="180" height="80" class="iot-device" rx="5"/>
                            <text x="370" y="235" text-anchor="middle" class="flow-text" font-weight="bold">Certificate</text>
                            <text x="370" y="255" text-anchor="middle" class="flow-text" font-size="12">• EAP-TLS</text>
                            <text x="370" y="270" text-anchor="middle" class="flow-text" font-size="12">• High security</text>
                            
                            <rect x="480" y="210" width="180" height="80" class="iot-device" rx="5"/>
                            <text x="570" y="235" text-anchor="middle" class="flow-text" font-weight="bold">PSK/MPSK</text>
                            <text x="570" y="255" text-anchor="middle" class="flow-text" font-size="12">• Per-device key</text>
                            <text x="570" y="270" text-anchor="middle" class="flow-text" font-size="12">• Easy deploy</text>
                            
                            <rect x="680" y="210" width="160" height="80" class="iot-device" rx="5"/>
                            <text x="760" y="235" text-anchor="middle" class="flow-text" font-weight="bold">Profiling</text>
                            <text x="760" y="255" text-anchor="middle" class="flow-text" font-size="12">• DHCP/CDP</text>
                            <text x="760" y="270" text-anchor="middle" class="flow-text" font-size="12">• Fingerprint</text>
                            
                            <!-- IoT Auth Flow -->
                            <rect x="40" y="340" width="820" height="320" class="flow-box" rx="5"/>
                            <text x="450" y="370" text-anchor="middle" class="flow-text" font-weight="bold">IoT Device Onboarding Flow</text>
                            
                            <rect x="100" y="400" width="120" height="60" class="iot-device" rx="5"/>
                            <text x="160" y="435" text-anchor="middle" class="flow-text">IoT Device</text>
                            
                            <rect x="350" y="400" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="410" y="435" text-anchor="middle" class="flow-text">Switch</text>
                            
                            <rect x="600" y="400" width="150" height="60" class="flow-box" rx="5"/>
                            <text x="675" y="435" text-anchor="middle" class="flow-text">RADIUS/ISE</text>
                            
                            <path d="M220 430 L350 430" class="flow-arrow"/>
                            <text x="285" y="420" text-anchor="middle" class="flow-label">1. Connect</text>
                            
                            <path d="M470 430 L600 430" class="flow-arrow"/>
                            <text x="535" y="420" text-anchor="middle" class="flow-label">2. MAB</text>
                            
                            <path d="M600 460 L470 460" class="flow-arrow"/>
                            <text x="535" y="475" text-anchor="middle" class="flow-label">3. Profile</text>
                            
                            <!-- Profiling Data -->
                            <rect x="550" y="500" width="250" height="120" class="iot-device" rx="5"/>
                            <text x="675" y="525" text-anchor="middle" class="flow-text" font-weight="bold">Collected Attributes</text>
                            <text x="575" y="545" text-anchor="start" class="flow-text" font-size="12">• MAC OUI: Axis Communications</text>
                            <text x="575" y="560" text-anchor="start" class="flow-text" font-size="12">• DHCP Options: "AXIS-00408C123456"</text>
                            <text x="575" y="575" text-anchor="start" class="flow-text" font-size="12">• CDP/LLDP: "AXIS P3225-LV"</text>
                            <text x="575" y="590" text-anchor="start" class="flow-text" font-size="12">• HTTP User-Agent: "Axis/1.0"</text>
                            <text x="575" y="605" text-anchor="start" class="flow-text" font-size="12">• Result: IP Camera Profile</text>
                            
                            <path d="M550 560 L470 560" class="flow-arrow"/>
                            <text x="510" y="550" text-anchor="middle" class="flow-label">4. Authorize</text>
                            
                            <path d="M350 560 L220 560" class="flow-arrow"/>
                            <text x="285" y="550" text-anchor="middle" class="flow-label">5. Apply Policy</text>
                            
                            <!-- Security Zones -->
                            <rect x="40" y="690" width="820" height="160" class="flow-box" rx="5"/>
                            <text x="450" y="720" text-anchor="middle" class="flow-text" font-weight="bold">IoT Security Architecture</text>
                            
                            <rect x="80" y="740" width="180" height="90" class="security-zone" rx="5"/>
                            <text x="170" y="765" text-anchor="middle" class="flow-text" font-weight="bold">IoT Zone</text>
                            <text x="170" y="785" text-anchor="middle" class="flow-text" font-size="12">• Isolated VLAN</text>
                            <text x="170" y="800" text-anchor="middle" class="flow-text" font-size="12">• No Internet</text>
                            <text x="170" y="815" text-anchor="middle" class="flow-text" font-size="12">• Strict ACLs</text>
                            
                            <rect x="280" y="740" width="180" height="90" class="security-zone" rx="5"/>
                            <text x="370" y="765" text-anchor="middle" class="flow-text" font-weight="bold">Management</text>
                            <text x="370" y="785" text-anchor="middle" class="flow-text" font-size="12">• IoT Controllers</text>
                            <text x="370" y="800" text-anchor="middle" class="flow-text" font-size="12">• Update Servers</text>
                            <text x="370" y="815" text-anchor="middle" class="flow-text" font-size="12">• NTP/DNS</text>
                            
                            <rect x="480" y="740" width="180" height="90" class="security-zone" rx="5"/>
                            <text x="570" y="765" text-anchor="middle" class="flow-text" font-weight="bold">DMZ</text>
                            <text x="570" y="785" text-anchor="middle" class="flow-text" font-size="12">• IoT Gateway</text>
                            <text x="570" y="800" text-anchor="middle" class="flow-text" font-size="12">• API Proxy</text>
                            <text x="570" y="815" text-anchor="middle" class="flow-text" font-size="12">• Cloud Bridge</text>
                            
                            <rect x="680" y="740" width="160" height="90" class="security-zone" rx="5"/>
                            <text x="760" y="765" text-anchor="middle" class="flow-text" font-weight="bold">Corporate</text>
                            <text x="760" y="785" text-anchor="middle" class="flow-text" font-size="12">• User Access</text>
                            <text x="760" y="800" text-anchor="middle" class="flow-text" font-size="12">• Applications</text>
                            <text x="760" y="815" text-anchor="middle" class="flow-text" font-size="12">• Monitoring</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>! IoT Device Switch Configuration

! Global Configuration
device-sensor filter-list dhcp list DHCP_LIST
device-sensor filter-list lldp list LLDP_LIST  
device-sensor filter-list cdp list CDP_LIST
device-sensor notify all-changes

! Interface Configuration for IoT
interface GigabitEthernet1/0/1
 description IoT Device Port
 switchport mode access
 switchport access vlan 999
 authentication host-mode multi-auth
 authentication order mab dot1x
 authentication priority mab dot1x
 authentication port-control auto
 authentication periodic
 authentication timer reauthenticate server
 mab
 dot1x pae authenticator
 dot1x timeout tx-period 10
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip device tracking maximum 10
 device-tracking attach-policy IPDT_POLICY

! IoT VLANs
vlan 100
 name IOT_CAMERAS
vlan 110
 name IOT_SENSORS
vlan 120
 name IOT_HVAC
vlan 130
 name IOT_MEDICAL
vlan 999
 name IOT_QUARANTINE

! RADIUS Configuration  
radius server ISE
 address ipv4 10.1.1.100 auth-port 1812 acct-port 1813
 key cisco123
 
aaa authentication dot1x default group ISE
aaa authorization network default group ISE
aaa accounting network default start-stop group ISE</code>
                    </div>
                    <div class="code-block">
                        <code>! IoT Device Profiles and Responses

! IP Camera Profile Response
Access-Accept
  User-Name = "00408c123456"
  Tunnel-Type = VLAN
  Tunnel-Private-Group-ID = "100"
  Filter-Id = "IOT_CAMERA_ACL"
  Cisco-AVPair = "device-traffic-class=voice"
 Cisco-AVPair = "subscriber:sub-qos-policy-in=CAMERA_QOS"
 Session-Timeout = 86400

! Smart Sensor Profile Response
Access-Accept
 User-Name = "001122334455"
 Tunnel-Type = VLAN
 Tunnel-Private-Group-ID = "110"
 Filter-Id = "IOT_SENSOR_ACL"
 Cisco-AVPair = "subscriber:sub-qos-policy-in=SENSOR_QOS"
 Termination-Action = RADIUS-Request
 
! HVAC System Profile Response
Access-Accept
 User-Name = "aabbccddeeff"
 Tunnel-Type = VLAN
 Tunnel-Private-Group-ID = "120"
 Filter-Id = "IOT_HVAC_ACL"
 Cisco-AVPair = "device-traffic-class=iot"
 Session-Timeout = 0

! Medical Device Profile Response  
Access-Accept
 User-Name = "112233445566"
 Tunnel-Type = VLAN
 Tunnel-Private-Group-ID = "130"
 Filter-Id = "IOT_MEDICAL_ACL"
 Cisco-AVPair = "subscriber:sub-qos-policy-in=MEDICAL_QOS"
 Cisco-AVPair = "device-traffic-class=medical"
 Session-Timeout = 3600</code>
                   </div>
                   <div class="code-block">
                       <code>! IoT ACLs and Security Policies

! IP Camera ACL
ip access-list extended IOT_CAMERA_ACL
remark DHCP and DNS
permit udp any eq bootpc any eq bootps
permit udp any any eq domain
remark NTP
permit udp any host 10.1.1.40 eq ntp
remark Camera Management
permit tcp any host 10.1.1.100 eq 80
permit tcp any host 10.1.1.100 eq 443
permit tcp any host 10.1.1.100 eq 554
remark Video Streaming to NVR
permit tcp any host 10.1.2.10 range 8000 8003
permit tcp any host 10.1.2.10 eq 554
remark ONVIF Protocol
permit tcp any host 10.1.2.10 eq 8080
deny ip any any log

! Smart Sensor ACL  
ip access-list extended IOT_SENSOR_ACL
permit udp any eq bootpc any eq bootps
permit udp any host 10.1.1.40 eq ntp
remark MQTT Broker
permit tcp any host 10.1.3.10 eq 1883
permit tcp any host 10.1.3.10 eq 8883
remark CoAP Protocol
permit udp any host 10.1.3.10 eq 5683
deny ip any any log

! HVAC System ACL
ip access-list extended IOT_HVAC_ACL
permit udp any eq bootpc any eq bootps
remark BACnet Protocol  
permit udp any any eq 47808
permit ip any 10.1.4.0 0.0.0.255
remark Modbus TCP
permit tcp any host 10.1.4.10 eq 502
deny ip any any log

! Medical Device ACL
ip access-list extended IOT_MEDICAL_ACL
permit udp any eq bootpc any eq bootps
permit tcp any host 10.1.5.10 eq 443
remark HL7 Communications
permit tcp any host 10.1.5.20 eq 2575
remark DICOM Protocol
permit tcp any host 10.1.5.30 eq 104
permit tcp any host 10.1.5.30 eq 11112
deny ip any any log</code>
                   </div>
                   <div class="code-block">
                       <code>! IoT Device Profiling Attributes

! DHCP Fingerprinting
device-sensor filter-spec dhcp DHCP_LIST
option 12 hostname
option 60 vendor-class-identifier  
option 61 client-identifier
option 55 parameter-request-list

! CDP/LLDP Discovery
device-sensor filter-spec cdp CDP_LIST
tlv device-name
tlv platform-type
tlv capabilities-type

device-sensor filter-spec lldp LLDP_LIST
tlv system-name
tlv system-description
tlv system-capabilities
tlv management-address

! IP Device Tracking Policy
device-tracking policy IPDT_POLICY
device-role node
security-level guard
tracking enable

! Profiling Examples:
! Axis Camera DHCP Option 60: "AXIS,Network Camera,M3044,5.51.4.2"
! Cisco Phone CDP Device-ID: "SEP001122334455"
! IoT Sensor DHCP Hostname: "sensor-bldg1-rm105"
! Medical Device LLDP System: "Philips-IntelliVue-MX450"</code>
                   </div>
                   <div class="code-block">
                       <code>! IoT Security Best Practices

! 1. Network Segmentation
vlan 100
name IOT_CAMERAS
vlan 110  
name IOT_SENSORS
vlan 120
name IOT_HVAC
vlan 130
name IOT_MEDICAL
vlan 140
name IOT_MGMT
vlan 150
name IOT_DMZ

! 2. Private VLANs for Isolation
vlan 100
private-vlan isolated
vlan 101
private-vlan community
vlan 102
private-vlan primary
private-vlan association 100,101

! 3. DHCP Snooping and ARP Inspection
ip dhcp snooping
ip dhcp snooping vlan 100-150
ip arp inspection vlan 100-150
ip arp inspection validate src-mac dst-mac ip

! 4. Port Security
interface range GigabitEthernet1/0/1-24
switchport port-security
switchport port-security maximum 2
switchport port-security violation restrict
switchport port-security mac-address sticky

! 5. Storm Control
interface range GigabitEthernet1/0/1-24  
storm-control broadcast level 1.00
storm-control multicast level 2.00
storm-control action trap

! 6. QoS for Critical IoT
class-map match-any MEDICAL_IOT
match access-group name MEDICAL_TRAFFIC
policy-map IOT_QOS
class MEDICAL_IOT
 priority percent 20
 set dscp af41</code>
                   </div>
                   <div class="code-block">
                       <code>! IoT Certificate-Based Authentication

! Configure 802.1X for Certificate Auth
aaa authentication dot1x default group radius
aaa authorization network default group radius

! Interface Config for Certificate-Based IoT
interface GigabitEthernet1/0/1
dot1x pae authenticator
dot1x authenticator eap profile EAP_TLS_PROFILE
dot1x timeout quiet-period 3
dot1x timeout tx-period 5
authentication port-control auto

! EAP Profile  
dot1x authenticator eap profile EAP_TLS_PROFILE
method tls

! RADIUS Response for Certificate Auth
Access-Accept
 User-Name = "camera01.iot.company.com"
 Tunnel-Type = VLAN
 Tunnel-Private-Group-ID = "100"
 Filter-Id = "CERT_IOT_ACL"
 Cisco-AVPair = "device-traffic-class=iot-secure"
 Class = "IoT-Certificate-Device"

! Certificate Template for IoT
crypto pki trustpoint IOT_CA
enrollment terminal
revocation-check crl

crypto pki certificate chain IOT_CA
certificate ca 01
 ! CA Certificate content</code>
                   </div>
                   <div class="code-block">
                       <code>! IoT Monitoring and Troubleshooting

! Show Commands
show authentication sessions
show authentication sessions interface gi1/0/1 details
show device-sensor cache all
show ip device tracking all
show mab all
show mab interface gi1/0/1 details

! Debug Commands  
debug radius authentication
debug mab all
debug device-sensor all
debug ip device tracking

! Example Output - Camera Detection
*Mar  1 00:01:23: RADIUS:  User-Name           [1]   14  "00408c123456"
*Mar  1 00:01:23: RADIUS:  Vendor, Cisco       [26]  31  
*Mar  1 00:01:23: RADIUS:   Cisco AVpair       [1]   25  "dhcp-option=AXIS,Camera"
*Mar  1 00:01:23: RADIUS:   Cisco AVpair       [1]   35  "lldp-tlv=system-name=AXIS-P3225"

! Common IoT Issues:
1. Device not profiling correctly
  - Check device-sensor configuration
  - Verify DHCP snooping is enabled
  - Enable CDP/LLDP on ports

2. MAB authentication failures
  - Verify MAC format (001122334455)
  - Check RADIUS server MAB configuration
  - Ensure MAB is enabled on port

3. Wrong VLAN assignment
  - Verify profiling rules in ISE
  - Check VLAN exists on switch
  - Review authorization profile

4. IoT device connectivity issues
  - Check ACLs for required protocols
  - Verify QoS not dropping packets
  - Review spanning-tree blocked ports</code>
                   </div>
               `
           }
       };

       // Modal functions
       function showWorkflow(type) {
           const workflow = workflows[type];
           if (!workflow) return;
           
           const modal = document.getElementById('workflowModal');
           const content = document.getElementById('modalContent');
           
           content.innerHTML = `
               <h2>${workflow.title}</h2>
               ${workflow.content}
           `;
           
           modal.style.display = 'flex';
       }

       function closeModal() {
           document.getElementById('workflowModal').style.display = 'none';
       }

       // Close modal on outside click
       window.onclick = function(event) {
           const modal = document.getElementById('workflowModal');
           if (event.target === modal) {
               modal.style.display = 'none';
           }
       }
   </script>
</body>
</html>
EOF

# Create viewer.html
cat > "viewer.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>VSA Viewer - 1Xer Radtribution</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Source+Code+Pro:wght@400;600&display=swap" rel="stylesheet">
   <style>
       :root {
           --primary-color: #2563eb;
           --secondary-color: #dc2626;
           --accent-color: #0891b2;
           --success-color: #16a34a;
           --warning-color: #d97706;
           --bg-dark: #0f172a;
           --bg-light: #1e293b;
           --text-light: #e2e8f0;
           --text-dark: #f8fafc;
           --card-bg: #1e293b;
           --border-color: #334155;
       }

       [data-theme="light"] {
           --bg-dark: #ffffff;
           --bg-light: #f8fafc;
           --text-light: #1e293b;
           --text-dark: #0f172a;
           --card-bg: #ffffff;
           --border-color: #e2e8f0;
       }

       * {
           margin: 0;
           padding: 0;
           box-sizing: border-box;
       }

       body {
           font-family: 'Inter', sans-serif;
           background-color: var(--bg-dark);
           color: var(--text-light);
           line-height: 1.6;
       }

       .container {
           max-width: 1400px;
           margin: 0 auto;
           padding: 20px;
       }

       .header {
           text-align: center;
           padding: 30px 20px;
           background: var(--bg-light);
           border-radius: 12px;
           margin-bottom: 30px;
           border: 1px solid var(--border-color);
       }

       .main-title {
           font-size: 2.2rem;
           font-weight: 700;
           color: var(--primary-color);
           margin-bottom: 10px;
       }

       .breadcrumb {
           display: flex;
           align-items: center;
           justify-content: center;
           gap: 10px;
           margin-top: 15px;
           color: var(--text-light);
       }

       .breadcrumb a {
           color: var(--primary-color);
           text-decoration: none;
           font-weight: 500;
           transition: all 0.3s ease;
       }

       .breadcrumb a:hover {
           text-decoration: underline;
       }

       .breadcrumb .separator {
           color: var(--text-light);
       }

       .controls {
           display: flex;
           gap: 20px;
           margin-bottom: 30px;
           flex-wrap: wrap;
           align-items: center;
       }

       .search-box {
           flex: 1;
           min-width: 300px;
           padding: 12px 16px;
           font-size: 1rem;
           background: var(--card-bg);
           border: 1px solid var(--border-color);
           border-radius: 8px;
           color: var(--text-light);
       }

       .search-box:focus {
           outline: none;
           border-color: var(--primary-color);
           box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
       }

       .feature-filters {
           display: flex;
           gap: 10px;
           flex-wrap: wrap;
       }

       .feature-btn {
           padding: 8px 16px;
           background: var(--card-bg);
           border: 1px solid var(--border-color);
           border-radius: 6px;
           cursor: pointer;
           font-size: 0.9rem;
           font-weight: 500;
           transition: all 0.3s ease;
           color: var(--text-light);
       }

       .feature-btn.active {
           background: var(--primary-color);
           color: white;
           border-color: var(--primary-color);
       }

       .feature-btn:hover:not(.active) {
           border-color: var(--primary-color);
           background: var(--bg-light);
       }

       .btn {
           padding: 10px 20px;
           background: var(--primary-color);
           color: white;
           border: none;
           border-radius: 6px;
           cursor: pointer;
           font-weight: 500;
           text-decoration: none;
           transition: all 0.3s ease;
           display: inline-flex;
           align-items: center;
           gap: 8px;
       }

       .btn:hover {
           background: #1d4ed8;
           transform: translateY(-1px);
       }

       .btn-secondary {
           background: var(--card-bg);
           color: var(--text-light);
           border: 1px solid var(--border-color);
       }

       .btn-secondary:hover {
           background: var(--bg-light);
           border-color: var(--primary-color);
       }

       .attributes-table {
           background: var(--card-bg);
           border-radius: 12px;
           overflow: hidden;
           border: 1px solid var(--border-color);
           margin-bottom: 30px;
       }

       table {
           width: 100%;
           border-collapse: collapse;
       }

       th, td {
           padding: 12px 16px;
           text-align: left;
           border-bottom: 1px solid var(--border-color);
       }

       th {
           background: var(--bg-light);
           font-weight: 600;
           color: var(--text-dark);
           position: sticky;
           top: 0;
           z-index: 10;
       }

       tr:hover {
           background: var(--bg-light);
       }

       .attribute-name {
           font-weight: 600;
           color: var(--primary-color);
           font-family: 'Source Code Pro', monospace;
       }

       .attribute-number {
           font-family: 'Source Code Pro', monospace;
           color: var(--accent-color);
       }

       .feature-badges {
           display: flex;
           gap: 6px;
           flex-wrap: wrap;
       }

       .feature-badge {
           padding: 4px 8px;
           border-radius: 4px;
           font-size: 0.75rem;
           font-weight: 500;
           text-transform: uppercase;
       }

       .feature-badge.yes {
           background: #dcfce7;
           color: #166534;
       }

       [data-theme="dark"] .feature-badge.yes {
           background: #166534;
           color: #dcfce7;
       }

       .expandable-row {
           cursor: pointer;
       }

       .expandable-row:hover {
           background: var(--bg-light);
       }

       .expand-icon {
           transition: transform 0.3s ease;
           margin-right: 8px;
       }

       .expand-icon.expanded {
           transform: rotate(90deg);
       }

       .expanded-content {
           display: none;
           background: var(--bg-dark);
           padding: 20px;
           border-top: 1px solid var(--border-color);
       }

       .expanded-content.show {
           display: block;
       }

       .code-block {
           background: var(--bg-dark);
           border: 1px solid var(--border-color);
           border-radius: 6px;
           padding: 16px;
           overflow-x: auto;
           font-family: 'Source Code Pro', monospace;
           font-size: 0.9rem;
           margin: 10px 0;
       }

       [data-theme="light"] .code-block {
           background: #f3f4f6;
       }

       .theme-toggle {
           position: fixed;
           top: 20px;
           right: 20px;
           background: var(--card-bg);
           border: 1px solid var(--border-color);
           border-radius: 8px;
           width: 44px;
           height: 44px;
           cursor: pointer;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 1.2rem;
           color: var(--primary-color);
           transition: all 0.3s ease;
           z-index: 1000;
       }

       .theme-toggle:hover {
           background: var(--primary-color);
           color: white;
       }

       .info-section {
           background: var(--card-bg);
           padding: 20px;
           border-radius: 12px;
           margin-bottom: 30px;
           border: 1px solid var(--border-color);
       }

       .info-section h3 {
           margin-bottom: 10px;
           color: var(--primary-color);
       }

       @media (max-width: 768px) {
           .controls {
               flex-direction: column;
               gap: 15px;
           }
           
           .search-box {
               width: 100%;
               min-width: unset;
           }
           
           .feature-filters {
               width: 100%;
               justify-content: center;
           }
           
           .table-container {
               overflow-x: auto;
           }
           
           table {
               min-width: 800px;
           }
       }
   </style>
</head>
<body>
   <button class="theme-toggle" onclick="toggleTheme()">
       <i class="fas fa-moon"></i>
   </button>

   <div class="container">
       <div class="header">
           <h1 class="main-title">VSA Attribute Viewer</h1>
           <p>Detailed vendor-specific attribute reference</p>
           <div class="breadcrumb">
               <a href="index.html">Home</a>
               <span class="separator">→</span>
               <span id="vendorName">Loading...</span>
               <span class="separator">→</span>
               <span id="protocolName">Loading...</span>
           </div>
       </div>

       <div class="controls">
           <input type="text" class="search-box" placeholder="Search attributes..." id="searchBox">
           <div class="feature-filters" id="featureFilters">
               <!-- Feature filters will be populated here -->
           </div>
           <a href="#" class="btn btn-secondary" onclick="downloadCSV()">
               <i class="fas fa-download"></i> Export CSV
           </a>
       </div>

       <div class="info-section">
           <h3>Vendor Information</h3>
           <p><strong>Vendor:</strong> <span id="vendorInfo">Loading...</span></p>
           <p><strong>Protocol:</strong> <span id="protocolInfo">Loading...</span></p>
           <p><strong>Total Attributes:</strong> <span id="attributeCount">0</span></p>
       </div>

       <div class="attributes-table">
           <div class="table-container">
               <table>
                   <thead>
                       <tr>
                           <th style="width: 50px;"></th>
                           <th>Attribute Name</th>
                           <th>Number</th>
                           <th>Description</th>
                           <th>Features</th>
                           <th>Example</th>
                       </tr>
                   </thead>
                   <tbody id="attributesBody">
                       <!-- Attributes will be populated here -->
                   </tbody>
               </table>
           </div>
       </div>
   </div>

   <script>
       // Theme toggle
       function toggleTheme() {
           const body = document.body;
           const themeToggle = document.querySelector('.theme-toggle i');
           
           if (body.getAttribute('data-theme') === 'light') {
               body.removeAttribute('data-theme');
               themeToggle.className = 'fas fa-moon';
               localStorage.setItem('theme', 'dark');
           } else {
               body.setAttribute('data-theme', 'light');
               themeToggle.className = 'fas fa-sun';
               localStorage.setItem('theme', 'light');
           }
       }

       // Check for saved theme
       if (localStorage.getItem('theme') === 'light') {
           document.body.setAttribute('data-theme', 'light');
           document.querySelector('.theme-toggle i').className = 'fas fa-sun';
       }

       // Get URL parameters
       const urlParams = new URLSearchParams(window.location.search);
       const vendor = urlParams.get('vendor');
       const protocol = urlParams.get('protocol');

       // Available features for filtering
       const features = [
           'acl', 'role', 'vlan', 'url', 'captive', 'sgt', 
           'dacl', 'qos', 'bandwidth', 'coa', 'vpn', 'ipv6', 'multicast'
       ];

       let attributesData = [];
       let activeFilters = new Set();

       // Load attribute data
       function loadAttributes() {
           const filename = `attributes/${vendor}/${protocol}_attributes.json`;
           
           fetch(filename)
               .then(response => {
                   if (!response.ok) {
                       throw new Error('File not found');
                   }
                   return response.json();
               })
               .then(data => {
                   attributesData = data.attributes;
                   updateUI(data);
                   renderAttributes(data.attributes);
                   setupFeatureFilters();
               })
               .catch(error => {
                   console.error('Error loading attributes:', error);
                   document.getElementById('attributesBody').innerHTML = 
                       '<tr><td colspan="6" style="text-align: center; padding: 40px;">Error loading attribute data. Please check the URL parameters.</td></tr>';
               });
       }

       // Update UI elements
       function updateUI(data) {
           document.getElementById('vendorName').textContent = data.vendor.toUpperCase();
           document.getElementById('protocolName').textContent = data.protocol.toUpperCase();
           document.getElementById('vendorInfo').textContent = data.vendor.toUpperCase();
           document.getElementById('protocolInfo').textContent = data.protocol.toUpperCase();
           document.getElementById('attributeCount').textContent = data.attributes.length;
       }

       // Setup feature filters
       function setupFeatureFilters() {
           const container = document.getElementById('featureFilters');
           container.innerHTML = '';
           
           features.forEach(feature => {
               const btn = document.createElement('button');
               btn.className = 'feature-btn';
               btn.textContent = feature.toUpperCase();
               btn.onclick = () => toggleFeatureFilter(feature, btn);
               container.appendChild(btn);
           });
       }

       // Toggle feature filter
       function toggleFeatureFilter(feature, btn) {
           if (activeFilters.has(feature)) {
               activeFilters.delete(feature);
               btn.classList.remove('active');
           } else {
               activeFilters.add(feature);
               btn.classList.add('active');
           }
           filterAttributes();
       }

       // Filter attributes
       function filterAttributes() {
           const searchTerm = document.getElementById('searchBox').value.toLowerCase();
           
           let filtered = attributesData.filter(attr => {
               // Search filter
               const matchesSearch = !searchTerm || 
                   attr.name.toLowerCase().includes(searchTerm) ||
                   attr.description.toLowerCase().includes(searchTerm) ||
                   (attr.example && attr.example.toLowerCase().includes(searchTerm));
               
               // Feature filter
               const matchesFeatures = activeFilters.size === 0 ||
                   Array.from(activeFilters).some(feature => attr.features[feature]);
               
               return matchesSearch && matchesFeatures;
           });
           
           renderAttributes(filtered);
       }

       // Render attributes table
       function renderAttributes(attributes) {
           const tbody = document.getElementById('attributesBody');
           tbody.innerHTML = '';
           
           attributes.forEach((attr, index) => {
               const row = document.createElement('tr');
               row.className = 'expandable-row';
               
               row.innerHTML = `
                   <td><i class="fas fa-chevron-right expand-icon"></i></td>
                   <td><span class="attribute-name">${attr.name}</span></td>
                   <td><span class="attribute-number">${attr.number}</span></td>
                   <td>${attr.description}</td>
                   <td>${renderFeatureBadges(attr.features)}</td>
                   <td>${attr.example ? `<code>${attr.example}</code>` : 'N/A'}</td>
               `;
               
               const expandedRow = document.createElement('tr');
               expandedRow.innerHTML = `
                   <td colspan="6">
                       <div class="expanded-content" id="expand-${index}">
                           ${renderExpandedContent(attr)}
                       </div>
                   </td>
               `;
               
               row.onclick = () => toggleExpanded(index, row);
               
               tbody.appendChild(row);
               tbody.appendChild(expandedRow);
           });
       }

       // Render feature badges
       function renderFeatureBadges(features) {
           return Object.entries(features)
               .filter(([_, value]) => value)
               .map(([feature, _]) => `<span class="feature-badge yes">${feature}</span>`)
               .join('');
       }

       // Render expanded content
       function renderExpandedContent(attr) {
           let content = '<div class="expanded-details">';
           
           if (attr.use_cases) {
               content += '<h4>Use Cases:</h4><ul>';
               attr.use_cases.forEach(useCase => {
                   content += `<li>${useCase}</li>`;
               });
               content += '</ul>';
           }
           
           if (attr.implementation) {
               content += '<h4>Implementation:</h4><ul>';
               attr.implementation.forEach(impl => {
                   content += `<li>${impl}</li>`;
               });
               content += '</ul>';
           }
           
           if (attr.reference) {
               content += `<h4>Reference:</h4><p><a href="${attr.reference}" target="_blank">${attr.reference}</a></p>`;
           }
           
           content += '</div>';
           return content;
       }

       // Toggle expanded content
       function toggleExpanded(index, row) {
           const expandedContent = document.getElementById(`expand-${index}`);
           const icon = row.querySelector('.expand-icon');
           
           if (expandedContent.classList.contains('show')) {
               expandedContent.classList.remove('show');
               icon.classList.remove('expanded');
           } else {
               expandedContent.classList.add('show');
               icon.classList.add('expanded');
           }
       }

       // Download CSV
       function downloadCSV() {
           const headers = ['Name', 'Number', 'Description', 'Features', 'Example'];
           const csvContent = [
               headers.join(','),
               ...attributesData.map(attr => [
                   `"${attr.name}"`,
                   `"${attr.number}"`,
                   `"${attr.description.replace(/"/g, '""')}"`,
                   `"${Object.keys(attr.features).filter(f => attr.features[f]).join(', ')}"`,
                   `"${attr.example ? attr.example.replace(/"/g, '""') : 'N/A'}"`
               ].join(','))
           ].join('\n');
           
           const blob = new Blob([csvContent], { type: 'text/csv' });
           const url = window.URL.createObjectURL(blob);
           const a = document.createElement('a');
           a.href = url;
           a.download = `${vendor}_${protocol}_attributes.csv`;
           a.click();
           window.URL.revokeObjectURL(url);
       }

       // Event listeners
       document.getElementById('searchBox').addEventListener('input', filterAttributes);

       // Initialize
       loadAttributes();
   </script>
</body>
</html>
EOF

# Create a simple start script
cat > "start_server.sh" << 'EOF'
#!/bin/bash
echo "Starting 1Xer Radtribution on http://localhost:8080"
echo "Press Ctrl+C to stop the server"
python3 -m http.server 8080
EOF

chmod +x start_server.sh

echo "Installation complete! 🎉"
echo "To view the site locally:"
echo "1. Run: ./start_server.sh"
echo "2. Open http://localhost:8080 in your browser"
echo ""
echo "Files created:"
echo "- index.html (main page with workflows)"
echo "- viewer.html (attribute viewer)"
echo "- directory.json (vendor directory)"
echo "- attributes/ (JSON data files)"
echo "- start_server.sh (local server script)"
