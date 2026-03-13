package crawler.models;

/**
 * Maps to [dbo].[RoomAmenity] junction table.
 */
public class RoomAmenity {

    private long roomAmenityId;
    private long roomId;
    private long amenityId;

    public RoomAmenity() {}

    public RoomAmenity(long roomId, long amenityId) {
        this.roomId = roomId;
        this.amenityId = amenityId;
    }

    public long getRoomAmenityId() { return roomAmenityId; }
    public void setRoomAmenityId(long roomAmenityId) { this.roomAmenityId = roomAmenityId; }

    public long getRoomId() { return roomId; }
    public void setRoomId(long roomId) { this.roomId = roomId; }

    public long getAmenityId() { return amenityId; }
    public void setAmenityId(long amenityId) { this.amenityId = amenityId; }

    @Override
    public String toString() {
        return "RoomAmenity{roomId=" + roomId + ", amenityId=" + amenityId + "}";
    }
}
