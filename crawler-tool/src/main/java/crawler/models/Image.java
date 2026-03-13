package crawler.models;

/**
 * Maps to [dbo].[Image] table.
 */
public class Image {

    private long imageId;
    private long roomId;
    private String imageUrl;
    private boolean isCover;

    public Image() {}

    public Image(long roomId, String imageUrl, boolean isCover) {
        this.roomId = roomId;
        this.imageUrl = imageUrl;
        this.isCover = isCover;
    }

    public long getImageId() { return imageId; }
    public void setImageId(long imageId) { this.imageId = imageId; }

    public long getRoomId() { return roomId; }
    public void setRoomId(long roomId) { this.roomId = roomId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isCover() { return isCover; }
    public void setCover(boolean cover) { isCover = cover; }

    @Override
    public String toString() {
        return "Image{roomId=" + roomId + ", url='" + imageUrl + "', cover=" + isCover + "}";
    }
}
