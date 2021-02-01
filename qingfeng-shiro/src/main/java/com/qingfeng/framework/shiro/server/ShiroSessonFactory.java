package com.qingfeng.framework.shiro.server;

import com.qingfeng.framework.shiro.session.ShiroSession;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.SessionContext;
import org.apache.shiro.session.mgt.SessionFactory;

/**
 * @Title: ShiroSessonFactory
 * @ProjectName wdata
 * @Description: TODO
 * @author anxingtao
 * @date 2020-10-7 23:17
 */
public class ShiroSessonFactory implements SessionFactory {

        @Override
        public Session createSession(SessionContext initData) {
            ShiroSession session = new ShiroSession();
            return session;
        }

}
