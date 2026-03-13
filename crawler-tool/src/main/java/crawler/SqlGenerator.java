package crawler;

import crawler.models.*;

import java.io.BufferedWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Normalizes scraped data and generates SQL INSERT statements
 * compatible with the BookNow MSSQL schema.
 *
 * Tables generated: RoomType, Amenity, Room, RoomAmenity, Image
 *
 * Uses IDENTITY_INSERT ON/OFF for explicit ID assignment and
 * SET IDENTITY_INSERT for MSSQL compatibility.
 */
public class SqlGenerator {

    private static final Logger log = LoggerFactory.getLogger(SqlGenerator.class);

    // Counters for auto-incrementing IDs
    private long roomTypeIdSeq = 1;
    private long amenityIdSeq = 1;
    private long roomIdSeq = 1;
    private long roomAmenityIdSeq = 1;
    private long imageIdSeq = 1;

    // De-duplication maps
    private final Map<String, RoomType> roomTypeMap = new LinkedHashMap<>();
    private final Map<String, Amenity> amenityMap = new LinkedHashMap<>();

    // Generated entities
    private final List<Room> normalizedRooms = new ArrayList<>();
    private final List<RoomAmenity> roomAmenities = new ArrayList<>();
    private final List<Image> images = new ArrayList<>();

    /**
     * Normalizes all scraped rooms into the relational schema.
     */
    public void normalize(List<Room> scrapedRooms) {
        log.info("Normalizing {} scraped rooms...", scrapedRooms.size());

        for (Room scraped : scrapedRooms) {
            // 1. Determine room type name from the room name / characteristics
            String typeName = deriveRoomTypeName(scraped);

            // 2. Get or create RoomType
            RoomType roomType = roomTypeMap.computeIfAbsent(typeName, key -> {
                RoomType rt = new RoomType(key);
                rt.setRoomTypeId(roomTypeIdSeq++);
                rt.setMaxGuests(scraped.getMaxGuests());
                // Build description: branch info + scraped description
                String desc = scraped.getDescription();
                if (scraped.getBranch() != null && desc != null) {
                    desc = scraped.getBranch() + " — " + desc;
                }
                if (desc != null && desc.length() > 500) {
                    desc = desc.substring(0, 497) + "...";
                }
                rt.setDescription(desc);
                rt.setBasePrice(HtmlParser.extractBasePrice(scraped.getPriceSlots()));
                rt.setOverPrice(HtmlParser.extractOverPrice(scraped.getPriceSlots()));
                // Use first image as room type image
                if (!scraped.getImageUrls().isEmpty()) {
                    rt.setImageUrl(scraped.getImageUrls().get(0));
                }
                return rt;
            });

            // 3. Create Room entity
            scraped.setRoomId(roomIdSeq++);
            scraped.setRoomTypeId(roomType.getRoomTypeId());
            normalizedRooms.add(scraped);

            // 4. Process amenities
            for (String amenityName : scraped.getAmenityNames()) {
                String normalized = amenityName.trim();
                if (normalized.isEmpty()) continue;

                Amenity amenity = amenityMap.computeIfAbsent(normalized, key -> {
                    Amenity a = new Amenity();
                    a.setAmenityId(amenityIdSeq++);
                    a.setName(key);
                    // Construct icon URL from known patterns
                    a.setIconUrl(guessIconUrl(key));
                    return a;
                });

                RoomAmenity ra = new RoomAmenity(scraped.getRoomId(), amenity.getAmenityId());
                ra.setRoomAmenityId(roomAmenityIdSeq++);
                roomAmenities.add(ra);
            }

            // 5. Process images
            boolean first = true;
            for (String imgUrl : scraped.getImageUrls()) {
                Image img = new Image(scraped.getRoomId(), imgUrl, first);
                img.setImageId(imageIdSeq++);
                images.add(img);
                first = false;
            }
        }

        log.info("Normalization complete: {} room types, {} amenities, {} rooms, {} room-amenities, {} images",
                roomTypeMap.size(), amenityMap.size(), normalizedRooms.size(),
                roomAmenities.size(), images.size());
    }

    /**
     * Derives a room type name based on the room's characteristics.
     * Each room becomes its own room type since each room on localhome
     * has unique theming, pricing, and amenities.
     */
    private String deriveRoomTypeName(Room room) {
        // Each room on this website is uniquely themed, so each room is its own type
        return room.getName() != null ? room.getName() : "Standard";
    }

    /**
     * Attempts to guess the icon URL for a known amenity name.
     */
    private String guessIconUrl(String amenityName) {
        String base = "https://v2.localhome.vn/gwzv/themes/localhome/images/";
        return switch (amenityName) {
            case "Ghế lười" -> base + "tien_nghi_ghe_luoi.png";
            case "Máy chiếu" -> base + "tien_nghi_may_chieu.png";
            case "Netflix" -> base + "tien_nghi_netflix.png";
            case "Giường King" -> base + "tien_nghi_guong_king.png";
            case "Gương toàn thân" -> base + "tien_nghi_guong_toan_than.png";
            case "Cửa sổ" -> base + "tien_nghi_cua_so.png";
            case "Ban công" -> base + "tien_nghi_ban_cong.png";
            case "Wifi tốc độ cao" -> base + "tien_nghi_wifi.png";
            case "Nhà bếp hiện đại" -> base + "tien_nghi_nha_bep.png";
            case "Bàn trang điểm" -> base + "tien_nghi_ban_trang_diem.png";
            case "Ghế tình yêu" -> base + "tien_nghi_ghe_tinh_yeu.png";
            case "Máy game PS" -> base + "tien_nghi_may_game_ps4.png";
            case "Bàn bida" -> base + "tien_nghi_ban_bida.png";
            case "Bồn tắm" -> base + "tien_nghi_bon_tam.png";
            case "Karaoke" -> base + "tien_nghi_karaoke.png";
            default -> null;
        };
    }

    /**
     * Generates all SQL INSERT statements and writes them to the specified file.
     */
    public void generateSql(Path outputPath) throws IOException {
        log.info("Generating SQL insert statements to: {}", outputPath.toAbsolutePath());

        Files.createDirectories(outputPath.getParent());

        try (BufferedWriter writer = Files.newBufferedWriter(outputPath, StandardCharsets.UTF_8)) {
            writer.write("-- ============================================================");
            writer.newLine();
            writer.write("-- BookNow — Auto-generated INSERT statements");
            writer.newLine();
            writer.write("-- Generated by: crawler-tool");
            writer.newLine();
            writer.write("-- Date: " + java.time.LocalDateTime.now());
            writer.newLine();
            writer.write("-- ============================================================");
            writer.newLine();
            writer.newLine();

            writer.write("USE [BookNow]");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
            writer.newLine();

            // ---- RoomType ----
            writeSection(writer, "RoomType");
            writer.write("SET IDENTITY_INSERT [dbo].[RoomType] ON;");
            writer.newLine();
            for (RoomType rt : roomTypeMap.values()) {
                writer.write(String.format(
                        "INSERT INTO [dbo].[RoomType] ([room_type_id], [name], [description], [base_price], [over_price], [image_url], [max_guests], [area_m2], [is_deleted]) " +
                        "VALUES (%d, N'%s', %s, %s, %s, %s, %d, NULL, 0);",
                        rt.getRoomTypeId(),
                        escapeSql(rt.getName()),
                        rt.getDescription() != null ? "N'" + escapeSql(rt.getDescription()) + "'" : "NULL",
                        rt.getBasePrice() != null ? rt.getBasePrice().toPlainString() : "NULL",
                        rt.getOverPrice() != null ? rt.getOverPrice().toPlainString() : "NULL",
                        rt.getImageUrl() != null ? "N'" + escapeSql(rt.getImageUrl()) + "'" : "NULL",
                        rt.getMaxGuests()
                ));
                writer.newLine();
            }
            writer.write("SET IDENTITY_INSERT [dbo].[RoomType] OFF;");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
            writer.newLine();

            // ---- Amenity ----
            writeSection(writer, "Amenity");
            writer.write("SET IDENTITY_INSERT [dbo].[Amenity] ON;");
            writer.newLine();
            for (Amenity a : amenityMap.values()) {
                writer.write(String.format(
                        "INSERT INTO [dbo].[Amenity] ([amenity_id], [name], [icon_url], [is_deleted]) " +
                        "VALUES (%d, N'%s', %s, 0);",
                        a.getAmenityId(),
                        escapeSql(a.getName()),
                        a.getIconUrl() != null ? "N'" + escapeSql(a.getIconUrl()) + "'" : "NULL"
                ));
                writer.newLine();
            }
            writer.write("SET IDENTITY_INSERT [dbo].[Amenity] OFF;");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
            writer.newLine();

            // ---- Room ----
            writeSection(writer, "Room");
            writer.write("SET IDENTITY_INSERT [dbo].[Room] ON;");
            writer.newLine();
            for (Room r : normalizedRooms) {
                writer.write(String.format(
                        "INSERT INTO [dbo].[Room] ([room_id], [room_type_id], [room_number], [status], [is_deleted]) " +
                        "VALUES (%d, %d, N'%s', 'AVAILABLE', 0);",
                        r.getRoomId(),
                        r.getRoomTypeId(),
                        escapeSql(r.getRoomNumber())
                ));
                writer.newLine();
            }
            writer.write("SET IDENTITY_INSERT [dbo].[Room] OFF;");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
            writer.newLine();

            // ---- RoomAmenity ----
            writeSection(writer, "RoomAmenity");
            writer.write("SET IDENTITY_INSERT [dbo].[RoomAmenity] ON;");
            writer.newLine();
            for (RoomAmenity ra : roomAmenities) {
                writer.write(String.format(
                        "INSERT INTO [dbo].[RoomAmenity] ([room_amenity_id], [room_id], [amenity_id]) " +
                        "VALUES (%d, %d, %d);",
                        ra.getRoomAmenityId(),
                        ra.getRoomId(),
                        ra.getAmenityId()
                ));
                writer.newLine();
            }
            writer.write("SET IDENTITY_INSERT [dbo].[RoomAmenity] OFF;");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
            writer.newLine();

            // ---- Image ----
            writeSection(writer, "Image");
            writer.write("SET IDENTITY_INSERT [dbo].[Image] ON;");
            writer.newLine();
            for (Image img : images) {
                writer.write(String.format(
                        "INSERT INTO [dbo].[Image] ([image_id], [room_id], [image_url], [is_cover], [public_id]) " +
                        "VALUES (%d, %d, N'%s', %d, NULL);",
                        img.getImageId(),
                        img.getRoomId(),
                        escapeSql(img.getImageUrl()),
                        img.isCover() ? 1 : 0
                ));
                writer.newLine();
            }
            writer.write("SET IDENTITY_INSERT [dbo].[Image] OFF;");
            writer.newLine();
            writer.write("GO");
            writer.newLine();
        }

        log.info("SQL file generated successfully: {} room types, {} amenities, {} rooms, {} room-amenities, {} images",
                roomTypeMap.size(), amenityMap.size(), normalizedRooms.size(),
                roomAmenities.size(), images.size());
    }

    private void writeSection(BufferedWriter writer, String tableName) throws IOException {
        writer.newLine();
        writer.write("-- ============================================================");
        writer.newLine();
        writer.write("-- " + tableName);
        writer.newLine();
        writer.write("-- ============================================================");
        writer.newLine();
    }

    /**
     * Escapes single quotes for SQL string literals.
     */
    private String escapeSql(String value) {
        if (value == null) return "";
        return value.replace("'", "''");
    }

    // Getters for stats
    public int getRoomTypeCount() { return roomTypeMap.size(); }
    public int getAmenityCount() { return amenityMap.size(); }
    public int getRoomCount() { return normalizedRooms.size(); }
    public int getRoomAmenityCount() { return roomAmenities.size(); }
    public int getImageCount() { return images.size(); }
}
