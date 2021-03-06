package com.qingfeng.gencode.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.common.service.UploadService;
import com.qingfeng.gencode.service.MantableService;
import com.qingfeng.util.*;
import com.qingfeng.util.upload.ParaUtil;
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
import java.util.List;

/**
 * @Title: MantableController
 * @ProjectName com.qingfeng
 * @Description: Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/gencode/mantable")
public class MantableController extends BaseController {

	@Autowired
	private MantableService mantableService;
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
		return "web/gencode/mantable/mantable_list";
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
		List<PageData> list = mantableService.findListPage(page);
		int num = mantableService.findListSize(page);
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

    	List<PageData> list = mantableService.findList(pd);
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
		PageData p = mantableService.findInfo(pd);
		map.addAttribute("p",p);
		//查询内容附件信息
        PageData filePd = new PageData();
        filePd.put("idList",Arrays.asList(p.get("content").toString().split(",")));
		List<PageData> contentFileList = uploadService.findFileList(filePd);
		map.addAttribute("contentFileList",contentFileList);
        //查询子表列表
        List<PageData> list = mantableService.findChildList(pd);
		map.put("list",list);
		map.put("listJson", JsonToMap.list2json(list));
		//查询备注附件信息
		for(PageData childPd:list){
            PageData childFilePd = new PageData();
            childFilePd.put("idList",Arrays.asList(childPd.get("remark").toString().split(",")));
			List<PageData> remarkFileList = uploadService.findFileList(childFilePd);
            childPd.put("remarkFileList",remarkFileList);
		}
		map.put("pd",pd);
		return "web/gencode/mantable/mantable_info";
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
		return "web/gencode/mantable/mantable_add";
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
        pd.put("status","0");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		int num = mantableService.save(pd);
        if(num==1){
			//处理内容附件信息-更新信息主要意义在于可删选删除垃圾图片
			PageData filePd = new PageData();
			filePd.put("obj_id",id);
			filePd.put("update_time", time);
			filePd.put("update_user", user.get("id"));
			String file_content[] = pd.get("content").toString().split(",");
            for (String file_content_id:file_content) {
				filePd.put("id", file_content_id);
				uploadService.updateFile(filePd);
			}

			String[] child_name = request.getParameterValues("child_name");
			String[] child_content = request.getParameterValues("child_content");
			String[] child_order_by = request.getParameterValues("child_order_by");
			String[] child_remark = request.getParameterValues("child_remark");
			for (int i = 0; i < child_remark.length; i++) {
				PageData p = new PageData();
				p.put("name",child_name[i]);
				p.put("content",child_content[i]);
				p.put("order_by",child_order_by[i]);
				p.put("remark",child_remark[i]);
				p.put("main_id",pd.get("id"));
				String child_id = GuidUtil.getUuid();
				p.put("id", child_id);
				p.put("create_user",user.get("id"));
				p.put("create_organize",organize.get("organize_id"));
				p.put("create_time", time);
				mantableService.saveChild(p);

				//处理备注附件信息-更新信息主要意义在于可删选删除垃圾图片
				PageData childFilePd = new PageData();
                childFilePd.put("obj_id",id);
                childFilePd.put("child_obj_id",child_id);
                childFilePd.put("update_time", time);
                childFilePd.put("update_user", user.get("id"));
				String file_child_remark[] = child_remark[i].toString().split(",");
                for (String file_child_remark_id:file_child_remark) {
					childFilePd.put("id", file_child_remark_id);
					uploadService.updateFile(childFilePd);
				}
			}
        }
		Json json = new Json();
		json.setCode(num);
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
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = mantableService.findInfo(pd);
		map.put("p",p);
		//查询内容附件信息
		PageData filePd = new PageData();
		filePd.put("idList",Arrays.asList(p.get("content").toString().split(",")));
		List<PageData> contentFileList = uploadService.findFileList(filePd);
		map.addAttribute("contentFileList",contentFileList);
        //查询子表列表
        List<PageData> list = mantableService.findChildList(pd);
		map.put("list",list);
        map.put("listJson", JsonToMap.list2json(list));
		//查询备注附件信息
		for(PageData childPd:list){
            PageData childFilePd = new PageData();
            childFilePd.put("idList",Arrays.asList(childPd.get("remark").toString().split(",")));
			List<PageData> remarkFileList = uploadService.findFileList(childFilePd);
			childPd.put("remarkFileList",remarkFileList);
		}
        map.put("pd",pd);
		return "web/gencode/mantable/mantable_update";
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
		int num = mantableService.update(pd);
        if(num==1){
			//处理内容附件信息-更新信息主要意义在于可删选删除垃圾图片
			PageData filePd = new PageData();
			filePd.put("obj_id",pd.get("id"));
			filePd.put("update_time", time);
			filePd.put("update_user", user.get("id"));
			String file_content[] = pd.get("content").toString().split(",");
            for (String file_content_id:file_content) {
                filePd.put("id", file_content_id);
				uploadService.updateFile(filePd);
			}
			String[] c_ids = request.getParameterValues("c_ids");
            String[] child_name = request.getParameterValues("child_name");
            String[] child_content = request.getParameterValues("child_content");
            String[] child_order_by = request.getParameterValues("child_order_by");
            String[] child_remark = request.getParameterValues("child_remark");
			for (int i = 0; i < c_ids.length; i++) {
				PageData p = new PageData();
				p.put("name",child_name[i]);
				p.put("content",child_content[i]);
				p.put("order_by",child_order_by[i]);
				p.put("remark",child_remark[i]);
        		p.put("main_id",pd.get("id"));
				if(Verify.verifyIsNotNull(c_ids[i])){
					p.put("id",c_ids[i]);
					p.put("update_user",user.get("id"));
					p.put("update_time", DateTimeUtil.getDateTimeStr());
					mantableService.updateChild(p);
				}else{
        			p.put("id", GuidUtil.getUuid());
					p.put("create_user",user.get("id"));
					p.put("create_organize",organize.get("organize_id"));
					p.put("create_time", DateTimeUtil.getDateTimeStr());
					mantableService.saveChild(p);
				}
                    //处理备注附件信息-更新信息主要意义在于可删选删除垃圾图片
                    PageData childFilePd = new PageData();
                    childFilePd.put("obj_id",pd.get("id"));
                    childFilePd.put("child_obj_id",p.get("id"));
                    childFilePd.put("update_time", time);
                    childFilePd.put("update_user", user.get("id"));
                    String file_child_remark[] = child_remark[i].split(",");
                    for (String file_child_remark_id:file_child_remark) {
                    	childFilePd.put("id", file_child_remark_id);
						uploadService.updateFile(childFilePd);
                    }
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
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		mantableService.delChildForPIds(ids);
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
		mantableService.del(ids);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

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
		mantableService.delChild(ids);
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

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


}
