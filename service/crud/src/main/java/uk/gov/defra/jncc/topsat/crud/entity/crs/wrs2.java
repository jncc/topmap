package uk.gov.defra.jncc.topsat.crud.entity.crs;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.vividsolutions.jts.geom.Geometry;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import org.hibernate.annotations.Type;
import uk.gov.defra.jncc.topsat.crud.entity.composites.PathRowKey;
/**
 *
 * @author Matt Debont
 */
@Entity
public class wrs2 implements Serializable {
    @EmbeddedId
    private PathRowKey key;
    private String mode;
    private double area;
    private double perimeter;
    private int wrs2sequence;
    @Column(columnDefinition = "geometry(MultiPolygon,4326)")
    @Type(type = "org.hibernate.spatial.GeometryType")
    private Geometry wkb_geometry;
    private String wkt;
    private String geojson;

    public PathRowKey getKey() {
        return key;
    }

    public void setKey(PathRowKey key) {
        this.key = key;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
    }

    public double getPerimeter() {
        return perimeter;
    }

    public void setPeremiter(double perimiter) {
        this.perimeter = perimiter;
    }

    public int getWrs2sequence() {
        return wrs2sequence;
    }

    public void setWrs2sequence(int wrs2sequence) {
        this.wrs2sequence = wrs2sequence;
    }    

    public Geometry getWkb_geometry() {
        return wkb_geometry;
    }

    public void setWkb_geometry(Geometry wkb_geometry) {
        this.wkb_geometry = wkb_geometry;
    }

    public String getWkt() {
        return wkt;
    }

    public void setWkt(String wkt) {
        this.wkt = wkt;
    }

    public String getGeojson() {
        return geojson;
    }

    public void setGeojson(String geojson) {
        this.geojson = geojson;
    }
}
