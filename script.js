document.addEventListener('DOMContentLoaded', function() {
    let currentVendor = 'all';
    let currentProtocol = 'all';
    const vendorSections = document.querySelectorAll('section.vendor-section');
    const vendorButtons = document.querySelectorAll('.vendor-button');
    const protocolButtons = document.querySelectorAll('.protocol-button');
    const allSection = document.getElementById('all');
    const searchInput = document.getElementById('searchInput');
    const featureCheckboxes = document.querySelectorAll('.filter-options input[type="checkbox"]');
    const resultsInfo = document.getElementById('resultsInfo');
    const noResults = document.getElementById('noResults');
    const allTable = allSection.querySelector('table');
    const allRows = allTable ? allTable.getElementsByTagName('tr') : [];
    
    // Vendor navigation
    vendorButtons.forEach(button => {
        button.addEventListener('click', function() {
            // set current vendor
            const vendor = this.getAttribute('data-vendor');
            if (currentVendor === vendor) return;
            currentVendor = vendor;
            
            // update active button
            vendorButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // show corresponding section
            vendorSections.forEach(sec => sec.classList.remove('active'));
            const targetSection = document.getElementById(vendor);
            if (targetSection) {
                targetSection.classList.add('active');
            }
            
            // If not all vendors section, hide filter panel and reset search if needed
            const filterContainer = document.querySelector('.filter-container');
            if (vendor !== 'all') {
                if(filterContainer) filterContainer.style.display = 'none';
                if(resultsInfo) resultsInfo.style.display = 'none';
                if(noResults) noResults.style.display = 'none';
                
                // Reset protocol buttons to All for vendor-specific view
                currentProtocol = 'all';
                protocolButtons.forEach(btn => {
                    btn.classList.remove('active');
                    if(btn.getAttribute('data-protocol') === 'all') {
                        btn.classList.add('active');
                    }
                });
            } else {
                // if all vendor section, show filter container
                if(filterContainer) filterContainer.style.display = 'block';
                if(resultsInfo) resultsInfo.style.display = 'block';
                
                // Reapply filter in case search/checkbox was active
                filterTable();
            }
        });
    });
    
    // Protocol toggle
    protocolButtons.forEach(button => {
        button.addEventListener('click', function() {
            const protocol = this.getAttribute('data-protocol');
            if(currentProtocol === protocol) return;
            currentProtocol = protocol;
            
            // Update active state
            protocolButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // If viewing All vendors, filter the table by protocol
            if (currentVendor === 'all') {
                filterTable();
            } else {
                // In specific vendor section, show relevant protocol subsection
                const vendorSection = document.getElementById(currentVendor);
                if(!vendorSection) return;
                const protocolSections = vendorSection.querySelectorAll('.protocol-section');
                protocolSections.forEach(sec => sec.classList.remove('active'));
                const targetSection = document.getElementById(currentVendor + '-' + protocol);
                if (targetSection) {
                    targetSection.classList.add('active');
                }
            }
        });
    });
    
    // Filtering function for All table
    function filterTable() {
        if (!allTable) return;
        const searchTerm = searchInput.value.toLowerCase();
        
        // Collect checked features
        const checkedFeatures = Array.from(featureCheckboxes)
            .filter(cb => cb.checked)
            .map(cb => cb.value);
        
        let visibleCount = 0;
        
        // Loop through all data rows (skip header)
        for (let i = 1; i < allRows.length; i++) {
            const row = allRows[i];
            if(!row.getAttribute) continue;
            
            const rowVendor = row.getAttribute('data-vendor');
            const rowProtocol = row.getAttribute('data-protocol');
            const text = row.textContent.toLowerCase();
            
            // Vendor filter: currentVendor or 'all'
            const vendorMatch = (currentVendor === 'all') || (rowVendor === currentVendor);
            
            // Protocol filter: currentProtocol or 'all'
            const protocolMatch = (currentProtocol === 'all') || (rowProtocol === currentProtocol);
            
            // Feature filters: all checked features must be 'yes' in row data
            let featuresMatch = true;
            if (checkedFeatures.length > 0) {
                featuresMatch = checkedFeatures.every(feature => 
                    row.getAttribute('data-' + feature) === 'yes');
            }
            
            // Search filter
            const searchMatch = (searchTerm === '' || text.includes(searchTerm));
            
            if (vendorMatch && protocolMatch && featuresMatch && searchMatch) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        }
        
        // Update results count
        if (resultsInfo) {
            if (searchInput.value === '' && checkedFeatures.length === 0 && currentProtocol === 'all') {
                resultsInfo.textContent = `Showing all ${visibleCount} attributes`;
            } else {
                resultsInfo.textContent = `Showing ${visibleCount} filtered attributes`;
            }
        }
        
        // Show or hide 'no results'
        if(noResults) {
            noResults.style.display = (visibleCount === 0) ? 'block' : 'none';
        }
    }
    
    // Search input event
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            if(currentVendor !== 'all') {
                // switch to All vendors section for searching
                document.querySelector('.vendor-button[data-vendor="all"]').click();
            }
            filterTable();
        });
    }
    
    // Feature checkboxes
    featureCheckboxes.forEach(cb => {
        cb.addEventListener('change', function() {
            if(currentVendor !== 'all') {
                document.querySelector('.vendor-button[data-vendor="all"]').click();
            }
            filterTable();
        });
    });
    
    // Tab navigation
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const tabContainer = this.closest('.tabs');
            const contentContainer = tabContainer.nextElementSibling.parentElement;
            
            // Update active tab
            tabContainer.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            // Update active content
            contentContainer.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById(targetId).classList.add('active');
        });
    });
    
    // Initialize the view to All vendors, All protocols
    filterTable();
});
