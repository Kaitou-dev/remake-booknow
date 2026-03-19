// ═══════════════════════════════════════════════════════════════════
// CUSTOMER NAVBAR UTILITIES - BookNow Homestay System
// ═══════════════════════════════════════════════════════════════════

(function() {
    'use strict';

    // ─── Navbar Scroll Behavior ───
    const NavbarManager = {
        init: function() {
            this.navbar = document.getElementById('mainNavbar');
            if (!this.navbar) return;

            this.bindScrollEvent();
        },

        bindScrollEvent: function() {
            let lastScroll = 0;
            const navbar = this.navbar;

            window.addEventListener('scroll', () => {
                const currentScroll = window.pageYOffset;

                // Change navbar background on scroll
                if (currentScroll > 100) {
                    navbar.classList.remove('bg-gradient-to-b', 'from-black/60', 'to-transparent');
                    navbar.classList.add('bg-white', 'shadow-md');

                    // Update text colors
                    const links = navbar.querySelectorAll('a, button, span');
                    links.forEach(link => {
                        link.classList.remove('text-white', 'text-blue-200');
                        link.classList.add('text-gray-700');
                    });
                } else {
                    navbar.classList.remove('bg-white', 'shadow-md');
                    navbar.classList.add('bg-gradient-to-b', 'from-black/60', 'to-transparent');

                    // Restore transparent text colors
                    const links = navbar.querySelectorAll('a, button, span');
                    links.forEach(link => {
                        link.classList.remove('text-gray-700');
                        link.classList.add('text-white');
                    });
                }

                lastScroll = currentScroll;
            });
        }
    };

    // ─── Booking Bar Management ───
    const BookingBarManager = {
        init: function() {
            this.bookingBar = document.getElementById('bookingBar');
            this.cancelBtn = document.getElementById('cancelBookingBtn');

            if (!this.bookingBar) return;

            this.bindEvents();
        },

        bindEvents: function() {
            if (this.cancelBtn) {
                this.cancelBtn.addEventListener('click', () => {
                    this.hide();
                });
            }
        },

        show: function(roomInfo) {
            if (!this.bookingBar) return;
            this.bookingBar.classList.remove('translate-y-full');
            this.bookingBar.classList.add('translate-y-0');

            // Update booking info if provided
            if (roomInfo) {
                const bookingText = document.getElementById('bookingBarText');
                if (bookingText) {
                    bookingText.textContent = roomInfo;
                }
            }
        },

        hide: function() {
            if (!this.bookingBar) return;
            this.bookingBar.classList.add('translate-y-full');
            this.bookingBar.classList.remove('translate-y-0');
        }
    };

    // Auto-initialize
    document.addEventListener('DOMContentLoaded', () => {
        NavbarManager.init();
        BookingBarManager.init();
    });

    // Export for external use
    window.BookingBarManager = BookingBarManager;

})();
