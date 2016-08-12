package uk.gov.defra.jncc.topsat.api.resources;

import java.util.Date;
import org.springframework.hateoas.ResourceSupport;

/**
 *
 * @author Matt Debont
 */
public class SceneResource extends ResourceSupport {
    // ID String
    public String guid;
    // Scene Metadata
    public Date captureDate;
    public float cloudcover;
    // Location Data
    public int wrs2Path;
    public int wrs2Row;
    public String bbox;
    
    public String downloadUrl;
}
