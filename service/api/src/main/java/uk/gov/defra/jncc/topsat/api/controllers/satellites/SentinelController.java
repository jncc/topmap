package uk.gov.defra.jncc.topsat.api.controllers.satellites;

import com.mysema.commons.lang.Pair;
import com.mysema.query.types.expr.BooleanExpression;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;
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
import uk.gov.defra.jncc.topsat.api.resources.sentinel.SentinelResource;
import uk.gov.defra.jncc.topsat.api.resources.assemblers.SentinelResourceAssembler;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.Sentinel;
import uk.gov.defra.jncc.topsat.crud.repository.satellites.SentinelRepository;
import uk.gov.defra.jncc.topsat.api.services.FileReader;
import uk.gov.defra.jncc.topsat.api.services.FileReaderResponse;
import uk.gov.defra.jncc.topsat.crud.predicate.builders.SentinelPredicateBuilder;
import uk.gov.defra.jncc.topsat.crud.predicate.parameters.SentinelParameters;

/**
 *
 * @author Felix Mason
 */
@RestController
@RequestMapping(path = "/sentinel", produces = MediaType.APPLICATION_JSON_VALUE)
@CrossOrigin
@Api(value = "/sentinel", description = "Retrieve scenes for sentinel satellites")
public class SentinelController {
    @Autowired SentinelRepository sentinelRepository;
    @Autowired SentinelResourceAssembler sentinelResourceAssembler;
//    @Autowired ApiConfiguration configuration;
    
    @ResponseBody
    @RequestMapping(method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all Sentinel scenes in a pageable manner", 
        response = SentinelResource.class, 
        responseContainer = "Page")
    public HttpEntity<PagedResources<SentinelResource>> getAll(Pageable pageable, PagedResourcesAssembler assembler) {
        Page<Sentinel> sentinalProducts = sentinelRepository.findAll(pageable);
        return new ResponseEntity<PagedResources<SentinelResource>>(assembler.toResource(sentinalProducts, sentinelResourceAssembler), HttpStatus.OK); 
    }
    
    @ResponseBody
    @RequestMapping(path = "/search", method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all Sentinel images in a given a set of parameters a pageable manner",
            response = SentinelResource.class,
            responseContainer = "Page")
    public HttpEntity<PagedResources<SentinelResource>> search(
            Pageable pageable, 
            PagedResourcesAssembler assembler, 
            @ApiParam(value = "A WKT bounding box defined in WGS84 (EPSG:4326)")
            @RequestParam(name = "wkt", required = false) String wkt, 
            @ApiParam(value = "The sentinel platform from which the product was generated")
            @RequestParam(name = "platform", required = false) String platform,
            @ApiParam(value = "The sentinel product type code")
            @RequestParam(name = "product", required = false) String product) throws ParseException 
        {
            SentinelParameters params = new SentinelParameters();
            params.BoundingBoxWkt = wkt;
            params.Platform = platform;
            params.Product = product;
            
            BooleanExpression criteria = SentinelPredicateBuilder.buildPredicates(params);
            
            if (criteria == null) 
            {
                return getAll(pageable, assembler);
            }
            
            Page<Sentinel> sentinalProducts = sentinelRepository.findAll(criteria, pageable);
            return new ResponseEntity<PagedResources<SentinelResource>>(assembler.toResource(sentinalProducts, sentinelResourceAssembler), HttpStatus.OK);
        }
    
    @ResponseBody
    @RequestMapping(value = "/download/{title}", method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves a sentinel producdt",
            response = HttpServletResponse.class,
            responseContainer = "Page")
    public void getFile(
        @PathVariable("title") String title, 
        HttpServletResponse response) {
        try {
            response.addHeader("content-disposition", "attachment; filename=" + title + ".zip");
            response.addHeader("content-type", "application/zip");
            FileReader fileReader = new FileReader();
            String path =  ApiConfiguration.getSentinalFilePath() + title + ".zip";
            FileReaderResponse fr = fileReader.Get(path);
            response.addHeader("content-length", String.valueOf(fr.fileSize));
            InputStream fileStream = fr.fileStream;
            IOUtils.copy(fileStream, response.getOutputStream());
            response.flushBuffer();
        } catch (IOException ex) {
            // log.info("Error writing file to output stream. Filename was '{}'", fileName, ex);
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
        
        result.add(new ParameterValueList("platform", sentinelRepository.getAllPlatforms()));
        result.add(new ParameterValueList("product", sentinelRepository.getAllProductTypes()));
        
        return new HttpEntity<>(result);
    }
    
    
}