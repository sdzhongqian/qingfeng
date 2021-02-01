package com.qingfeng.framework.shiro.filter;

import com.qingfeng.framework.shiro.server.RedisSessionDao;
import com.qingfeng.util.Verify;
import org.apache.shiro.session.Session;
import org.apache.shiro.web.filter.PathMatchingFilter;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * 同步Session数据到Db
 * 
 * @author ruoyi
 */
public class SyncOnlineSessionFilter extends PathMatchingFilter
{
    @Autowired
    private RedisSessionDao sessionDao;

    /**
     * 同步会话数据到DB 一次请求最多同步一次 防止过多处理 需要放到Shiro过滤器之前
     */
    @Override
    protected boolean onPreHandle(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception
    {
        Session session = (Session)request.getAttribute("session");
        if(Verify.verifyIsNotNull(session)){
            System.out.println("SyncOnlineSessionFilter。。。。。。。。。。。:"+session.getId());
            sessionDao.doUpdate(session);
        }
        return true;
    }
}
