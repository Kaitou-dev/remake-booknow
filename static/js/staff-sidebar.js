// ═══════════════════════════════════════════════════════════════════
// STAFF SIDEBAR UTILITIES - BookNow Homestay System
// ═══════════════════════════════════════════════════════════════════

(function() {
    'use strict';

    // ─── Sidebar State Management ───
    const SidebarManager = {
        init: function() {
            this.bindEvents();
            this.highlightActivePage();
        },

        bindEvents: function() {
            // Mobile menu toggle is handled in common.js
            // Add any additional sidebar-specific events here
        },

        highlightActivePage: function() {
            // Get current page path
            const currentPath = window.location.pathname;

            // Find matching nav link
            const navLinks = document.querySelectorAll('aside nav a');
            navLinks.forEach(link => {
                const linkPath = new URL(link.href).pathname;
                if (currentPath.startsWith(linkPath) && linkPath !== '/') {
                    link.classList.add('bg-blue-50', 'text-blue-600', 'shadow-sm', 'ring-1', 'ring-black/5');
                    link.classList.remove('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
                }
            });
        }
    };

    // Auto-initialize
    document.addEventListener('DOMContentLoaded', () => {
        SidebarManager.init();
    });

})();
