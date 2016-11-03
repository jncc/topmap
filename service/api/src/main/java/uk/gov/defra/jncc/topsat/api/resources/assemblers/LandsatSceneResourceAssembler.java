package uk.gov.defra.jncc.topsat.api.resources.assemblers;

import java.text.SimpleDateFormat;
import org.springframework.hateoas.mvc.ResourceAssemblerSupport;
import org.springframework.stereotype.Component;
import uk.gov.defra.jncc.topsat.api.controllers.satellites.LandsatSceneController;
import uk.gov.defra.jncc.topsat.api.resources.landsat.LandsatSceneResource;
import uk.gov.defra.jncc.topsat.api.resources.landsat.Wrs2;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.Landsat;

/**
 *
 * @author Matt Debont
 */
@Component
public class LandsatSceneResourceAssembler extends ResourceAssemblerSupport<Landsat, LandsatSceneResource> {
    
    public LandsatSceneResourceAssembler() {
        super(LandsatSceneController.class, LandsatSceneResource.class);
    }
    
    @Override
    public LandsatSceneResource toResource(Landsat entity) {
        LandsatSceneResource resource = new LandsatSceneResource();
        resource.guid = entity.getGuid();
        resource.platform = entity.getPlatform();
        resource.captureDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(entity.getCaptureDate());
        resource.cloudCover = entity.getCloudCover();
        resource.wrs2 = new Wrs2(entity.getWrs2().getKey().getWrs2path(), 
                entity.getWrs2().getKey().getWrs2row(), 
                entity.getWrs2().getMode(), 
                entity.getWrs2().getArea(), 
                entity.getWrs2().getPerimeter(), 
                entity.getWrs2().getWrs2sequence(), 
                entity.getWrs2().getWkt(), 
                entity.getWrs2().getGeojson());
        resource.location = entity.getLocation();
        
        return resource;
    }   
}
