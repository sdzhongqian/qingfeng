package com.qingfeng.example.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.common.service.UploadService;
import com.qingfeng.example.service.EiedataService;
import com.qingfeng.util.*;
import com.qingfeng.util.upload.ParaUtil;
import net.sf.jxls.transformer.XLSTransformer;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Title: EiedataController
 * @ProjectName com.qingfeng
 * @Description: Controller层
 * @author anxingtao
 * @date 2020-9-22 22:45
 */
@Controller
@RequestMapping(value = "/example/eiedata")
public class EiedataController extends BaseController {

	@Autowired
	private EiedataService eiedataService;
	@Autowired
	public UploadService uploadService;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("eiedataList")
	@RequestMapping(value = "/index", method = RequestMethod.GET)
		public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/example/eiedata/eiedata_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */ 
	@RequestMapping(value = "/findListPage", method = RequestMethod.GET)
	public void findListPage(Page page, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
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
		List<PageData> list = eiedataService.findListPage(page);
		int num = eiedataService.findListSize(page);
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

    	List<PageData> list = eiedataService.findList(pd);
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
		PageData p = eiedataService.findInfo(pd);
		map.addAttribute("p",p);
		map.put("pd",pd);
		return "web/example/eiedata/eiedata_info";
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
		return "web/example/eiedata/eiedata_add";
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

		int num = eiedataService.save(pd);


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
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/example/eiedata/eiedata_addMore";
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

		String[] classify = request.getParameterValues("classify");
		String[] name = request.getParameterValues("name");
		String[] num = request.getParameterValues("num");
		String[] order_by = request.getParameterValues("order_by");
		String[] remark = request.getParameterValues("remark");
		for (int i = 0; i < remark.length; i++) {
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			pd.put("classify",classify[i]);
			pd.put("name",name[i]);
			pd.put("num",num[i]);
			pd.put("order_by",order_by[i]);
			pd.put("remark",remark[i]);
			eiedataService.save(pd);

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
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = eiedataService.findInfo(pd);
		map.put("p",p);
        map.put("pd",pd);
		return "web/example/eiedata/eiedata_update";
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

        String id = pd.get("id").toString();
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
        PageData user = (PageData) session.getAttribute("loginUser");
        PageData organize = (PageData) session.getAttribute("loginOrganize");
        pd.put("update_user",user.get("id"));
		int num = eiedataService.update(pd);
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
		eiedataService.del(ids);
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
        PageData param = new PageData();
        param.put("update_time", time);
        param.put("status","1");
		eiedataService.updateStatus(param);
        param.put("id",pd.get("id"));
        param.put("status","0");
		eiedataService.updateStatus(param);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}





	/**
	 * @title: downloadExcel
	 * @description: 下载导入Excel模板
	 * @author: Administrator
	 * @date: 2021/4/5 0005 18:52
	 */
	@RequestMapping(value = "/downloadExcel", method = RequestMethod.GET)
	public void downloadExcel(HttpServletRequest request,HttpSession session,HttpServletResponse response) throws Exception {
		PageData pd = new PageData(request);
		FileUtil.downFile(response, session.getServletContext().getRealPath("/")+"/template/excelImport/eiedata_import_mb.xlsx", "Excel导入导出案例数据导入模板.xlsx");
	}

	/**
	 * @title: toImport
	 * @description: toImport
	 * @author: Administrator
	 * @date: 2021/4/5 0005 18:57
	 */
	@RequestMapping(value = "/toImport", method = RequestMethod.GET)
	public String toImport(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/example/eiedata/eiedata_importExcel";
	}

	/**
	 * @title: saveImportExcel
	 * @description: 执行导入
	 * @author: Administrator
	 * @date: 2021/4/5 0005 18:57
	 */
	@RequestMapping(value = "/saveImportExcel", method = RequestMethod.POST)
	public void saveImportExcel(HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		String str = "导入成功";
		String savePath = ParaUtil.localName;
		File files = new File(savePath+pd.get("file_path"));
		FileInputStream fileInputStream = new FileInputStream(files);
		Workbook book = new XSSFWorkbook(fileInputStream);
		Sheet sheet = book.getSheetAt(0);  //示意访问sheet

		int totalRows = sheet.getPhysicalNumberOfRows();
		int totalCells = sheet.getRow(0).getPhysicalNumberOfCells();
		String[] objs = new String[totalCells];
		Boolean flag = true;
		String time = DateTimeUtil.getDateTimeStr();
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		Pinyin4JUtil pinyin4JUtil = new Pinyin4JUtil();
		List<PageData> list = new ArrayList<PageData>();
		for (int i = 0; i < totalRows; i++) {
			for (int j = 0; j < totalCells; j++) {
				Cell xssfCell = sheet.getRow(i).getCell(j);
				if (totalRows >= 1 && sheet.getRow(0) != null) {
					if(xssfCell==null){
						objs[j]="";
					}else{
						if(xssfCell.toString().trim().equals("")){
							objs[j]="";
						}else{
							if(xssfCell.getCellType()== HSSFCell.CELL_TYPE_FORMULA){
								FormulaEvaluator evaluator = book.getCreationHelper().createFormulaEvaluator();
								double resultScore = evaluator.evaluate(xssfCell).getNumberValue();// 读取计算结果 =SUM(M6:M15)
								objs[j] = resultScore+"";
							}else if(xssfCell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
								if (HSSFDateUtil.isCellDateFormatted(xssfCell)) {// 处理日期格式、时间格式
									SimpleDateFormat sdf = null;
									if (xssfCell.getCellStyle().getDataFormat() == HSSFDataFormat
											.getBuiltinFormat("h:mm")) {
										sdf = new SimpleDateFormat("HH:mm");
									} else {// 日期
										sdf = new SimpleDateFormat("yyyy-MM-dd");
									}
									Date date = xssfCell.getDateCellValue();
									objs[j] = sdf.format(date).trim();
								} else if (xssfCell.getCellStyle().getDataFormat() == 58) {
									// 处理自定义日期格式：m月d日(通过判断单元格的格式id解决，id的值是58)
									SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
									double value = xssfCell.getNumericCellValue();
									Date date = org.apache.poi.ss.usermodel.DateUtil
											.getJavaDate(value);
									objs[j] = sdf.format(date).trim();
								} else {
									System.out.println(xssfCell.toString());
									objs[j] = xssfCell.toString().trim();
								}
							}else if(xssfCell.getCellType()==HSSFCell.CELL_TYPE_STRING){
								objs[j] = xssfCell.getRichStringCellValue().toString().trim();
							}else{
								objs[j]="";
							}
//								objs[j] = parseExcel(xssfCell,book);//xssfCell.toString();
						}
					}

				}
			}
			if(i!=0){
				if(Verify.verifyIsNotNull(objs[0])){
					PageData p = new PageData();
					//主键id
					String id = GuidUtil.getUuid();
					p.put("id", id);
					p.put("create_time", time);
					//处理数据权限
					p.put("create_user",user.get("id"));
					p.put("create_organize",organize.get("organize_id"));

					//处理类型
					if(objs[1].equals("水果")){
						p.put("classify","0");
					}else if(objs[1].equals("蔬菜")){
						p.put("classify","1");
					}else if(objs[1].equals("其他")){
						p.put("classify","2");
					}

					p.put("name",objs[2]); //名称
					p.put("num",objs[3]); //数量
					p.put("order_by",objs[4]); //排序
					p.put("remark",objs[5]); //备注
					System.out.println("----------------------");
					System.out.println(p.toString());
					list.add(p);
				}
			}
		}
		Json json = new Json();
		if(list.size()>0){
			eiedataService.saveImportList(list);
			json.setSuccess(flag);
			json.setMsg(str);
		}else{
			json.setSuccess(flag);
			json.setMsg(str);
		}
		this.writeJson(response,json);
	}



	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = eiedataService.findList(pd);
		for (PageData p:list) {
			if(p.get("classify").equals("0")){
				p.put("classify_name","水果");
			}else if(p.get("classify").equals("1")){
				p.put("classify_name","蔬菜");
			}else if(p.get("classify").equals("2")){
				p.put("classify_name","其他");
			}
		}
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/example_eiedata.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/example_eiedata.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "案例信息-导入导出案例_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}



	@RequestMapping(value = "/exportMergeData", method = RequestMethod.GET)
	public void exportMergeData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);

		List<PageData> list = new ArrayList<PageData>();
		PageData p1 = new PageData();
		p1.put("classify","0");
		p1.put("classify_name","水果");
		list.add(p1);
		PageData p2 = new PageData();
		p2.put("classify","1");
		p2.put("classify_name","蔬菜");
		list.add(p2);
		PageData p3 = new PageData();
		p3.put("classify","2");
		p3.put("classify_name","其他");
		list.add(p3);
		for (PageData pp:list) {
			pd.put("classify",pp.get("classify"));
			List<PageData> ls = eiedataService.findList(pd);
			pp.put("child_list",ls);
		}

		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/example_eiedata_merge.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/example_eiedata_merge.xls";

		XLSTransformer transformer = new XLSTransformer();
//        transformer.transformXLS(tempPath, beans, toFile);
		//处理合并单元格
		InputStream is = new FileInputStream(tempPath);
		HSSFWorkbook workbook = (HSSFWorkbook)transformer.transformXLS(is,beans);
		HSSFSheet sheet = workbook.getSheetAt(0);

		int startNum = 1;
		int endNum = 0;
		for (PageData pp:list) {
			endNum = endNum+((ArrayList<PageData>)pp.get("child_list")).size();

			System.out.println(startNum+"------------"+endNum);

			sheet.addMergedRegion(new CellRangeAddress(startNum,endNum,0,0));
			sheet.addMergedRegion(new CellRangeAddress(startNum,endNum,1,1));
			startNum = startNum+((ArrayList<PageData>)pp.get("child_list")).size();
		}

//		sheet.addMergedRegion(new CellRangeAddress(1,3,0,0));
//		sheet.addMergedRegion(new CellRangeAddress(1,3,1,1));
//
//		sheet.addMergedRegion(new CellRangeAddress(4,5,0,0));
//		sheet.addMergedRegion(new CellRangeAddress(4,5,1,1));
//
//		sheet.addMergedRegion(new CellRangeAddress(6,7,0,0));
//		sheet.addMergedRegion(new CellRangeAddress(6,7,1,1));

		OutputStream os = new FileOutputStream(toFile);
		workbook.write(os);
		is.close();;
		os.flush();

		FileUtil.downFile(response, toFile, "案例信息-导入导出案例_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}



}
