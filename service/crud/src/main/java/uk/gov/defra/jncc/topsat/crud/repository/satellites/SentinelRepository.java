
package uk.gov.defra.jncc.topsat.crud.repository.satellites;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import uk.gov.defra.jncc.topsat.crud.entity.satellites.Sentinel;

public interface SentinelRepository extends PagingAndSortingRepository <Sentinel, Serializable>, QueryDslPredicateExecutor<Sentinel> 
{
    @Query("SELECT DISTINCT s.platform FROM Sentinel s ORDER BY s.platform")
    public List<String> getAllPlatforms();
    
    @Query("SELECT DISTINCT s.productType FROM Sentinel s ORDER BY s.productType")
    public List<String> getAllProductTypes();
}

