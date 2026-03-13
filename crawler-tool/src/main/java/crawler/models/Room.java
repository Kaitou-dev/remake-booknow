package crawler.models;

import java.util.ArrayList;
import java.util.List;

/**
 * Maps to [dbo].[Room] table.
 * A Room references a RoomType and holds transient scraped data
 * (amenities, images) used for generating junction/child table inserts.
 */
public class Room {

    private long roomId;
    private long roomTypeId;
    private String roomNumber;  // unique room identifier (slug-based)
    private String status = "AVAILABLE";

    // Transient scraped data (not stored in Room table directly)
    private String name;
    private String description;
    private String detailUrl;
    private String branch;
    private int maxGuests = 4;
    private List<String> amenityNames = new ArrayList<>();
    private List<String> imageUrls = new ArrayList<>();
    private List<String> priceSlots = new ArrayList<>();

    public Room() {}

    public long getRoomId() { return roomId; }
    public void setRoomId(long roomId) { this.roomId = roomId; }

    public long getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(long roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDetailUrl() { return detailUrl; }
    public void setDetailUrl(String detailUrl) { this.detailUrl = detailUrl; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public int getMaxGuests() { return maxGuests; }
    public void setMaxGuests(int maxGuests) { this.maxGuests = maxGuests; }

    public List<String> getAmenityNames() { return amenityNames; }
    public void setAmenityNames(List<String> amenityNames) { this.amenityNames = amenityNames; }

    public List<String> getImageUrls() { return imageUrls; }
    public void setImageUrls(List<String> imageUrls) { this.imageUrls = imageUrls; }

    public List<String> getPriceSlots() { return priceSlots; }
    public void setPriceSlots(List<String> priceSlots) { this.priceSlots = priceSlots; }

    @Override
    public String toString() {
        return "Room{name='" + name + "', roomNumber='" + roomNumber + "', amenities=" + amenityNames.size() +
               ", images=" + imageUrls.size() + "}";
    }
}
