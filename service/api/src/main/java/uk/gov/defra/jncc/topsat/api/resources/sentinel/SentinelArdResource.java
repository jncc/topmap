package uk.gov.defra.jncc.topsat.api.resources.sentinel;

import java.util.Date;
import org.springframework.hateoas.ResourceSupport;
import java.util.UUID;


/**
 *
 * @author felix
 */
public class SentinelArdResource extends ResourceSupport {
    public UUID uniqueId;
    public String name;
    public String srcTitle;
    public Date date;
    public String footprint;
    public String location;
}
