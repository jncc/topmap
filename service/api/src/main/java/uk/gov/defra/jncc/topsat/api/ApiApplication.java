package uk.gov.defra.jncc.topsat.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.boot.orm.jpa.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.web.config.EnableSpringDataWebSupport;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EntityScan(basePackages = {"uk.gov.defra.jncc.topsat.crud.entity"})
@EnableJpaRepositories(basePackages = {"uk.gov.defra.jncc.topsat.crud.repository"})
@ComponentScan
@EnableSpringDataWebSupport
@EnableSwagger2
public class ApiApplication extends SpringBootServletInitializer {
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(ApiApplication.class);
    }
    
    public static void main(String[] args) {
        SpringApplication.run(ApiApplication.class, args);
    }
}
