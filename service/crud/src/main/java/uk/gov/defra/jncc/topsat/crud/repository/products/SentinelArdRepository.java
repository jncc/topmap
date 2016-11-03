package uk.gov.defra.jncc.topsat.crud.repository.products;

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
import uk.gov.defra.jncc.topsat.crud.entity.products.SentinelArd;

public interface SentinelArdRepository extends PagingAndSortingRepository <SentinelArd, Serializable>, QueryDslPredicateExecutor<SentinelArd> { 

}
