package com.booknow.controller.housekeeping;

import com.booknow.model.HousekeepingTask;
import com.booknow.service.HousekeepingService;
import com.booknow.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controller for Housekeeping Staff Pages
 */
@Controller
@RequestMapping("/housekeeping")
public class HousekeepingController {

    @Autowired
    private HousekeepingService housekeepingService;

    @Autowired
    private RoomService roomService;

    /**
     * Housekeeping Dashboard
     * URL: /housekeeping/dashboard
     * Template: templates/housekeeping/dashboard.html
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Housekeeping Dashboard");

        // Set user information
        model.addAttribute("userName", userDetails.getUsername());

        // Dashboard statistics
        model.addAttribute("needsCleaning", roomService.countDirtyRooms());
        model.addAttribute("underMaintenance", roomService.countMaintenanceRooms());
        model.addAttribute("overdueCheckout", roomService.countOverdueCheckouts());
        model.addAttribute("availableRooms", roomService.countAvailableRooms());

        // Task list
        List<HousekeepingTask> taskList = housekeepingService.getAllTasks();
        model.addAttribute("taskList", taskList);

        return "housekeeping/dashboard";
    }

    /**
     * Cleaning Task List
     * URL: /housekeeping/cleaning-tasks
     */
    @GetMapping("/cleaning-tasks")
    public String cleaningTasks(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Cleaning Tasks");
        model.addAttribute("userName", userDetails.getUsername());

        List<HousekeepingTask> tasks = housekeepingService.getCleaningTasks();
        model.addAttribute("taskList", tasks);

        return "housekeeping/cleaning-task-list";
    }

    /**
     * Task Detail
     * URL: /housekeeping/task/{id}
     */
    @GetMapping("/task/{id}")
    public String taskDetail(@PathVariable Long id, Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Task Detail");
        model.addAttribute("userName", userDetails.getUsername());

        HousekeepingTask task = housekeepingService.getTaskById(id);
        model.addAttribute("task", task);

        return "housekeeping/task-detail";
    }

    /**
     * Assign Task
     * URL: /housekeeping/task/{id}/assign
     */
    @PostMapping("/task/{id}/assign")
    public String assignTask(
            @PathVariable Long id,
            @RequestParam String assignTo,
            @AuthenticationPrincipal UserDetails userDetails) {

        housekeepingService.assignTask(id, assignTo);

        return "redirect:/housekeeping/dashboard";
    }

    /**
     * Mark Room as Cleaned
     * URL: /housekeeping/room/{roomId}/mark-cleaned
     */
    @PostMapping("/room/{roomId}/mark-cleaned")
    public String markRoomCleaned(
            @PathVariable Long roomId,
            @AuthenticationPrincipal UserDetails userDetails) {

        housekeepingService.markRoomCleaned(roomId, userDetails.getUsername());

        return "redirect:/housekeeping/dashboard";
    }
}
