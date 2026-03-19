// ═══════════════════════════════════════════════════════════════════
// COMMON UTILITIES - BookNow Homestay System
// ═══════════════════════════════════════════════════════════════════

const BookNow = {

    // ─── Sidebar Toggle (for staff/admin pages) ───
    initSidebar: function() {
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');

        if (!mobileMenuBtn || !sidebar || !sidebarOverlay) return;

        function toggleSidebar() {
            const isClosed = sidebar.classList.contains('-translate-x-full');
            if (isClosed) {
                sidebar.classList.remove('-translate-x-full');
                sidebarOverlay.classList.remove('hidden');
            } else {
                sidebar.classList.add('-translate-x-full');
                sidebarOverlay.classList.add('hidden');
            }
        }

        mobileMenuBtn.addEventListener('click', toggleSidebar);
        sidebarOverlay.addEventListener('click', toggleSidebar);
    },

    // ─── Profile Dropdown (for customer pages) ───
    initProfileDropdown: function() {
        const profileBtn = document.getElementById('profileBtn');
        const profileDropdown = document.getElementById('profileDropdown');

        if (!profileBtn || !profileDropdown) return;

        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            const isHidden = profileDropdown.classList.contains('dropdown-hidden');
            if (isHidden) {
                profileDropdown.classList.remove('dropdown-hidden');
                profileDropdown.classList.add('dropdown-visible');
            } else {
                profileDropdown.classList.add('dropdown-hidden');
                profileDropdown.classList.remove('dropdown-visible');
            }
        });

        document.addEventListener('click', (e) => {
            if (!profileBtn.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.classList.add('dropdown-hidden');
                profileDropdown.classList.remove('dropdown-visible');
            }
        });
    },

    // ─── Format Date (Vietnamese) ───
    formatDate: function(date) {
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'numeric',
            day: 'numeric'
        };
        return date.toLocaleDateString('vi-VN', options);
    },

    // ─── Format Currency (VND) ───
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    },

    // ─── Show Toast Notification ───
    showToast: function(message, type = 'info') {
        const toast = document.createElement('div');
        const bgColor = {
            'success': 'bg-green-500',
            'error': 'bg-red-500',
            'warning': 'bg-yellow-500',
            'info': 'bg-blue-500'
        }[type] || 'bg-gray-500';

        toast.className = `fixed top-4 right-4 ${bgColor} text-white px-6 py-3 rounded-lg shadow-lg z-50 fade-in`;
        toast.textContent = message;

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-10px)';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    },

    // ─── Confirm Dialog ───
    confirm: function(message) {
        return window.confirm(message);
    },

    // ─── Auto-init on page load ───
    init: function() {
        this.initSidebar();
        this.initProfileDropdown();

        // Update current date on pages with #currentDate element
        const dateElement = document.getElementById('currentDate');
        if (dateElement) {
            dateElement.textContent = this.formatDate(new Date());
        }
    }
};

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    BookNow.init();
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = BookNow;
}
