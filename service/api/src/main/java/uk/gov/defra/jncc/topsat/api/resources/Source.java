package uk.gov.defra.jncc.topsat.api.resources;

import org.springframework.hateoas.ResourceSupport;

/**
 *
 * @author Matt Debont
 */
public class Source extends ResourceSupport {
    public String uri;
    public String type;
}
