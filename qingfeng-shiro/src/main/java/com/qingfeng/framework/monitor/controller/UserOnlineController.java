package com.qingfeng.framework.monitor.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.framework.shiro.server.RedisSessionDao;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.Json;
import com.qingfeng.util.Page;
import com.qingfeng.util.PageData;
import com.qingfeng.util.Verify;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.Serializable;
import java.util.*;

/**
 * Created by anxingtao on 2020-10-3.
 */
@Controller
@RequestMapping(value = "/monitor/userOnline")
public class UserOnlineController extends BaseController {

    @Autowired
    private UserService userService;
    @Autowired
    private RedisSessionDao sessionDao;
    //在线用户前缀
    private String prefix = "onlineUser:";
    @Autowired
    private RedisTemplate redisTemplate;


    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/monitor/userOnline/userOnline";
    }

    /**
     * @Description: findUserOnlineList 获取当前用户数量
     * @Param: [session, request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2020-10-3 8:52
     */
    @RequestMapping(value = "/findUserOnlineListPage", method = RequestMethod.GET)
    public void findUserOnlineListPage(Page page, HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PageData pd = new PageData(request);
        Json json = new Json();

        Set<String> keys = redisTemplate.keys(prefix + "*");
        if(keys.size()>0){
            List<String> userIds = new ArrayList<String>();
            for (String key:keys) {
                userIds.add(key.split(":")[1]);
            }
            pd.put("userIds", userIds);
            //处理分页
            if(Verify.verifyIsNotNull(pd.get("page"))){
                page.setIndex(Integer.parseInt(pd.get("page").toString()));
            }else{
                page.setIndex(1);
            }
            if(Verify.verifyIsNotNull(pd.get("limit"))){
                page.setShowCount(Integer.parseInt(pd.get("limit").toString()));
            }else{
                page.setShowCount(10);
            }
            page.setPd(pd);
            List<PageData> userOnlineList = userService.findUserOnlineListPage(page);
            json.setMsg("获取数据成功");
            json.setSuccess(true);
            json.setCount(keys.size());
            json.setData(userOnlineList);
        }else{
            json.setMsg("获取数据成功");
            json.setSuccess(true);
            json.setCount(0);
            json.setData(new ArrayList<PageData>());
        }
        this.writeJson(response,json);
    }

    /**
     * @Description: findUserOnline 获取当前在线用户数量
     * @Param: [session, request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2020-10-3 8:21
     */
    @RequestMapping(value = "/findUserOnlineNum", method = RequestMethod.GET)
    public void findUserOnlineNum(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PageData pd = new PageData(request);
        ServletContext application=session.getServletContext();
        PageData userOnlineObj= (PageData) application.getAttribute("userOnlineObj");
        int num = 0;
        if(userOnlineObj!=null){
            num = userOnlineObj.getKeys(userOnlineObj).length;
        }
        Json json = new Json();
        json.setMsg("获取数据成功");
        json.setSuccess(true);
        json.setData(num);
        this.writeJson(response,json);
    }


    /**
     * @Description: kickUserOffline 根据Session将用户踢下线
     * @Param: [request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2020-10-3 20:01
     */
    @RequestMapping(value = "/kickUserOffline", method = RequestMethod.GET)
    public void kickUserOffline(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws Exception {
        PageData pd = new PageData(request);
        String ids[] = pd.get("ids").toString().split(",");
        for (String id:ids) {
            String key = prefix + id;
            Serializable session_id = (Serializable)redisTemplate.opsForValue().get(key);
            Session shiroSession=sessionDao.readSession(session_id);
            sessionDao.delete(shiroSession);
            redisTemplate.delete(key);
            shiroSession.removeAttribute("loginUser");
        }
        Json json = new Json();
        json.setMsg("下线成功");
        json.setSuccess(true);
        this.writeJson(response,json);
    }


    @RequestMapping(value = "/redis",method = RequestMethod.GET)
    public void testRedis(HttpServletRequest request, HttpServletResponse response) throws Exception{
        Subject subject = SecurityUtils.getSubject();
        Session session = subject.getSession();
        Set<String> keys = redisTemplate.keys(prefix + "*");
        this.writeJson(response,keys);
    }


    @RequestMapping(value = "/allSession",method = RequestMethod.GET)
    public void allSession(HttpServletRequest request, HttpServletResponse response) throws Exception{
        Collection<Session> collection = sessionDao.getActiveSessions();
        for (Session session:collection) {
            System.out.println("##################:"+session.getId());
        }
        this.writeJson(response,collection);
    }


    @RequestMapping(value = "/allSessionIds",method = RequestMethod.GET)
    public void allSessionIds(HttpServletRequest request, HttpServletResponse response) throws Exception{
        Collection<String> collection = sessionDao.getActiveSessionIds();
        for (String session_id:collection) {
            System.out.println("##################:"+session_id);
        }
        this.writeJson(response,collection);
    }


}
