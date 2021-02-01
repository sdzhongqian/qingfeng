package com.qingfeng.framework.servlet;

/**
 * Created by anxingtao on 2018-8-19.
 */

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;

import javax.servlet.Filter;

//@Configuration
public class WebFilterConfig {

    @Bean
    public FilterRegistrationBean filterDemo3Registration() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(WebUrlFilter());
        registration.addUrlPatterns("/*");
        registration.addInitParameter("paramName", "paramValue");
        registration.setName("filterDemo3");
        registration.setOrder(1);
        return registration;
    }


    @Bean
    public Filter WebUrlFilter() {
        return new WebUrlFilter();
    }

}