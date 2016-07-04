package uk.gov.defra.jncc.topsat.api.resources.landsat;

import uk.gov.defra.jncc.topsat.crud.entity.crs.wrs2;

/**
 *
 * @author Matt Debont
 */
public class Wrs2 {
    public int path;
    public int row;
    public String mode;
    public double area;
    public double perimeter;
    public int sequence;
    public String wkt;
    public String geoJson;

    public Wrs2(int path, int row, String mode, double area, double perimeter, int sequence, String wkt, String geoJson) {
        this.path = path;
        this.row = row;
        this.mode = mode;
        this.area = area;
        this.perimeter = perimeter;
        this.sequence = sequence;
        this.wkt = wkt;
        this.geoJson = geoJson;
    }
    
    public Wrs2(wrs2 input) {
        this.path = input.getKey().getWrs2path();
        this.row = input.getKey().getWrs2row();
        this.mode = input.getMode();
        this.area = input.getArea();
        this.perimeter = input.getPerimeter();
        this.sequence = input.getWrs2sequence();
        this.wkt = input.getWkt();
        this.geoJson = input.getGeojson();
    }
}
