package com.qingfeng.framework.filter;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Set;

/**
 * @ProjectName XssFilter
 * @author Administrator
 * @version 1.0.0
 * @Description XSS过滤
 * @createTime 2021/7/18 0018 21:12
 */
public class XssFilter implements Filter {

    private List<String> excludedUris;

    public XssFilter() {
    }

    public XssFilter(List<String> excludedUris) {
        this.excludedUris = excludedUris;
    }

    /**
     * 是否排除
     *
     * @param uri
     * @return
     */
    private boolean isExcludedUri(String uri) {
        if (CollectionUtils.isEmpty(excludedUris)) {
            return false;
        }
        for (String ex : excludedUris) {
            if (match(ex, uri)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 地址匹配
     *
     * @param patternPath
     * @param requestPath
     * @return
     */
    public static boolean match(String patternPath, String requestPath) {
        if (StringUtils.isEmpty(patternPath) || StringUtils.isEmpty(requestPath)) {
            return false;
        }
        PathMatcher matcher = new AntPathMatcher();
        return matcher.match(patternPath, requestPath);
    }


    @Override
    public void init(FilterConfig config) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        //跨域设置
        if(response instanceof HttpServletResponse){
            HttpServletResponse httpServletResponse=(HttpServletResponse)response;
            //通过在响应 header 中设置 ‘*’ 来允许来自所有域的跨域请求访问。
            httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
            //通过对 Credentials 参数的设置，就可以保持跨域 Ajax 时的 Cookie
            //设置了Allow-Credentials，Allow-Origin就不能为*,需要指明具体的url域
            //httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
            //请求方式
            httpServletResponse.setHeader("Access-Control-Allow-Methods", "*");
            //（预检请求）的返回结果（即 Access-Control-Allow-Methods 和Access-Control-Allow-Headers 提供的信息） 可以被缓存多久
            httpServletResponse.setHeader("Access-Control-Max-Age", "86400");
            //首部字段用于预检请求的响应。其指明了实际请求中允许携带的首部字段
            httpServletResponse.setHeader("Access-Control-Allow-Headers", "*");
        }
        //可配置多个字符串过滤
        XssHttpServletRequestWrapper xssRequest = new XssHttpServletRequestWrapper(
                (HttpServletRequest) request, new HTMLFilter());
        String url = xssRequest.getServletPath();
        if (isExcludedUri(url)) {
            chain.doFilter(request, response);
            return;
        }
        chain.doFilter(xssRequest, response);
    }

    @Override
    public void destroy() {
    }

}