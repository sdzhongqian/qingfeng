package com.qingfeng.quartz.controller;

import com.qingfeng.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Title: CronController
 * @ProjectName wdata
 * @Description: cron
 * @author anxingtao
 * @date 2020-10-2 9:57
 */
@Controller
@RequestMapping(value = "/quartz/cron")
public class CronController {

    /** 
     * @Description: index
     * @Param: [map, request, response] 
     * @return: java.lang.String 
     * @Author: anxingtao
     * @Date: 2020-10-2 9:58 
     */ 
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/quartz/cron/cron";
    }

}
