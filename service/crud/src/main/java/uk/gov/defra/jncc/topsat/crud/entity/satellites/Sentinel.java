package uk.gov.defra.jncc.topsat.crud.entity.satellites;

import com.vividsolutions.jts.geom.Geometry;
import java.io.Serializable;
import java.sql.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.UUID;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

/**
 *
 * @author Felix Mason
 */
@Entity
@Table(name = "sentinelview")
public class Sentinel implements Serializable {
    public static final String URI = "sentinel";
    public static final String NAME = "Sentinel";
    
    @Id
    @org.hibernate.annotations.Type(type="pg-uuid")
    @Column(name="uniqueid")
    private UUID uniqueid;
    @Column(name="polygonindex")
    private int polygonIndex;
    private String title;
    @Column(name="ingestiondate")
    private Date ingestionDate;
    @Column(name="beginposition")
    private String beginPosition;
    @Column(name="endposition")
    private String endPosition;
    @Column(name="orbitdirection")
    private String orbitDirection;
    @Column(name="producttype")
    private String productType;
    @Column(name="orbitno")
    private int orbitNo;
    @Column(name="relorbitno")
    private int relOrbitNo;
    private String platform;
    private String footprint;
    private String centroid;
    @Column(columnDefinition = "geometry(Polygon,4326)")
    @Type(type = "org.hibernate.spatial.GeometryType")
    private Geometry footprintGeom;
    private String location;

    /**
     * @return the uniqueId
     */
    public UUID getUniqueid() {
        return uniqueid;
    }

    /**
     * @param uniqueId the uniqueId to set
     */
    public void setUniqueid(UUID uniqueId) {
        this.uniqueid = uniqueId;
    }

    /**
     * @return the polygonIndex
     */
    public int getPolygonIndex() {
        return polygonIndex;
    }

    /**
     * @param polygonIndex the polygonIndex to set
     */
    public void setPolygonIndex(int polygonIndex) {
        this.polygonIndex = polygonIndex;
    }

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the ingestionDate
     */
    public Date getIngestionDate() {
        return ingestionDate;
    }

    /**
     * @param ingestionDate the ingestionDate to set
     */
    public void setIngestionDate(Date ingestionDate) {
        this.ingestionDate = ingestionDate;
    }

    /**
     * @return the beginPostion
     */
    
    public String getBeginPosition() {
        return beginPosition;
    }

    /**
     * @param beginPostion the beginPostion to set
     */
    public void setBeginPosition(String beginPostion) {
        this.beginPosition = beginPostion;
    }

    /**
     * @return the endPostion
     */
    
    public String getEndPosition() {
        return endPosition;
    }

    /**
     * @param endPostion the endPostion to set
     */
    public void setEndPosition(String endPostion) {
        this.endPosition = endPostion;
    }

    /**
     * @return the orbitDirection
     */
    public String getOrbitDirection() {
        return orbitDirection;
    }

    /**
     * @param orbitDirection the orbitDirection to set
     */
    public void setOrbitDirection(String orbitDirection) {
        this.orbitDirection = orbitDirection;
    }

    /**
     * @return the productType
     */
    public String getProductType() {
        return productType;
    }

    /**
     * @param productType the productType to set
     */
    public void setProductType(String productType) {
        this.productType = productType;
    }

    /**
     * @return the orbitNo
     */
    public int getOrbitNo() {
        return orbitNo;
    }

    /**
     * @param orbitNo the orbitNo to set
     */
    public void setOrbitNo(int orbitNo) {
        this.orbitNo = orbitNo;
    }

    /**
     * @return the relOrbitNo
     */
    public int getRelOrbitNo() {
        return relOrbitNo;
    }

    /**
     * @param relOrbitNo the relOrbitNo to set
     */
    public void setRelOrbitNo(int relOrbitNo) {
        this.relOrbitNo = relOrbitNo;
    }

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


    /**
     * @return the footprint
     */
    public String getFootprint() {
        return footprint;
    }

    /**
     * @param footprint the footprint to set
     */
    public void setFootprint(String footprint) {
        this.footprint = footprint;
    }

    /**
     * @return the Centroid
     */
    public String getCentroid() {
        return centroid;
    }

    /**
     * @param Centroid the Centroid to set
     */
    public void setCentroid(String Centroid) {
        this.centroid = Centroid;
    }

    /**
     * @return the footprintGeom
     */
    public Geometry getFootprintGeom() {
        return footprintGeom;
    }

    /**
     * @param footprintGeom the footprintGeom to set
     */
    public void setFootprintGeom(Geometry footprintGeom) {
        this.footprintGeom = footprintGeom;
    }

    /**
     * @return the location
     */
    public String getLocation() {
        return location;
    }

    /**
     * @param location the location to set
     */
    public void setLocation(String location) {
        this.location = location;
    }
}
