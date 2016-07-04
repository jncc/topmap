/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.resources.sentinel;

import java.util.Date;
import org.springframework.hateoas.ResourceSupport;
import java.util.UUID;

/**
 *
 * @author felix
 */
public class SentinelResource extends ResourceSupport {
    public UUID uniqueId;
    public int polygonIndex;
    public String title;
    public Date ingestionDate;
    public String beginPosition;
    public String endPosition;
    public String orbitDirection;
    public String productType;
    public int orbitNo;
    public int relOrbitNo;
    public String platform;
    public boolean available;
    public boolean downloaded;
    public String footprint;
    public String Centroid;
}
