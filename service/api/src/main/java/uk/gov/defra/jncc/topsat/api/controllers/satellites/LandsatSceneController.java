package uk.gov.defra.jncc.topsat.api.controllers.satellites;

import com.mysema.query.types.expr.BooleanExpression;
import com.vividsolutions.jts.io.ParseException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.PagedResources;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import uk.gov.defra.jncc.topsat.api.configuration.ApiConfiguration;
import uk.gov.defra.jncc.topsat.api.resources.ParameterValueList;
import uk.gov.defra.jncc.topsat.api.resources.landsat.LandsatSceneResource;
import uk.gov.defra.jncc.topsat.api.resources.assemblers.LandsatSceneResourceAssembler;
import uk.gov.defra.jncc.topsat.api.resources.sentinel.SentinelResource;
import uk.gov.defra.jncc.topsat.api.services.FileReader;
import uk.gov.defra.jncc.topsat.api.services.FileReaderResponse;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.Landsat;
import uk.gov.defra.jncc.topsat.crud.predicate.builders.LandsatPredicateBuilder;
import uk.gov.defra.jncc.topsat.crud.predicate.parameters.LandsatParameters;
import uk.gov.defra.jncc.topsat.crud.repository.satellites.LandsatRepository;

/**
 *
 * @author Matt Debont
 */
@RestController
@RequestMapping(path = "/landsat", produces = MediaType.APPLICATION_JSON_VALUE)
@CrossOrigin
@Api(value = "/landsat", description = "Retrieve scenes for landsat satellites")
public class LandsatSceneController {
    @Autowired LandsatRepository landsatRepository;
    @Autowired LandsatSceneResourceAssembler landsatSceneResourceAssembler;
    
    @ResponseBody
    @RequestMapping(method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all Landsat scenes in a pageable manner", 
        response = LandsatSceneResource.class, 
        responseContainer = "Page")
    public HttpEntity<PagedResources<LandsatSceneResource>> getAll(Pageable pageable, PagedResourcesAssembler assembler) {
        Page<Landsat> landsatScenes = landsatRepository.findAll(pageable);
        return new ResponseEntity<PagedResources<LandsatSceneResource>>(assembler.toResource(landsatScenes, landsatSceneResourceAssembler), HttpStatus.OK); 
    }
    
    @ResponseBody
    @RequestMapping(path = "/search", method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all Landsat images in a given search area in a pageable manner",
            response = LandsatSceneResource.class,
            responseContainer = "Page")
    public HttpEntity<PagedResources<LandsatSceneResource>> search(
            Pageable pageable, 
            PagedResourcesAssembler assembler, 
            @ApiParam(value = "A WKT bounding box defined in WGS84 (EPSG:4326)")
            @RequestParam(name = "wkt", required = false) String wkt,
            @ApiParam(value = "The landsat platform")
            @RequestParam(name = "platform", required = false) String platform) throws ParseException {
        LandsatParameters params = new LandsatParameters();
        params.BoundingBoxWkt = wkt;
        params.Platform = platform;
        
        BooleanExpression criteria = LandsatPredicateBuilder.buildPredicates(params);
        
        if (criteria == null) {
            return getAll(pageable, assembler);
        }
        
        Page<Landsat> landsatScenes = landsatRepository.findAll(criteria, pageable);
        return new ResponseEntity<PagedResources<LandsatSceneResource>>(assembler.toResource(landsatScenes, landsatSceneResourceAssembler), HttpStatus.OK);
    }
    
    @ResponseBody
    @RequestMapping(value = "/download/{guid}", method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves a sentinel producdt",
            response = SentinelResource.class,
            responseContainer = "Page")
    public void getFile(
        @PathVariable("guid") String guid, 
        HttpServletResponse response) {
        try {
            response.addHeader("content-disposition", "attachment; filename=" + guid + ".tar.gz");
            response.addHeader("content-type", "application/x-compressed");
            
            FileReader fileReader = new FileReader();
            String path =  ApiConfiguration.getLandsatFilePath() + guid + ".tar.gz";
            
            FileReaderResponse fr = fileReader.Get(path);
            response.addHeader("content-length", String.valueOf(fr.fileSize));
            InputStream fileStream = fr.fileStream;
            IOUtils.copy(fileStream, response.getOutputStream());
            response.flushBuffer();
        } catch (IOException ex) {            
            throw new RuntimeException("IOError writing file to output stream");
        }
    }
    
    @ResponseBody
    @RequestMapping(path = "/parameters", method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all possible values for api parameter lists",
            response = SentinelResource.class,
            responseContainer = "Page")
    public HttpEntity<List<ParameterValueList>> getParameters ()
    {
        List<ParameterValueList> result = new ArrayList<>();
        
        result.add(new ParameterValueList("platform", landsatRepository.getAllPlatforms()));
        
        return new HttpEntity<>(result);
    }
}
