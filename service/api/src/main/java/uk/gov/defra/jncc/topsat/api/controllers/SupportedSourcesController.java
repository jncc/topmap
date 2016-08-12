package uk.gov.defra.jncc.topsat.api.controllers;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import java.util.List;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import uk.gov.defra.jncc.topsat.api.resources.Source;

/**
 *
 * @author Matt Debont
 */
@RestController
@CrossOrigin
@RequestMapping(path = "/sources", produces = MediaType.APPLICATION_JSON_VALUE)
@Api(value = "/sources", description = "Retrieve all source data types")
public class SupportedSourcesController {
    
    @ResponseBody
    @RequestMapping(method = RequestMethod.GET)
    @ApiOperation(value = "Retrieves all Landsat scenes in a pageable manner", 
        response = Source.class, 
        responseContainer = "List")
    public HttpEntity<List<Source>> getAllSourceTypes() {
        
        return null;
    }
}
