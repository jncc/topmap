/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.resources.assemblers;

import org.springframework.hateoas.mvc.ResourceAssemblerSupport;
import org.springframework.stereotype.Component;
import uk.gov.defra.jncc.topsat.api.controllers.satellites.SentinelController;
import uk.gov.defra.jncc.topsat.api.resources.sentinel.SentinelResource;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.Sentinel;

/**
 *
 * @author felix
 */
@Component
public class SentinelResourceAssembler extends ResourceAssemblerSupport<Sentinel, SentinelResource> {

    public SentinelResourceAssembler() {
        super(SentinelController.class, SentinelResource.class);
    }
    
    @Override
    public SentinelResource toResource(Sentinel t) {
        SentinelResource resource = new SentinelResource();
        
        resource.uniqueId = t.getUniqueid();
        resource.Centroid = t.getCentroid();
        resource.available = t.isAvailable();
        resource.beginPosition = t.getBeginPosition();
        resource.downloaded = t.isDownloaded();
        resource.endPosition = t.getEndPosition();
        resource.footprint = t.getFootprint();
        resource.ingestionDate = t.getIngestionDate();
        resource.orbitDirection = t.getOrbitDirection();
        resource.orbitNo = t.getOrbitNo();
        resource.platform = t.getPlatform();
        resource.polygonIndex = t.getPolygonIndex();
        resource.productType = t.getProductType();
        resource.relOrbitNo = t.getRelOrbitNo();
        resource.title = t.getTitle();
        
        return resource;
    }
    
}
