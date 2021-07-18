package com.qingfeng.framework.config;

import com.qingfeng.framework.filter.XssFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.DispatcherType;
import java.util.Arrays;
import java.util.Objects;

/**
 * @ProjectName FilterConfig
 * @author Administrator
 * @version 1.0.0
 * @Description Filter配置
 * @createTime 2021/7/18 0018 21:11
 */
@Configuration
public class FilterConfig {

    //xss 不拦截的过滤器
    @Value("${xss.domains}")
    private String xss_domains;

    /**
     * @ProjectName FilterConfig
     * @author Administrator
     * @version 1.0.0
     * @Description 注册过滤器 实现配置不过滤部分接口，部分接口需要不做过滤
     * @createTime 2021/7/18 0018 21:12
     */
    @Bean
    public FilterRegistrationBean xssFilterRegistration() {
        FilterRegistrationBean registration = getFilterRegistrationBean();
        return registration;
    }

    private FilterRegistrationBean getFilterRegistrationBean() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        //指定发起请求时过滤
        registration.setDispatcherTypes(DispatcherType.REQUEST);
        registration.setFilter(new XssFilter(Objects.isNull(xss_domains) ? null : Arrays.asList(xss_domains.split(","))));
        //默认所有接口
        registration.addUrlPatterns("/*");
        registration.setName("xssFilter");
        //设置最后执行，防止有其他过滤器对值需要修改等操作，保证最后过滤字符即可
        registration.setOrder(Integer.MAX_VALUE);
        return registration;
    }
}
