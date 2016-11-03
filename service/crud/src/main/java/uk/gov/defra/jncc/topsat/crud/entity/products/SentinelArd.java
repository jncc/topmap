package uk.gov.defra.jncc.topsat.crud.entity.products;

import com.vividsolutions.jts.geom.Geometry;
import java.io.Serializable;
import java.sql.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.UUID;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

@Entity
@Table(name = "sentinelardview")
public class SentinelArd implements Serializable {
    public static final String URI = "sentinelard";
    public static final String NAME = "SentinelArd";
    
    @Id
    @org.hibernate.annotations.Type(type="pg-uuid")
    @Column(name="uniqueid")
    private UUID uniqueid;
    private String name;
    private String srcTitle;
    private Date date;
    private String location;
    private String footprint;
    
    @Column(columnDefinition = "geometry(Polygon,4326)")
    @Type(type = "org.hibernate.spatial.GeometryType")
    private Geometry footprintGeom;

    /**
     * @return the uniqueid
     */
    public UUID getUniqueid() {
        return uniqueid;
    }

    /**
     * @param uniqueid the uniqueid to set
     */
    public void setUniqueid(UUID uniqueid) {
        this.uniqueid = uniqueid;
    }

    /**
     * @return the srcTitle
     */
    public String getSrcTitle() {
        return srcTitle;
    }

    /**
     * @param srcTitle the srcTitle to set
     */
    public void setSrcTitle(String srcTitle) {
        this.srcTitle = srcTitle;
    }

    /**
     * @return the date
     */
    public Date getDate() {
        return date;
    }

    /**
     * @param date the date to set
     */
    public void setDate(Date date) {
        this.date = date;
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
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

   
}
