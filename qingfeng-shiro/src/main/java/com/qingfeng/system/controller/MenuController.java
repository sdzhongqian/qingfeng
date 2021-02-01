package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.framework.shiro.service.ShiroService;
import com.qingfeng.system.service.MenuService;
import com.qingfeng.system.service.RoleService;
import com.qingfeng.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * @Title: MenuController
 * @ProjectName com.qingfeng
 * @Description: 菜单Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/system/menu")
public class MenuController extends BaseController {

	@Autowired
	private MenuService menuService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private ShiroService shiroService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/menu/menu_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:49 
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
		List<PageData> list = menuService.findListPage(page);
		int num = menuService.findListSize(page);
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
     * @Date: 2020-9-22 22:49 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = menuService.findList(pd);
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
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = menuService.findInfo(pd);
		//查询菜单下的功能菜单
		pd.put("parent_id",pd.get("id"));
		pd.put("type","button");
		List<PageData> list = menuService.findList(pd);
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/menu/menu_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/menu/menu_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
		String id = GuidUtil.getUuid();
        pd.put("id", id);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("type","menu");
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		pd.put("menu_cascade", pd.get("menu_cascade").toString()+id+"_");
		pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
		int num = menuService.save(pd);
		if(num==1){
			//添加功能菜单
			if(Verify.verifyIsNotNull(pd.get("open_button"))){
				if(pd.get("open_button").equals("on")){
					String[] button_name = request.getParameterValues("button_name");
					String[] button_code = request.getParameterValues("button_code");
					String[] button_order_by = request.getParameterValues("button_order_by");
					int lv = Integer.parseInt(pd.get("level_num").toString());
					for (int i = 0; i < button_name.length; i++) {
						PageData p = new PageData();
						//主键id
						p.put("id",GuidUtil.getUuid());
						p.put("menu_cascade",pd.get("menu_cascade").toString()+"_"+p.get("id").toString());
						p.put("name",button_name[i]);
						p.put("code",button_code[i]);
						p.put("parent_id",pd.get("id"));
						p.put("type","button");
						p.put("level_num", lv+1);
						p.put("order_by",button_order_by[i]);
						p.put("create_time", time);
						p.put("create_user",pd.get("create_user"));
						p.put("create_organize","1");
						menuService.save(p);
					}
				}
			}
		}
		//重新加载权限
		shiroService.updatePermission();
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	/**
	 * @Description: toAddMore
	 * @Param: [map, request]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-24 16:06
	 */
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/menu/menu_addMore";
		return return_url;
	}

	/**
	 * @Description: saveMore
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-23 23:51
	 */
	@RequestMapping(value = "/saveMore", method = RequestMethod.POST)
	public void saveMore(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		//处理时间
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		String[] name = request.getParameterValues("name");
		String[] code = request.getParameterValues("code");
		String[] url = request.getParameterValues("url");
		String[] icon = request.getParameterValues("icon");

		String[] order_by = request.getParameterValues("order_by");
		String[] remark = request.getParameterValues("remark");
		pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
		String menu_cascade = pd.get("menu_cascade").toString();
		for (int i = 0; i < name.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			pd.put("name",name[i]);
			pd.put("code",code[i]);
			pd.put("url",url[i]);
			pd.put("icon",icon[i]);
			pd.put("type","menu");
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			pd.put("menu_cascade", menu_cascade+id+"_");
			menuService.save(pd);
		}
		//重新加载权限
		shiroService.updatePermission();
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: toUpdate 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = menuService.findInfo(pd);
		//查询菜单下的功能菜单
		pd.put("parent_id",pd.get("id"));
		pd.put("type","button");
		List<PageData> list = menuService.findList(pd);
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/menu/menu_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
        pd.put("update_user",user.get("id"));
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		int num = menuService.update(pd);
		if(num==1){
			//添加功能菜单
			if(Verify.verifyIsNotNull(pd.get("open_button"))){
				if(pd.get("open_button").equals("on")){
					String[] button_id = request.getParameterValues("button_id");
					String[] button_name = request.getParameterValues("button_name");
					String[] button_code = request.getParameterValues("button_code");
					String[] button_order_by = request.getParameterValues("button_order_by");
					int lv = Integer.parseInt(pd.get("level_num").toString());
					for (int i = 0; i < button_name.length; i++) {
						PageData p = new PageData();
						//主键id
//						p.put("menu_cascade",pd.get("menu_cascade").toString()+"_"+p.get("id").toString());
						p.put("name",button_name[i]);
						p.put("code",button_code[i]);
						p.put("parent_id",pd.get("id"));
						p.put("type","button");
						p.put("level_num", lv+1);
						p.put("order_by",button_order_by[i]);
						p.put("create_time", time);
						p.put("create_user",user.get("id"));
						p.put("create_organize",organize.get("organize_id"));
						if(Verify.verifyIsNotNull(button_id[i])){
							p.put("id",button_id[i]);
							menuService.update(p);
						}else{
							//主键id
							p.put("id",GuidUtil.getUuid());
							p.put("menu_cascade", pd.get("menu_cascade").toString()+ "_"+p.get("id").toString());
							menuService.save(p);
						}
					}
				}
			}else{
				//先删除菜单
				pd.put("type","button");
				pd.put("parent_id",pd.get("id"));
				menuService.delForParam(pd);
			}
		}
		//重新加载权限
		shiroService.updatePermission();
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
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		pd.put("menu_ids", Arrays.asList(ids));
		//删除角色菜单
		roleService.delRoleMenu(pd);
		menuService.del(ids);
		//重新加载权限
		shiroService.updatePermission();
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
	 * @Date: 2020-9-22 22:52
	 */ 
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		menuService.update(pd);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


	/**
	 * @Description: findMenuList
	 * @Param: [request, response]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-27 21:50
	 */
	@RequestMapping(value = "/findMenuList", method = RequestMethod.GET)
	public void findMenuList(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		PageData mPd = menuService.findInfo(pd);

		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("user_id",user.get("id"));
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("organize_id",organize.get("organize_id"));
		pd.put("menu_cascade",mPd.get("menu_cascade"));
		pd.put("type","menu");
		List<PageData> menuList = menuService.findMenuList(pd);
		Json json = new Json();
		json.setSuccess(true);
		json.setData(menuList);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}




}
