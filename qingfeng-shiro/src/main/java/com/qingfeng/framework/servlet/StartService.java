package com.qingfeng.framework.servlet;

/**
 * @author anxingtao
 * @Title: StartService
 * @ProjectName com.qingfeng
 * @Description: TODO
 * @date 2018-10-2310:21
 */
import com.qingfeng.framework.shiro.server.RedisSessionDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * 继承Application接口后项目启动时会按照执行顺序执行run方法
 * 通过设置Order的value来指定执行的顺序
 */
@Component
@Order(value = 1)
public class StartService implements ApplicationRunner {
    @Autowired
    private RedisSessionDao sessionDao;
    //在线用户前缀
    private String session_prefix = "sessionId:";
    private String prefix = "onlineUser:";
    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public void run(ApplicationArguments applicationArguments) throws Exception {
        Collection<String> collection = sessionDao.getActiveSessionIds();
        if(collection.size()>0){
            for (String session_id:collection) {
//                Session shiroSession=sessionDao.readSession(session_id);
//                sessionDao.delete(shiroSession);
                redisTemplate.delete(session_prefix+session_id);
                String key = prefix + session_id;
                redisTemplate.delete(key);
//                shiroSession.removeAttribute("loginUser");
            }
        }
        System.out.println("###############################项目启动成功###############################");
    }
}
