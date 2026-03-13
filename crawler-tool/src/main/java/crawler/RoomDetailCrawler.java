package crawler;

import crawler.models.Room;
import org.openqa.selenium.WebDriver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Visits each room detail page and delegates HTML parsing to HtmlParser.
 * Handles retry logic and rate limiting between requests.
 */
public class RoomDetailCrawler {

    private static final Logger log = LoggerFactory.getLogger(RoomDetailCrawler.class);

    private static final long DELAY_BETWEEN_ROOMS_MS = 2500;
    private static final int MAX_RETRIES = 3;

    private final WebDriver driver;
    private final HtmlParser parser;

    public RoomDetailCrawler(WebDriver driver) {
        this.driver = driver;
        this.parser = new HtmlParser(driver);
    }

    /**
     * Visits each room detail URL and extracts room data.
     */
    public List<Room> crawlAllRoomDetails(List<String> roomUrls) {
        List<Room> rooms = new ArrayList<>();
        int total = roomUrls.size();

        for (int i = 0; i < total; i++) {
            String url = roomUrls.get(i);
            log.info("[{}/{}] Crawling room detail: {}", i + 1, total, url);

            Room room = crawlWithRetry(url);
            if (room != null) {
                rooms.add(room);
                log.info("  => {} | amenities={} | images={}", room.getName(),
                        room.getAmenityNames().size(), room.getImageUrls().size());
            } else {
                log.warn("  => FAILED to crawl: {}", url);
            }

            if (i < total - 1) {
                sleep(DELAY_BETWEEN_ROOMS_MS);
            }
        }

        log.info("Successfully crawled {}/{} rooms.", rooms.size(), total);
        return rooms;
    }

    private Room crawlWithRetry(String url) {
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                driver.get(url);
                // Allow page to fully load (OWL carousel + booking table)
                sleep(2000);

                Room room = parser.parseRoomDetailPage();
                room.setDetailUrl(url);

                // Derive room number from URL slug
                String slug = extractSlug(url);
                room.setRoomNumber(slug);

                return room;
            } catch (Exception e) {
                log.warn("  Attempt {}/{} failed for {}: {}", attempt, MAX_RETRIES, url, e.getMessage());
                if (attempt < MAX_RETRIES) {
                    sleep(3000);
                }
            }
        }
        return null;
    }

    /**
     * Extracts the slug from a URL like "https://v2.localhome.vn/room/ocean-city/"
     * Returns "ocean-city".
     */
    private String extractSlug(String url) {
        String trimmed = url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
        int lastSlash = trimmed.lastIndexOf('/');
        return lastSlash >= 0 ? trimmed.substring(lastSlash + 1) : trimmed;
    }

    private void sleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
