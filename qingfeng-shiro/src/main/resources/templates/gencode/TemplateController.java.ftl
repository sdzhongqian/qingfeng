package ${tablePd.pack_path}.${tablePd.mod_name}.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.common.service.UploadService;
import ${tablePd.pack_path}.${tablePd.mod_name}.service.${tablePd.bus_name?cap_first}Service;
import com.qingfeng.util.*;
import com.qingfeng.util.upload.ParaUtil;
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
import java.util.*;

/**
 * @Title: ${tablePd.bus_name?cap_first}Controller
 * @ProjectName com.qingfeng
 * @Description: Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/${tablePd.mod_name}/${tablePd.bus_name}")
public class ${tablePd.bus_name?cap_first}Controller extends BaseController {

	@Autowired
	private ${tablePd.bus_name?cap_first}Service ${tablePd.bus_name}Service;
	@Autowired
	public UploadService uploadService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/${tablePd.mod_name}/${tablePd.bus_name}/${tablePd.bus_name}_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
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
		List<PageData> list = ${tablePd.bus_name}Service.findListPage(page);
		int num = ${tablePd.bus_name}Service.findListSize(page);
		Json json = new Json();
		json.setMsg("获取数据成功。");
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

    	List<PageData> list = ${tablePd.bus_name}Service.findList(pd);
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
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = ${tablePd.bus_name}Service.findInfo(pd);
		map.addAttribute("p",p);
	<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
		//查询${obj.field_comment}附件信息
        PageData filePd = new PageData();
        filePd.put("idList",Arrays.asList(p.get("${obj.field_name}").toString().split(",")));
		List<PageData> ${obj.field_name}FileList = uploadService.findFileList(filePd);
		map.addAttribute("${obj.field_name}FileList",${obj.field_name}FileList);
		</#if>
		</#if>
	</#list>
		<#if tablePd.temp_type == '1'>
        //查询子表列表
        List<PageData> list = ${tablePd.bus_name}Service.findChildList(pd);
		map.put("list",list);
		map.put("listJson", JsonToMap.list2json(list));
	<#list linkFieldList as obj>
	<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
		//查询${obj.field_comment}附件信息
		for(PageData childPd:list){
            PageData childFilePd = new PageData();
            childFilePd.put("idList",Arrays.asList(childPd.get("${obj.field_name}").toString().split(",")));
			List<PageData> ${obj.field_name}FileList = uploadService.findFileList(childFilePd);
            childPd.put("${obj.field_name}FileList",${obj.field_name}FileList);
		}
		</#if>
	</#if>
	</#list>
	</#if>
		map.put("pd",pd);
		return "web/${tablePd.mod_name}/${tablePd.bus_name}/${tablePd.bus_name}_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/${tablePd.mod_name}/${tablePd.bus_name}/${tablePd.bus_name}_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
        //主键id
		String id = GuidUtil.getUuid();
        pd.put("id", id);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
        pd.put("status","1");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		int num = ${tablePd.bus_name}Service.save(pd);
	<#if tablePd.temp_type == '1'>
        if(num==1){
		<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
			//处理${obj.field_comment}附件信息-更新信息主要意义在于可删选删除垃圾图片
			PageData filePd = new PageData();
			filePd.put("obj_id",id);
			filePd.put("update_time", time);
			filePd.put("update_user", user.get("id"));
			String file_${obj.field_name}[] = pd.get("${obj.field_name}").toString().split(",");
            for (String file_${obj.field_name}_id:file_${obj.field_name}) {
				filePd.put("id", file_${obj.field_name}_id);
				uploadService.updateFile(filePd);
			}
		</#if>
		</#if>
		</#list>

		<#assign keParam = ''>
		<#list linkFieldList as obj>
			<#if obj.field_operat == 'Y'>
			<#assign keParam = 'child_${obj.field_name}'>
			String[] child_${obj.field_name} = request.getParameterValues("child_${obj.field_name}");
			</#if>
		</#list>
			for (int i = 0; i < ${keParam}.length; i++) {
				PageData p = new PageData();
			<#list linkFieldList as obj>
				<#if obj.field_operat == 'Y'>
				p.put("${obj.field_name}",child_${obj.field_name}[i]);
				</#if>
			</#list>
				p.put("${linkTablePd.link_field}",pd.get("id"));
				String child_id = GuidUtil.getUuid();
				p.put("id", child_id);
				p.put("create_user",user.get("id"));
				p.put("create_organize",organize.get("organize_id"));
				p.put("create_time", time);
				${tablePd.bus_name}Service.saveChild(p);

		<#list linkFieldList as obj>
			<#if obj.field_operat == 'Y'>
			<#if obj.show_type == '8'>
				//处理${obj.field_comment}附件信息-更新信息主要意义在于可删选删除垃圾图片
				PageData childFilePd = new PageData();
                childFilePd.put("obj_id",id);
                childFilePd.put("child_obj_id",child_id);
                childFilePd.put("update_time", time);
                childFilePd.put("update_user", user.get("id"));
				String file_child_${obj.field_name}[] = child_${obj.field_name}[i].toString().split(",");
                for (String file_child_${obj.field_name}_id:file_child_${obj.field_name}) {
					childFilePd.put("id", file_child_${obj.field_name}_id);
					uploadService.updateFile(childFilePd);
				}
			</#if>
			</#if>
		</#list>
			}
        }
	</#if>
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	<#if tablePd.more_add == '1'>
	/**
	 * @Description: toAddMore
	 * @Param: [map, request]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-23 22:32
	 */
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/${tablePd.mod_name}/${tablePd.bus_name}/${tablePd.bus_name}_addMore";
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
        pd.put("status","1");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

	<#assign keParam = ''>
	<#list fieldList as obj>
	<#if obj.field_operat == 'Y'>
		<#assign keParam = '${obj.field_name}'>
		String[] ${obj.field_name} = request.getParameterValues("${obj.field_name}");
	</#if>
	</#list>
		for (int i = 0; i < ${keParam}.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
		<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
			pd.put("${obj.field_name}",${obj.field_name}[i]);
		</#if>
		</#list>
			${tablePd.bus_name}Service.save(pd);

		<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
			//处理${obj.field_comment}附件信息-更新信息主要意义在于可删选删除垃圾图片
			PageData filePd = new PageData();
			filePd.put("obj_id",id);
			filePd.put("update_time", time);
			filePd.put("update_user", user.get("id"));
			String file_${obj.field_name}[] = ${obj.field_name}[i].split(",");
            for (String file_${obj.field_name}_id:file_${obj.field_name}) {
            filePd.put("id", file_${obj.field_name}_id);
				uploadService.updateFile(filePd);
			}
		</#if>
		</#if>
		</#list>
		}
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}
	</#if>

	/** 
	 * @Description: toUpdate 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = ${tablePd.bus_name}Service.findInfo(pd);
		map.put("p",p);
	<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
		//查询${obj.field_comment}附件信息
		PageData filePd = new PageData();
		filePd.put("idList",Arrays.asList(p.get("${obj.field_name}").toString().split(",")));
		List<PageData> ${obj.field_name}FileList = uploadService.findFileList(filePd);
		map.addAttribute("${obj.field_name}FileList",${obj.field_name}FileList);
		</#if>
		</#if>
	</#list>
		<#if tablePd.temp_type == '1'>
        //查询子表列表
        List<PageData> list = ${tablePd.bus_name}Service.findChildList(pd);
		map.put("list",list);
        map.put("listJson", JsonToMap.list2json(list));
	<#list linkFieldList as obj>
		<#if obj.field_operat == 'Y'>
		<#if obj.show_type == '8'>
		//查询${obj.field_comment}附件信息
		for(PageData childPd:list){
            PageData childFilePd = new PageData();
            childFilePd.put("idList",Arrays.asList(childPd.get("${obj.field_name}").toString().split(",")));
			List<PageData> ${obj.field_name}FileList = uploadService.findFileList(childFilePd);
			childPd.put("${obj.field_name}FileList",${obj.field_name}FileList);
		}
		</#if>
		</#if>
	</#list>
	</#if>
        map.put("pd",pd);
		return "web/${tablePd.mod_name}/${tablePd.bus_name}/${tablePd.bus_name}_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
        PageData organize = (PageData) session.getAttribute("loginOrganize");
        pd.put("update_user",user.get("id"));
		int num = ${tablePd.bus_name}Service.update(pd);
	<#if tablePd.temp_type == '1'>
        if(num==1){
		<#list fieldList as obj>
		<#if obj.field_operat == 'Y'>
			<#if obj.show_type == '8'>
			//处理${obj.field_comment}附件信息-更新信息主要意义在于可删选删除垃圾图片
			PageData filePd = new PageData();
			filePd.put("obj_id",pd.get("id"));
			filePd.put("update_time", time);
			filePd.put("update_user", user.get("id"));
			String file_${obj.field_name}[] = pd.get("${obj.field_name}").toString().split(",");
            for (String file_${obj.field_name}_id:file_${obj.field_name}) {
                filePd.put("id", file_${obj.field_name}_id);
				uploadService.updateFile(filePd);
			}
			</#if>
		</#if>
		</#list>
			String[] c_ids = request.getParameterValues("c_ids");
	<#list linkFieldList as obj>
		<#if obj.field_operat == 'Y'>
            String[] child_${obj.field_name} = request.getParameterValues("child_${obj.field_name}");
		</#if>
	</#list>
			for (int i = 0; i < c_ids.length; i++) {
				PageData p = new PageData();
			<#list linkFieldList as obj>
				<#if obj.field_operat == 'Y'>
				p.put("${obj.field_name}",child_${obj.field_name}[i]);
				</#if>
			</#list>
        		p.put("${linkTablePd.link_field}",pd.get("id"));
				if(Verify.verifyIsNotNull(c_ids[i])){
					p.put("id",c_ids[i]);
					p.put("update_user",user.get("id"));
					p.put("update_time", DateTimeUtil.getDateTimeStr());
					${tablePd.bus_name}Service.updateChild(p);
				}else{
        			p.put("id", GuidUtil.getUuid());
					p.put("create_user",user.get("id"));
					p.put("create_organize",organize.get("organize_id"));
					p.put("create_time", DateTimeUtil.getDateTimeStr());
					${tablePd.bus_name}Service.saveChild(p);
				}
		<#list linkFieldList as obj>
			<#if obj.field_operat == 'Y'>
				<#if obj.show_type == '8'>
                    //处理${obj.field_comment}附件信息-更新信息主要意义在于可删选删除垃圾图片
                    PageData childFilePd = new PageData();
                    childFilePd.put("obj_id",pd.get("id"));
                    childFilePd.put("child_obj_id",p.get("id"));
                    childFilePd.put("update_time", time);
                    childFilePd.put("update_user", user.get("id"));
                    String file_child_${obj.field_name}[] = child_${obj.field_name}[i].split(",");
                    for (String file_child_${obj.field_name}_id:file_child_${obj.field_name}) {
                    	childFilePd.put("id", file_child_${obj.field_name}_id);
						uploadService.updateFile(childFilePd);
                    }
				</#if>
			</#if>
		</#list>
			}
        }
	</#if>
		Json json = new Json();
		json.setCode(num);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	<#if tablePd.temp_type != '2'>
	/** 
	 * @Description: del 
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		<#assign delMain = 'false'>
		<#assign delChild = 'false'>
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
	<#if tablePd.temp_type == '1'>
		${tablePd.bus_name}Service.delChildForPIds(ids);
	</#if>
	<#list fieldList as obj>
	<#if obj.field_operat == 'Y'>
	<#if obj.show_type == '8'>
		<#assign delMain = 'true'>
	</#if>
	</#if>
	</#list>
		<#if delMain == 'true'>
        //删除主表附件信息
        for (String id:ids) {
			pd.put("obj_id",id);
			List<PageData> fileList = uploadService.findFileList(pd);
			for (PageData fPd:fileList) {
				//查询信息
				File pathFile = new File(ParaUtil.localName+fPd.getString("file_path"));
				pathFile.delete();
				pathFile.deleteOnExit();
				uploadService.delFile(fPd);
			}
        }
		</#if>
		${tablePd.bus_name}Service.del(ids);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}
	</#if>
	<#if tablePd.temp_type == '2'>
	/**
	* @Description: del
	* @Param: [request, response]
	* @return: void
	* @Author: anxingtao
	* @Date: 2020-9-22 22:51
	*/
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		String[] ids = pd.get("ids").toString().split(",");
		pd.put("idList", Arrays.asList(ids));
		List<PageData> list = ${tablePd.bus_name}Service.findContainChildList(pd);
		if(list.size()>0){
			String msg = "";
			for (PageData p:list) {
				msg += p.get("name").toString()+",";
			}
			if(msg.length()>0){
				msg = msg.substring(0,msg.length()-1);
			}
			json.setSuccess(false);
			json.setMsg("删除内容【"+msg+"】存在下级节点，请先删除下级节点再进行删除。");
		}else{
			${tablePd.bus_name}Service.del(ids);
			json.setSuccess(true);
			json.setMsg("操作成功。");
		}
		this.writeJson(response,json);
	}
	</#if>

	<#if tablePd.temp_type == '1'>
	/**
	* @Description: delChild
	* @Param: [request, response]
	* @return: void
	* @Author: anxingtao
	* @Date: 2020-9-22 22:51
    */
	@RequestMapping(value = "/delChild", method = RequestMethod.GET)
	public void delChild(HttpServletRequest request, HttpServletResponse response) throws IOException  {
        PageData pd = new PageData(request);
        String[] ids = pd.get("ids").toString().split(",");
		${tablePd.bus_name}Service.delChild(ids);
        Json json = new Json();
        json.setSuccess(true);
        json.setMsg("操作成功。");
        this.writeJson(response,json);
	}
	</#if>


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
	<#if tablePd.status_type == '1'>
		${tablePd.bus_name}Service.updateStatus(pd);
	</#if>
	<#if tablePd.status_type == '0'>
        PageData param = new PageData();
        param.put("update_time", time);
        param.put("status","1");
		${tablePd.bus_name}Service.updateStatus(param);
        param.put("id",pd.get("id"));
        param.put("status","0");
		${tablePd.bus_name}Service.updateStatus(param);
	</#if>

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


}
