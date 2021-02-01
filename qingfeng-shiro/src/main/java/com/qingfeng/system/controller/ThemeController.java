package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.LoginService;
import com.qingfeng.system.service.ThemeService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;

/**  
 * @Title: ThemeController
 * @ProjectName wdata
 * @Description: 主题设置Controller
 * @author anxingtao
 * @date 2020-9-28 17:45
 */
@Controller
@RequestMapping(value = "/system/theme")
public class ThemeController extends BaseController {

	@Autowired
	private ThemeService themeService;
	@Autowired
	private UserService userService;
	@Autowired
	public LoginService loginService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:45 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/theme/theme_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:46 
	 */
	@RequestMapping(value = "/findListPage", method = RequestMethod.GET)
	public void findListPage(Page page, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
		PageData pd = new PageData(request);
		//处理数据权限
		page = dealDataAuth(page,pd,session);
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
		List<PageData> list = themeService.findListPage(page);
		int num = themeService.findListSize(page);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setCode(0);
		json.setCount(num);
		json.setData(list);
		json.setSuccess(true);
		this.writeJson(response,json);
	}

    /** 
     * @Description: findList 
     * @Param: [request, response] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-28 17:46 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = themeService.findList(pd);
        Json json = new Json();
        json.setMsg("获取数据成功。");
        json.setData(list);
        json.setSuccess(true);
        this.writeJson(response,json);
    }

	/** 
	 * @Description: findInfo
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:46 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = themeService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/theme/theme_info";
	}


	/**
	 * @Description: toAdd
	 * @Param: [map, request]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:46
	 */
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/theme/theme_add";
	}

	/**
	 * @Description: save
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:46
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
        pd.put("id", GuidUtil.getUuid());
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		int num = themeService.save(pd);
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	
	/** 
	 * @Description: saveTheme 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 21:57 
	 */ 
	@RequestMapping(value = "/saveTheme", method = RequestMethod.POST)
	public void saveTheme(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		String file_name = "theme_1_"+GuidUtil.getGuid();
		//主题内容：index_style 需要保存为css
//		String relativelyPath=System.getProperty("user.dir");
		String contexPath= request.getSession().getServletContext().getRealPath("/");
		//img 图片 base64位需要存储为图片
		String img = pd.get("img").toString().substring(pd.get("img").toString().indexOf("base64,") + 7);
		String imgPath = contexPath+"/resources/plugins/xadmin/css/theme/"+file_name+".png";
		Base64ImgUtil.convertBase64ToFile(img,imgPath);

		String filePath = contexPath+"/resources/plugins/xadmin/css/theme/"+file_name+".css";
		FileExport.writeFile(filePath,pd.get("index_style").toString());

		//主键id
		String theme_id = GuidUtil.getUuid();
		pd.put("id", theme_id);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("status","0");
		pd.put("type","1");
		pd.put("file_path","/resources/plugins/xadmin/css/theme/"+file_name+".png");
		pd.put("file_name",file_name);
		pd.put("content",pd.get("index_style").toString());
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));
		themeService.save(pd);

		//切换主题
		//将所有的个人信息use_status更新为：1
		PageData param = new PageData();
		param.put("id",user.get("id"));
		param.put("theme_id",theme_id);
		param.put("update_time",DateTimeUtil.getDateTimeStr());
		userService.update(param);
		//更新成功重新刷新用户session
		pd.put("login_id",user.get("id"));
		PageData uPd = loginService.findUserInfo(pd);
		session.setAttribute("loginUser", uPd);

		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-29 9:16 
	 */ 
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("update_user",user.get("id"));
		int num = themeService.update(pd);
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	/** 
	 * @Description: del
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:47 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		String contexPath= request.getSession().getServletContext().getRealPath("/");
		for (int i = 0; i < ids.length; i++) {
			pd.put("id",ids[i]);
			PageData p = themeService.findInfo(pd);
			if(Verify.verifyIsNotNull(p)){
				File imgFile = new File(contexPath+p.get("file_path"));
				imgFile.delete();imgFile.deleteOnExit();
				File cssFile = new File(contexPath+"/resources/plugins/xadmin/css/theme/"+p.get("file_name")+".css");
				cssFile.delete();cssFile.deleteOnExit();
			}
		}
		themeService.del(ids);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: updateStatus 
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:47 
	 */ 
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		themeService.update(pd);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


}
