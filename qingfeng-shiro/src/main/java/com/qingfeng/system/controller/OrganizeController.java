package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.OrganizeService;
import com.qingfeng.system.service.RoleService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.*;
import net.sf.jxls.transformer.XLSTransformer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
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
 * @Title: OrganizeController
 * @ProjectName com.qingfeng
 * @Description: 组织Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/system/organize")
public class OrganizeController extends BaseController {

	@Autowired
	private OrganizeService organizeService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private UserService userService;
	@Autowired
	private PlatformTransactionManager txManager;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/organize/organize_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
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
		List<PageData> list = organizeService.findListPage(page);
		int num = organizeService.findListSize(page);
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
     * @Date: 2020-9-22 22:50 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
    	PageData pd = new PageData(request);

		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		if(!user.get("type").equals("0")){//管理员
			pd.put("org_cascade",organize.get("org_cascade"));
		}
    	List<PageData> list = organizeService.findList(pd);
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
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = organizeService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/organize/organize_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/organize/organize_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
		String id = GuidUtil.getUuid();
        pd.put("id", id);
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

		pd.put("org_cascade", pd.get("org_cascade").toString()+id+"_");
		pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
		int num = organizeService.save(pd);
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
	 * @Date: 2020-9-24 15:50 
	 */ 
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/organize/organize_addMore";
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
		pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
		String org_cascade = pd.get("org_cascade").toString();
		for (int i = 0; i < name.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			pd.put("name",name[i]);
			pd.put("short_name",short_name[i]);
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			pd.put("org_cascade", org_cascade+id+"_");
			organizeService.save(pd);
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
	 * @Date: 2020-9-22 22:50 
	 */ 
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = organizeService.findInfo(pd);
		map.put("p",p);
		return "web/system/organize/organize_update";
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
		//处理数据权限
        PageData user = (PageData) session.getAttribute("loginUser");
        pd.put("update_user",user.get("id"));
		int num = organizeService.update(pd);
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
		pd.put("organize_ids",Arrays.asList(ids));
		//删除用户组织信息
		userService.delUserOrganize(pd);
		//删除组织角色信息
		organizeService.delOrganizeRole(pd);
		organizeService.del(ids);
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
		organizeService.update(pd);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: selectUser 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-25 8:51 
	 */ 
	@RequestMapping(value = "/selectOneOrganize", method = RequestMethod.GET)
	public String selectUser(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/organize/organize_selectOneOrganize";
	}

	/** 
	 * @Description: selectMoreUser
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-25 8:52 
	 */ 
	@RequestMapping(value = "/selectMoreOrganize", method = RequestMethod.GET)
	public String selectMoreUser(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/organize/organize_selectMoreOrganize";
	}

	/**
	 * @Description: exportData
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-26 14:40
	 */
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = organizeService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_organize.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_organize.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统组织基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}


	/** 
	 * @Description: toAssignRoleAuth
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 15:45 
	 */ 
	@RequestMapping(value = "/toAssignRoleAuth", method = RequestMethod.GET)
	public String toAssignRoleAuth(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		pd.put("organize_id",pd.get("id"));
		List<PageData> roleLs = roleService.findSimpleList(pd);
		map.put("roleLs",JsonToMap.list2json(roleLs));

		List<PageData> myRoleLs = organizeService.findOrganizeRoleList(pd);
		map.put("myRoleLs",JsonToMap.list2json(myRoleLs));

		map.put("pd",pd);
		return "web/system/organize/organize_roleAuth";
	}

	/**
	 * @Description: updateAuth
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-26 16:05
	 */
	@RequestMapping(value = "/updateAuth", method = RequestMethod.POST)
	public void updateAuth(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		PageData user = (PageData) session.getAttribute("loginUser");
		try {
			String time = DateTimeUtil.getDateTimeStr();
			String[] role_ids = pd.get("role_ids").toString().split(",");
			//删除用户角色表。
			pd.put("organize_id",pd.get("id"));
			pd.put("role_ids", Arrays.asList(role_ids));
			organizeService.delOrganizeRole(pd);
			if(Verify.verifyIsNotNull(pd.get("role_ids"))){
				System.out.println("###:"+pd.get("role_ids").toString());
				String organize_id = pd.get("id").toString();
				List<PageData> list = new ArrayList<PageData>();
				//执行保存
				for (int i = 0; i < role_ids.length; i++) {
					PageData p = new PageData();
					//主键id
					p.put("id",GuidUtil.getUuid());
					p.put("role_id",role_ids[i]);
					p.put("organize_id",organize_id);
					p.put("create_time",time);
					p.put("create_user",user.get("id"));
					p.put("update_time",time);
					list.add(p);
				}
				organizeService.saveOrganizeRole(list);
			}
			json.setSuccess(true);
			json.setMsg("操作成功。");
			txManager.commit(status);
		} catch (Exception ex) {
			json.setSuccess(false);
			json.setMsg("操作异常，请联系管理员");
			txManager.rollback(status);
			ex.printStackTrace();
		}
		this.writeJson(response,json);
	}




}
