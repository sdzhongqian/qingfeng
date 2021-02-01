package com.qingfeng.framework.shiro.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Set;


/**
 * @Title: TimerController
 * @ProjectName wdata
 * @Description: 定时器
 * @author anxingtao
 * @date 2020-10-1 21:40
 */
@Configuration
@EnableScheduling
@Component
public class ShiroTimerService{

    private String prefix = "sessionId:";
    private String user_prefix = "onlineUser:";
    @Autowired
    private StringRedisTemplate redisTemplate;

    @Scheduled(cron = "0 0/10 * * * ? ")
    public void execSql() throws Exception{
        Set<String> user_keys = redisTemplate.keys(user_prefix + "*");
        Set<String> keys = redisTemplate.keys(prefix + "*");
        for (String uk:user_keys) {
            String session_id = redisTemplate.opsForValue().get(uk);
            if(!keys.contains(prefix+session_id)){
                redisTemplate.delete(uk);
            }
        }
    }

}
