package uk.gov.defra.jncc.topsat.crud.entity.satellites;

import static com.mysema.query.types.PathMetadataFactory.*;

import com.mysema.query.types.path.*;

import com.mysema.query.types.PathMetadata;
import javax.annotation.Generated;
import com.mysema.query.types.Path;
import com.mysema.query.types.path.PathInits;


/**
 * QLandsat is a Querydsl query type for Landsat
 */
@Generated("com.mysema.query.codegen.EntitySerializer")
public class QLandsat extends EntityPathBase<Landsat> {

    private static final long serialVersionUID = 698693157L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QLandsat landsat = new QLandsat("landsat");

    public final DateTimePath<java.sql.Timestamp> captureDate = createDateTime("captureDate", java.sql.Timestamp.class);

    public final NumberPath<Double> cloudCover = createNumber("cloudCover", Double.class);

    public final StringPath guid = createString("guid");

    public final StringPath platform = createString("platform");

    public final uk.gov.defra.jncc.topsat.crud.entity.crs.Qwrs2 wrs2;

    public final NumberPath<Integer> wrs2path = createNumber("wrs2path", Integer.class);

    public final NumberPath<Integer> wrs2row = createNumber("wrs2row", Integer.class);

    public QLandsat(String variable) {
        this(Landsat.class, forVariable(variable), INITS);
    }

    public QLandsat(Path<? extends Landsat> path) {
        this(path.getType(), path.getMetadata(), path.getMetadata().isRoot() ? INITS : PathInits.DEFAULT);
    }

    public QLandsat(PathMetadata<?> metadata) {
        this(metadata, metadata.isRoot() ? INITS : PathInits.DEFAULT);
    }

    public QLandsat(PathMetadata<?> metadata, PathInits inits) {
        this(Landsat.class, metadata, inits);
    }

    public QLandsat(Class<? extends Landsat> type, PathMetadata<?> metadata, PathInits inits) {
        super(type, metadata, inits);
        this.wrs2 = inits.isInitialized("wrs2") ? new uk.gov.defra.jncc.topsat.crud.entity.crs.Qwrs2(forProperty("wrs2"), inits.get("wrs2")) : null;
    }

}

