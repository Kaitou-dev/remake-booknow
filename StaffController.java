package com.booknow.controller.staff;

import com.booknow.model.Booking;
import com.booknow.service.BookingService;
import com.booknow.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * Controller for Staff Dashboard and Management Pages
 */
@Controller
@RequestMapping("/staff")
public class StaffController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private RoomService roomService;

    /**
     * Staff Dashboard - Main Page
     * URL: /staff/dashboard
     * Template: templates/staff/dashboard.html
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        // Set page metadata
        model.addAttribute("pageTitle", "Staff Dashboard");
        model.addAttribute("activePage", "dashboard");

        // Set user information
        model.addAttribute("userName", userDetails.getUsername());
        model.addAttribute("userRole", "Nhân viên"); // Or get from authorities
        model.addAttribute("userInitials", getInitials(userDetails.getUsername()));

        // Dashboard statistics
        model.addAttribute("todayBookings", bookingService.countTodayBookings());
        model.addAttribute("availableRooms", roomService.countAvailableRooms());
        model.addAttribute("totalRooms", roomService.countTotalRooms());
        model.addAttribute("pendingCheckins", bookingService.countPendingCheckins());
        model.addAttribute("newFeedback", 2); // Replace with actual service call

        // Check-in list for today
        model.addAttribute("checkinList", bookingService.getTodayCheckins());

        return "staff/dashboard";
    }

    /**
     * Booking List Page with Filtering and Pagination
     * URL: /staff/bookings
     * Template: templates/staff/booking-list.html
     */
    @GetMapping("/bookings")
    public String bookingList(
            @RequestParam(required = false) LocalDate fromDate,
            @RequestParam(required = false) LocalDate toDate,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            @AuthenticationPrincipal UserDetails userDetails) {

        // Set page metadata
        model.addAttribute("pageTitle", "Danh sách đặt phòng");
        model.addAttribute("activePage", "bookings");

        // Set user information
        model.addAttribute("userName", userDetails.getUsername());
        model.addAttribute("userRole", "Nhân viên");
        model.addAttribute("userInitials", getInitials(userDetails.getUsername()));

        // Create pageable object
        Pageable pageable = PageRequest.of(page, size);

        // Get filtered bookings
        Page<Booking> bookingPage = bookingService.getFilteredBookings(
            fromDate, toDate, status, search, pageable
        );

        // Add data to model
        model.addAttribute("bookingList", bookingPage.getContent());
        model.addAttribute("page", bookingPage);

        // Retain filter values
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("searchQuery", search);

        return "staff/booking-list";
    }

    /**
     * Booking Detail Page
     * URL: /staff/booking/{id}
     */
    @GetMapping("/booking/{id}")
    public String bookingDetail(@PathVariable Long id, Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Chi tiết đặt phòng");
        model.addAttribute("activePage", "bookings");
        model.addAttribute("userName", userDetails.getUsername());
        model.addAttribute("userRole", "Nhân viên");
        model.addAttribute("userInitials", getInitials(userDetails.getUsername()));

        // Get booking details
        Booking booking = bookingService.getBookingById(id);
        model.addAttribute("booking", booking);

        return "staff/booking-detail";
    }

    /**
     * Utility method to get user initials
     */
    private String getInitials(String name) {
        if (name == null || name.isEmpty()) return "NV";
        String[] parts = name.split(" ");
        if (parts.length >= 2) {
            return parts[0].substring(0, 1).toUpperCase() +
                   parts[parts.length - 1].substring(0, 1).toUpperCase();
        }
        return name.substring(0, Math.min(2, name.length())).toUpperCase();
    }
}
