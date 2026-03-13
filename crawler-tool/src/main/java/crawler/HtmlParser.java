package crawler;

import crawler.models.Room;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

/**
 * Parses the room detail page HTML to extract all room information.
 * Designed specifically for v2.localhome.vn room detail pages.
 *
 * Actual HTML structure (verified):
 *   Room name:      h1.entry-title
 *   Description:    article .entry-content p
 *   Amenities:      .itemBoxTN  (contains img + span)
 *   Gallery:        .owl-item:not(.cloned) .lgx-item img
 *   Pricing:        .price-box  (.price-vl + .price-dv)
 *   Guest count:    select#bw-soluong
 *   Branch:         input#bw-branch_address, input#bw-branch_area
 *   Booking data:   .non-item[data-price]  (data-price, data-range, data-day)
 */
public class HtmlParser {

    private static final Logger log = LoggerFactory.getLogger(HtmlParser.class);

    private final WebDriver driver;

    public HtmlParser(WebDriver driver) {
        this.driver = driver;
    }

    /**
     * Parses the currently loaded room detail page and returns a Room object.
     */
    public Room parseRoomDetailPage() {
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        Room room = new Room();

        room.setName(extractRoomName(wait));
        room.setDescription(extractDescription());
        room.setAmenityNames(extractAmenities());
        room.setImageUrls(extractImages());
        room.setPriceSlots(extractPriceSlots());
        room.setBranch(extractBranch());
        room.setMaxGuests(extractMaxGuests());

        return room;
    }

    // ========================================================================
    // Room Name — from <h1 class="entry-title">Ocean City</h1>
    // ========================================================================
    private String extractRoomName(WebDriverWait wait) {
        // Primary: h1.entry-title (verified in actual HTML)
        try {
            WebElement h1 = wait.until(
                    ExpectedConditions.presenceOfElementLocated(By.cssSelector("h1.entry-title")));
            String name = h1.getText().trim();
            if (!name.isEmpty()) return name;
        } catch (Exception ignored) {}

        // Fallback: hidden input #bw-room-name
        try {
            WebElement input = driver.findElement(By.cssSelector("input#bw-room-name"));
            String name = input.getAttribute("value");
            if (name != null && !name.isBlank()) return name.trim();
        } catch (Exception ignored) {}

        // Fallback: page title "Room Name - Localhome V2"
        try {
            String title = driver.getTitle();
            if (title != null && title.contains(" - ")) {
                return title.substring(0, title.indexOf(" - ")).trim();
            }
        } catch (Exception ignored) {}

        log.warn("Could not extract room name");
        return "Unknown Room";
    }

    // ========================================================================
    // Description — from <article id="post-XXXX"> .entry-content p
    // ========================================================================
    private String extractDescription() {
        try {
            // Target the description paragraphs inside the article content area
            // The article is at the bottom of the page: article .entry-content p
            List<WebElement> paragraphs = driver.findElements(
                    By.cssSelector("article .entry-content p"));

            StringBuilder desc = new StringBuilder();
            for (WebElement p : paragraphs) {
                String text = p.getText().trim();
                // Skip empty, very short paragraphs and skip hotline/contact lines
                if (text.length() > 20
                        && !text.startsWith("Hotline")
                        && !text.startsWith("Liên hệ")) {
                    if (!desc.isEmpty()) desc.append(" ");
                    desc.append(text);
                    if (desc.length() > 450) break;
                }
            }

            String result = desc.toString().trim();
            if (result.length() > 500) {
                result = result.substring(0, 497) + "...";
            }
            return result.isEmpty() ? null : result;
        } catch (Exception e) {
            log.debug("Could not extract description: {}", e.getMessage());
            return null;
        }
    }

    // ========================================================================
    // Amenities — from .itemBoxTN elements
    // HTML: <div class="... itemBoxTN"><img src="...tien_nghi_xxx.png"><span>Name</span></div>
    // ========================================================================
    public List<String> extractAmenities() {
        List<String> amenities = new ArrayList<>();
        try {
            List<WebElement> items = driver.findElements(By.cssSelector(".itemBoxTN"));

            for (WebElement item : items) {
                // Primary: read the <span> text inside the amenity box
                try {
                    WebElement span = item.findElement(By.tagName("span"));
                    String name = span.getText().trim();
                    if (!name.isEmpty()) {
                        amenities.add(name);
                        continue;
                    }
                } catch (Exception ignored) {}

                // Fallback: derive name from icon image filename
                try {
                    WebElement img = item.findElement(By.tagName("img"));
                    String src = img.getAttribute("src");
                    if (src != null) {
                        String name = deriveAmenityNameFromIcon(src);
                        if (name != null) amenities.add(name);
                    }
                } catch (Exception ignored) {}
            }
        } catch (Exception e) {
            log.debug("Could not extract amenities: {}", e.getMessage());
        }

        log.debug("Extracted {} amenities", amenities.size());
        return amenities;
    }

    /**
     * Derives a human-readable amenity name from the icon URL filename.
     * Example: "tien_nghi_may_chieu.png" -> "Máy chiếu"
     */
    private String deriveAmenityNameFromIcon(String iconUrl) {
        if (iconUrl.contains("tien_nghi_ghe_luoi")) return "Ghế lười";
        if (iconUrl.contains("tien_nghi_may_chieu")) return "Máy chiếu";
        if (iconUrl.contains("tien_nghi_netflix")) return "Netflix";
        if (iconUrl.contains("tien_nghi_guong_king") || iconUrl.contains("tien_nghi_giuong_king")) return "Giường King";
        if (iconUrl.contains("tien_nghi_guong_toan_than")) return "Gương toàn thân";
        if (iconUrl.contains("tien_nghi_cua_so")) return "Cửa sổ";
        if (iconUrl.contains("tien_nghi_ban_cong")) return "Ban công";
        if (iconUrl.contains("tien_nghi_wifi")) return "Wifi tốc độ cao";
        if (iconUrl.contains("tien_nghi_nha_bep")) return "Nhà bếp hiện đại";
        if (iconUrl.contains("tien_nghi_ban_trang_diem")) return "Bàn trang điểm";
        if (iconUrl.contains("tien_nghi_ghe_tinh_yeu")) return "Ghế tình yêu";
        if (iconUrl.contains("tien_nghi_may_game") || iconUrl.contains("tien_nghi_ps")) return "Máy game PS";
        if (iconUrl.contains("tien_nghi_ban_bida") || iconUrl.contains("tien_nghi_bida")) return "Bàn bida";
        if (iconUrl.contains("tien_nghi_bon_tam")) return "Bồn tắm";
        if (iconUrl.contains("tien_nghi_karaoke")) return "Karaoke";
        if (iconUrl.contains("tien_nghi_loa")) return "Hệ thống loa";
        if (iconUrl.contains("tien_nghi_dieu_hoa") || iconUrl.contains("tien_nghi_may_lanh")) return "Điều hòa";
        if (iconUrl.contains("tien_nghi_tu_lanh")) return "Tủ lạnh";
        if (iconUrl.contains("tien_nghi_bep_tu")) return "Bếp từ";
        if (iconUrl.contains("tien_nghi_lo_vi_song")) return "Lò vi sóng";
        if (iconUrl.contains("tien_nghi_may_say_toc")) return "Máy sấy tóc";
        if (iconUrl.contains("tien_nghi_binh_nong_lanh")) return "Bình nóng lạnh";
        if (iconUrl.contains("tien_nghi_den_ngu")) return "Đèn ngủ";
        if (iconUrl.contains("tien_nghi_sofa")) return "Sofa";

        // Generic fallback: extract filename part
        try {
            String filename = iconUrl.substring(iconUrl.lastIndexOf("/") + 1);
            filename = filename.replace("tien_nghi_", "").replace(".png", "").replace(".jpg", "");
            filename = filename.replace("_", " ");
            return filename.substring(0, 1).toUpperCase() + filename.substring(1);
        } catch (Exception e) {
            return null;
        }
    }

    // ========================================================================
    // Gallery Images — from OWL Carousel
    // HTML: .owl-item:not(.cloned) .lgx-item img
    // The carousel clones items for looping; we must exclude .cloned to avoid duplicates
    // ========================================================================
    public List<String> extractImages() {
        List<String> imageUrls = new ArrayList<>();
        try {
            // Primary: OWL carousel non-cloned items (exact selector from actual HTML)
            List<WebElement> carouselImages = driver.findElements(
                    By.cssSelector(".owl-item:not(.cloned) .lgx-item img"));

            for (WebElement img : carouselImages) {
                String src = getImageSrc(img);
                if (isRoomImage(src)) {
                    imageUrls.add(cleanImageUrl(src));
                }
            }

            // Fallback: if no carousel, try .lgx-carousel-section img
            if (imageUrls.isEmpty()) {
                List<WebElement> sectionImages = driver.findElements(
                        By.cssSelector(".lgx-carousel-section img[src*='/uploads/']"));
                for (WebElement img : sectionImages) {
                    String src = getImageSrc(img);
                    if (isRoomImage(src)) {
                        imageUrls.add(cleanImageUrl(src));
                    }
                }
            }

            // Fallback: any content image with /uploads/ path
            if (imageUrls.isEmpty()) {
                List<WebElement> allImages = driver.findElements(
                        By.cssSelector(".entry-description img[src*='/uploads/']"));
                for (WebElement img : allImages) {
                    String src = getImageSrc(img);
                    if (isRoomImage(src)) {
                        imageUrls.add(cleanImageUrl(src));
                    }
                }
            }

        } catch (Exception e) {
            log.debug("Could not extract images: {}", e.getMessage());
        }

        // De-duplicate while preserving order
        List<String> unique = new ArrayList<>(new LinkedHashSet<>(imageUrls));
        log.debug("Extracted {} unique images", unique.size());
        return unique;
    }

    private String getImageSrc(WebElement img) {
        String src = img.getAttribute("src");
        if (src == null || src.isBlank()) {
            src = img.getAttribute("data-src");
        }
        if (src == null || src.isBlank()) {
            src = img.getAttribute("data-lazy-src");
        }
        return src;
    }

    private boolean isRoomImage(String url) {
        if (url == null || url.isBlank()) return false;
        return url.contains("/uploads/")
                && !url.contains("-150x150")       // menu thumbnails
                && !url.contains("-300x300")        // small thumbs
                && !url.contains("tien_nghi_")     // amenity icons
                && !url.contains("ico-")            // UI icons
                && !url.contains("lucky-bag")
                && !url.contains("tuimu")
                && !url.contains("Screenshot");     // tutorial screenshots
    }

    /**
     * Removes WordPress thumbnail suffixes to get the original full-size image URL.
     * E.g., "image-768x1024.jpeg" -> "image.jpeg"
     */
    private String cleanImageUrl(String url) {
        return url.replaceAll("-\\d+x\\d+(?=\\.\\w+$)", "");
    }

    // ========================================================================
    // Pricing — from .price-box elements
    // HTML: <div class="price-box">
    //          <span class="price-vl">175.000</span>
    //          <span class="price-dv">đ/7:40 - 10:30</span>
    //       </div>
    //
    // Also available: .non-item[data-price][data-range] in the booking table
    // ========================================================================
    public List<String> extractPriceSlots() {
        List<String> slots = new ArrayList<>();
        try {
            // Primary: parse the .price-box elements in the "Bảng giá" section
            List<WebElement> priceBoxes = driver.findElements(By.cssSelector(".price-box"));

            for (WebElement box : priceBoxes) {
                try {
                    WebElement priceValue = box.findElement(By.cssSelector(".price-vl"));
                    WebElement priceDesc = box.findElement(By.cssSelector(".price-dv"));

                    String value = priceValue.getText().trim();   // e.g., "175.000"
                    String desc = priceDesc.getText().trim();     // e.g., "đ/7:40 - 10:30"

                    // Parse numeric price
                    String cleanPrice = value.replace(".", "").replace(",", "");

                    // Extract time range from desc if available
                    // Format examples: "đ/7:40 - 10:30", "đ/đêm", "đ/ngày"
                    String label = desc.replaceAll("^đ/?", "").trim();

                    slots.add(label + " | " + cleanPrice);
                } catch (Exception ignored) {
                    // Some price-box entries are discount info ("Giảm: 10.000 đ/mỗi khung giờ")
                }
            }

            // Fallback: extract from booking table data attributes if price-box not found
            if (slots.isEmpty()) {
                slots.addAll(extractPriceSlotsFromBookingTable());
            }

        } catch (Exception e) {
            log.debug("Could not extract price slots: {}", e.getMessage());
        }
        return slots;
    }

    /**
     * Extracts pricing from the booking table's data attributes.
     * HTML: <div class="non-item" data-price="175000" data-range="7:40 - 10:30" data-day="595000">
     * Only reads the first row to get unique slot prices.
     */
    private List<String> extractPriceSlotsFromBookingTable() {
        List<String> slots = new ArrayList<>();
        try {
            // Get all slots from the first row only (data-row="1")
            List<WebElement> cells = driver.findElements(
                    By.cssSelector(".non-item[data-row='1'][data-price][data-range]"));

            for (WebElement cell : cells) {
                String price = cell.getAttribute("data-price");
                String range = cell.getAttribute("data-range");
                if (price != null && range != null) {
                    slots.add(range + " | " + price);
                }
            }
        } catch (Exception e) {
            log.debug("Could not extract prices from booking table: {}", e.getMessage());
        }
        return slots;
    }

    // ========================================================================
    // Branch — from hidden inputs
    // HTML: <input type="hidden" id="bw-branch_address" value="Home – Hồng Phát, Ninh Kiều">
    //       <input type="hidden" id="bw-branch_area" value="Cần Thơ">
    // ========================================================================
    public String extractBranch() {
        try {
            String address = "";
            String area = "";

            try {
                WebElement addrInput = driver.findElement(By.cssSelector("input#bw-branch_address"));
                address = addrInput.getAttribute("value");
            } catch (Exception ignored) {}

            try {
                WebElement areaInput = driver.findElement(By.cssSelector("input#bw-branch_area"));
                area = areaInput.getAttribute("value");
            } catch (Exception ignored) {}

            String branch = (address != null ? address : "") +
                    (area != null && !area.isEmpty() ? ", " + area : "");
            return branch.isBlank() ? null : branch.trim();
        } catch (Exception e) {
            return null;
        }
    }

    // ========================================================================
    // Max Guests — from <select id="bw-soluong">
    // HTML: <option value="1">1</option> ... <option value="4">4</option>
    // ========================================================================
    public int extractMaxGuests() {
        try {
            List<WebElement> options = driver.findElements(
                    By.cssSelector("select#bw-soluong option"));
            int maxGuests = 0;
            for (WebElement opt : options) {
                try {
                    int val = Integer.parseInt(opt.getAttribute("value").trim());
                    if (val > maxGuests && val <= 10) {
                        maxGuests = val;
                    }
                } catch (NumberFormatException ignored) {}
            }
            return maxGuests > 0 ? maxGuests : 4;
        } catch (Exception e) {
            return 4;
        }
    }

    // ========================================================================
    // Static price helpers
    // ========================================================================

    /**
     * Parses a Vietnamese-format price string to BigDecimal.
     * E.g., "175.000" -> 175000, "175000" -> 175000
     */
    public static BigDecimal parsePrice(String priceStr) {
        if (priceStr == null || priceStr.isBlank()) return null;
        try {
            String cleaned = priceStr.replaceAll("[^\\d]", "");
            return cleaned.isEmpty() ? null : new BigDecimal(cleaned);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Extracts the base_price (cheapest time slot) from price slots.
     * Skips "đêm" (overnight) and "ngày" (full day) entries.
     */
    public static BigDecimal extractBasePrice(List<String> priceSlots) {
        BigDecimal minPrice = null;
        for (String slot : priceSlots) {
            // Skip overnight and full-day prices
            String label = slot.split("\\|")[0].trim().toLowerCase();
            if (label.contains("đêm") || label.contains("ngày")) continue;

            String[] parts = slot.split("\\|");
            if (parts.length >= 2) {
                BigDecimal price = parsePrice(parts[1].trim());
                if (price != null && (minPrice == null || price.compareTo(minPrice) < 0)) {
                    minPrice = price;
                }
            }
        }
        return minPrice;
    }

    /**
     * Extracts the over_price (overnight price) from price slots.
     * Looks for "đêm" or time ranges starting with "21:".
     */
    public static BigDecimal extractOverPrice(List<String> priceSlots) {
        for (String slot : priceSlots) {
            String label = slot.split("\\|")[0].trim().toLowerCase();
            if (label.contains("đêm") || label.contains("21:")) {
                String[] parts = slot.split("\\|");
                if (parts.length >= 2) {
                    return parsePrice(parts[1].trim());
                }
            }
        }
        // Fallback: highest price
        BigDecimal maxPrice = null;
        for (String slot : priceSlots) {
            String[] parts = slot.split("\\|");
            if (parts.length >= 2) {
                BigDecimal price = parsePrice(parts[1].trim());
                if (price != null && (maxPrice == null || price.compareTo(maxPrice) > 0)) {
                    maxPrice = price;
                }
            }
        }
        return maxPrice;
    }
}
