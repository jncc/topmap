/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.resources.assemblers;

import org.springframework.hateoas.mvc.ResourceAssemblerSupport;
import uk.gov.defra.jncc.topsat.api.controllers.satellites.SentinelController;
import uk.gov.defra.jncc.topsat.api.resources.sentinel.SentinelArdResource;
import uk.gov.defra.jncc.topsat.crud.entity.products.SentinelArd;


public class SentinelArdResourceAssembler extends ResourceAssemblerSupport<SentinelArd, SentinelArdResource>  {
    public SentinelArdResourceAssembler() {
        super(SentinelController.class, SentinelArdResource.class);
    }
    
    @Override
    public SentinelArdResource toResource(SentinelArd t) {
        SentinelArdResource resource = new SentinelArdResource();
        
        resource.uniqueId = t.getUniqueid();
        resource.name = t.getName();
        resource.date = t.getDate();
        resource.srcTitle = t.getSrcTitle();
        resource.footprint = t.getFootprint();
        resource.location = t.getLocation();
        
        return resource;
    }
}
