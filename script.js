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
    const tabs = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tab-content');
    const aboutLink = document.getElementById('aboutLink');
    const aboutModal = document.getElementById('aboutModal');
    const closeModal = document.querySelector('.close');

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

    // Tabs functionality
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const targetId = this.dataset.target;
            
            // Deactivate all tabs in the same group
            const tabGroup = this.parentElement;
            tabGroup.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            
            // Find all tab content in this section
            const tabContentSection = tabGroup.parentElement;
            tabContentSection.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            // Activate the clicked tab
            this.classList.add('active');
            tabContentSection.querySelector('#' + targetId).classList.add('active');
        });
    });

    // Modal functionality
    aboutLink.addEventListener('click', function(e) {
        e.preventDefault();
        aboutModal.style.display = 'block';
    });

    closeModal.addEventListener('click', function() {
        aboutModal.style.display = 'none';
    });

    window.addEventListener('click', function(e) {
        if (e.target === aboutModal) {
            aboutModal.style.display = 'none';
        }
    });

    // Update protocol section based on active vendor and protocol
    function updateProtocolSection() {
        protocolSections.forEach(section => {
            section.classList.remove('active');
            if (section.id === `${activeVendor}-${activeProtocol}`) {
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
        resultsInfo.textContent = `Showing ${count} ${count === 1 ? 'attribute' : 'attributes'}`;
    }

    // Initialize with all rows visible
    filterTable();
});
// Enhanced functionality for Radtribution Dictionary
// Version: 2.0.0

// Debug mode configuration
let DEBUG_MODE = false;
const DEBUG_CONSOLE = document.getElementById('debugConsole');

// Console logging wrapper
function logDebug(message, data = null) {
    if (!DEBUG_MODE) return;
    
    const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
    let logMessage = `[${timestamp}] ${message}`;
    
    // Log to browser console
    if (data) {
        console.log(logMessage, data);
    } else {
        console.log(logMessage);
    }
    
    // Log to debug console in UI
    if (DEBUG_CONSOLE) {
        DEBUG_CONSOLE.innerHTML += logMessage + (data ? ': ' + JSON.stringify(data, null, 2) : '') + '\n';
        DEBUG_CONSOLE.scrollTop = DEBUG_CONSOLE.scrollHeight;
    }
}

// Enhanced filter table function with advanced search capabilities
function enhancedFilterTable() {
    logDebug("Starting enhanced filter operation with current settings");
    
    const searchTerm = searchInput.value.toLowerCase();
    const startTime = performance.now();
    let visibleRows = 0;
    
    logDebug(`Active filters: ${activeFilters.join(', ')}`);
    logDebug(`Active vendor: ${activeVendor}, Active protocol: ${activeProtocol}`);
    
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
    logDebug(`Filter operation completed in ${(endTime - startTime).toFixed(2)}ms, showing ${visibleRows} rows`);
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
        logDebug(`Processing ${vendor.name} attributes`, { count: vendor.attributes.length });
        
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
        badge.className = `badge badge-${attr.network}`;
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
            const badge = `<span class="badge badge-${value ? 'yes' : 'no'}">${featureLabels[feature]}</span>`;
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
    logDebug(`Exporting data in ${format} format`);
    
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
    logDebug(`Exporting ${rows.length} rows to CSV`);
    
    // Headers
    const headers = [
        'Vendor', 'Protocol', 'Attribute Name', 'Attribute Number', 
        'Description', 'ACL', 'Role', 'VLAN', 'URL', 'Captive Portal',
        'SGT', 'DACL', 'QoS', 'Bandwidth', 'CoA', 'VPN', 'IPv6', 'Multicast',
        'Network', 'Example', 'Reference'
    ];
    
    // Create CSV content
    let csvContent = headers.join(',') + '\n';
    
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
        
        csvContent += rowData.join(',') + '\n';
    });
    
    // Create a download link
    const blob = new Blob([csvContent], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const filename = `radtribution_attributes_${new Date().toISOString().split('T')[0]}.csv`;
    
    downloadFile(url, filename);
    
    logDebug('CSV export completed');
}

// Function to export data to JSON format
function exportToJSON(rows) {
    logDebug(`Exporting ${rows.length} rows to JSON`);
    
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
    const filename = `radtribution_attributes_${new Date().toISOString().split('T')[0]}.json`;
    
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
