package com.qingfeng.system.controller;

import cn.hutool.core.util.StrUtil;
import com.qingfeng.base.controller.BaseController;
import com.qingfeng.base.model.CommonConfig;
import com.qingfeng.system.service.GenCodeService;
import com.qingfeng.system.service.MenuService;
import com.qingfeng.util.*;
import com.qingfeng.util.freemarker.FreemarkerParaUtil;
import com.qingfeng.util.zip.ZipUtils;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.*;

/**
 * @Title: GenCodeController
 * @ProjectName wdata
 * @Description: 代码生成
 * @author anxingtao
 * @date 2020-10-9 13:13
 */
@Controller
@RequestMapping(value = "/system/gencode")
public class GenCodeController extends BaseController {

	@Autowired
	private GenCodeService genCodeService;
	@Autowired
	private CommonConfig commonConfig;
	@Autowired
	private MenuService menuService;
	@Autowired
	private FreeMarkerConfigurer freeMarkerConfigurer;
	private static String table_schema = "qingfeng_shiro";

	/**
	 * @Description: index 跳转list页面
	 * @Param: [map, request, response]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46
	 */
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/gencode/gencode_list";
	}

	/**
	 * @Description: 打开数据表导入页面
	 * @Param: [map, request, response]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-10-9 15:21
	 */
	@RequestMapping(value = "/toImportTable", method = RequestMethod.GET)
	public String toImportTable(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/gencode/select_table";
	}

	/**
	 * @Description: findTableListPage
	 * @Param: [page, request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-10-9 15:22
	 */
	@RequestMapping(value = "/findTableListPage", method = RequestMethod.GET)
	public void findTableListPage(Page page, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
		PageData pd = new PageData(request);
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
		pd.put("table_schema",table_schema);
		page.setPd(pd);
		List<PageData> list = genCodeService.findTableListPage(page);
		int num = genCodeService.findTableListSize(page);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setCode(0);
		json.setCount(num);
		json.setData(list);
		json.setSuccess(true);
		this.writeJson(response,json);
	}

	/** 
	 * @Description: updateTable 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-10-9 15:50 
	 */ 
	@RequestMapping(value = "/updateComment", method = RequestMethod.POST)
	public void updateTable(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		genCodeService.updateComment(pd);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
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
		//初始化数据表
		pd.put("table_schema",table_schema);
		pd.put("table_names", Arrays.asList(pd.get("table_names").toString().split(",")));
		List<PageData> list = genCodeService.findTableList(pd);
		String time = DateTimeUtil.getDateTimeStr();
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		if(list.size()>0){
			for (PageData param:list) {
				String[] table_name = param.get("table_name").toString().split("_");
				String id = GuidUtil.getUuid();
				param.put("id",id);
				param.put("type","0");
				param.put("temp_type","0");//单表
				param.put("pack_path","com.qingfeng");
				param.put("mod_name",table_name[0]);
				String bus_name = "";
				if(table_name.length>1){
					for (int i = 1; i < table_name.length; i++) {
						if(i==1){
							bus_name+= table_name[1];
						}else{
							bus_name+= StrUtil.upperFirst(table_name[i]);
						}
					}
				}else{
					bus_name = table_name[0];
				}
				param.put("tree_id",id);
				param.put("bus_name",bus_name);
				param.put("menu_name",param.get("table_comment"));
				param.put("gen_type","0");
				param.put("gen_path",PathUtil.getSystemPath());
				param.put("more_add","0");
				param.put("status_type","0");
				param.put("order_by","1");
				param.put("create_time", time);
				param.put("create_user",user.get("id"));
				param.put("create_organize",organize.get("organize_id"));

				//生成数据字段表
				pd.put("table_schema",table_schema);
				pd.put("table_name",param.get("table_name"));
				List<PageData> fieldList = genCodeService.findColumndList(pd);
				if(fieldList.size()>0){
					for (PageData fieldParam:fieldList) {
						fieldParam.put("id",GuidUtil.getUuid());
						fieldParam.put("type","0");
						fieldParam.put("table_id",id);
						fieldParam.put("field_name",fieldParam.get("column_name"));
						fieldParam.put("field_comment",fieldParam.get("column_comment"));
						fieldParam.put("field_type",fieldParam.get("data_type"));
						if(commonConfig.getGencodeField().contains(fieldParam.get("column_name").toString())){
							fieldParam.put("field_operat","N");
							fieldParam.put("field_list","N");
						}else{
							fieldParam.put("field_operat","Y");
							fieldParam.put("field_list","Y");
						}
						if(fieldParam.get("is_nullable").equals("NO")){
							fieldParam.put("verify_rule","required");
						}else{
							fieldParam.put("verify_rule","");
						}
						fieldParam.put("field_query","N");

						fieldParam.put("query_type","");
						fieldParam.put("show_type","1");
						fieldParam.put("order_by",fieldParam.get("ordinal_position"));
						fieldParam.put("remark",fieldParam.get("column_type"));
						fieldParam.put("create_time", time);
						fieldParam.put("create_user",user.get("id"));
						fieldParam.put("create_organize",organize.get("organize_id"));
					}
				}
				genCodeService.saveField(fieldList);
			}
		}
		genCodeService.saveTable(list);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:46 
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
		List<PageData> list = genCodeService.findListPage(page);
		int num = genCodeService.findListSize(page);
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

    	List<PageData> list = genCodeService.findList(pd);
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
		PageData p = genCodeService.findInfo(pd);
		pd.put("table_id",p.get("id"));
		List<PageData> list = genCodeService.findFieldList(pd);
		if(p.get("temp_type").equals("1")){//主子表，查询子表信息
			PageData linkTablePd = genCodeService.findTableLinkInfo(pd);
			pd.put("table_id",linkTablePd.get("link_table"));
			List<PageData> linkFieldList = genCodeService.findFieldList(pd);
//			linkTablePd.put("linkFieldList",linkFieldList);

			map.put("linkTablePd",linkTablePd);
			map.put("linkFieldList",linkFieldList);
		}
		//查询关联表
		pd.put("excludeIds",Arrays.asList(p.get("id").toString().split(",")));
		List<PageData> tableList = genCodeService.findList(pd);
		map.put("tableList",tableList);
		pd.put("excludeField",commonConfig.getGencodeField());
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/gencode/gencode_info";
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
		PageData p = genCodeService.findInfo(pd);
		pd.put("table_id",p.get("id"));
		List<PageData> list = genCodeService.findFieldList(pd);
		if(p.get("temp_type").equals("1")){//主子表，查询子表信息
			PageData linkTablePd = genCodeService.findTableLinkInfo(pd);
			pd.put("table_id",linkTablePd.get("link_table"));
			List<PageData> linkFieldList = genCodeService.findFieldList(pd);
//			linkTablePd.put("linkFieldList",linkFieldList);

			map.put("linkTablePd",linkTablePd);
			map.put("linkFieldList",linkFieldList);
		}
		//查询关联表
		pd.put("excludeIds",Arrays.asList(p.get("id").toString().split(",")));
		List<PageData> tableList = genCodeService.findList(pd);
		map.put("tableList",tableList);
		pd.put("excludeField",commonConfig.getGencodeField());
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/gencode/gencode_update";
	}

	/** 
	 * @Description: findFieldLinkList
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-10-12 9:02 
	 */ 
	@RequestMapping(value = "/findFieldLinkList", method = RequestMethod.GET)
	public void findFieldLinkList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		List<PageData> list = genCodeService.findFieldList(pd);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setData(list);
		json.setSuccess(true);
		this.writeJson(response,json);
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
		System.out.println("###:"+pd.toString());
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
        pd.put("update_user",user.get("id"));
		int num = genCodeService.update(pd);
		//更新子表信息
		String[] field_id = request.getParameterValues("field_id");
		String[] field_comment = request.getParameterValues("field_comment");
		String[] field_operat = request.getParameterValues("field_operat");
		String[] field_list = request.getParameterValues("field_list");
		String[] field_query = request.getParameterValues("field_query");
		String[] query_type = request.getParameterValues("query_type");
		String[] verify_rule = request.getParameterValues("verify_rule");
		String[] show_type = request.getParameterValues("show_type");
		String[] option_content = request.getParameterValues("option_content");
		String[] default_value = request.getParameterValues("default_value");
		String[] order_by = request.getParameterValues("table_order_by");
		for (int i = 0; i < field_id.length; i++) {
			PageData fieldPd = new PageData();
			fieldPd.put("id",field_id[i]);
			fieldPd.put("field_comment",field_comment[i]);
			fieldPd.put("field_operat",field_operat[i]);
			fieldPd.put("field_list",field_list[i]);
			fieldPd.put("field_query",field_query[i]);
			fieldPd.put("query_type",query_type[i]);
			fieldPd.put("verify_rule",verify_rule[i]);
			fieldPd.put("show_type",show_type[i]);
			fieldPd.put("option_content",option_content[i]);
			fieldPd.put("default_value",default_value[i]);
			fieldPd.put("order_by",order_by[i]);
			fieldPd.put("update_time", time);
			fieldPd.put("update_user",user.get("id"));
			genCodeService.updateField(fieldPd);
		}
		//处理关联信息
		if(pd.get("temp_type").equals("1")){
			PageData linkTablePd = new PageData();
			linkTablePd.put("table_id",pd.get("id"));
			linkTablePd.put("link_table",pd.get("link_table"));
			linkTablePd.put("link_field",pd.get("link_field"));
			if(Verify.verifyIsNotNull(pd.get("link_table_id"))){
				linkTablePd.put("id",pd.get("link_table_id"));
				linkTablePd.put("update_time",time);
				linkTablePd.put("update_user",user.get("id"));
				genCodeService.updateTableLink(linkTablePd);
			}else{
				linkTablePd.put("id",GuidUtil.getUuid());
				linkTablePd.put("create_time",time);
				linkTablePd.put("create_user",user.get("id"));
				linkTablePd.put("create_organize",organize.get("organize_id"));
				genCodeService.saveTableLink(linkTablePd);
			}
			//处理关联子表
			//更新子表信息
			String[] link_field_id = request.getParameterValues("link_field_id");
			String[] link_field_comment = request.getParameterValues("link_field_comment");
			String[] link_field_operat = request.getParameterValues("link_field_operat");
			String[] link_verify_rule = request.getParameterValues("link_verify_rule");
			String[] link_show_type = request.getParameterValues("link_show_type");
			String[] link_option_content = request.getParameterValues("link_option_content");
			String[] link_default_value = request.getParameterValues("link_default_value");
			String[] link_order_by = request.getParameterValues("link_order_by");
			for (int i = 0; i < link_field_id.length; i++) {
				PageData fieldPd = new PageData();
				fieldPd.put("id",link_field_id[i]);
				fieldPd.put("field_comment",link_field_comment[i]);
				fieldPd.put("field_operat",link_field_operat[i]);
				fieldPd.put("verify_rule",link_verify_rule[i]);
				fieldPd.put("show_type",link_show_type[i]);
				fieldPd.put("option_content",link_option_content[i]);
				fieldPd.put("default_value",link_default_value[i]);
				fieldPd.put("order_by",link_order_by[i]);
				fieldPd.put("update_time", time);
				fieldPd.put("update_user",user.get("id"));
				genCodeService.updateField(fieldPd);
			}
		}
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	@RequestMapping(value = "/toUpdateField", method = RequestMethod.GET)
	public String toUpdateField(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = genCodeService.findFieldInfo(pd);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/gencode/gencode_update_field";
	}


	/**
	 * @Description: updateField
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-10-12 15:30
	 */
	@RequestMapping(value = "/updateField", method = RequestMethod.POST)
	public void updateField(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("update_time", time);
		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("update_user",user.get("id"));
		int num = genCodeService.updateField(pd);
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
		genCodeService.delField(ids);
		genCodeService.del(ids);
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
		genCodeService.update(pd);
		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: gencode
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-10-12 22:21 
	 */ 
	@RequestMapping(value = "/gencode", method = RequestMethod.GET)
	public void gencode(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		PageData tablePd = genCodeService.findInfo(pd);
		PageData linkTablePd = new PageData();
		List<PageData> linkFieldList = new ArrayList<PageData>();
		pd.put("table_id",tablePd.get("id"));
		List<PageData> fieldList = genCodeService.findFieldList(pd);
		if(tablePd.get("temp_type").equals("1")){//主子表，查询子表信息
			linkTablePd = genCodeService.findTableLinkInfo(pd);
			pd.put("table_id",linkTablePd.get("link_table"));
			linkFieldList = genCodeService.findFieldList(pd);
		}


		if(tablePd.get("temp_type").equals("0")){//单表

		}else if(tablePd.get("temp_type").equals("1")){//主子表
			Iterator<PageData> itLs=linkFieldList.iterator();
			while(itLs.hasNext()){
				PageData p=itLs.next();
				if(p.get("field_name").equals(tablePd.get("link_field"))){
					itLs.remove();
				}
			}
		}else if(tablePd.get("temp_type").equals("2")){//树表
			Iterator<PageData> itLs=fieldList.iterator();
			while(itLs.hasNext()){
				PageData p=itLs.next();
				if(p.get("field_name").equals(tablePd.get("tree_pid"))){
					itLs.remove();
				}
			}
		}

		//1、创建数据模型
		Map<String,Object> root = new HashMap<String,Object>();
		//2、为数据模型添加值
		root.put("pd", pd);
		root.put("tablePd",tablePd);
		root.put("fieldList",fieldList);
		root.put("linkTablePd",linkTablePd);
		root.put("linkFieldList",linkFieldList);

		String gen_path = PathUtil.getSystemPath();
		if(Verify.verifyIsNotNull(tablePd.get("gen_path").toString())){
			gen_path = tablePd.get("gen_path").toString();
		}
		gen_path = gen_path+"gencode/";
		//生成Mapper.xml
		fprint("gencode/TemplateMapper.xml.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.mapper+StrUtil.upperFirst(tablePd.get("bus_name").toString())+"Mapper.xml");
		//生成Dao
		fprint("gencode/TemplateDao.java.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.dao+StrUtil.upperFirst(tablePd.get("bus_name").toString())+"Dao.java");
		//生成Service
		fprint("gencode/TemplateService.java.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.service+StrUtil.upperFirst(tablePd.get("bus_name").toString())+"Service.java");
		//生成Controller
		fprint("gencode/TemplateController.java.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.controller+StrUtil.upperFirst(tablePd.get("bus_name").toString())+"Controller.java");

		//生成List
		fprint("gencode/TemplateList.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_list.jsp");
		//生成Add
		fprint("gencode/TemplateAdd.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_add.jsp");
		//生成Update
		fprint("gencode/TemplateUpdate.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_update.jsp");
		//生成Info
		fprint("gencode/TemplateInfo.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_info.jsp");
		if(tablePd.get("more_add").toString().equals("1")){
			//生成AddMore
			fprint("gencode/TemplateAddMore.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_addMore.jsp");
		}
		if(tablePd.get("temp_type").toString().equals("2")){
			//生成AddMore
			fprint("gencode/TemplateZtree.jsp.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.jsp+tablePd.get("bus_name").toString()+"/"+tablePd.get("bus_name").toString()+"_ztree.jsp");
		}


		//=====================================处理菜单信息==================================================
		//查询父级菜单
		PageData param = new PageData();
		param.put("id",tablePd.get("menu_id"));
		PageData menuPd = menuService.findInfo(param);
		if(Verify.verifyIsNotNull(menuPd)){
			String time = DateTimeUtil.getDateTimeStr();
			PageData user = (PageData) session.getAttribute("loginUser");
			PageData organize = (PageData) session.getAttribute("loginOrganize");
			List<PageData> menuList = new ArrayList<PageData>();
			//组织菜单信息
			PageData mPd = new PageData();
			String id = GuidUtil.getUuid();
			mPd.put("id",id);
			mPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_");
			mPd.put("name",tablePd.get("menu_name"));
			mPd.put("code",tablePd.get("mod_name"));
			mPd.put("parent_id",menuPd.get("id"));
			mPd.put("url","/"+tablePd.get("mod_name")+"/"+tablePd.get("bus_name")+"/index");
			mPd.put("icon","&#xe66b;");
			mPd.put("type","menu");
			mPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+1);
			mPd.put("order_by",Integer.parseInt(menuPd.get("child_num").toString())+1);
			mPd.put("remark","");
			mPd.put("create_time",time);
			mPd.put("create_user",time);
			mPd.put("create_organize",time);
			mPd.put("create_user",user.get("id"));
			mPd.put("create_organize",organize.get("organize_id"));
			menuList.add(mPd);
			//组织菜单功能按钮-添加
			PageData btnAddPd = new PageData();
			String btnAdd_id = GuidUtil.getUuid();
			btnAddPd.put("id",btnAdd_id);
			btnAddPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnAdd_id);
			btnAddPd.put("name","添加");
			btnAddPd.put("code","add");
			btnAddPd.put("parent_id",id);
			btnAddPd.put("url","");
			btnAddPd.put("icon","");
			btnAddPd.put("type","button");
			btnAddPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
			btnAddPd.put("order_by","1");
			btnAddPd.put("remark","");
			btnAddPd.put("create_time",time);
			btnAddPd.put("create_user",time);
			btnAddPd.put("create_organize",time);
			btnAddPd.put("create_user",user.get("id"));
			btnAddPd.put("create_organize",organize.get("organize_id"));
			menuList.add(btnAddPd);
			//组织菜单功能按钮-编辑
			PageData btnEditPd = new PageData();
			String btnEdit_id = GuidUtil.getUuid();
			btnEditPd.put("id",btnEdit_id);
			btnEditPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnEdit_id);
			btnEditPd.put("name","编辑");
			btnEditPd.put("code","edit");
			btnEditPd.put("parent_id",id);
			btnEditPd.put("url","");
			btnEditPd.put("icon","");
			btnEditPd.put("type","button");
			btnEditPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
			btnEditPd.put("order_by","2");
			btnEditPd.put("remark","");
			btnEditPd.put("create_time",time);
			btnEditPd.put("create_user",time);
			btnEditPd.put("create_organize",time);
			btnEditPd.put("create_user",user.get("id"));
			btnEditPd.put("create_organize",organize.get("organize_id"));
			menuList.add(btnEditPd);
			//组织菜单功能按钮-删除
			PageData btnDelPd = new PageData();
			String btnDel_id = GuidUtil.getUuid();
			btnDelPd.put("id",btnDel_id);
			btnDelPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnDel_id);
			btnDelPd.put("name","删除");
			btnDelPd.put("code","del");
			btnDelPd.put("parent_id",id);
			btnDelPd.put("url","");
			btnDelPd.put("icon","");
			btnDelPd.put("type","button");
			btnDelPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
			btnDelPd.put("order_by","3");
			btnDelPd.put("remark","");
			btnDelPd.put("create_time",time);
			btnDelPd.put("create_user",time);
			btnDelPd.put("create_organize",time);
			btnDelPd.put("create_user",user.get("id"));
			btnDelPd.put("create_organize",organize.get("organize_id"));
			menuList.add(btnDelPd);
			//组织菜单功能按钮-详情
			PageData btnInfoPd = new PageData();
			String btnInfo_id = GuidUtil.getUuid();
			btnInfoPd.put("id",btnInfo_id);
			btnInfoPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnInfo_id);
			btnInfoPd.put("name","详情");
			btnInfoPd.put("code","info");
			btnInfoPd.put("parent_id",id);
			btnInfoPd.put("url","");
			btnInfoPd.put("icon","");
			btnInfoPd.put("type","button");
			btnInfoPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
			btnInfoPd.put("order_by","4");
			btnInfoPd.put("remark","");
			btnInfoPd.put("create_time",time);
			btnInfoPd.put("create_user",time);
			btnInfoPd.put("create_organize",time);
			btnInfoPd.put("create_user",user.get("id"));
			btnInfoPd.put("create_organize",organize.get("organize_id"));
			menuList.add(btnInfoPd);
			if(tablePd.get("more_add").toString().equals("1")){//批量添加
				//组织菜单功能按钮-批量添加
				PageData btnAddMorePd = new PageData();
				String btnAddMore_id = GuidUtil.getUuid();
				btnAddMorePd.put("id",btnAddMore_id);
				btnAddMorePd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnAddMore_id);
				btnAddMorePd.put("name","批量添加");
				btnAddMorePd.put("code","addMore");
				btnAddMorePd.put("parent_id",id);
				btnAddMorePd.put("url","");
				btnAddMorePd.put("icon","");
				btnAddMorePd.put("type","button");
				btnAddMorePd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
				btnAddMorePd.put("order_by","5");
				btnAddMorePd.put("remark","");
				btnAddMorePd.put("create_time",time);
				btnAddMorePd.put("create_user",time);
				btnAddMorePd.put("create_organize",time);
				btnAddMorePd.put("create_user",user.get("id"));
				btnAddMorePd.put("create_organize",organize.get("organize_id"));
				menuList.add(btnAddMorePd);
			}
			if(tablePd.get("status_type").toString().equals("0")||tablePd.get("status_type").toString().equals("1")){//批量添加
				//组织菜单功能按钮-批量添加
				PageData btnStatusPd = new PageData();
				String btnAddMore_id = GuidUtil.getUuid();
				btnStatusPd.put("id",btnAddMore_id);
				btnStatusPd.put("menu_cascade",menuPd.get("menu_cascade")+id+"_"+btnAddMore_id);
				btnStatusPd.put("name","状态管理");
				btnStatusPd.put("code","setStatus");
				btnStatusPd.put("parent_id",id);
				btnStatusPd.put("url","");
				btnStatusPd.put("icon","");
				btnStatusPd.put("type","button");
				btnStatusPd.put("level_num",Integer.parseInt(menuPd.get("level_num").toString())+2);
				btnStatusPd.put("order_by","6");
				btnStatusPd.put("remark","");
				btnStatusPd.put("create_time",time);
				btnStatusPd.put("create_user",time);
				btnStatusPd.put("create_organize",time);
				btnStatusPd.put("create_user",user.get("id"));
				btnStatusPd.put("create_organize",organize.get("organize_id"));
				menuList.add(btnStatusPd);
			}
			root.put("mPd",mPd);
			root.put("menuList",menuList);
			fprint("gencode/TemplateMenuSql.sql.ftl", root, gen_path+tablePd.get("bus_name").toString()+File.separator+tablePd.get("mod_name").toString()+File.separator+FreemarkerParaUtil.sql+tablePd.get("bus_name").toString()+"_menu.sql");
		}

		Json json = new Json();
		json.setData(gen_path+tablePd.get("bus_name").toString());
		json.setSuccess(true);
		json.setMsg("代码生成成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: downloadCode
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-10-14 13:18
	 */ 
	@RequestMapping(value = "/downloadCode", method = RequestMethod.GET)
	public void downloadCode(HttpServletRequest request, HttpServletResponse response , HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		PageData tablePd = genCodeService.findInfo(pd);
		String path = pd.get("path").toString();
		ZipUtils.toZip(path+File.separator+tablePd.get("mod_name").toString(), path+"/"+tablePd.get("bus_name")+".zip", true);
		FileUtil.downFile(response, path+"/"+tablePd.get("bus_name")+".zip",tablePd.get("menu_name").toString()+"【代码】.zip");
	}


	public void fprint(String templatePath,Object obj,String outPath) throws Exception {
		Configuration configuration = freeMarkerConfigurer.getConfiguration();
		configuration.setClassForTemplateLoading(this.getClass(), "/templates/");
		System.out.println(outPath);
		//ContextLoader loader = new ContextLoader();
		Template template = configuration.getTemplate(templatePath);

		String dirpath = outPath.substring(0,outPath.lastIndexOf("/"));
		System.out.println(dirpath);
		File dirFile = new File(dirpath);
		if(!dirFile.exists()){
			dirFile.mkdir();
			dirFile.mkdirs();
		}

		File file = new File(outPath);
		Writer out = new FileWriter(file);
		template.process(obj, out);//输出
		out.close();
	}


	/** 
	 * @Description: toViewCode 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-10-16 11:07 
	 */ 
	@RequestMapping(value = "/toViewCode", method = RequestMethod.GET)
	public String toViewCode(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData tablePd = genCodeService.findInfo(pd);
		String path = pd.get("path").toString();
		path = path+File.separator+tablePd.get("mod_name").toString();
		//读取文件夹下所有的文件
		List<File> fileList = FileUtil.traverseFolder1(path);
		List<PageData> list = new ArrayList<PageData>();
		for (File file: fileList) {
			PageData param = new PageData();
			param.put("name",file.getName());
			param.put("content",StringEscapeUtils.escapeHtml(FileUtil.readFileContent(file)));
			list.add(param);
//			System.out.println("##########name:::"+file.getName());
//			System.out.println("##########content:::"+param.get("content"));
		}
		map.put("list",list);
		map.put("pd",pd);
		return "web/system/gencode/gencode_viewCode";
	}


	public static void main(String[] args) {
		String HTMLText="<p>我的<br/>评论</p>";
		System.out.println(StringEscapeUtils.escapeHtml(HTMLText));
	}

}
