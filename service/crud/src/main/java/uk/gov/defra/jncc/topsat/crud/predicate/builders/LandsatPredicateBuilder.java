/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.crud.predicate.builders;

import com.mysema.query.types.expr.BooleanExpression;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;
import java.util.ArrayList;
import java.util.List;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.QLandsat;
import uk.gov.defra.jncc.topsat.crud.predicate.parameters.LandsatParameters;

/**
 *
 * @author felix
 */
public class LandsatPredicateBuilder {
    public static BooleanExpression buildPredicates(LandsatParameters params) throws ParseException
    {
        QLandsat landsat = QLandsat.landsat;
        
        List<BooleanExpression> predicates = new ArrayList<BooleanExpression>();
        
        if (params.BoundingBoxWkt != null && !params.BoundingBoxWkt.isEmpty())
        {
            WKTReader fromText = new WKTReader();
            Geometry boundingBox = fromText.read(params.BoundingBoxWkt);
            boundingBox.setSRID(4326);
            predicates.add(landsat.wrs2.wkb_geometry.intersects(boundingBox));   
        }
        
        if (params.Platform != null && !params.Platform.isEmpty())
        {
            predicates.add(landsat.platform.equalsIgnoreCase(params.Platform));
        }
        
        return PredicateBuilderHelper.assemblePredicates(predicates);
    }
}
