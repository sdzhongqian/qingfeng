package com.qingfeng.framework.shiro.filter;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.qingfeng.util.Json;
import com.qingfeng.util.ServletUtils;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.cache.CacheManager;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.DefaultSessionKey;
import org.apache.shiro.session.mgt.SessionManager;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.springframework.core.annotation.Order;

import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.Deque;
import java.util.LinkedList;

/**
 * @author: WangSaiChao
 * @date: 2018/5/23
 * @description: shiro 自定义filter 实现 并发登录控制
 */
@Order(1)
public class KickoutSessionFilter  extends AccessControlFilter{

    /** 踢出后到的地址 */
    private String kickoutUrl;

    /**  踢出之前登录的/之后登录的用户 默认踢出之前登录的用户 */
    private boolean kickoutAfter = false;

    /**  同一个帐号最大会话数 默认1 */
    private int maxSession = 100;
    private SessionManager sessionManager;
    private Cache<String, Deque<Serializable>> cache;

    public void setKickoutUrl(String kickoutUrl) {
        this.kickoutUrl = kickoutUrl;
    }

    public void setKickoutAfter(boolean kickoutAfter) {
        this.kickoutAfter = kickoutAfter;
    }

    public void setMaxSession(int maxSession) {
        this.maxSession = maxSession;
    }

    public void setSessionManager(SessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }

    public void setCacheManager(CacheManager cacheManager) {
        this.cache = cacheManager.getCache("shiro-activeSessionCache");
    }
    /**
     * 是否允许访问，返回true表示允许
     */
    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
        return false;
    }
    /**
     * 表示访问拒绝时是否自己处理，如果返回true表示自己不处理且继续拦截器链执行，返回false表示自己已经处理了（比如重定向到另一个页面）。
     */
    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
        Subject subject = getSubject(request, response);
        if(!subject.isAuthenticated()) {
//            if(!subject.isAuthenticated() && !subject.isRemembered()) {
            //如果没有登录，直接进行之后的流程
            return true;
        }

        Session session = subject.getSession();
        //这里获取的User是实体 因为我在 自定义ShiroRealm中的doGetAuthenticationInfo方法中
        //new SimpleAuthenticationInfo(user, password, getName()); 传的是 User实体 所以这里拿到的也是实体,如果传的是userName 这里拿到的就是userName
        String userId = subject.getPrincipal().toString();
        Serializable sessionId = session.getId();

        // 初始化用户的队列放到缓存里
        Deque<Serializable> deque = cache.get(userId);
        if(deque == null) {
            deque = new LinkedList<Serializable>();
        }

        //如果队列里没有此sessionId，且用户没有被踢出；放入队列
        if(!deque.contains(sessionId) && session.getAttribute("kickout") == null) {
            System.out.println(deque.toString());
            System.out.println(sessionId);
            deque.push(sessionId);
            cache.put(userId, deque);
        }

        //如果队列里的sessionId数超出最大会话数，开始踢人
        System.out.println("开始踢人了。。。。。。。。："+deque.size());
        while(deque.size() > maxSession) {
            Serializable kickoutSessionId = null;
            if(kickoutAfter) { //如果踢出后者
                kickoutSessionId=deque.getFirst();
                kickoutSessionId = deque.removeFirst();
            } else { //否则踢出前者
                kickoutSessionId = deque.removeLast();
            }
            // 踢出后再更新下缓存队列
            cache.put(userId, deque);
            Session kickoutSession = sessionManager.getSession(new DefaultSessionKey(kickoutSessionId));
            if(kickoutSession != null) {
                //设置会话的kickout属性表示踢出了
                kickoutSession.setAttribute("kickout", true);
            }
        }

        //如果被踢出了，直接退出，重定向到踢出后的地址
        if (session.getAttribute("kickout") != null) {
            //会话被踢出了
            try {
                subject.logout();
                System.out.println("33333333333333");
                return isAjaxResponse(request, response);
            } catch (Exception e) {
                System.out.println("444444444444444");
                return isAjaxResponse(request, response);
            }
        }
        return true;
    }

    private boolean isAjaxResponse(ServletRequest request, ServletResponse response) throws IOException
    {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        if (ServletUtils.isAjaxRequest(req)) {
            ServletOutputStream out = response.getOutputStream();
            Json json = new Json();
            json.setSuccess(false);
            json.setUrl(req.getContextPath() + kickoutUrl);
            json.setLoseSession("loseSession");
            json.setMsg("登录失效，正在跳转。。。");
            response.setContentType("text/html;charset=utf-8");
            ObjectMapper objMapper = new ObjectMapper();
            JsonGenerator jsonGenerator = objMapper.getJsonFactory()
                    .createJsonGenerator(response.getOutputStream(),
                            JsonEncoding.UTF8);

            jsonGenerator.writeObject(json);
            jsonGenerator.flush();
            jsonGenerator.close();
        } else {
            //登陆过滤
            PrintWriter out = response.getWriter();
            out.println("<html>");
            out.println("<script>");
            out.println("window.open ('"+req.getContextPath()+kickoutUrl+"','_top')");
            out.println("</script>");
            out.println("</html>");
        }
        return false;
    }

}