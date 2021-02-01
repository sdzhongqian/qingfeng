package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.framework.shiro.service.ShiroService;
import com.qingfeng.system.service.OrganizeService;
import com.qingfeng.system.service.RoleService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.*;
import net.sf.jxls.transformer.XLSTransformer;
import org.apache.shiro.authz.annotation.RequiresPermissions;
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
import java.util.*;

/**
 * @Title: RoleController
 * @ProjectName com.qingfeng
 * @Description: 角色Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/system/role")
public class RoleController extends BaseController {

	@Autowired
	private RoleService roleService;
	@Autowired
	private OrganizeService organizeService;
	@Autowired
	private UserService userService;
	@Autowired
	private ShiroService shiroService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("roleList")
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/role/role_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("roleList")
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
		List<PageData> list = roleService.findListPage(page);
		int num = roleService.findListSize(page);
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
     * @Date: 2020-9-22 22:51 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = roleService.findList(pd);
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
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:info")
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = roleService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/role/role_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:add")
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/role/role_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:add")
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
        pd.put("id", GuidUtil.getUuid());
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("update_time", time);
		pd.put("type","1");
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		int num = roleService.save(pd);
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
	 * @Date: 2020-9-23 22:32
	 */
	@RequiresPermissions("role:addMore")
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/role/role_addMore";
		return return_url;
	}

	/**
	 * @Description: saveMore
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-23 22:32
	 */
	@RequiresPermissions("[role:addMore]")
	@RequestMapping(value = "/saveMore", method = RequestMethod.POST)
	public void saveMore(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		//处理时间
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("type","1");
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		String[] name = request.getParameterValues("name");
		String[] short_name = request.getParameterValues("short_name");
		String[] order_by = request.getParameterValues("order_by");
		String[] remark = request.getParameterValues("remark");
		for (int i = 0; i < name.length; i++) {
			pd.put("id", GuidUtil.getUuid());
			pd.put("name",name[i]);
			pd.put("short_name",short_name[i]);
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			roleService.save(pd);
		}
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
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:update")
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = roleService.findInfo(pd);
		map.put("p",p);
		return "web/system/role/role_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:update")
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
        pd.put("update_user",user.get("id"));
		int num = roleService.update(pd);
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
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("role:del")
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		pd.put("role_ids",Arrays.asList(ids));
		//删除组织角色信息
		organizeService.delOrganizeRole(pd);
		//删除组织角色
		userService.delUserRole(pd);
		//删除角色菜单
		roleService.delRoleMenu(pd);
		roleService.del(ids);
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
		roleService.update(pd);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: exportData 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-23 23:21
	 */
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = roleService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_role.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_role.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统角色基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}


	/** 
	 * @Description: toSetAuth 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 14:51 
	 */
	@RequestMapping(value = "/toSetAuth", method = RequestMethod.GET)
	public String toSetAuth(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/role/role_auth";
	}

	/** 
	 * @Description: findRoleMenuList 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 14:51 
	 */ 
	@RequestMapping(value = "/findRoleMenuList", method = RequestMethod.GET)
	public void findRoleMenuList(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		List<PageData> list = roleService.findRoleMenuList(pd);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setData(list);
		json.setSuccess(true);
		this.writeJson(response,json);
	}

	/** 
	 * @Description: saveRoleMenu
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 14:57 
	 */ 
	@RequestMapping(value = "/saveRoleMenu", method = RequestMethod.POST)
	public void saveRoleMenu(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		String role_id = pd.get("role_id").toString();
		String time = DateTimeUtil.getDateTimeStr();
		PageData user = (PageData) session.getAttribute("loginUser");
		String[] ids = pd.get("ids").toString().split(",");
		pd.put("menu_ids", Arrays.asList(ids));
		roleService.delRoleMenu(pd);
		List<PageData> list = new ArrayList<PageData>();
		for (int i = 0; i < ids.length; i++) {
			PageData param = new PageData();
			//主键id
			param.put("id",GuidUtil.getUuid());
			param.put("menu_id",ids[i]);
			param.put("role_id",role_id);
			param.put("create_user",user.get("id"));
			param.put("create_time",time);
			list.add(param);
		}
		roleService.saveRoleMenu(list);
		//重新加载权限
		shiroService.reloadAuthorizingByRoleId(role_id);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}
	
	


}
