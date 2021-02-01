package com.qingfeng.common.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.util.Json;
import com.qingfeng.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**  
 * @Title: backController
 * @ProjectName com.qingfeng
 * @Description: TODO
 * @author qingfeng
 * @date 2018-9-18
 */
@Controller
@RequestMapping(value = "/common/test")
public class TestController extends BaseController {


    /**
     * @Description: index 
     * @Param: [map, request, response] 
     * @return: java.lang.String 
     * @Author: wangcong
     * @Date: 2018-9-18
     */ 
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public void index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData  pd = new PageData(request);

        Json json = new Json();
        json.setData(pd);
        this.writeJson(response,json);
    }



    //=======================================测试相关=======================================

    /** 
     * @Description: selectOneOrganize 
     * @Param: [request, session] 
     * @return: org.springframework.web.servlet.ModelAndView 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:58 
     */ 
    @RequestMapping("/selectUserOrOrganize")
    public ModelAndView selectOneOrganize(HttpServletRequest request, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("web/common/test/index");
        return mv;
    }


    /** 
     * @Description: tableTree
     * @Param: [request, session] 
     * @return: org.springframework.web.servlet.ModelAndView 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:58 
     */ 
    @RequestMapping("/treeTable")
    public ModelAndView tableTree(HttpServletRequest request, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("web/common/test/treeTable");
        return mv;
    }


    @RequestMapping("/verifyCode")
    public ModelAndView verifyCode(HttpServletRequest request, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("web/common/test/verifyCode");
        return mv;
    }



}
