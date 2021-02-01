package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.GroupService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.*;
import net.sf.jxls.transformer.XLSTransformer;
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
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Title: GroupController
 * @ProjectName com.qingfeng
 * @Description: 用户组Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/system/group")
public class GroupController extends BaseController {

	@Autowired
	private GroupService groupService;
	@Autowired
	private UserService userService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/group/group_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
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
		List<PageData> list = groupService.findListPage(page);
		int num = groupService.findListSize(page);
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
     * @Date: 2020-9-22 22:48 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = groupService.findList(pd);
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
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = groupService.findInfo(pd);
		//查询组用户
		pd.put("group_id",p.get("id"));
		List<PageData> list = groupService.findGroupUser(pd);
		map.put("list",list);
		map.put("listJson", JsonToMap.list2json(list));
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/group/group_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/group/group_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
		String id = GuidUtil.getUuid();
        pd.put("id", id);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("type","1");
		pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));
		int num = groupService.save(pd);
		if(num==1){
			String[] user_ids = pd.get("user_ids").toString().split(",");
			String[] user_names = pd.get("user_names").toString().split(",");
			for (int i = 0; i < user_ids.length; i++) {
				PageData param = new PageData();
				param.put("id",GuidUtil.getGuid());
				param.put("user_id",user_ids[i]);
				param.put("group_id",id);
				param.put("create_time", time);
				param.put("create_user",user.get("id"));
				groupService.saveGroupUser(param);
			}
		}
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
	 * @Date: 2020-9-23 22:54
	 */
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/group/group_addMore";
		return return_url;
	}

	/**
	 * @Description: saveMore
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-23 22:32
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
		String[] user_ids = request.getParameterValues("user_ids");
		for (int i = 0; i < name.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			pd.put("name",name[i]);
			pd.put("short_name",short_name[i]);
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			groupService.save(pd);
			//处理组织信息
			PageData param = new PageData();
			param.put("group_id",id);
			String[] uids = user_ids[i].split(",");
			for (int j = 0; j < uids.length; j++) {
				param.put("id",GuidUtil.getGuid());
				param.put("user_id",uids[j]);
				param.put("create_time", time);
				param.put("create_user",user.get("id"));
				groupService.saveGroupUser(param);
			}
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
	 * @Date: 2020-9-22 22:48 
	 */ 	
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = groupService.findInfo(pd);
		//查询组用户
		pd.put("group_id",p.get("id"));
		List<PageData> list = groupService.findGroupUser(pd);
		map.put("list",list);
		map.put("listJson", JsonToMap.list2json(list));
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/group/group_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String id = pd.get("id").toString();
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		pd.put("update_user","1");
		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("update_user",user.get("id"));
		int num = groupService.update(pd);
		if(num==1){
			PageData param = new PageData();
			//先执行删除
			param.put("group_id",id);
			groupService.delGroupUser(param);
			//处理组织信息
			String[] user_ids = pd.get("user_ids").toString().split(",");
			String[] user_names = pd.get("user_names").toString().split(",");
			for (int i = 0; i < user_ids.length; i++) {
				param.put("id",GuidUtil.getGuid());
				param.put("user_id",user_ids[i]);
				param.put("create_time", time);
				param.put("create_user",user.get("id"));
				groupService.saveGroupUser(param);
			}
		}
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
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		//删除组用户关联表
		pd.put("group_ids", Arrays.asList(ids));
		userService.delUserGroup(pd);
		groupService.del(ids);
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
	 * @Date: 2020-9-22 22:49 
	 */ 
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		groupService.update(pd);

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
	 * @Date: 2020-9-23 22:59
	 */
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = groupService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_group.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_group.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统用户组基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}


}
