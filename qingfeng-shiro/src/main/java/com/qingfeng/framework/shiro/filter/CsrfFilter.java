package com.qingfeng.framework.shiro.filter;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.qingfeng.util.Json;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

public class CsrfFilter extends OncePerRequestFilter {
    private Collection<String> domains;

    // 临时过滤路径。对用户管理使用`csrf token`的方式进行防范。
    private List<String> paths = Arrays.asList("/system/user/updateAuth", "/system/user/updatePwd");

    public CsrfFilter(Collection<String> domains) {
        this.domains = domains;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        Subject subject = SecurityUtils.getSubject();
        Session session = subject.getSession();
        if(subject.isAuthenticated()||subject.isRemembered()) {
            Object token = session.getAttribute("csrfToken");
            Object httpToken = request.getHeader("httpToken");
            boolean missingToken = false;
            if (token == null) {
                missingToken = true;
                token = UUID.randomUUID().toString().replace("-", "");
                session.setAttribute("csrfToken",token);
            }
            request.setAttribute("csrfToken", token);

            // GET 等方式不用提供Token，自动放行，不能用于修改数据。修改数据必须使用 POST、PUT、DELETE、PATCH 方式并且Referer要合法。
            if (Arrays.asList("GET", "HEAD", "TRACE", "OPTIONS").contains(request.getMethod())) {
                filterChain.doFilter(request, response);
                return;
            }
            String uri = request.getRequestURI();
            if (paths.contains(uri) && !token.equals(httpToken)) {
//                response.sendError(HttpServletResponse.SC_FORBIDDEN, missingToken ? "CSRF Token Missing" : "CSRF Token Invalid");
                Json json = new Json();
                json.setSuccess(false);
                json.setMsg(missingToken ? "CSRF 令牌丢失" : "CSRF 令牌无效");
                response.setContentType("text/html;charset=utf-8");
                ObjectMapper objMapper = new ObjectMapper();
                JsonGenerator jsonGenerator = objMapper.getJsonFactory()
                        .createJsonGenerator(response.getOutputStream(),
                                JsonEncoding.UTF8);
                jsonGenerator.writeObject(json);
                jsonGenerator.flush();
                jsonGenerator.close();
                return;
            }
            if (!domains.isEmpty() && !verifyDomains(request)) {
//                response.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Protection: Referer Illegal");
                Json json = new Json();
                json.setSuccess(false);
                json.setMsg("CSRF 保护：Referer 非法");
                response.setContentType("text/html;charset=utf-8");
                ObjectMapper objMapper = new ObjectMapper();
                JsonGenerator jsonGenerator = objMapper.getJsonFactory()
                        .createJsonGenerator(response.getOutputStream(),
                                JsonEncoding.UTF8);
                jsonGenerator.writeObject(json);
                jsonGenerator.flush();
                jsonGenerator.close();
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private boolean verifyDomains(HttpServletRequest request) {
        // 从 HTTP 头中取得 Referer 值
        String referer = request.getHeader("Referer");
        // 判断 Referer 是否以 合法的域名 开头。
        if (referer != null) {
            // 如 http://mysite.com/abc.html https://www.mysite.com:8080/abc.html
            if (referer.indexOf("://") > 0) referer = referer.substring(referer.indexOf("://") + 3);
            // 如 mysite.com/abc.html
            if (referer.indexOf("/") > 0) referer = referer.substring(0, referer.indexOf("/"));
            // 如 mysite.com:8080
            if (referer.indexOf(":") > 0) referer = referer.substring(0, referer.indexOf(":"));
            // 如 mysite.com
            for (String domain : domains) {
                if (referer.contains(domain)) return true;
            }
        }
        return false;
    }

    private boolean verifyToken(HttpServletRequest request, String token) {
        return token.equals(request.getParameter("csrfToken"));
    }
}
