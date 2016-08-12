package uk.gov.defra.jncc.topsat.api;

import java.util.List;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.context.annotation.Profile;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.SqlGroup;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import uk.gov.defra.jncc.topsat.crud.entity.Scene;
import uk.gov.defra.jncc.topsat.crud.repository.SceneRepository;

@Profile("test")
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = TestApiApplication.class)
public class ApiApplicationTests {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private SceneRepository sceneRepository;

    @Test
    @SqlGroup({
        @Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD, scripts = "classpath:sql/beforeTestRun.sql"),
        @Sql(executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD, scripts = "classpath:sql/afterTestRun.sql")
    })
    public void contextLoads() {
        Iterable<Scene> scenes = sceneRepository.findAll();
        String selectQuery = "SELECT * from PERSON WHERE PERSONID = 1";

        List<Map<String, Object>> resultSet = jdbcTemplate
                .queryForList(selectQuery);

        System.out.println(resultSet);
    }
}
