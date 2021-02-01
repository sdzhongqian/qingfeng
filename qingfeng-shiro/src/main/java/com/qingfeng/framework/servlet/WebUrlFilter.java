package com.qingfeng.framework.servlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import java.io.IOException;

/**
 *
 * @author anxingtao
 * @date 2018-8-19
 */

public class WebUrlFilter implements Filter {
    private final Logger log = LoggerFactory.getLogger(getClass());

   /* @Resource
    private CommonConfig commonConfig;*/


    @Override
    public void init(FilterConfig arg0) throws ServletException {
        System.out.println("doFilter 1");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
//        request.setAttribute("menuAuthParams","add,edit,del");
        System.out.println("doFilter 2");
        filterChain.doFilter(request, response);

    }

    @Override
    public void destroy() {
        System.out.println("doFilter 3");
    }


}