package uk.gov.defra.jncc.topsat.crud.entity.satellites;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.OneToOne;
import uk.gov.defra.jncc.topsat.crud.entity.crs.wrs2;

/**
 *
 * @author Matt Debont
 */
@Entity
public class Landsat implements Serializable {
    public static final String URI = "landsat";
    public static final String NAME = "Landsat";
    
    @Id
    private String guid;
    @Column(insertable = false, updatable = false)
    private int wrs2path;
    @Column(insertable = false, updatable = false)
    private int wrs2row;
    @OneToOne(fetch = javax.persistence.FetchType.EAGER)
    @JoinColumns({
        @JoinColumn(name = "wrs2path", referencedColumnName = "wrs2path"),
        @JoinColumn(name = "wrs2row", referencedColumnName = "wrs2row")
    })
    private wrs2 wrs2;
    @Column(name = "capturedate")
    private Timestamp captureDate;
    @Column(name = "cloudcover")
    private double cloudCover;
    private String platform;
    private String location;    
    
    public Landsat() {}

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public int getWrs2path() {
        return wrs2path;
    }

    public void setWrs2path(int wrs2Path) {
        this.wrs2path = wrs2Path;
    }

    public int getWrs2row() {
        return wrs2row;
    }

    public void setWrs2row(int wrs2Row) {
        this.wrs2row = wrs2Row;
    }

    public wrs2 getWrs2() {
        return wrs2;
    }

    public void setWrs2(wrs2 wrs2) {
        this.wrs2 = wrs2;
    }

    public Timestamp getCaptureDate() {
        return captureDate;
    }

    public void setCaptureDate(Timestamp captureDate) {
        this.captureDate = captureDate;
    }

    public double getCloudCover() {
        return cloudCover;
    }

    public void setCloudCover(double cloudCover) {
        this.cloudCover = cloudCover;
    }    

//    public String getGeoJson() {
//        return geoJson;
//    }
//
//    public void setGeoJson(String geoJson) {
//        this.geoJson = geoJson;
//    }

    /**
     * @return the platform
     */
    public String getPlatform() {
        return platform;
    }

    /**
     * @param platform the platform to set
     */
    public void setPlatform(String platform) {
        this.platform = platform;
    }
    
    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }    
}
