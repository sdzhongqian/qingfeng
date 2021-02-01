package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.util.Json;
import com.qingfeng.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created by anxingtao on 2020-9-20.
 */
@Controller
@RequestMapping(value = "/system/admin")
public class AdminController extends BaseController {

    
    /** 
     * @Description: index 
     * @Param: [map, request, response] 
     * @return: java.lang.String 
     * @Author: anxingtao
     * @Date: 2020-9-27 0:33 
     */ 
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/system/admin/main";
    }


    /** 
     * @Description: saveTheme 保存主题
     * @Param: [request, response, session] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-20 22:24 
     */ 
    @RequestMapping(value = "/saveTheme", method = RequestMethod.POST)
    public void saveTheme(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        PageData pd = new PageData(request);
        System.out.println(pd.toString());
        Json json = new Json();
        json.setData(pd);
        json.setSuccess(true);
        json.setMsg("操作成功。");
        this.writeJson(response,json);
    }


}
