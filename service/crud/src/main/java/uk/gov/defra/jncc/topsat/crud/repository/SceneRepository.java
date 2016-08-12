package uk.gov.defra.jncc.topsat.crud.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import uk.gov.defra.jncc.topsat.crud.entity.Scene;


/**
 *
 * @author Matt Debont
 */
@Repository
@Transactional(readOnly = true)
public interface SceneRepository extends PagingAndSortingRepository<Scene, Long> {

    @Query 
    Page<Scene> findByGuidOrderByCaptureDateDesc(@Param("guid") String guid, Pageable pageable);
}
