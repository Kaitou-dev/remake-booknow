package crawler;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Crawls the room list pages to collect all room detail page URLs.
 * Handles pagination across multiple pages.
 */
public class RoomListCrawler {

    private static final Logger log = LoggerFactory.getLogger(RoomListCrawler.class);

    private static final String BASE_URL = "https://v2.localhome.vn/room/";
    private static final int TOTAL_PAGES = 5;
    private static final long DELAY_BETWEEN_PAGES_MS = 2000;
    private static final int MAX_RETRIES = 3;

    // Correct CSS selectors based on actual page structure
    // Room cards use: <div class="card lc_cardDefault mb-3">
    private static final String ROOM_CARD_SELECTOR = "div.card.lc_cardDefault";
    private static final String ROOM_LINK_SELECTOR = "div.card.lc_cardDefault .card-title a";
    private static final String NEXT_PAGE_SELECTOR = "a.next.page-numbers";

    private final WebDriver driver;

    public RoomListCrawler(WebDriver driver) {
        this.driver = driver;
    }

    /**
     * Crawls all pages and returns a de-duplicated list of room detail URLs.
     */
    public List<String> collectAllRoomUrls() {
        Set<String> urls = new LinkedHashSet<>();

        for (int page = 1; page <= TOTAL_PAGES; page++) {
            String pageUrl = (page == 1) ? BASE_URL : BASE_URL + "page/" + page + "/";
            log.info("Crawling room list page {}/{}: {}", page, TOTAL_PAGES, pageUrl);

            List<String> pageUrls = crawlPageWithRetry(pageUrl);
            urls.addAll(pageUrls);
            log.info("  Found {} room links on page {} (total so far: {})", pageUrls.size(), page, urls.size());

            if (page < TOTAL_PAGES) {
                sleep(DELAY_BETWEEN_PAGES_MS);
            }
        }

        log.info("Total unique room URLs collected: {}", urls.size());
        return new ArrayList<>(urls);
    }

    private List<String> crawlPageWithRetry(String pageUrl) {
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                return crawlSinglePage(pageUrl);
            } catch (Exception e) {
                log.warn("Attempt {}/{} failed for {}: {}", attempt, MAX_RETRIES, pageUrl, e.getMessage());
                if (attempt < MAX_RETRIES) {
                    sleep(3000);
                }
            }
        }
        log.error("All {} attempts failed for page: {}", MAX_RETRIES, pageUrl);
        return List.of();
    }

    private List<String> crawlSinglePage(String pageUrl) {
        driver.get(pageUrl);

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(20));

        // Wait for room cards to be present
        // The actual page structure uses: <div class="card lc_cardDefault mb-3">
        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(ROOM_CARD_SELECTOR)));

        // Wait for cards to be visible (handles lazy loading)
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(ROOM_CARD_SELECTOR)));

        // Scroll to load any lazy-loaded content
        scrollToLoadAllContent();

        List<String> urls = new ArrayList<>();

        // Strategy 1: Find all room links using the correct selector
        // Structure: div.card.lc_cardDefault > .card-body > h5.card-title > a
        List<WebElement> roomLinks = driver.findElements(By.cssSelector(ROOM_LINK_SELECTOR));
        for (WebElement link : roomLinks) {
            try {
                String href = link.getAttribute("href");
                if (href != null && !href.isBlank() && href.contains("/room/") && !href.contains("/page/")) {
                    urls.add(href.trim());
                }
            } catch (Exception e) {
                log.debug("Could not extract URL from room link: {}", e.getMessage());
            }
        }

        // Strategy 2: Fallback - find all cards and extract links
        if (urls.isEmpty()) {
            log.info("  Falling back to card container search...");
            List<WebElement> cards = driver.findElements(By.cssSelector(ROOM_CARD_SELECTOR));
            for (WebElement card : cards) {
                try {
                    // Look for any anchor with href containing /room/
                    List<WebElement> anchors = card.findElements(By.cssSelector("a[href*='/room/']"));
                    if (!anchors.isEmpty()) {
                        String href = anchors.get(0).getAttribute("href");
                        if (href != null && !href.isBlank() && !href.contains("/page/")) {
                            urls.add(href.trim());
                        }
                    }
                } catch (Exception e) {
                    log.debug("Could not extract URL from card: {}", e.getMessage());
                }
            }
        }

        // Strategy 3: Ultimate fallback - direct link discovery
        if (urls.isEmpty()) {
            log.info("  Falling back to direct link search...");
            List<WebElement> allRoomLinks = driver.findElements(
                    By.cssSelector("a[href*='/room/'][title]"));
            for (WebElement link : allRoomLinks) {
                String href = link.getAttribute("href");
                if (href != null && href.matches(".*v2\\.localhome\\.vn/room/[^/]+/$")
                        && !href.contains("/page/")) {
                    urls.add(href.trim());
                }
            }
        }

        return urls;
    }

    /**
     * Scroll the page to ensure all lazy-loaded content is loaded.
     */
    private void scrollToLoadAllContent() {
        try {
            JavascriptExecutor js = (JavascriptExecutor) driver;

            // Scroll to bottom in increments to trigger lazy loading
            long lastHeight = (long) js.executeScript("return document.body.scrollHeight");

            int maxScrollAttempts = 5;
            int attempts = 0;

            while (attempts < maxScrollAttempts) {
                js.executeScript("window.scrollTo(0, document.body.scrollHeight)");
                sleep(300);

                long newHeight = (long) js.executeScript("return document.body.scrollHeight");
                if (newHeight == lastHeight) {
                    break;
                }
                lastHeight = newHeight;
                attempts++;
            }

            // Scroll back to top
            js.executeScript("window.scrollTo(0, 0)");
            sleep(200);
        } catch (Exception e) {
            log.debug("Error during scroll: {}", e.getMessage());
        }
    }

    private void sleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
