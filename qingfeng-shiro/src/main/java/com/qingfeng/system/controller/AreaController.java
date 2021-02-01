package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.AreaService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Title: AreaController
 * @ProjectName com.qingfeng
 * @Description: 地区Controller层
 * @author anxingtao
 * @date 2020-9-22 22:44
 */
@Controller
@RequestMapping(value = "/system/area")
public class AreaController extends BaseController {

	@Autowired
	private AreaService areaService;

	/**
	 * @Description: index 跳转list页面
	 * @Param: [map, request, response]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46
	 */
	@RequiresPermissions("areaList")
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/area/area_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46 
	 */
	@RequiresPermissions("areaList")
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
		List<PageData> list = areaService.findListPage(page);
		int num = areaService.findListSize(page);
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
     * @Date: 2020-9-22 22:46 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = areaService.findList(pd);
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
	 * @Date: 2020-9-22 22:46 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = areaService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/area/area_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/area/area_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46 
	 */ 
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception  {
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
		pd.put("area_cascade", pd.get("area_cascade").toString()+id+"_");
		pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
		Pinyin4JUtil pinyin4JUtil = new Pinyin4JUtil();
		pd.put("en_name", pinyin4JUtil.getFullSpell(pd.get("name").toString()));
		pd.put("en_short_name", pinyin4JUtil.toPinYinUppercase(pd.get("name").toString()));
		int num = areaService.save(pd);
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
	 * @Date: 2020-9-24 0:32
	 */
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/area/area_addMore";
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
		String area_cascade = pd.get("area_cascade").toString();
		Pinyin4JUtil pinyin4JUtil = new Pinyin4JUtil();
		for (int i = 0; i < name.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			pd.put("name",name[i]);
			pd.put("short_name",short_name[i]);
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			pd.put("area_cascade", area_cascade+id+"_");
			pd.put("en_name", pinyin4JUtil.getFullSpell(name[i]));
			pd.put("en_short_name", pinyin4JUtil.toPinYinUppercase(name[i]));
			areaService.save(pd);
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
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = areaService.findInfo(pd);
		map.put("p",p);
		return "web/system/area/area_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
        pd.put("update_user",user.get("id"));
		int num = areaService.update(pd);
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
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		areaService.del(ids);
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
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		areaService.update(pd);
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
	 * @Date: 2020-9-24 0:38 
	 */ 
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = areaService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_area.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_area.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统地区基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}



}
