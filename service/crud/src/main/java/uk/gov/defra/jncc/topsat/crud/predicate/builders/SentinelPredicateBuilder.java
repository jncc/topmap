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
import uk.gov.defra.jncc.topsat.crud.entity.satellites.QSentinel;
import uk.gov.defra.jncc.topsat.crud.predicate.parameters.SentinelParameters;

/**
 *
 * @author felix
 */
public class SentinelPredicateBuilder {
    public static BooleanExpression buildPredicates(SentinelParameters params) throws ParseException {
        QSentinel sentinel = QSentinel.sentinel;
        
        List<BooleanExpression> predicates = new ArrayList<BooleanExpression>();
        
        if (params.BoundingBoxWkt != null && !params.BoundingBoxWkt.isEmpty())
        {
            WKTReader fromText = new WKTReader();
            Geometry boundingBox = fromText.read(params.BoundingBoxWkt);
            boundingBox.setSRID(4326);
            predicates.add(sentinel.footprintGeom.intersects(boundingBox));   
        }
        
        if (params.Platform != null && !params.Platform.isEmpty())
        {
            predicates.add(sentinel.platform.equalsIgnoreCase(params.Platform));
        }

        if (params.Product != null && !params.Product.isEmpty())
        {
            predicates.add(sentinel.productType.equalsIgnoreCase(params.Product));
        }
        
        return PredicateBuilderHelper.assemblePredicates(predicates);
    }
}
