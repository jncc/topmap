package uk.gov.defra.jncc.topsat.crud.entity.composites;

import static com.mysema.query.types.PathMetadataFactory.*;

import com.mysema.query.types.path.*;

import com.mysema.query.types.PathMetadata;
import javax.annotation.Generated;
import com.mysema.query.types.Path;


/**
 * QPathRowKey is a Querydsl query type for PathRowKey
 */
@Generated("com.mysema.query.codegen.EmbeddableSerializer")
public class QPathRowKey extends BeanPath<PathRowKey> {

    private static final long serialVersionUID = -29978196L;

    public static final QPathRowKey pathRowKey = new QPathRowKey("pathRowKey");

    public final NumberPath<Integer> wrs2path = createNumber("wrs2path", Integer.class);

    public final NumberPath<Integer> wrs2row = createNumber("wrs2row", Integer.class);

    public QPathRowKey(String variable) {
        super(PathRowKey.class, forVariable(variable));
    }

    public QPathRowKey(Path<? extends PathRowKey> path) {
        super(path.getType(), path.getMetadata());
    }

    public QPathRowKey(PathMetadata<?> metadata) {
        super(PathRowKey.class, metadata);
    }

}

