package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.base.entity.AuthUser;
import com.qingfeng.framework.shiro.server.RedisSessionDao;
import com.qingfeng.framework.shiro.service.ShiroService;
import com.qingfeng.system.service.LoginService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.Json;
import com.qingfeng.util.PageData;
import com.qingfeng.util.Verify;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Enumeration;

/**
 * Created by anxingtao on 2020-9-27.
 */
@Controller
@RequestMapping(value = "/system/login")
public class LoginController extends BaseController {

    @Autowired
    public LoginService loginService;
    @Autowired
    private UserService userService;
    @Autowired
    private ShiroService shiroService;
    @Autowired
    private RedisSessionDao sessionDao;
    //在线用户前缀
    private String prefix = "onlineUser:";
    @Autowired
    private RedisTemplate redisTemplate;


    /**
     * @Description: login
     * @Param: [request, response, session]
     * @return: java.lang.String
     * @Author: anxingtao
     * @Date: 2020-9-27 9:09
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String getLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        PageData pd = new PageData(request);
        if(Verify.verifyIsNotNull(session.getAttribute("loginUser"))){
            PageData uPd = (PageData) session.getAttribute("loginUser");
            //退出登录
//        SecurityUtils.getSubject().logout();
            session.removeAttribute("loginUser");//清除用户
            session.removeAttribute("loginOrganize");//清除组织
            redisTemplate.delete(prefix+uPd.get("id"));//清除在线用户
            Enumeration em = session.getAttributeNames();
            while(em.hasMoreElements()){
                session.removeAttribute(em.nextElement().toString());
            }
        }
        Subject subject = SecurityUtils.getSubject();
        if (subject.isAuthenticated()){
            subject.logout();
        }
        return "web/system/login/login";
    }

    /** 
     * @Description: postLogin 
     * @Param: [request, response, session] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-27 10:42 
     */ 
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public void postLogin(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException {
        PageData pd = new PageData(request);
        String errMsg = "";
        String errCode = "0";
        boolean errBol = true;
        Json json = new Json();
        if(!Verify.verifyIsNotNull(pd.getString("login_name"))){
            errMsg="登录名称不可为空。";
            errCode = "1";
            errBol = false;
        }else if(!Verify.verifyIsNotNull(pd.getString("password"))){
            errMsg="登录密码不可为空。";
            errCode = "2";
            errBol = false;
        }else{
            PageData uPd = loginService.findUserInfo(pd);
            UsernamePasswordToken token = new UsernamePasswordToken(pd.getString("login_name"), pd.getString("password"),Boolean.getBoolean(pd.get("my_remember").toString()));
            try {
                //获取当前的Subject
                Subject currentUser = SecurityUtils.getSubject();
                // 在调用了login方法后,SecurityManager会收到AuthenticationToken,并将其发送给已配置的Realm执行必须的认证检查
                // 每个Realm都能在必要时对提交的AuthenticationTokens作出反应
                // 所以这一步在调用login(token)方法时,它会走到xxRealm.doGetAuthenticationInfo()方法中,具体验证方式详见此方法
                currentUser.login(token);
                if(currentUser.isAuthenticated()){
                    errMsg = "用户已经登录！";
                }else{
                    //更新权限
                    AuthUser au = new AuthUser();
                    au.setId(uPd.get("id").toString());
                    au.setLogin_name(uPd.get("login_name").toString());
                    au.setName(uPd.get("name").toString());
                    shiroService.reloadAuthorizingByUserId(au);
                    shiroService.updatePermission();
                    // 登录成功之后 设置session时间为30分钟，单位为毫秒
                    Session shiroSession = currentUser.getSession();
                    shiroSession.setTimeout(30 * 60 * 1000L);
                }
            } catch (Exception e) {
                token.clear();
                errMsg = e.getMessage();
                errBol = false;
            }
        }

        json.setMsg(errMsg);
        json.setFlag(errCode);
        json.setSuccess(errBol);
        this.writeJson(response,json);
    }



}
