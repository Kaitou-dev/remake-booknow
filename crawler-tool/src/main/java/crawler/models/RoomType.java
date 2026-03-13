package crawler.models;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Maps to [dbo].[RoomType] table.
 * Contains room type info: name, description, pricing, capacity, area.
 */
public class RoomType {

    private long roomTypeId;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private BigDecimal overPrice;
    private String imageUrl;
    private int maxGuests;
    private BigDecimal areaM2;

    public RoomType() {}

    public RoomType(String name) {
        this.name = name;
    }

    public long getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(long roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public BigDecimal getOverPrice() { return overPrice; }
    public void setOverPrice(BigDecimal overPrice) { this.overPrice = overPrice; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getMaxGuests() { return maxGuests; }
    public void setMaxGuests(int maxGuests) { this.maxGuests = maxGuests; }

    public BigDecimal getAreaM2() { return areaM2; }
    public void setAreaM2(BigDecimal areaM2) { this.areaM2 = areaM2; }

    @Override
    public String toString() {
        return "RoomType{name='" + name + "', basePrice=" + basePrice + ", maxGuests=" + maxGuests + "}";
    }
}
