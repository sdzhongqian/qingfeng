package com.qingfeng.example.controller;

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
 * @author Administrator
 * @title: WatermarkController
 * @projectName com.qingfeng
 * @description: TODO
 * @date 2021/3/18 001817:07
 */
@Controller
@RequestMapping(value = "/example/watermark")
public class WatermarkController extends BaseController {


    /**
     * @title: image
     * @description: 图片水印
     * @author: Administrator
     * @date: 2021/3/18 0018 17:09
     */
    @RequestMapping(value = "/imagePage", method = RequestMethod.GET)
    public String imagePage(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/example/watermark/image_watermark";
    }


    @RequestMapping(value = "/htmlPage", method = RequestMethod.GET)
    public String htmlPage(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/example/watermark/html_watermark";
    }


}