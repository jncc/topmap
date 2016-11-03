package uk.gov.defra.jncc.topsat.api.resources.landsat;

import org.springframework.hateoas.ResourceSupport;

/**
 *
 * @author Matt Debont
 */
public class LandsatSceneResource extends ResourceSupport {
    public String guid;
    public String platform;
    public Wrs2 wrs2;
    public String captureDate;
    public double cloudCover;
    public String location;
}
