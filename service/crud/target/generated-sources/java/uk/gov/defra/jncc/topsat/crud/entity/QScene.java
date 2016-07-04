package uk.gov.defra.jncc.topsat.crud.entity;

import static com.mysema.query.types.PathMetadataFactory.*;

import com.mysema.query.types.path.*;

import com.mysema.query.types.PathMetadata;
import javax.annotation.Generated;
import com.mysema.query.types.Path;


/**
 * QScene is a Querydsl query type for Scene
 */
@Generated("com.mysema.query.codegen.EntitySerializer")
public class QScene extends EntityPathBase<Scene> {

    private static final long serialVersionUID = 141348588L;

    public static final QScene scene = new QScene("scene");

    public final StringPath bbox = createString("bbox");

    public final DatePath<java.util.Date> captureDate = createDate("captureDate", java.util.Date.class);

    public final NumberPath<Float> cloudCover = createNumber("cloudCover", Float.class);

    public final StringPath guid = createString("guid");

    public final StringPath source = createString("source");

    public QScene(String variable) {
        super(Scene.class, forVariable(variable));
    }

    public QScene(Path<? extends Scene> path) {
        super(path.getType(), path.getMetadata());
    }

    public QScene(PathMetadata<?> metadata) {
        super(Scene.class, metadata);
    }

}

