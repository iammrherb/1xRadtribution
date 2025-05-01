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
