/**
 * MIT License
 * Copyright (c) 2018 yadong.zhang
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.qingfeng.framework.shiro.credentials;

import com.qingfeng.system.service.LoggerService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.DateTimeUtil;
import com.qingfeng.util.GuidUtil;
import com.qingfeng.util.PageData;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AccountException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.util.concurrent.TimeUnit;

/**
 * Shiro-密码输入错误的状态下重试次数的匹配管理
 *
 * @author yadong.zhang (yadong.zhang0415(a)gmail.com)
 * @version 1.0
 * @website https://www.zhyd.me
 * @date 2018/4/24 14:37
 * @since 1.0
 */
@Slf4j
public class RetryLimitCredentialsMatcher extends CredentialsMatcher {

    /**
     * 用户登录次数计数  redisKey 前缀
     */
    private static final String SHIRO_LOGIN_COUNT = "shiro_login_count_";
    /**
     * 用户登录是否被锁定    一小时 redisKey 前缀
     */
    private static final String SHIRO_IS_LOCK = "shiro_is_lock_";
//    在线用户前缀
    private String prefix = "onlineUser:";
    // 设置会话的过期时间
    private int seconds = 30*24*60;
    @Autowired
    private RedisTemplate redisTemplate;
    @Autowired
    private UserService userService;
    @Autowired
    private LoggerService loggerService;

    @Override
    public boolean doCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) {
        String userId = (String)info.getPrincipals().getPrimaryPrincipal();
        PageData pd = new PageData();
        pd.put("id",userId);
        PageData userPd = userService.findInfo(pd);
        String username = userPd.get("login_name").toString();
        // 访问一次，计数一次
        ValueOperations<String, String> opsForValue = redisTemplate.opsForValue();
        String loginCountKey = SHIRO_LOGIN_COUNT + username;
        String isLockKey = SHIRO_IS_LOCK + username;
        opsForValue.increment(loginCountKey, 1);

        if (redisTemplate.hasKey(isLockKey)) {
            throw new ExcessiveAttemptsException("帐号[" + username + "]已被禁止登录！");
        }

        // 计数大于5时，设置用户被锁定一小时
        String loginCount = String.valueOf(opsForValue.get(loginCountKey));
        int retryCount = (5 - Integer.parseInt(loginCount));
        if (retryCount <= 0) {
            opsForValue.set(isLockKey, "LOCK");
            redisTemplate.expire(isLockKey, 1, TimeUnit.HOURS);
            redisTemplate.expire(loginCountKey, 1, TimeUnit.HOURS);
            PageData p = new PageData();
            p.put("id",userPd.get("id"));
            p.put("pwd_error_num",5);
            p.put("pwd_error_time", DateTimeUtil.getDateTimeStr());
            p.put("update_time",DateTimeUtil.getDateTimeStr());
            p.put("update_user",userPd.get("id"));
            p.put("status","2");
            userService.update(p);
            throw new ExcessiveAttemptsException("由于密码输入错误次数过多，帐号[" + username + "]已被禁止登录！");
        }

        boolean matches = super.doCredentialsMatch(token, info);
        if (!matches) {
            String msg = retryCount <= 0 ? "您的账号一小时内禁止登录！" : "您还剩" + retryCount + "次重试的机会";
            throw new AccountException("帐号或密码不正确！" + msg);
        }

        //添加在线用户
        Subject subject = SecurityUtils.getSubject();
        redisTemplate.opsForValue().set(prefix+userPd.get("id").toString(),subject.getSession().getId(),seconds, TimeUnit.MINUTES);
        //清空登录计数
        redisTemplate.delete(loginCountKey);
        try {
            PageData p = new PageData();
            //主键id
            p.put("id", GuidUtil.getUuid());
            p.put("type","1");
            p.put("title",userPd.get("name")+"在"+DateTimeUtil.getDateTimeStr()+"进行了登录操作");
            p.put("content",userPd.get("name")+"在"+DateTimeUtil.getDateTimeStr()+"进行了登录操作");
            p.put("operate_type","POST");
            p.put("operate_user",userPd.get("name"));
            p.put("create_user",userPd.get("id"));
            p.put("create_time", DateTimeUtil.getDateTimeStr());
            p.put("update_time",DateTimeUtil.getDateTimeStr());
            loggerService.save(p);

            int pwd_error_num = 0;
            String time = DateTimeUtil.getDateTimeStr();
            PageData pu = new PageData();
            pu.put("id",userPd.get("id"));
            pu.put("pwd_error_num",pwd_error_num);
            pu.put("pwd_error_time",time);
            pu.put("update_time",time);
            pu.put("last_login_time",time);
            pu.put("update_user",userPd.get("id"));
//            UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
//            // 获取客户端操作系统
//            String os = userAgent.getOperatingSystem().getName();
//            // 获取客户端浏览器
//            String browser = userAgent.getBrowser().getName();
//            pu.put("browser",browser);
//            pu.put("os",os);
//            pu.put("ipaddr", IpUtils.getIpAddr(request));
//            pu.put("iprealaddr", AddressUtils.getRealAddressByIP(IpUtils.getIpAddr(request)));
            int num = userService.update(pu);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 当验证都通过后，把用户信息放在session里
        // 注：User必须实现序列化
        SecurityUtils.getSubject().getSession().setAttribute("loginUser", userPd);
        return true;
    }
}
