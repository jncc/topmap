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
import uk.gov.defra.jncc.topsat.crud.entity.products.QSentinelArd;
import uk.gov.defra.jncc.topsat.crud.predicate.parameters.SentinelParameters;


public class SentinelArdPredicateBuilder {
        public static BooleanExpression buildPredicates(SentinelParameters params) throws ParseException {
        QSentinelArd sard = QSentinelArd.sentinelArd;
        
        List<BooleanExpression> predicates = new ArrayList<BooleanExpression>();
        
        if (params.BoundingBoxWkt != null && !params.BoundingBoxWkt.isEmpty())
        {
            WKTReader fromText = new WKTReader();
            Geometry boundingBox = fromText.read(params.BoundingBoxWkt);
            boundingBox.setSRID(4326);
            predicates.add(sard.footprintGeom.intersects(boundingBox));   
        }
        
        return PredicateBuilderHelper.assemblePredicates(predicates);
    }
}

