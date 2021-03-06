package com.qingfeng.common.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.util.DateTimeUtil;
import com.qingfeng.util.GuidUtil;
import com.qingfeng.util.Json;
import com.qingfeng.util.PageData;
import com.qingfeng.util.upload.ParaUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

/**  
 * @Title: backController
 * @ProjectName com.qingfeng
 * @Description: TODO
 * @author wangcong
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
        mv.setViewName("web/base/index");
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
        mv.setViewName("web/base/treeTable");
        return mv;
    }

    @RequestMapping("/verifyCode")
    public ModelAndView verifyCode(HttpServletRequest request, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("web/base/verifyCode");
        return mv;
    }



    /**
     * @title: toCreateCert
     * @description: 测试-证书生成
     * @author: Administrator
     * @date: 2021/3/6 0006 11:37
     */
    @RequestMapping("/toCreateCert")
    public ModelAndView toCreateCert(HttpServletRequest request, HttpSession session) {
        PageData pd = new PageData();
        pd.put("name","王宝强");
        pd.put("code","SD202103010001");
        pd.put("start_date",DateTimeUtil.getBeforeDaty(10));
        pd.put("end_date",DateTimeUtil.getDate());
        pd.put("kc_name","青锋微课堂-青锋后台系统开源产品培训");
        pd.put("class_time","48");
        ModelAndView mv = new ModelAndView();
        mv.addObject("pd",pd);
        mv.setViewName("web/base/cert");
        return mv;
    }

    /**
     * @title: createCert
     * @description:
     * 参数：开始日期：start_date、结束日期：start_date，课程名称：kc_name，学时：class_time
     * 姓名：name，证书编号：code
     * @author: Administrator
     * @date: 2021/3/6 0006 11:36
     */
    @RequestMapping(value = "/createCert", method = RequestMethod.GET)
    public void createCert(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
        PageData pd = new PageData(request);
        String tempPath = session.getServletContext().getRealPath("/") + "/resources/images/cert.jpg";
        String path = ParaUtil.common+"cert/"+ GuidUtil.getGuid()+".png";
		String fontPath = session.getServletContext().getRealPath("/") + "/resources/fonts/msyh.ttf";
//        String fontPath = ParaUtil.localName + "/resources/fonts/msyh.ttf";

        String line = pd.get("start_date").toString()+"至"+pd.get("end_date").toString()+"参加"+pd.get("kc_name")+
                "学习，计"+pd.get("class_time")+"学时。";

        //月份
        SimpleDateFormat sdf = new SimpleDateFormat("MM");
        String month = sdf.format(new Date());
        //电子章
        String url = session.getServletContext().getRealPath("/") + "/resources/images/qingfeng_dzz.png";
        InputStream inputStream=new FileInputStream(url);
        compositePicture(tempPath,ParaUtil.localName+path,pd.get("name").toString()+"：",pd.get("code").toString(),line, DateTimeUtil.getCurrentYear(),month,fontPath,inputStream);

        pd.put("show_cert_path", ParaUtil.cloudfile+path);
        pd.put("cert_path",path);
        Json json = new Json();
        json.setSuccess(true);
        json.setMsg("生成证书成功。");
        this.writeJson(response,json);
    }


    /**
     * @title: compositePicture
     * @description: 生成证书
     * @author: Administrator
     * @date: 2021/3/6 0006 11:26
     */
    public static String compositePicture(String path,String outPath, String title,String code,String line, String year, String month,String fontPath,InputStream inputStream) {
        try {
            // 加载背景图片
            BufferedImage imageLocal = ImageIO.read(new File(path));
            int srcImgWidth = imageLocal.getWidth(null);
            int srcImgHeight = imageLocal.getHeight(null);
            System.out.println("srcImgWidth:"+srcImgWidth+",srcImgHeight:"+srcImgHeight);

            // 以背景图片为模板
            Graphics2D g = imageLocal.createGraphics();
            // 消除文字锯齿
            g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            InputStream is = new FileInputStream(new File(fontPath));
            // 在模板上添加用户二维码(地址,左边距,上边距,图片宽度,图片高度,未知)
//			Font font1 = new Font("微软雅黑", Font.PLAIN, 50);// 添加字体的属性设置
            Font font1 = Font.createFont(Font.TRUETYPE_FONT, is);
            font1 = font1.deriveFont(Font.PLAIN,50);
            g.setFont(font1);
            Color color1 = new Color(133,95,43);
            g.setColor(color1);
            // 姓名
            g.drawString(title, 182, 460);

//			Font font2 = new Font("微软雅黑", Font.PLAIN, 30);// 添加字体的属性设置
            InputStream is1 = new FileInputStream(new File(fontPath));
            Font font2 = Font.createFont(Font.TRUETYPE_FONT, is1);
            font2 = font2.deriveFont(Font.PLAIN,30);
            g.setFont(font2);
            Color color2 = new Color(133,95,43);
            g.setColor(color2);
            // code
            g.drawString(code, 1130, 382);
            // 年
            g.drawString(year, 962, 926);
            // 月
            g.drawString(month, 1078, 926);
            // class_time
//			Font font3 = new Font("微软雅黑", Font.PLAIN, 38);// 添加字体的属性设置
            InputStream is2 = new FileInputStream(new File(fontPath));
            Font font3 = Font.createFont(Font.TRUETYPE_FONT, is2);
            font3 = font3.deriveFont(Font.PLAIN,38);
            g.setFont(font3);
            String one_line = line.substring(0,36);
            String two_line = line.substring(36);
            g.drawString(one_line, 260, 550);
            g.drawString(two_line, 180, 610);

            // 加盖电子章
            BufferedImage imageCode = ImageIO.read(inputStream);
            g.drawImage(imageCode, 920, imageLocal.getHeight() - 400, 260, 260, null);
            // 完成模板修改
            g.dispose();
            // 判断新文件的地址路径是否存在，如果不存在就创建一个
            File outputfile = new File(outPath);
            if (!outputfile.getParentFile().exists()) {
                outputfile.getParentFile().mkdirs();
            }
            // 生成新的合成过的用户二维码并写入新图片
            ImageIO.write(imageLocal, "png", outputfile);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return outPath;
    }



}
