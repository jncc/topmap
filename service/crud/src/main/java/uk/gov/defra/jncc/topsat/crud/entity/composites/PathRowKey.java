package uk.gov.defra.jncc.topsat.crud.entity.composites;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 *
 * @author Matt Debont
 */
@Embeddable
public class PathRowKey implements Serializable {
    @Column(name="wrs2path", nullable = false)
    private int wrs2path;
    @Column(name="wrs2row", nullable = false)
    private int wrs2row;

    public int getWrs2path() {
        return wrs2path;
    }

    public void setWrs2path(int wrs2path) {
        this.wrs2path = wrs2path;
    }

    public int getWrs2row() {
        return wrs2row;
    }

    public void setWrs2row(int wrs2row) {
        this.wrs2row = wrs2row;
    }
}
