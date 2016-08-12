package uk.gov.defra.jncc.topsat.crud.repository.satellites;

import java.io.Serializable;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import uk.gov.defra.jncc.topsat.crud.entity.satellites.Landsat;

/**
 *
 * @author Matt Debont
 */
//@Repository
//public interface LandsatRepository extends PagingAndSortingRepository<Landsat, Serializable>{
//    
////    @Query(value = "SELECT l FROM Landsat l "
////            + "INNER JOIN wrs2 w WHERE l.wrs2path = w.wrs2path AND l.wrs2row = w.wrs2row "
////            + "AND ST_Intersects(w.wkb_boundary, ST_GeomFromText(:wkt, 4326))", nativeQuery = true)
//    @Query(value = "SELECT l FROM Landsat l "
//            + "INNER JOIN l.wrs2 w WHERE l.wrs2path = w.key.wrs2path AND l.wrs2row = w.key.wrs2row "
//            + "AND ST_Intersects(w.wkb_geometry, ST_GeomFromText(:wkt, 4326)) = TRUE")            
//    Page<Landsat> findLandsatByWKT(@Param("wkt") String wkt, Pageable pageable);
//}

@Repository
public interface LandsatRepository extends PagingAndSortingRepository<Landsat, Serializable>, QueryDslPredicateExecutor<Landsat>
{
    @Query("SELECT DISTINCT l.platform FROM Landsat l ORDER BY l.platform")
    public List<String> getAllPlatforms();
}