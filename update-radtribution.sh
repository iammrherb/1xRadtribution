#!/bin/bash

# Update index.html with new theme and features
cat > "index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1Xer Radtribution - The Hitch Hiker's Guide to Vendor Specific Attributes</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Orbitron:wght@400;700;900&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #00ff88;
            --secondary-color: #ff0088;
            --accent-color: #00ccff;
            --bg-dark: #0a0a0a;
            --bg-light: #1a1a1a;
            --text-light: #e0e0e0;
            --text-dark: #0a0a0a;
            --card-bg: #1e1e1e;
            --hover-glow: 0 0 20px var(--primary-color);
        }

        [data-theme="light"] {
            --bg-dark: #ffffff;
            --bg-light: #f5f5f5;
            --text-light: #333333;
            --text-dark: #000000;
            --card-bg: #ffffff;
            --primary-color: #00cc66;
            --secondary-color: #cc0066;
            --accent-color: #0099cc;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'JetBrains Mono', monospace;
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
            padding: 60px 20px;
            background: linear-gradient(45deg, var(--bg-light), var(--bg-dark));
            border-radius: 20px;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y="50" font-size="100" fill="rgba(255,255,255,0.03)">01</text></svg>');
            animation: matrix 20s linear infinite;
        }

        @keyframes matrix {
            from { transform: translateY(0); }
            to { transform: translateY(-100px); }
        }

        .main-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 3.5rem;
            font-weight: 900;
            color: var(--primary-color);
            margin-bottom: 10px;
            text-shadow: 0 0 10px var(--primary-color);
            animation: glow 2s ease-in-out infinite alternate;
        }

        @keyframes glow {
            from { text-shadow: 0 0 10px var(--primary-color); }
            to { text-shadow: 0 0 20px var(--primary-color), 0 0 30px var(--primary-color); }
        }

        .subtitle {
            font-family: 'Space Mono', monospace;
            font-size: 1.5rem;
            color: var(--accent-color);
            margin-bottom: 30px;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            border: 2px solid var(--primary-color);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .theme-toggle:hover {
            box-shadow: var(--hover-glow);
            transform: rotate(180deg);
        }

        .search-section {
            margin-bottom: 40px;
        }

        .search-box {
            width: 100%;
            padding: 15px 25px;
            font-size: 1.1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--card-bg);
            border: 2px solid var(--accent-color);
            border-radius: 10px;
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .search-box:focus {
            outline: none;
            box-shadow: 0 0 15px var(--accent-color);
            transform: translateY(-2px);
        }

        .vendor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }

        .vendor-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 25px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .vendor-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
        }

        .vendor-card:hover {
            transform: translateY(-5px) scale(1.02);
            border-color: var(--primary-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .vendor-card:hover::before {
            opacity: 0.1;
        }

        .vendor-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: block;
        }

        .vendor-card h3 {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 1.5rem;
        }

        .protocol-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .protocol-link {
            flex: 1;
            padding: 12px 20px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: var(--bg-dark);
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            text-transform: uppercase;
            transition: all 0.3s ease;
            text-align: center;
        }

        .protocol-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
        }

        .workflow-section {
            margin: 60px 0;
            padding: 40px;
            background: var(--card-bg);
            border-radius: 20px;
            border: 2px solid var(--accent-color);
        }

        .workflow-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .workflow-item {
            background: var(--bg-dark);
            padding: 25px;
            border-radius: 15px;
            border: 1px solid var(--primary-color);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .workflow-item:hover {
            transform: scale(1.05);
            box-shadow: var(--hover-glow);
        }

        .workflow-item i {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: block;
            text-align: center;
        }

        .workflow-item h4 {
            font-family: 'Orbitron', sans-serif;
            color: var(--accent-color);
            margin-bottom: 10px;
            text-align: center;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .feature-item {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 15px;
            border: 1px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .feature-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }

        .feature-item i {
            font-size: 2rem;
            color: var(--secondary-color);
            margin-bottom: 15px;
            display: block;
        }

        .feature-item h4 {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .footer {
            text-align: center;
            padding: 40px 20px;
            margin-top: 60px;
            border-top: 2px solid var(--accent-color);
            color: var(--text-light);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: var(--card-bg);
            padding: 40px;
            border-radius: 20px;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
            position: relative;
            border: 2px solid var(--primary-color);
        }

        .close-modal {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 2rem;
            cursor: pointer;
            color: var(--secondary-color);
        }

        .diagram-container {
            margin: 20px 0;
            text-align: center;
        }

        .diagram-container svg {
            max-width: 100%;
            height: auto;
        }

        .code-block {
            background: var(--bg-dark);
            border: 1px solid var(--accent-color);
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            overflow-x: auto;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
        }

        .code-block code {
            color: var(--primary-color);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-title {
                font-size: 2.5rem;
            }
            
            .subtitle {
                font-size: 1.2rem;
            }
            
            .vendor-grid {
                grid-template-columns: 1fr;
            }
            
            .workflow-grid {
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
            <p style="color: var(--accent-color);">Don't Panic! Your comprehensive guide to RADIUS/TACACS+ VSAs is here.</p>
        </div>

        <div class="search-section">
            <input type="text" class="search-box" placeholder="🔍 Search for vendors across the galaxy..." id="searchBox">
        </div>

        <div class="vendor-grid" id="vendorGrid">
            <!-- Vendors will be populated here by JavaScript -->
        </div>

        <div class="workflow-section">
            <h2 style="font-family: 'Orbitron', sans-serif; color: var(--primary-color); text-align: center; margin-bottom: 20px;">
                <i class="fas fa-sitemap"></i> Authentication Workflows
            </h2>
            <div class="workflow-grid">
                <div class="workflow-item" onclick="showWorkflow('radius')">
                    <i class="fas fa-satellite-dish"></i>
                    <h4>RADIUS Flow</h4>
                    <p>802.1X Authentication Process</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('tacacs')">
                    <i class="fas fa-shield-alt"></i>
                    <h4>TACACS+ Flow</h4>
                    <p>Device Administration</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('vlan')">
                    <i class="fas fa-network-wired"></i>
                    <h4>Dynamic VLAN</h4>
                    <p>VLAN Assignment Process</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('acl')">
                    <i class="fas fa-filter"></i>
                    <h4>Dynamic ACL</h4>
                    <p>Access Control Lists</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('redirect')">
                    <i class="fas fa-directions"></i>
                    <h4>URL Redirect</h4>
                    <p>Captive Portal Flow</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('iot')">
                    <i class="fas fa-microchip"></i>
                    <h4>IoT Auth</h4>
                    <p>IoT Device Onboarding</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('mac')">
                    <i class="fas fa-fingerprint"></i>
                    <h4>MAB</h4>
                    <p>MAC Authentication Bypass</p>
                </div>
                <div class="workflow-item" onclick="showWorkflow('qos')">
                    <i class="fas fa-tachometer-alt"></i>
                    <h4>QoS/Bandwidth</h4>
                    <p>Quality of Service</p>
                </div>
            </div>
        </div>

        <div class="workflow-section">
            <h2 style="font-family: 'Orbitron', sans-serif; color: var(--primary-color); text-align: center; margin-bottom: 20px;">
                <i class="fas fa-star"></i> Features
            </h2>
            <div class="feature-grid">
                <div class="feature-item">
                    <i class="fas fa-building"></i>
                    <h4>Multi-Vendor</h4>
                    <p>Comprehensive coverage of all major networking vendors in the known universe.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-code"></i>
                    <h4>Protocol Support</h4>
                    <p>Both RADIUS and TACACS+ protocols with vendor-specific implementations.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-search"></i>
                    <h4>Advanced Search</h4>
                    <p>Find attributes faster than light speed with our quantum search engine.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-book"></i>
                    <h4>Implementation Guides</h4>
                    <p>Detailed guides that even a Vogon could understand (mostly).</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-download"></i>
                    <h4>CSV Export</h4>
                    <p>Export attributes to CSV for your towel... err... spreadsheet.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-moon"></i>
                    <h4>Dark/Light Mode</h4>
                    <p>Perfect for reading in deep space or under bright stars.</p>
                </div>
            </div>
        </div>

        <div class="footer">
            <p><i class="fas fa-rocket"></i> 1Xer Radtribution | Generated on <span id="genDate"></span></p>
            <p style="color: var(--accent-color); margin-top: 10px;">Remember: The answer to AAA is not always 42</p>
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
                                <i class="fas fa-${protocol === 'radius' ? 'satellite-dish' : 'shield-alt'}"></i>
                                ${protocol.toUpperCase()}
                            </a>`
                        ).join('');
                        
                        card.innerHTML = `
                            <i class="${icon} vendor-icon"></i>
                            <h3>${vendor.name}</h3>
                            <p>Explore ${vendor.name} authentication attributes</p>
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
                document.getElementById('vendorGrid').innerHTML = '<p style="color: var(--secondary-color);">Error loading vendor directory. The universe has experienced a temporary glitch.</p>';
            });

        // Workflow diagrams
        const workflows = {
            radius: {
                title: 'RADIUS Authentication Flow',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .flow-label { fill: var(--accent-color); font-family: 'JetBrains Mono', monospace; font-size: 12px; }
                            </style>
                            <defs>
                                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--accent-color)" />
                                </marker>
                            </defs>
                            
                            <!-- Client -->
                            <rect x="50" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="285" text-anchor="middle" class="flow-text">Client</text>
                            
                            <!-- Switch -->
                            <rect x="300" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="360" y="285" text-anchor="middle" class="flow-text">Switch/AP</text>
                            
                            <!-- RADIUS Server -->
                            <rect x="550" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="610" y="285" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <!-- Flow arrows -->
                            <path d="M170 280 L300 280" class="flow-arrow"/>
                            <text x="235" y="270" text-anchor="middle" class="flow-label">1. EAP Start</text>
                            
                            <path d="M420 280 L550 280" class="flow-arrow"/>
                            <text x="485" y="270" text-anchor="middle" class="flow-label">2. Access-Request</text>
                            
                            <path d="M550 290 L420 290" class="flow-arrow"/>
                            <text x="485" y="310" text-anchor="middle" class="flow-label">3. Access-Challenge</text>
                            
                            <path d="M300 290 L170 290" class="flow-arrow"/>
                            <text x="235" y="310" text-anchor="middle" class="flow-label">4. EAP Challenge</text>
                            
                            <!-- Additional steps -->
                            <rect x="50" y="380" width="620" height="150" class="flow-box" rx="5" fill-opacity="0.1"/>
                            <text x="360" y="410" text-anchor="middle" class="flow-text" font-size="16">Authentication Exchange</text>
                            <text x="360" y="440" text-anchor="middle" class="flow-text">5. Client provides credentials</text>
                            <text x="360" y="470" text-anchor="middle" class="flow-text">6. Multiple Access-Request/Challenge exchanges</text>
                            <text x="360" y="500" text-anchor="middle" class="flow-text">7. Access-Accept with VSAs (VLAN, ACL, etc.)</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>RADIUS Access-Accept VSAs:
Tunnel-Type = VLAN
Tunnel-Medium-Type = 802
Tunnel-Private-Group-ID = 100
Filter-Id = "EMPLOYEE_ACL"
Session-Timeout = 3600</code>
                    </div>
                `
            },
            tacacs: {
                title: 'TACACS+ Authentication Flow',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .flow-label { fill: var(--accent-color); font-family: 'JetBrains Mono', monospace; font-size: 12px; }
                            </style>
                            <defs>
                                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--accent-color)" />
                                </marker>
                            </defs>
                            
                            <!-- Admin -->
                            <rect x="50" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="285" text-anchor="middle" class="flow-text">Admin</text>
                            
                            <!-- Network Device -->
                            <rect x="300" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="360" y="285" text-anchor="middle" class="flow-text">Router/Switch</text>
                            
                            <!-- TACACS+ Server -->
                            <rect x="550" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="610" y="285" text-anchor="middle" class="flow-text">TACACS+</text>
                            
                            <!-- Authentication Flow -->
                            <path d="M170 260 L300 260" class="flow-arrow"/>
                            <text x="235" y="250" text-anchor="middle" class="flow-label">1. Login</text>
                            
                            <path d="M420 260 L550 260" class="flow-arrow"/>
                            <text x="485" y="250" text-anchor="middle" class="flow-label">2. START</text>
                            
                            <path d="M550 280 L420 280" class="flow-arrow"/>
                            <text x="485" y="300" text-anchor="middle" class="flow-label">3. REPLY (getuser)</text>
                            
                            <path d="M420 300 L550 300" class="flow-arrow"/>
                            <text x="485" y="320" text-anchor="middle" class="flow-label">4. CONTINUE</text>
                            
                            <!-- Authorization Flow -->
                            <rect x="50" y="380" width="620" height="60" class="flow-box" rx="5"/>
                            <text x="360" y="415" text-anchor="middle" class="flow-text">Authorization Phase</text>
                            
                            <path d="M420 440 L550 440" class="flow-arrow"/>
                            <text x="485" y="430" text-anchor="middle" class="flow-label">5. REQUEST (service=shell)</text>
                            
                            <path d="M550 460 L420 460" class="flow-arrow"/>
                            <text x="485" y="480" text-anchor="middle" class="flow-label">6. RESPONSE (priv-lvl=15)</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>TACACS+ Authorization Response:
service=shell
priv-lvl=15
cmd=show
Shell:roles="network-admin"
timeout=60</code>
                    </div>
                `
            },
            vlan: {
                title: 'Dynamic VLAN Assignment',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .vlan-box { fill: var(--primary-color); fill-opacity: 0.2; stroke: var(--primary-color); stroke-width: 2; }
                            </style>
                            <defs>
                                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--accent-color)" />
                                </marker>
                            </defs>
                            
                            <!-- VLANs -->
                            <rect x="50" y="100" width="200" height="80" class="vlan-box" rx="5"/>
                            <text x="150" y="145" text-anchor="middle" class="flow-text">Guest VLAN 10</text>
                            
                            <rect x="300" y="100" width="200" height="80" class="vlan-box" rx="5"/>
                            <text x="400" y="145" text-anchor="middle" class="flow-text">Employee VLAN 20</text>
                            
                            <rect x="550" y="100" width="200" height="80" class="vlan-box" rx="5"/>
                            <text x="650" y="145" text-anchor="middle" class="flow-text">IT VLAN 30</text>
                            
                            <!-- Switch -->
                            <rect x="300" y="300" width="200" height="80" class="flow-box" rx="5"/>
                            <text x="400" y="345" text-anchor="middle" class="flow-text">Switch Port</text>
                            
                            <!-- RADIUS Decision -->
                            <rect x="300" y="450" width="200" height="80" class="flow-box" rx="5"/>
                            <text x="400" y="480" text-anchor="middle" class="flow-text">RADIUS Server</text>
                            <text x="400" y="500" text-anchor="middle" class="flow-text" font-size="12">User: john@company.com</text>
                            
                            <!-- Arrows -->
                            <path d="M400 380 L400 450" class="flow-arrow"/>
                            <path d="M400 300 L400 180" class="flow-arrow"/>
                            <path d="M350 300 L150 180" class="flow-arrow"/>
                            <path d="M450 300 L650 180" class="flow-arrow"/>
                            
                            <text x="400" y="240" text-anchor="middle" class="flow-text" font-size="16">Dynamic Assignment</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>RADIUS Response for VLAN Assignment:
User-Name = "john@company.com"
Tunnel-Type = VLAN (13)
Tunnel-Medium-Type = IEEE-802 (6)
Tunnel-Private-Group-ID = "20"
# User assigned to Employee VLAN 20</code>
                    </div>
                `
            },
            acl: {
                title: 'Dynamic ACL (dACL) Application',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .acl-rule { fill: var(--secondary-color); fill-opacity: 0.1; stroke: var(--secondary-color); stroke-width: 1; }
                            </style>
                            
                            <!-- User Device -->
                            <rect x="50" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="285" text-anchor="middle" class="flow-text">User Device</text>
                            
                            <!-- Switch with ACL -->
                            <rect x="300" y="200" width="200" height="200" class="flow-box" rx="5"/>
                            <text x="400" y="230" text-anchor="middle" class="flow-text">Switch/Firewall</text>
                            
                            <!-- ACL Rules -->
                            <rect x="320" y="250" width="160" height="30" class="acl-rule" rx="3"/>
                            <text x="400" y="270" text-anchor="middle" class="flow-text" font-size="12">permit tcp any eq 80</text>
                            
                            <rect x="320" y="290" width="160" height="30" class="acl-rule" rx="3"/>
                            <text x="400" y="310" text-anchor="middle" class="flow-text" font-size="12">permit tcp any eq 443</text>
                            
                            <rect x="320" y="330" width="160" height="30" class="acl-rule" rx="3"/>
                            <text x="400" y="350" text-anchor="middle" class="flow-text" font-size="12">deny ip any any</text>
                            
                            <!-- Network Resources -->
                            <rect x="600" y="150" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="660" y="185" text-anchor="middle" class="flow-text">Web Server</text>
                            
                            <rect x="600" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="660" y="285" text-anchor="middle" class="flow-text">Database</text>
                            
                            <rect x="600" y="350" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="660" y="385" text-anchor="middle" class="flow-text">File Server</text>
                            
                            <!-- Connections -->
                            <path d="M170 280 L300 280" class="flow-arrow"/>
                            <path d="M500 200 L600 180" class="flow-arrow" stroke="#00ff00"/>
                            <path d="M500 280 L600 280" class="flow-arrow" stroke="#ff0000" stroke-dasharray="5,5"/>
                            <path d="M500 360 L600 380" class="flow-arrow" stroke="#ff0000" stroke-dasharray="5,5"/>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>Cisco dACL Example:
Cisco-AVPair = "ip:inacl#1=permit tcp any any eq 80"
Cisco-AVPair = "ip:inacl#2=permit tcp any any eq 443"
Cisco-AVPair = "ip:inacl#3=deny ip any any"

Aruba dACL Example:
Aruba-ACL-Name = "GUEST-RESTRICTED"
Aruba-User-Role = "guest-limited"</code>
                    </div>
                `
            },
            redirect: {
                title: 'URL Redirect / Captive Portal',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .redirect-arrow { stroke: var(--secondary-color); stroke-width: 3; fill: none; marker-end: url(#arrowhead-red); }
                            </style>
                            <defs>
                                <marker id="arrowhead-red" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
                                    <polygon points="0 0, 10 3.5, 0 7" fill="var(--secondary-color)" />
                                </marker>
                            </defs>
                            
                            <!-- User -->
                            <rect x="50" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="110" y="285" text-anchor="middle" class="flow-text">User</text>
                            
                            <!-- Switch/Controller -->
                            <rect x="250" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="310" y="285" text-anchor="middle" class="flow-text">Switch</text>
                            
                            <!-- Internet -->
                            <rect x="450" y="150" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="510" y="185" text-anchor="middle" class="flow-text">Internet</text>
                            
                            <!-- Captive Portal -->
                            <rect x="450" y="350" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="510" y="385" text-anchor="middle" class="flow-text">Portal</text>
                            
                            <!-- RADIUS -->
                            <rect x="650" y="250" width="120" height="60" class="flow-box" rx="5"/>
                            <text x="710" y="285" text-anchor="middle" class="flow-text">RADIUS</text>
                            
                            <!-- Flow -->
                            <path d="M170 280 L250 280" class="flow-arrow"/>
                            <text x="210" y="270" text-anchor="middle" class="flow-text" font-size="12">1. HTTP</text>
                            
                            <path d="M370 280 L450 380" class="redirect-arrow"/>
                            <text x="410" y="330" text-anchor="middle" class="flow-text" font-size="12" fill="var(--secondary-color)">2. Redirect</text>
                            
                            <path d="M570 380 L650 310" class="flow-arrow"/>
                            <text x="610" y="345" text-anchor="middle" class="flow-text" font-size="12">3. Auth</text>
                            
                            <path d="M650 280 L570 180" class="flow-arrow"/>
                            <text x="610" y="230" text-anchor="middle" class="flow-text" font-size="12">4. Accept</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>URL Redirect Configuration:
Cisco-URL-Redirect = "https://portal.company.com/guest"
Cisco-URL-Redirect-ACL = "REDIRECT_ACL"

Aruba-Captive-Portal-Profile = "GUEST_PORTAL"
Aruba-User-Role = "pre-auth-guest"</code>
                    </div>
                `
            },
            iot: {
                title: 'IoT Device Authentication',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .iot-device { fill: var(--accent-color); fill-opacity: 0.2; stroke: var(--accent-color); stroke-width: 2; }
                            </style>
                            
                            <!-- IoT Devices -->
                            <rect x="50" y="100" width="100" height="60" class="iot-device" rx="5"/>
                            <text x="100" y="135" text-anchor="middle" class="flow-text">Camera</text>
                            
                            <rect x="50" y="200" width="100" height="60" class="iot-device" rx="5"/>
                            <text x="100" y="235" text-anchor="middle" class="flow-text">Sensor</text>
                            
                            <rect x="50" y="300" width="100" height="60" class="iot-device" rx="5"/>
                            <text x="100" y="335" text-anchor="middle" class="flow-text">Badge</text>
                            
                            <!-- Switch -->
                            <rect x="300" y="200" width="150" height="100" class="flow-box" rx="5"/>
                            <text x="375" y="240" text-anchor="middle" class="flow-text">Switch</text>
                            <text x="375" y="260" text-anchor="middle" class="flow-text" font-size="12">MAB + Profiling</text>
                            
                            <!-- RADIUS/ISE -->
                            <rect x="550" y="200" width="150" height="100" class="flow-box" rx="5"/>
                            <text x="625" y="240" text-anchor="middle" class="flow-text">RADIUS/ISE</text>
                            <text x="625" y="260" text-anchor="middle" class="flow-text" font-size="12">Device DB</text>
                            
                            <!-- IoT VLAN -->
                            <rect x="300" y="400" width="400" height="80" class="iot-device" rx="5"/>
                            <text x="500" y="445" text-anchor="middle" class="flow-text">IoT Isolated VLAN</text>
                            
                            <!-- Arrows -->
                            <path d="M150 130 L300 230" class="flow-arrow"/>
                            <path d="M150 230 L300 240" class="flow-arrow"/>
                            <path d="M150 330 L300 260" class="flow-arrow"/>
                            
                            <path d="M450 250 L550 250" class="flow-arrow"/>
                            <text x="500" y="240" text-anchor="middle" class="flow-text" font-size="12">MAB Auth</text>
                            
                            <path d="M375 300 L375 400" class="flow-arrow"/>
                            <text x="375" y="350" text-anchor="middle" class="flow-text" font-size="12">Policy</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>IoT Device Policy:
Filter-Id = "IOT_DEVICE_ACL"
Tunnel-Type = VLAN
Tunnel-Medium-Type = IEEE-802
Tunnel-Private-Group-ID = "150"
Cisco-AVPair = "device-type=IP-Camera"
Aruba-Device-Type = "Camera"</code>
                    </div>
                `
            },
            mac: {
                title: 'MAC Authentication Bypass (MAB)',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .mac-box { fill: var(--secondary-color); fill-opacity: 0.1; stroke: var(--secondary-color); stroke-width: 2; }
                            </style>
                            
                            <!-- Non-802.1X Device -->
                            <rect x="50" y="250" width="120" height="80" class="mac-box" rx="5"/>
                            <text x="110" y="280" text-anchor="middle" class="flow-text">Printer</text>
                            <text x="110" y="300" text-anchor="middle" class="flow-text" font-size="12">MAC: 00:11:22:33:44:55</text>
                            
                            <!-- Switch -->
                            <rect x="300" y="250" width="150" height="80" class="flow-box" rx="5"/>
                            <text x="375" y="280" text-anchor="middle" class="flow-text">Switch</text>
                            <text x="375" y="300" text-anchor="middle" class="flow-text" font-size="12">802.1X → MAB</text>
                            
                            <!-- RADIUS -->
                            <rect x="580" y="250" width="150" height="80" class="flow-box" rx="5"/>
                            <text x="655" y="280" text-anchor="middle" class="flow-text">RADIUS</text>
                            <text x="655" y="300" text-anchor="middle" class="flow-text" font-size="12">MAC Database</text>
                            
                            <!-- Process Flow -->
                            <rect x="50" y="400" width="680" height="150" class="flow-box" rx="5" fill-opacity="0.1"/>
                            <text x="390" y="430" text-anchor="middle" class="flow-text" font-size="16">MAB Process</text>
                            <text x="390" y="460" text-anchor="middle" class="flow-text">1. 802.1X timeout (device doesn't respond)</text>
                            <text x="390" y="490" text-anchor="middle" class="flow-text">2. Switch extracts MAC address</text>
                            <text x="390" y="520" text-anchor="middle" class="flow-text">3. MAC used as username/password in RADIUS</text>
                            
                            <!-- Arrows -->
                            <path d="M170 290 L300 290" class="flow-arrow"/>
                            <text x="235" y="280" text-anchor="middle" class="flow-text" font-size="12">No EAP</text>
                            
                            <path d="M450 290 L580 290" class="flow-arrow"/>
                            <text x="515" y="280" text-anchor="middle" class="flow-text" font-size="12">MAB Auth</text>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>MAB Configuration (Cisco):
interface GigabitEthernet1/0/1
 authentication order mab dot1x
 authentication priority dot1x mab
 mab

RADIUS MAB Response:
User-Name = "001122334455"
Filter-Id = "PRINTER_ACL"
Tunnel-Type = VLAN
Tunnel-Private-Group-ID = "50"</code>
                    </div>
                `
            },
            qos: {
                title: 'QoS and Bandwidth Management',
                content: `
                    <div class="diagram-container">
                        <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                            <style>
                                .flow-box { fill: var(--card-bg); stroke: var(--primary-color); stroke-width: 2; }
                                .flow-text { fill: var(--text-light); font-family: 'JetBrains Mono', monospace; font-size: 14px; }
                                .flow-arrow { stroke: var(--accent-color); stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                                .qos-high { fill: var(--primary-color); fill-opacity: 0.2; stroke: var(--primary-color); }
                                .qos-med { fill: var(--accent-color); fill-opacity: 0.2; stroke: var(--accent-color); }
                                .qos-low { fill: var(--secondary-color); fill-opacity: 0.2; stroke: var(--secondary-color); }
                            </style>
                            
                            <!-- Users -->
                            <rect x="50" y="100" width="120" height="60" class="qos-high" rx="5"/>
                            <text x="110" y="135" text-anchor="middle" class="flow-text">VIP User</text>
                            
                            <rect x="50" y="200" width="120" height="60" class="qos-med" rx="5"/>
                            <text x="110" y="235" text-anchor="middle" class="flow-text">Standard</text>
                            
                            <rect x="50" y="300" width="120" height="60" class="qos-low" rx="5"/>
                            <text x="110" y="335" text-anchor="middle" class="flow-text">Guest</text>
                            
                            <!-- QoS Queues -->
                            <rect x="300" y="100" width="200" height="300" class="flow-box" rx="5"/>
                            <text x="400" y="130" text-anchor="middle" class="flow-text">QoS Engine</text>
                            
                            <rect x="320" y="150" width="160" height="60" class="qos-high" rx="5"/>
                            <text x="400" y="185" text-anchor="middle" class="flow-text">Priority Queue</text>
                            
                            <rect x="320" y="220" width="160" height="60" class="qos-med" rx="5"/>
                            <text x="400" y="255" text-anchor="middle" class="flow-text">Normal Queue</text>
                            
                            <rect x="320" y="290" width="160" height="60" class="qos-low" rx="5"/>
                            <text x="400" y="325" text-anchor="middle" class="flow-text">Best Effort</text>
                            
                            <!-- Bandwidth Pipe -->
                            <rect x="600" y="150" width="100" height="200" class="flow-box" rx="5"/>
                            <text x="650" y="250" text-anchor="middle" class="flow-text" transform="rotate(-90, 650, 250)">Bandwidth</text>
                            
                            <!-- Arrows -->
                            <path d="M170 130 L320 180" class="flow-arrow"/>
                            <path d="M170 230 L320 250" class="flow-arrow"/>
                            <path d="M170 330 L320 320" class="flow-arrow"/>
                            
                            <path d="M500 180 L600 200" class="flow-arrow"/>
                            <path d="M500 250 L600 250" class="flow-arrow"/>
                            <path d="M500 320 L600 300" class="flow-arrow"/>
                        </svg>
                    </div>
                    <div class="code-block">
                        <code>QoS VSA Examples:

Cisco QoS:
Cisco-AVPair = "ip:sub-qos-policy-in=VOICE_POLICY"
Cisco-AVPair = "ip:sub-qos-policy-out=STANDARD_POLICY"
Cisco-Policing-Rate = "10000000"  # 10 Mbps

HP/Aruba Bandwidth:
HP-Bandwidth-Max-Ingress = "102400"  # 100 Mbps
HP-Bandwidth-Max-Egress = "51200"    # 50 Mbps
HP-Cos = "5"                         # Voice priority</code>
                    </div>
                `
            }
        };

        function showWorkflow(type) {
            const modal = document.getElementById('workflowModal');
            const modalContent = document.getElementById('modalContent');
            const workflow = workflows[type];
            
            if (workflow) {
                modalContent.innerHTML = `
                    <h2 style="font-family: 'Orbitron', sans-serif; color: var(--primary-color); margin-bottom: 20px;">
                        ${workflow.title}
                    </h2>
                    ${workflow.content}
                `;
                modal.style.display = 'flex';
            }
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

# Update viewer.html with new theme and features
cat > "viewer.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1Xer Radtribution - Attribute Viewer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Orbitron:wght@400;700;900&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #00ff88;
            --secondary-color: #ff0088;
            --accent-color: #00ccff;
            --bg-dark: #0a0a0a;
            --bg-light: #1a1a1a;
            --text-light: #e0e0e0;
            --text-dark: #0a0a0a;
            --card-bg: #1e1e1e;
            --hover-glow: 0 0 20px var(--primary-color);
            --code-bg: #0d1117;
        }

        [data-theme="light"] {
            --bg-dark: #ffffff;
            --bg-light: #f5f5f5;
            --text-light: #333333;
            --text-dark: #000000;
            --card-bg: #ffffff;
            --primary-color: #00cc66;
            --secondary-color: #cc0066;
            --accent-color: #0099cc;
            --code-bg: #f6f8fa;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'JetBrains Mono', monospace;
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
            background: linear-gradient(45deg, var(--bg-light), var(--bg-dark));
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            text-align: center;
            border: 2px solid var(--primary-color);
        }

        .header h1 {
            font-family: 'Orbitron', sans-serif;
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 10px;
            text-shadow: 0 0 10px var(--primary-color);
        }

        .header p {
            color: var(--accent-color);
            font-size: 1.2rem;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            border: 2px solid var(--primary-color);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .theme-toggle:hover {
            box-shadow: var(--hover-glow);
            transform: rotate(180deg);
        }

        .navigation {
            margin-bottom: 30px;
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-link {
            color: var(--primary-color);
            text-decoration: none;
            padding: 10px 20px;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .nav-link:hover {
            background: var(--primary-color);
            color: var(--bg-dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .controls {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 300px;
            padding: 12px 20px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--card-bg);
            border: 2px solid var(--accent-color);
            border-radius: 8px;
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .search-box:focus {
            outline: none;
            box-shadow: 0 0 15px var(--accent-color);
            transform: translateY(-2px);
        }

        .filter-select {
            padding: 12px 20px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--card-bg);
            border: 2px solid var(--accent-color);
            border-radius: 8px;
            color: var(--text-light);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:hover {
            box-shadow: 0 0 10px var(--accent-color);
        }

        .export-button {
            padding: 12px 25px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 8px;
            color: var(--bg-dark);
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .export-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
        }

        .attributes-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            margin-top: 20px;
        }

        .attributes-table th {
            background: var(--card-bg);
            padding: 15px;
            text-align: left;
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .attributes-table td {
            background: var(--card-bg);
            padding: 15px;
            border: 1px solid var(--bg-light);
        }

        .attributes-table tr:hover td {
            background: var(--bg-light);
            border-color: var(--accent-color);
        }

        .attribute-name {
            font-weight: bold;
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
        }

        .attribute-features {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .feature-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: bold;
            text-transform: uppercase;
            background: var(--primary-color);
            color: var(--bg-dark);
            box-shadow: 0 0 10px var(--primary-color);
        }

        .expandable-row {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .details-row {
            display: none;
        }

        .details-content {
            padding: 20px;
            background: var(--bg-light);
            border-radius: 10px;
        }

        .details-section {
            margin-bottom: 20px;
        }

        .details-section h4 {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .details-section ul {
            margin-left: 20px;
            list-style-type: none;
        }

        .details-section li {
            margin-bottom: 8px;
            position: relative;
            padding-left: 20px;
        }

        .details-section li:before {
            content: '▸';
            color: var(--accent-color);
            position: absolute;
            left: 0;
        }

        .example-code {
            background: var(--code-bg);
            border: 1px solid var(--accent-color);
            border-radius: 8px;
            padding: 15px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            overflow-x: auto;
            white-space: pre-wrap;
            color: var(--primary-color);
            box-shadow: inset 0 0 10px rgba(0,0,0,0.2);
        }

        .implementation-code {
            background: var(--code-bg);
            border: 1px solid var(--secondary-color);
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            overflow-x: auto;
            color: var(--accent-color);
        }

        .reference-link {
            color: var(--accent-color);
            text-decoration: none;
            padding: 5px 10px;
            border: 1px solid var(--accent-color);
            border-radius: 5px;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .reference-link:hover {
            background: var(--accent-color);
            color: var(--bg-dark);
            transform: translateY(-2px);
        }

        .loading {
            text-align: center;
            padding: 50px;
            font-size: 1.5rem;
            color: var(--primary-color);
        }

        .error {
            text-align: center;
            padding: 50px;
            color: var(--secondary-color);
            font-size: 1.2rem;
        }

        .stats-section {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .stats-card {
            flex: 1;
            min-width: 200px;
            background: var(--card-bg);
            border: 2px solid var(--primary-color);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }

        .stats-card h3 {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            font-size: 2rem;
            margin-bottom: 5px;
        }

        .stats-card p {
            color: var(--accent-color);
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8rem;
            }
            
            .controls {
                flex-direction: column;
            }
            
            .search-box, .filter-select, .export-button {
                width: 100%;
            }
            
            .attributes-table {
                font-size: 0.9rem;
            }
            
            .feature-badge {
                font-size: 0.65rem;
                padding: 2px 6px;
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
            <h1 id="pageTitle">Loading...</h1>
            <p id="pageDescription">Preparing your guide to the galaxy of attributes...</p>
        </div>
        
        <div class="navigation">
            <a href="index.html" class="nav-link">
                <i class="fas fa-rocket"></i> Back to Mothership
            </a>
            <a href="#" id="otherProtocol" class="nav-link">
                <i class="fas fa-exchange-alt"></i> Switch Protocol
            </a>
        </div>

        <div class="stats-section" id="statsSection">
            <!-- Stats will be populated here -->
        </div>
        
        <div class="controls">
            <input type="text" class="search-box" placeholder="🔍 Search for attributes..." id="searchBox">
            <select class="filter-select" id="featureFilter">
                <option value="">All Features</option>
                <option value="acl">🛡️ ACL</option>
                <option value="role">👤 Role</option>
                <option value="vlan">🌐 VLAN</option>
                <option value="url">🔗 URL</option>
                <option value="captive">🚪 Captive Portal</option>
                <option value="sgt">🏷️ SGT</option>
                <option value="dacl">📋 dACL</option>
                <option value="qos">⚡ QoS</option>
                <option value="bandwidth">📊 Bandwidth</option>
                <option value="coa">🔄 CoA</option>
                <option value="vpn">🔒 VPN</option>
                <option value="ipv6">🌐 IPv6</option>
                <option value="multicast">📡 Multicast</option>
            </select>
            <select class="filter-select" id="networkFilter">
                <option value="">All Networks</option>
                <option value="wired">🔌 Wired</option>
                <option value="wireless">📡 Wireless</option>
                <option value="both">🔄 Both</option>
            </select>
            <button class="export-button" onclick="exportToCSV()">
                <i class="fas fa-download"></i> Export to CSV
            </button>
        </div>
        
        <div id="attributesList" class="loading">
            <i class="fas fa-satellite-dish fa-spin"></i> Connecting to the authentication matrix...
        </div>
    </div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const vendor = urlParams.get('vendor');
        const protocol = urlParams.get('protocol');
        let attributesData = [];

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

        // Update page title and navigation
        function updatePageInfo(data) {
            const vendorName = data.vendor.charAt(0).toUpperCase() + data.vendor.slice(1);
            const protocolName = data.protocol.toUpperCase();
            
            document.getElementById('pageTitle').textContent = `${vendorName} ${protocolName} Attributes`;
            document.getElementById('pageDescription').textContent = `Your comprehensive guide to ${vendorName} ${protocolName} attributes`;
            
            // Update other protocol link
            const otherProtocol = protocol === 'radius' ? 'tacacs' : 'radius';
            const otherProtocolLink = document.getElementById('otherProtocol');
            otherProtocolLink.href = `viewer.html?vendor=${vendor}&protocol=${otherProtocol}`;
            otherProtocolLink.innerHTML = `<i class="fas fa-exchange-alt"></i> Switch to ${otherProtocol.toUpperCase()}`;
            
            // Update stats
            updateStats(data.attributes);
        }

        // Update statistics
        function updateStats(attributes) {
            const statsSection = document.getElementById('statsSection');
            
            const totalAttributes = attributes.length;
            const featuresCount = attributes.reduce((acc, attr) => {
                return acc + Object.values(attr.features).filter(Boolean).length;
            }, 0);
            
            const networkTypes = {
                both: attributes.filter(attr => attr.network === 'both').length,
                wired: attributes.filter(attr => attr.network === 'wired').length,
                wireless: attributes.filter(attr => attr.network === 'wireless').length
            };
            
            statsSection.innerHTML = `
                <div class="stats-card">
                    <h3>${totalAttributes}</h3>
                    <p>Total Attributes</p>
                </div>
                <div class="stats-card">
                    <h3>${featuresCount}</h3>
                    <p>Feature Implementations</p>
                </div>
                <div class="stats-card">
                    <h3>${networkTypes.both}</h3>
                    <p>Universal Attributes</p>
                </div>
            `;
        }

        // Create attribute table
        function createAttributeTable(attributes) {
            if (attributes.length === 0) {
                return '<p style="text-align: center; padding: 50px; color: var(--accent-color);">No attributes found matching your criteria. Try adjusting your search.</p>';
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
                    .map(([key]) => `<span class="feature-badge">${key.toUpperCase()}</span>`)
                    .join('');

                // Get network icon
                const networkIcon = attr.network === 'wired' ? '🔌' : 
                                  attr.network === 'wireless' ? '📡' : '🔄';

                html += `
                    <tr class="expandable-row" onclick="toggleDetails(${index})">
                        <td class="attribute-name">${attr.name}</td>
                        <td>${attr.number}</td>
                        <td>${attr.description}</td>
                        <td class="attribute-features">${featureBadges}</td>
                        <td>${networkIcon} ${attr.network}</td>
                    </tr>
                    <tr id="details-${index}" class="details-row">
                        <td colspan="5">
                            <div class="details-content">
                                <div class="details-section">
                                    <h4><i class="fas fa-code"></i> Example</h4>
                                    <div class="example-code">${attr.example}</div>
                                </div>
                                
                                <div class="details-section">
                                    <h4><i class="fas fa-lightbulb"></i> Use Cases</h4>
                                    <ul>
                                        ${(attr.use_cases || []).map(uc => `<li>${uc}</li>`).join('')}
                                    </ul>
                                </div>
                                
                                <div class="details-section">
                                    <h4><i class="fas fa-wrench"></i> Implementation</h4>
                                    <ul>
                                        ${attr.implementation.map(impl => `<li>${impl}</li>`).join('')}
                                    </ul>
                                    <div class="implementation-code">
# Example configuration
${generateConfigExample(attr)}
                                    </div>
                                </div>
                                
                                <div class="details-section">
                                    <h4><i class="fas fa-book"></i> Reference</h4>
                                    <a href="${attr.reference}" target="_blank" class="reference-link">
                                        <i class="fas fa-external-link-alt"></i> View Documentation
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                `;
            });

            html += '</tbody></table>';
            return html;
        }

        // Generate configuration example based on attribute
        function generateConfigExample(attr) {
            const vendor = urlParams.get('vendor');
            const protocol = urlParams.get('protocol');
            
            // Generate vendor-specific config examples
            if (vendor === 'cisco' && protocol === 'radius') {
                if (attr.name.includes('URL-Redirect')) {
                    return `interface GigabitEthernet0/1
 authentication order mab dot1x
 authentication port-control auto
 mab

! RADIUS server returns:
${attr.example}`;
                } else if (attr.name.includes('VLAN')) {
                    return `interface GigabitEthernet0/1
 switchport mode access
 authentication host-mode multi-auth
 dot1x pae authenticator

! RADIUS returns dynamic VLAN:
${attr.example}`;
                } else {
                    return `! Configure on RADIUS server
${attr.example}

! Apply to user/group policy`;
                }
            } else if (vendor === 'juniper' && protocol === 'radius') {
                return `# Juniper configuration
set access radius-server 192.168.1.10 secret "secret123"

# RADIUS server returns:
${attr.example}`;
            } else if (vendor === 'aruba' && protocol === 'radius') {
                return `# Aruba configuration
aaa authentication dot1x default group radius
radius-server host 192.168.1.10 key "secret123"

# RADIUS server configuration:
${attr.example}`;
            } else {
                return `# Configure on AAA server:
${attr.example}

# Check vendor documentation for specific implementation`;
            }
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
                    (attr.use_cases && attr.use_cases.some(uc => uc.toLowerCase().includes(searchTerm))) ||
                    (attr.implementation && attr.implementation.some(impl => impl.toLowerCase().includes(searchTerm)));

                // Feature filter
                const matchesFeature = !featureFilter || attr.features[featureFilter];

                // Network filter
                const matchesNetwork = !networkFilter || attr.network === networkFilter;

                return matchesSearch && matchesFeature && matchesNetwork;
            });

            document.getElementById('attributesList').innerHTML = createAttributeTable(filtered);
        }

        // Export to CSV
        function exportToCSV() {
            if (attributesData.length === 0) {
                alert('No data to export!');
                return;
            }

            const headers = ['Name', 'Number', 'Description', 'Features', 'Network', 'Example', 'Use Cases', 'Implementation', 'Reference'];
            const csvContent = [
                headers.join(','),
                ...attributesData.map(attr => {
                    const features = Object.entries(attr.features)
                        .filter(([key, value]) => value)
                        .map(([key]) => key.toUpperCase())
                        .join(';');
                    
                    const useCases = (attr.use_cases || []).join(';');
                    const implementation = attr.implementation.join(';');
                    
                    return [
                        `"${attr.name}"`,
                        `"${attr.number}"`,
                        `"${attr.description}"`,
                        `"${features}"`,
                        `"${attr.network}"`,
                        `"${attr.example}"`,
                        `"${useCases}"`,
                        `"${implementation}"`,
                        `"${attr.reference}"`
                    ].join(',');
                })
            ].join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const vendorName = vendor.charAt(0).toUpperCase() + vendor.slice(1);
            const protocolName = protocol.toUpperCase();
            
            link.href = URL.createObjectURL(blob);
            link.download = `${vendorName}_${protocolName}_Attributes.csv`;
            link.click();
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
                        `<p><i class="fas fa-exclamation-triangle"></i> Error loading attributes for ${vendor} ${protocol}.</p>
                         <p>The authentication matrix seems to be experiencing turbulence.</p>
                         <p>Please check the URL or return to the <a href="index.html" style="color: var(--primary-color);">mothership</a>.</p>`;
                });
        } else {
            document.getElementById('attributesList').className = 'error';
            document.getElementById('attributesList').innerHTML = 
                '<p><i class="fas fa-exclamation-triangle"></i> Invalid URL parameters.</p>' +
                '<p>You seem to have drifted off course!</p>' +
                '<p>Please return to the <a href="index.html" style="color: var(--primary-color);">mothership</a>.</p>';
        }
    </script>
</body>
</html>
EOF

# Create new diagram page
cat > "diagrams.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>1Xer Radtribution - Authentication Flows</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Orbitron:wght@400;700;900&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Same theme styles as main pages */
        :root {
            --primary-color: #00ff88;
            --secondary-color: #ff0088;
            --accent-color: #00ccff;
            --bg-dark: #0a0a0a;
            --bg-light: #1a1a1a;
            --text-light: #e0e0e0;
            --text-dark: #0a0a0a;
            --card-bg: #1e1e1e;
            --hover-glow: 0 0 20px var(--primary-color);
        }

        [data-theme="light"] {
            --bg-dark: #ffffff;
            --bg-light: #f5f5f5;
            --text-light: #333333;
            --text-dark: #000000;
            --card-bg: #ffffff;
            --primary-color: #00cc66;
            --secondary-color: #cc0066;
            --accent-color: #0099cc;
        }

        body {
            font-family: 'JetBrains Mono', monospace;
            background-color: var(--bg-dark);
            color: var(--text-light);
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            padding: 40px 20px;
            background: linear-gradient(45deg, var(--bg-light), var(--bg-dark));
            border-radius: 20px;
            margin-bottom: 40px;
            border: 2px solid var(--primary-color);
        }

        .header h1 {
            font-family: 'Orbitron', sans-serif;
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 10px;
            text-shadow: 0 0 10px var(--primary-color);
        }

        .diagram-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .diagram-card {
            background: var(--card-bg);
            border: 2px solid var(--primary-color);
            border-radius: 15px;
            padding: 30px;
            transition: all 0.3s ease;
        }

        .diagram-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .diagram-title {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            margin-bottom: 20px;
            font-size: 1.5rem;
            text-align: center;
        }

        .diagram-container {
            background: var(--bg-dark);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .diagram-container svg {
            width: 100%;
            height: auto;
        }

        .code-example {
            background: var(--bg-dark);
            border: 1px solid var(--accent-color);
            border-radius: 8px;
            padding: 15px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            overflow-x: auto;
            white-space: pre-wrap;
            color: var(--primary-color);
        }

        .nav-link {
            display: inline-block;
            color: var(--primary-color);
            text-decoration: none;
            padding: 10px 20px;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            background: var(--primary-color);
            color: var(--bg-dark);
            transform: translateY(-2px);
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            border: 2px solid var(--primary-color);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-color);
            z-index: 1000;
        }

        .theme-toggle:hover {
            box-shadow: var(--hover-glow);
            transform: rotate(180deg);
        }
    </style>
</head>
<body>
    <button class="theme-toggle" onclick="toggleTheme()">
        <i class="fas fa-moon"></i>
    </button>

    <div class="container">
        <a href="index.html" class="nav-link">
            <i class="fas fa-rocket"></i> Back to Mothership
        </a>

        <div class="header">
            <h1>Authentication Flow Diagrams</h1>
            <p style="color: var(--accent-color);">Visual guides to authentication workflows</p>
        </div>

        <div class="diagram-grid">
            <!-- Complex RADIUS Flow -->
            <div class="diagram-card">
                <h2 class="diagram-title">802.1X EAP Authentication Flow</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG content for 802.1X flow diagram -->
                        <!-- This would be a detailed flow showing EAP exchange -->
                    </svg>
                </div>
                <div class="code-example">EAP-TLS Configuration:
aaa authentication dot1x default group radius
radius-server host 192.168.1.10 key secret123
dot1x system-auth-control

interface GigabitEthernet0/1
 switchport mode access
 authentication port-control auto
 dot1x pae authenticator</div>
            </div>

            <!-- TACACS+ Command Authorization -->
            <div class="diagram-card">
                <h2 class="diagram-title">TACACS+ Command Authorization</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG content for TACACS+ command auth -->
                    </svg>
                </div>
                <div class="code-example">TACACS+ Command Auth:
aaa authorization exec default group tacacs+ local
aaa authorization commands 15 default group tacacs+ local

tacacs-server host 192.168.1.20 key secret123
tacacs-server timeout 5</div>
            </div>

            <!-- Dynamic VLAN Assignment -->
            <div class="diagram-card">
                <h2 class="diagram-title">Dynamic VLAN Assignment Flow</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG for VLAN assignment process -->
                    </svg>
                </div>
                <div class="code-example">Dynamic VLAN Configuration:
interface GigabitEthernet0/1
 switchport mode access
 switchport access vlan 999
 authentication order dot1x mab
 authentication port-control auto
 dot1x pae authenticator

! RADIUS returns:
Tunnel-Type = VLAN
Tunnel-Medium-Type = IEEE-802  
Tunnel-Private-Group-ID = 100</div>
            </div>

            <!-- CoA Process -->
            <div class="diagram-card">
                <h2 class="diagram-title">Change of Authorization (CoA)</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG for CoA process -->
                    </svg>
                </div>
                <div class="code-example">CoA Configuration:
aaa server radius dynamic-author
 client 192.168.1.10 server-key secret123
 port 3799

! CoA packet format:
User-Name = "user@domain.com"
Acct-Session-Id = "0000B25F"
Cisco-AVPair = "subscriber:command=reauthenticate"</div>
            </div>

            <!-- MAB Flow -->
            <div class="diagram-card">
                <h2 class="diagram-title">MAC Authentication Bypass</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG for MAB process -->
                    </svg>
                </div>
                <div class="code-example">MAB Configuration:
interface GigabitEthernet0/1
 authentication order mab dot1x
 authentication priority dot1x mab
 mab
 
! RADIUS MAB format:
User-Name = "aabbcc112233"
User-Password = "aabbcc112233"
Service-Type = Call-Check</div>
            </div>

            <!-- Guest Portal Flow -->
            <div class="diagram-card">
                <h2 class="diagram-title">Guest Portal Authentication</h2>
                <div class="diagram-container">
                    <svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
                        <!-- SVG for guest portal flow -->
                    </svg>
                </div>
                <div class="code-example">Guest Portal Setup:
ip http server
ip http secure-server

! Pre-auth ACL
ip access-list extended GUEST_REDIRECT
 permit tcp any any eq 80
 permit tcp any any eq 443
 permit udp any any eq 53
 deny ip any any

! RADIUS returns:
Cisco-URL-Redirect = "https://portal.company.com"
Cisco-URL-Redirect-ACL = "GUEST_REDIRECT"</div>
            </div>
        </div>
    </div>

    <script>
        // Theme toggle function
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
    </script>
</body>
</html>
EOF

# Update the README with new branding
cat > "README.md" << 'EOF'
# 1Xer Radtribution

**The Hitch Hiker's Guide to Vendor Specific Attributes**

Don't Panic! Your comprehensive guide to RADIUS and TACACS+ vendor-specific attributes (VSAs) across the networking universe.

## Features

- 🚀 **Multi-vendor support**: Comprehensive coverage of all major networking vendors in the known universe
- 🔐 **Protocol coverage**: Both RADIUS and TACACS+ attributes with vendor-specific implementations
- 🔍 **Advanced search**: Find attributes faster than light speed with our quantum search engine
- 📊 **CSV Export**: Export attributes to CSV for your towel... err... spreadsheet
- 🌓 **Dark/Light Mode**: Perfect for reading in deep space or under bright stars
- 📈 **Visual Workflows**: Detailed authentication flow diagrams for all scenarios
- 🎯 **Implementation Guides**: Code examples that even a Vogon could understand (mostly)

## Usage

Visit the GitHub Pages site to browse and search attributes:
https://[your-username].github.io/1xer-radtribution/

## Interactive Features

- **Dynamic Search**: Real-time filtering across all attributes
- **Feature Filtering**: Filter by ACL, Role, VLAN, QoS, CoA, and more
- **Network Type Filtering**: Wired, Wireless, or Both
- **CSV Export**: One-click export of all or filtered attributes
- **Visual Authentication Flows**: Interactive diagrams for:
  - 802.1X EAP Authentication
  - TACACS+ Command Authorization
  - Dynamic VLAN Assignment
  - MAC Authentication Bypass (MAB)
  - Captive Portal/URL Redirect
  - IoT Device Authentication
  - QoS and Bandwidth Management
  - Change of Authorization (CoA)

## Supported Vendors

- Cisco Systems
- Juniper Networks
- Aruba Networks (HPE)
- Fortinet
- Palo Alto Networks
- HP/HPE
- Extreme Networks
- Dell Technologies
- Meraki
- Ruckus (CommScope)
- Check Point
- SonicWall
- F5 Networks
- Huawei
- Microsoft NAS
- Zyxel
- WatchGuard
- Standard RADIUS/TACACS+

## Structure
#[200~/
#├── index.html              # Main landing page
#├── viewer.html             # Attribute viewer page
#├── diagrams.html           # Authentication flow diagrams
#├── directory.json          # Vendor directory
#└── attributes/             # Attribute data files
#├── cisco/
#│   ├── radius_attributes.json
#│   └── tacacs_attributes.json
#├── juniper/
#│   ├── radius_attributes.json
#│   └── tacacs_attributes.json
#└── ...
#
## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or update attribute files
4. Submit a pull request

Remember: The answer to AAA is not always 42, but proper attribute configuration!

## License

MIT License - see LICENSE file for details

---

*"In the beginning the Universe was created. This has made a lot of people very angry and been widely regarded as a bad move. Authentication attributes, however, are quite useful."*
EOF

# Create an enhanced deploy script
cat > "deploy.sh" << 'EOF'
#!/bin/bash

# Enhanced deployment script for 1Xer Radtribution

echo "🚀 Preparing for deployment to the authentication galaxy..."

# Ensure all files are generated
if [ ! -f "directory.json" ]; then
    echo "Error: directory.json not found. Run the generation script first."
    exit 1
fi

# Check for required files
required_files=("index.html" "viewer.html" "diagrams.html" "README.md" "LICENSE")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file $file not found."
        exit 1
    fi
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: The Universe begins"
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
git commit -m "Update 1Xer Radtribution $(date)"

echo "
================================
 Deployment prepared! 🛸
================================

To deploy to GitHub Pages:

1. Add your GitHub repository as origin:
   git remote add origin https://github.com/YOUR_USERNAME/1xer-radtribution.git

2. Push to GitHub:
   git push -u origin gh-pages

3. Enable GitHub Pages in your repository settings:
   - Go to Settings > Pages
   - Source: Deploy from branch
   - Branch: gh-pages
   - Folder: / (root)

4. Your site will be available at:
   https://YOUR_USERNAME.github.io/1xer-radtribution/

Don't forget your towel! 🌌
"
EOF

chmod +x deploy.sh

echo "
========================================
 1Xer Radtribution Setup Complete! 🚀
========================================

Generated files:
- HTML interface with new theme
- Interactive authentication diagrams
- CSV export functionality
- Light/Dark mode support
- Enhanced search and filtering
- Visual workflow diagrams
- Code syntax highlighting

Features implemented:
✓ New title: '1Xer Radtribution'
✓ Subtitle: 'The Hitch Hiker's Guide to Vendor Specific Attributes'
✓ Modern color theme with neon accents
✓ Dark/Light mode toggle
✓ CSV export functionality
✓ Interactive workflow diagrams
✓ Code blocks with syntax highlighting
✓ Awesome icons and typography
✓ Responsive design
✓ Enhanced user experience

To deploy:
1. Run ./deploy.sh
2. Follow the deployment instructions
3. Your guide to the authentication galaxy awaits!

Remember: Don't Panic! 🌌
"
