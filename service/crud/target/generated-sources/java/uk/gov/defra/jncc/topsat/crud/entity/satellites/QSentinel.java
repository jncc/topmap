package uk.gov.defra.jncc.topsat.crud.entity.satellites;

import static com.mysema.query.types.PathMetadataFactory.*;

import com.mysema.query.types.path.*;

import com.mysema.query.types.PathMetadata;
import javax.annotation.Generated;
import com.mysema.query.types.Path;


/**
 * QSentinel is a Querydsl query type for Sentinel
 */
@Generated("com.mysema.query.codegen.EntitySerializer")
public class QSentinel extends EntityPathBase<Sentinel> {

    private static final long serialVersionUID = -1231040166L;

    public static final QSentinel sentinel = new QSentinel("sentinel");

    public final BooleanPath available = createBoolean("available");

    public final StringPath beginPosition = createString("beginPosition");

    public final StringPath centroid = createString("centroid");

    public final BooleanPath downloaded = createBoolean("downloaded");

    public final StringPath endPosition = createString("endPosition");

    public final StringPath footprint = createString("footprint");

    // custom
    public final com.mysema.query.spatial.jts.path.JTSGeometryPath footprintGeom = new com.mysema.query.spatial.jts.path.JTSGeometryPath(forProperty("footprintGeom"));

    public final DatePath<java.sql.Date> ingestionDate = createDate("ingestionDate", java.sql.Date.class);

    public final StringPath orbitDirection = createString("orbitDirection");

    public final NumberPath<Integer> orbitNo = createNumber("orbitNo", Integer.class);

    public final StringPath platform = createString("platform");

    public final NumberPath<Integer> polygonIndex = createNumber("polygonIndex", Integer.class);

    public final StringPath productType = createString("productType");

    public final NumberPath<Integer> relOrbitNo = createNumber("relOrbitNo", Integer.class);

    public final StringPath title = createString("title");

    public final ComparablePath<java.util.UUID> uniqueid = createComparable("uniqueid", java.util.UUID.class);

    public QSentinel(String variable) {
        super(Sentinel.class, forVariable(variable));
    }

    public QSentinel(Path<? extends Sentinel> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSentinel(PathMetadata<?> metadata) {
        super(Sentinel.class, metadata);
    }

}

