package crawler;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;

/**
 * Factory for creating and configuring Selenium ChromeDriver instances.
 */
public class SeleniumDriverFactory {

    private static final Logger log = LoggerFactory.getLogger(SeleniumDriverFactory.class);

    private static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

    private SeleniumDriverFactory() {}

    /**
     * Creates a headless Chrome WebDriver with sensible defaults.
     */
    public static WebDriver createDriver() {
        log.info("Setting up ChromeDriver via WebDriverManager...");
        WebDriverManager.chromedriver().setup();

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--disable-gpu");
        options.addArguments("--window-size=1920,1080");
        options.addArguments("--user-agent=" + USER_AGENT);
        options.addArguments("--disable-blink-features=AutomationControlled");
        options.addArguments("--lang=vi-VN");
        options.setExperimentalOption("excludeSwitches", new String[]{"enable-automation"});

        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));

        log.info("ChromeDriver initialized successfully (headless mode).");
        return driver;
    }
}
