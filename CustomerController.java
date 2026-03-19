package com.booknow.controller.customer;

import com.booknow.model.Room;
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

/**
 * Controller for Customer-Facing Pages
 */
@Controller
public class CustomerController {

    @Autowired
    private RoomService roomService;

    /**
     * Homepage
     * URL: /
     * Template: templates/customer/index.html
     */
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("pageTitle", "Trang chủ");
        model.addAttribute("navbarTransparent", true);

        // Get featured rooms
        model.addAttribute("featuredRooms", roomService.getFeaturedRooms());

        return "customer/index";
    }

    /**
     * Room Search Results
     * URL: /search
     */
    @GetMapping("/search")
    public String search(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) Integer guests,
            @RequestParam(required = false) String priceRange,
            @RequestParam(required = false) String[] amenity,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            Model model) {

        model.addAttribute("pageTitle", "Kết quả tìm kiếm");
        model.addAttribute("navbarTransparent", false);

        Pageable pageable = PageRequest.of(page, size);
        Page<Room> roomPage = roomService.searchRooms(query, location, guests, priceRange, amenity, pageable);

        model.addAttribute("roomList", roomPage.getContent());
        model.addAttribute("page", roomPage);

        return "customer/search-results";
    }

    /**
     * Room Detail Page
     * URL: /room/{id}
     */
    @GetMapping("/room/{id}")
    public String roomDetail(@PathVariable Long id, Model model) {
        model.addAttribute("pageTitle", "Chi tiết phòng");
        model.addAttribute("navbarTransparent", false);

        Room room = roomService.getRoomById(id);
        model.addAttribute("room", room);

        return "customer/room-detail";
    }

    /**
     * Customer Login Page
     * URL: /login
     */
    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("pageTitle", "Đăng nhập");
        return "customer/login"; // This would be a simple page without layout if needed
    }

    /**
     * Customer Profile
     * URL: /customer/profile
     */
    @GetMapping("/customer/profile")
    public String profile(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Hồ sơ của tôi");
        model.addAttribute("navbarTransparent", false);

        // Get customer profile
        // Customer customer = customerService.getByEmail(userDetails.getUsername());
        // model.addAttribute("customer", customer);

        return "customer/profile";
    }

    /**
     * Booking History
     * URL: /customer/booking-history
     */
    @GetMapping("/customer/booking-history")
    public String bookingHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            @AuthenticationPrincipal UserDetails userDetails) {

        model.addAttribute("pageTitle", "Lịch sử đặt phòng");
        model.addAttribute("navbarTransparent", false);

        // Get customer's booking history
        // Page<Booking> bookingPage = bookingService.getCustomerBookingHistory(userDetails.getUsername(), pageable);
        // model.addAttribute("bookingList", bookingPage.getContent());
        // model.addAttribute("page", bookingPage);

        return "customer/booking-history";
    }
}
