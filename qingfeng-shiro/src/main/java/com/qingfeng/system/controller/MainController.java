package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.MenuService;
import com.qingfeng.util.PageData;
import com.qingfeng.util.Verify;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * @Title: MainController
 * @ProjectName wdata
 * @Description: 主入口Controller
 * @author anxingtao
 * @date 2020-9-24 22:32
 */
@Controller
@RequestMapping(value = "/")
public class MainController extends BaseController {

    @Autowired
    private MenuService menuService;


    /** 
     * @Description: index 主入口
     * @Param: [map, request, response] 
     * @return: java.lang.String 
     * @Author: anxingtao
     * @Date: 2020-9-24 22:33 
     */ 
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "redirect:/main";
    }

    /** 
     * @Description: main 
     * @Param: [request, session]
     * @return: org.springframework.web.servlet.ModelAndView 
     * @Author: anxingtao
     * @Date: 2020-9-24 22:45
     */ 
    @RequestMapping("/main")
    public ModelAndView main(HttpServletRequest request, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        PageData pd = new PageData(request);
        PageData user = (PageData) session.getAttribute("loginUser");
        if(Verify.verifyIsNotNull(user)){
            pd.put("user_id",user.get("id"));
            PageData organize = (PageData) session.getAttribute("loginOrganize");
            pd.put("organize_id",organize.get("organize_id"));
            //查询头部菜单
            pd.put("type","menu");
            pd.put("level_num","0");
            pd.put("parent_id","0");
            List<PageData> menuList = menuService.findMenuList(pd);//查找一级菜单
            mv.addObject("menuList",menuList);
            mv.setViewName("web/system/admin/index");
        }else{
            mv.setViewName("web/system/login/login");
        }
        return mv;
    }







}
