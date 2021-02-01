package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.DictionaryService;
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
 * @Title: DictionaryController
 * @ProjectName com.qingfeng
 * @Description: 字典Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/system/dictionary")
public class DictionaryController extends BaseController {

	@Autowired
	private DictionaryService dictionaryService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/dictionary/dictionary_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:47 
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
		List<PageData> list = dictionaryService.findListPage(page);
		int num = dictionaryService.findListSize(page);
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
     * @Date: 2020-9-22 22:47 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = dictionaryService.findList(pd);
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
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = dictionaryService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/dictionary/dictionary_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:47 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/dictionary/dictionary_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:47 
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		System.out.println("#############:"+pd.get("code"));
		PageData param = new PageData();
		param.put("codes", Arrays.asList(pd.get("code").toString().split(",")));
		List<PageData> list = dictionaryService.findList(param);
		System.out.println(list.size());
		if(list.size()>0){
			String msg = "字典编码："+pd.get("code")+"已经存在。";
			json.setSuccess(false);
			json.setMsg(msg);
		}else{
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

			pd.put("dic_cascade", pd.get("dic_cascade").toString()+id+"_");
			pd.put("level_num",Integer.parseInt(pd.get("level_num").toString())+1);
			dictionaryService.save(pd);

			json.setSuccess(true);
			json.setMsg("操作成功。");
		}
		this.writeJson(response,json);
	}


	/**
	 * @Description: toAddMore
	 * @Param: [map, request]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-23 23:51
	 */
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/dictionary/dictionary_addMore";
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
		Json json = new Json();
		String[] code = request.getParameterValues("code");
		PageData param = new PageData();
		param.put("codes", Arrays.asList(code));
		List<PageData> list = dictionaryService.findList(param);
		if(list.size()>0){
			String msg = "字典编码：";
			for (PageData p:list) {
				msg=msg+","+p.get("code");
			}
			msg = msg+"已经存在。";
			json.setSuccess(false);
			json.setMsg(msg);
		}else{
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
			String dic_cascade = pd.get("dic_cascade").toString();
			for (int i = 0; i < name.length; i++) {
				String id = GuidUtil.getUuid();
				pd.put("id", id);
				pd.put("name",name[i]);
				pd.put("short_name",short_name[i]);
				pd.put("code",code[i]);
				pd.put("order_by",order_by[i]);
				pd.put("remark",remark[i]);
				pd.put("dic_cascade", dic_cascade+id+"_");
				dictionaryService.save(pd);
			}
			json.setSuccess(true);
			json.setMsg("操作成功。");
		}

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
		PageData p = dictionaryService.findInfo(pd);
		map.put("p",p);
		return "web/system/dictionary/dictionary_update";
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
		PageData p = dictionaryService.findInfo(pd);
		Json json = new Json();
		if(pd.get("code").equals(p.get("code"))){
			String time = DateTimeUtil.getDateTimeStr();
			pd.put("update_time", time);
			PageData user = (PageData) session.getAttribute("loginUser");
			pd.put("update_user",user.get("id"));
			dictionaryService.update(pd);
			json.setSuccess(true);
			json.setMsg("操作成功。");
		}else{
			PageData param = new PageData();
			param.put("codes", Arrays.asList(pd.get("code").toString().split(",")));
			List<PageData> list = dictionaryService.findList(param);
			if(list.size()>0){
				String msg = "字典编码："+pd.get("code")+"已经存在。";
				json.setSuccess(false);
				json.setMsg(msg);
			}else{
				String time = DateTimeUtil.getDateTimeStr();
				pd.put("update_time", time);
				PageData user = (PageData) session.getAttribute("loginUser");
				pd.put("update_user",user.get("id"));
				dictionaryService.update(pd);
				json.setSuccess(true);
				json.setMsg("操作成功。");
			}
		}
		this.writeJson(response,json);
	}


	/** 
	 * @Description: del 
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:48 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		dictionaryService.del(ids);
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
		dictionaryService.update(pd);

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
	 * @Date: 2020-9-24 0:18 
	 */ 
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = dictionaryService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_dictionary.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_dictionary.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统字典基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}


	/**
	 * @Description: findInfoJson
	 * @Param: [request, response]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-10-13 22:52
	 */
	@RequestMapping(value = "/findInfoJson", method = RequestMethod.GET)
	public void findInfoJson(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		pd.put("ids",Arrays.asList(pd.get("id").toString().split(",")));
		List<PageData> list = dictionaryService.findList(pd);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setData(list);
		json.setSuccess(true);
		this.writeJson(response,json);
	}

}
