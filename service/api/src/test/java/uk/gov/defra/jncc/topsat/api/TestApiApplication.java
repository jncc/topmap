package uk.gov.defra.jncc.topsat.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.boot.orm.jpa.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

/**
 *
 * @author Matt Debont
 */
@SpringBootApplication
@EntityScan(basePackages = {"uk.gov.defra.jncc.topsat.crud.entity"})
@EnableJpaRepositories(basePackages = {"uk.gov.defra.jncc.topsat.crud.repository"})
@ComponentScan(basePackages = {"uk.gov.defra.jncc.topsat.api.controllers", "uk.gov.defra.jncc.topsat.api.resources.assemblers"})
@EnableSpringDataWebSupport
public class TestApiApplication extends SpringBootServletInitializer {
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(TestApiApplication.class);
    }
    
    public static void main(String[] args) {
       SpringApplication.run(TestApiApplication.class, args);
    }    
}
