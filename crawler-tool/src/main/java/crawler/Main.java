package crawler;

import crawler.models.Room;
import org.openqa.selenium.WebDriver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * Main entry point for the BookNow Room Crawler.
 *
 * Workflow:
 *   1. Launch headless Chrome via Selenium
 *   2. Crawl all room list pages to collect room detail URLs
 *   3. Visit each room detail page and extract data
 *   4. Normalize data into relational schema
 *   5. Generate SQL INSERT statements
 *   6. Save to output/insert.sql
 */
public class Main {

    private static final Logger log = LoggerFactory.getLogger(Main.class);

    private static final Path OUTPUT_FILE = Paths.get("output", "insert.sql");

    public static void main(String[] args) {
        log.info("=== BookNow Room Crawler ===");
        log.info("Target: https://v2.localhome.vn/room/");
        log.info("Output: {}", OUTPUT_FILE.toAbsolutePath());

        long startTime = System.currentTimeMillis();
        WebDriver driver = null;

        try {
            // Step 1: Initialize browser
            log.info("");
            log.info("STEP 1: Initializing Selenium WebDriver...");
            driver = SeleniumDriverFactory.createDriver();

            // Step 2: Crawl room list pages
            log.info("");
            log.info("STEP 2: Crawling room list pages...");
            RoomListCrawler listCrawler = new RoomListCrawler(driver);
            List<String> roomUrls = listCrawler.collectAllRoomUrls();

            if (roomUrls.isEmpty()) {
                log.error("No room URLs found. Exiting.");
                return;
            }

            // Step 3: Crawl each room detail page
            log.info("");
            log.info("STEP 3: Crawling {} room detail pages...", roomUrls.size());
            RoomDetailCrawler detailCrawler = new RoomDetailCrawler(driver);
            List<Room> rooms = detailCrawler.crawlAllRoomDetails(roomUrls);

            if (rooms.isEmpty()) {
                log.error("No room data extracted. Exiting.");
                return;
            }

            // Step 4: Normalize and generate SQL
            log.info("");
            log.info("STEP 4: Normalizing data and generating SQL...");
            SqlGenerator sqlGen = new SqlGenerator();
            sqlGen.normalize(rooms);
            sqlGen.generateSql(OUTPUT_FILE);

            // Summary
            long elapsed = (System.currentTimeMillis() - startTime) / 1000;
            log.info("");
            log.info("=== CRAWL COMPLETE ===");
            log.info("  Room Types:     {}", sqlGen.getRoomTypeCount());
            log.info("  Amenities:      {}", sqlGen.getAmenityCount());
            log.info("  Rooms:          {}", sqlGen.getRoomCount());
            log.info("  Room-Amenities: {}", sqlGen.getRoomAmenityCount());
            log.info("  Images:         {}", sqlGen.getImageCount());
            log.info("  SQL file:       {}", OUTPUT_FILE.toAbsolutePath());
            log.info("  Time elapsed:   {} seconds", elapsed);

        } catch (Exception e) {
            log.error("Fatal error during crawl: {}", e.getMessage(), e);
        } finally {
            if (driver != null) {
                try {
                    driver.quit();
                    log.info("Browser closed.");
                } catch (Exception e) {
                    log.warn("Error closing browser: {}", e.getMessage());
                }
            }
        }
    }
}
