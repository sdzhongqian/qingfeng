package com.qingfeng.framework.monitor.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.framework.monitor.server.SystemHardwareServer;
import com.qingfeng.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Title: SystemHardwareController
 * @ProjectName wdata
 * @Description: 监控服务
 * @author anxingtao
 * @date 2020-10-2 21:43
 */
@Controller
@RequestMapping(value = "/monitor/server")
public class SystemHardwareController extends BaseController {

    /** 
     * @Description: index 
     * @Param: [map, request, response] 
     * @return: java.lang.String 
     * @Author: anxingtao
     * @Date: 2020-10-2 21:43 
     */ 
    @RequestMapping(value = "/systemHardware", method = RequestMethod.GET)
    public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        PageData pd = new PageData(request);
        SystemHardwareServer server = new SystemHardwareServer();
        server.copyTo();
        map.put("server",server);
        map.put("pd",pd);
        return "web/monitor/server/systemHardware";
    }



}
