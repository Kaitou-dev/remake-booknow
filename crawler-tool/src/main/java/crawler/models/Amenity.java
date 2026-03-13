package crawler.models;

/**
 * Maps to [dbo].[Amenity] table.
 */
public class Amenity {

    private long amenityId;
    private String name;
    private String iconUrl;

    public Amenity() {}

    public Amenity(String name, String iconUrl) {
        this.name = name;
        this.iconUrl = iconUrl;
    }

    public long getAmenityId() { return amenityId; }
    public void setAmenityId(long amenityId) { this.amenityId = amenityId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }

    @Override
    public String toString() {
        return "Amenity{name='" + name + "'}";
    }
}
