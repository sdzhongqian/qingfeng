package com.qingfeng.framework.shiro.filter;

import com.qingfeng.framework.shiro.server.RedisSessionDao;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * @Title: OnlineSessionFilter
 * @ProjectName wdata
 * @Description: 自定义访问控制
 * @author anxingtao
 * @date 2020-10-8 0:22
 */
public class OnlineSessionFilter extends AccessControlFilter
{
    @Autowired
    private RedisSessionDao sessionDao;


    /**
     * 表示是否允许访问；mappedValue就是[urls]配置中拦截器参数部分，如果允许访问返回true，否则false；
     */
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue)
            throws Exception
    {
        System.out.println("shiro拦截器进来了。。。。。。。。。。。。。。。。。");
        Subject subject = getSubject(request, response);
        if (subject == null || subject.getSession() == null)
        {
            return true;
        }
//        System.out.println(subject);
//        System.out.println(subject.getSession());
//        Session session = subject.getSession();
        System.out.println(subject.getSession().getId());
        System.out.println(subject.isAuthenticated());
        if(subject.isAuthenticated()){
            Session session = sessionDao.readSession(subject.getSession().getId());
            request.setAttribute("session",session);
        }
        return true;
    }

    /**
     * 表示当访问拒绝时是否已经处理了；如果返回true表示需要继续处理；如果返回false表示该拦截器实例已经处理了，将直接返回即可。
     */
    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception
    {
        Subject subject = getSubject(request, response);
        if (subject != null)
        {
            subject.logout();
        }
        saveRequestAndRedirectToLogin(request, response);
        return false;
    }
}
