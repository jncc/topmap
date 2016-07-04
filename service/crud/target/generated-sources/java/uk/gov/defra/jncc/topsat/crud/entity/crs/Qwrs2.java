package uk.gov.defra.jncc.topsat.crud.entity.crs;

import static com.mysema.query.types.PathMetadataFactory.*;

import com.mysema.query.types.path.*;

import com.mysema.query.types.PathMetadata;
import javax.annotation.Generated;
import com.mysema.query.types.Path;
import com.mysema.query.types.path.PathInits;


/**
 * Qwrs2 is a Querydsl query type for wrs2
 */
@Generated("com.mysema.query.codegen.EntitySerializer")
public class Qwrs2 extends EntityPathBase<wrs2> {

    private static final long serialVersionUID = 438034820L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final Qwrs2 wrs2 = new Qwrs2("wrs2");

    public final NumberPath<Double> area = createNumber("area", Double.class);

    public final StringPath geojson = createString("geojson");

    public final uk.gov.defra.jncc.topsat.crud.entity.composites.QPathRowKey key;

    public final StringPath mode = createString("mode");

    public final NumberPath<Double> perimeter = createNumber("perimeter", Double.class);

    // custom
    public final com.mysema.query.spatial.jts.path.JTSGeometryPath wkb_geometry = new com.mysema.query.spatial.jts.path.JTSGeometryPath(forProperty("wkb_geometry"));

    public final StringPath wkt = createString("wkt");

    public final NumberPath<Integer> wrs2sequence = createNumber("wrs2sequence", Integer.class);

    public Qwrs2(String variable) {
        this(wrs2.class, forVariable(variable), INITS);
    }

    public Qwrs2(Path<? extends wrs2> path) {
        this(path.getType(), path.getMetadata(), path.getMetadata().isRoot() ? INITS : PathInits.DEFAULT);
    }

    public Qwrs2(PathMetadata<?> metadata) {
        this(metadata, metadata.isRoot() ? INITS : PathInits.DEFAULT);
    }

    public Qwrs2(PathMetadata<?> metadata, PathInits inits) {
        this(wrs2.class, metadata, inits);
    }

    public Qwrs2(Class<? extends wrs2> type, PathMetadata<?> metadata, PathInits inits) {
        super(type, metadata, inits);
        this.key = inits.isInitialized("key") ? new uk.gov.defra.jncc.topsat.crud.entity.composites.QPathRowKey(forProperty("key")) : null;
    }

}

