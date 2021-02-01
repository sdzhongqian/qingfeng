package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by anxingtao on 2020-9-20.
 */
@Controller
@RequestMapping(value = "/system/error")
public class ErrorController extends BaseController {

    
    /** 
     * @Description: index error
     * @Param: [map, request, response]
     * @return: java.lang.String 
     * @Author: anxingtao
     * @Date: 2020-9-30 15:39 
     */ 
    @RequestMapping(value = "/error", method = RequestMethod.GET)
    public String indexerror(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/base/error/error";
    }


}
