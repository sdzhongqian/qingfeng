package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.LoggerService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
* @author anxingtao
* @Title: LoggerController
* @ProjectName wdata
* @Description: 自定义数据表分类
* @date 2018-9-314:44
*/
@Controller
@RequestMapping(value = "/system/logger")
public class LoggerController extends BaseController {

	@Autowired
	private LoggerService loggerService;

	/**
	* @Description: index
	* @Param: [map, request, response]
	* @return: java.lang.String
	* @Author: anxingtao
	* @Date: 2018-9-3 15:00
	*/
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/logger/logger_list";
	}

	/**
	* @Description: findListPage
	* @Param: [page, request, response, session]
	* @return: void
	* @Author: anxingtao
	* @Date: 2018-9-3 15:00
	*/
	@RequestMapping(value = "/findListPage", method = RequestMethod.GET)
	public void findListPage(Page page, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
		PageData pd = new PageData(request);
		//处理数据权限
//		page = dealDataAuth(page,pd,session);
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
		List<PageData> list = loggerService.findListPage(page);
		int num = loggerService.findListSize(page);
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
    * @Date: 2018-9-3 15:01
    */
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = loggerService.findList(pd);
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
	* @Date: 2018-9-3 15:01
	*/
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = loggerService.findInfo(pd);
		map.addAttribute("p",p);
		return "web/system/logger/logger_info";
	}


	/**
	* @Description: del
	* @Param: [request, response]
	* @return: void
	* @Author: anxingtao
	* @Date: 2018-9-3 15:03
	*/
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		loggerService.del(ids);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: exportData
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-27 17:16
	 */ 
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
//		pd = dealDataAuth(pd, session);
		List<PageData> list = loggerService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_logger.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_logger.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统登录/操作日志信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}






}
