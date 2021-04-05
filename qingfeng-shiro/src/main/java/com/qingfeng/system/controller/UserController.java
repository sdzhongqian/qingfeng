package com.qingfeng.system.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.system.service.*;
import com.qingfeng.util.*;
import net.sf.jxls.transformer.XLSTransformer;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
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
import java.util.concurrent.TimeUnit;

/**
 * @Title: UserController
 * @ProjectName com.qingfeng
 * @Description: 用户Controller层
 * @author anxingtao
 * @date 2020-9-22 22:46
 */
@Controller
@RequestMapping(value = "/system/user")
public class UserController extends BaseController {

	/**
	 * 用户登录次数计数  redisKey 前缀
	 */
	private static final String SHIRO_LOGIN_COUNT = "shiro_login_count_";
	/**
	 * 用户登录是否被锁定    一小时 redisKey 前缀
	 */
	private static final String SHIRO_IS_LOCK = "shiro_is_lock_";

	@Autowired
	private UserService userService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private OrganizeService organizeService;
	@Autowired
	public LoginService loginService;
	@Autowired
	private ThemeService themeService;
	@Autowired
	private PlatformTransactionManager txManager;
	@Autowired
	private RedisTemplate redisTemplate;

	/** 
	 * @Description: index 
	 * @Param: [map, request, response] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("userList")
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(ModelMap map, HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/user/user_list";
	}

	/** 
	 * @Description: findListPage 
	 * @Param: [page, request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:51 
	 */
	@RequiresPermissions("userList")
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
		List<PageData> list = userService.findListPage(page);
		int num = userService.findListSize(page);
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
     * @Date: 2020-9-22 22:52 
     */ 
    @RequestMapping(value = "/findList", method = RequestMethod.GET)
    public void findList(HttpServletRequest request, HttpServletResponse response) throws IOException  {
    	PageData pd = new PageData(request);

    	List<PageData> list = userService.findList(pd);
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
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:info")
	@RequestMapping(value = "/findInfo", method = RequestMethod.GET)
	public String findInfo(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = userService.findInfo(pd);
		//查询用户组织
		pd.put("user_id",p.get("id"));
		List<PageData> list = userService.findUserOrganize(pd);
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/user/user_info";
	}


	/** 
	 * @Description: toAdd 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:add")
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/user/user_add";
	}

	/** 
	 * @Description: save 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:add")
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		Json json = new Json();

		//判断登录用户名称是否存在
		pd.put("query_login_name",Arrays.asList(pd.get("login_name").toString().split(",")));
		List<PageData> list = userService.findUserList(pd);
		if(list.size()>0){
			json.setSuccess(false);
			json.setMsg("用户【"+pd.get("login_name").toString()+"】已经存在！");
		}else{
			//主键id
			String id = GuidUtil.getUuid();
			pd.put("id", id);
			String time = DateTimeUtil.getDateTimeStr();
			pd.put("create_time", time);
			pd.put("update_time", time);
			pd.put("status","0");
			pd.put("type","1");
			pd.put("pwd_error_num","0");
			pd.put("theme_id","1");
			pd.put("login_password", PasswordUtil.encrypt(pd.get("login_password").toString(), pd.get("login_name").toString()));
			//处理数据权限
			PageData user = (PageData) session.getAttribute("loginUser");
			PageData organize = (PageData) session.getAttribute("loginOrganize");
			pd.put("create_user",user.get("id"));
			pd.put("create_organize",organize.get("organize_id"));

			int num = userService.save(pd);
			if(num==1){
				//处理组织信息
				String[] type = request.getParameterValues("type");
				String[] organize_id = request.getParameterValues("organize_id");
				String[] organize_name = request.getParameterValues("organize_name");
				String[] position = request.getParameterValues("position");
				String[] child_order_by = request.getParameterValues("child_order_by");
				for (int i = 0; i < organize_id.length; i++) {
					PageData orgPd = new PageData();
					orgPd.put("id",GuidUtil.getGuid());
					orgPd.put("user_id",id);
					orgPd.put("type",type[i]);
					orgPd.put("use_status",type[i]);
					orgPd.put("organize_id",organize_id[i]);
					orgPd.put("organize_name",organize_name[i]);
					orgPd.put("position",position[i]);
					orgPd.put("order_by",child_order_by[i]);
					orgPd.put("create_user",user.get("id"));
					orgPd.put("create_time", time);
					userService.saveUserOrganize(orgPd);
				}
			}
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
	 * @Date: 2020-9-25 23:52
	 */
	@RequiresPermissions("user:addMore")
	@RequestMapping(value = "/toAddMore", method = RequestMethod.GET)
	public String toAddMore(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		String return_url = "web/system/user/user_addMore";
		return return_url;
	}

	/**
	 * @Description: saveMore
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2019-7-9 10:06
	 */
	@RequiresPermissions("user:addMore")
	@RequestMapping(value = "/saveMore", method = RequestMethod.POST)
	public void saveMore(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		Json json = new Json();
		//处理时间
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("type","1");
		pd.put("status",0);
		pd.put("theme_id","1");
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		String[] login_name = request.getParameterValues("login_name");
		String[] name = request.getParameterValues("name");
		String[] sex = request.getParameterValues("sex");
		String[] phone = request.getParameterValues("phone");
		String[] email = request.getParameterValues("email");
//		String[] birth_date = request.getParameterValues("birth_date");
//		String[] live_address = request.getParameterValues("live_address");
//		String[] birth_address = request.getParameterValues("birth_address");
//		String[] motto = request.getParameterValues("motto");
		String[] order_by = request.getParameterValues("order_by");
		String[] remark = request.getParameterValues("remark");

		//判断登录用户名称是否存在
		pd.put("query_login_name",Arrays.asList(login_name));
		List<PageData> list = userService.findUserList(pd);
		if(list.size()>0){
			String msg = "";
			StringBuffer sb = new StringBuffer();
			for(PageData p: list){
				sb.append(p.get("login_name")).append(",");
			}
			if(sb.length()>0){
				msg = sb.substring(0,sb.length()-1);
			}
			json.setSuccess(false);
			json.setMsg("用户【"+msg+"】已经存在！");
		}else{
			for (int i = 0; i < login_name.length; i++) {
				String id = GuidUtil.getUuid();
				pd.put("id", id);
				pd.put("login_name",login_name[i]);
				pd.put("login_password",PasswordUtil.encrypt(pd.get("login_password").toString(), login_name[i]));
				pd.put("name",name[i]);
				pd.put("sex",sex[i]);
				pd.put("phone",phone[i]);
				pd.put("email",email[i]);
//			pd.put("birth_date",birth_date[i]);
//			pd.put("live_address",live_address[i]);
//			pd.put("birth_address",birth_address[i]);
//			pd.put("motto",motto[i]);
				pd.put("order_by",order_by[i]);
				pd.put("remark",remark[i]);
				userService.save(pd);

				PageData orgPd = new PageData();
				orgPd.put("id",GuidUtil.getGuid());
				orgPd.put("user_id",id);
				orgPd.put("type","0");//主组织
				orgPd.put("organize_id",pd.get("organize_id"));
				orgPd.put("organize_name",pd.get("organize_name"));
				orgPd.put("use_status","0");
				orgPd.put("position","1");
				orgPd.put("order_by","1");
				orgPd.put("create_user",user.get("id"));
				orgPd.put("create_time", time);
				userService.saveUserOrganize(orgPd);
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
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:update")
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = userService.findInfo(pd);
		//查询用户组织
		pd.put("user_id",p.get("id"));
		List<PageData> list = userService.findUserOrganize(pd);
		map.put("list",list);
		map.put("p",p);
		map.put("pd",pd);
		return "web/system/user/user_update";
	}

	/** 
	 * @Description: update 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:update")
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();

		boolean bol = true;
		if(!pd.get("old_login_name").equals(pd.get("login_name"))){
			//判断登录用户名称是否存在
			pd.put("query_login_name",Arrays.asList(pd.get("login_name").toString().split(",")));
			List<PageData> list = userService.findUserList(pd);
			if(list.size()>0){
				json.setSuccess(false);
				json.setMsg("用户【"+pd.get("login_name").toString()+"】已经存在！");
				bol = false;
			}
		}
		if(bol){
			String id = pd.get("id").toString();
			String time = DateTimeUtil.getDateTimeStr();
			pd.put("update_time", time);
			PageData user = (PageData) session.getAttribute("loginUser");
			pd.put("update_user",user.get("id"));
			int num = userService.update(pd);
			if(num==1){
				//处理组织信息
				String[] child_id = request.getParameterValues("child_id");
				String[] type = request.getParameterValues("type");
				String[] organize_id = request.getParameterValues("organize_id");
				String[] organize_name = request.getParameterValues("organize_name");
				String[] position = request.getParameterValues("position");
				String[] child_order_by = request.getParameterValues("child_order_by");
				for (int i = 0; i < child_id.length; i++) {
					PageData orgPd = new PageData();
					orgPd.put("user_id",id);
					orgPd.put("type",type[i]);
					orgPd.put("use_status",type[i]);
					orgPd.put("organize_id",organize_id[i]);
					orgPd.put("organize_name",organize_name[i]);
					orgPd.put("position",position[i]);
					orgPd.put("order_by",child_order_by[i]);
					if(Verify.verifyIsNotNull(child_id[i])){
						orgPd.put("id",child_id[i]);
						orgPd.put("update_time", time);
						userService.updateUserOrganize(orgPd);
					}else{
						orgPd.put("create_user",user.get("id"));
						orgPd.put("create_time", time);
						orgPd.put("id",GuidUtil.getGuid());
						userService.saveUserOrganize(orgPd);
					}
				}
			}
			json.setSuccess(true);
			json.setMsg("操作成功。");
		}
		this.writeJson(response,json);
	}


	/** 
	 * @Description: del 
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-22 22:52 
	 */
	@RequiresPermissions("user:del")
	@RequestMapping(value = "/del", method = RequestMethod.GET)
	public void del(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String[] ids = pd.get("ids").toString().split(",");
		pd.put("user_ids", Arrays.asList(ids));
		//删除关联组织
		userService.delUserOrganize(pd);
		//删除组用户关联表
		userService.delUserGroup(pd);
		//删除用户角色关联
		userService.delUserRole(pd);
		userService.del(ids);
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
	@RequiresPermissions("user:setStatus")
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		userService.update(pd);
		String loginCountKey = SHIRO_LOGIN_COUNT + pd.get("login_name");
		String isLockKey = SHIRO_IS_LOCK + pd.get("login_name");
		if(pd.get("status").equals("0")){//恢复
			redisTemplate.delete(loginCountKey);
			redisTemplate.delete(isLockKey);
		}else{//禁用
			redisTemplate.expire(isLockKey, 1, TimeUnit.HOURS);
			redisTemplate.expire(loginCountKey, 1, TimeUnit.HOURS);
		}

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


	/**
	 * @Description: toResetPwd 设置密码
	 * @Param: [map, request, session]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-23 17:40
	 */
	@RequestMapping(value = "/toResetPwd", method = RequestMethod.GET)
	public String toResetPwd(ModelMap map,HttpServletRequest request,HttpSession session)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/user/user_resetPwd";
	}


	/** 
	 * @Description: updatePwd 
	 * @Param: [request, response, session]
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-23 17:48 
	 */ 
	@RequestMapping(value = "/updatePwd", method = RequestMethod.POST)
	public void updatePwd(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		try {
			String[] ids = pd.get("ids").toString().split(",");
			String time = DateTimeUtil.getDateTimeStr();
			for (int i = 0; i < ids.length; i++) {
				pd.put("id",ids[i]);
				PageData uPd = userService.findInfo(pd);
				pd.put("login_password",PasswordUtil.encrypt(pd.get("login_password").toString(), uPd.get("login_name").toString()));
				pd.put("update_time",time);
				userService.update(pd);
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


	/** 
	 * @Description: exportData 导出 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-23 21:57
	 */ 
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public void exportData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		PageData pd = new PageData(request);
		//处理数据权限
		pd = dealDataAuth(pd, session);
		List<PageData> list = userService.findList(pd);
		Map<String, Object> beans = new HashMap<String, Object>();
		beans.put("obj", pd);
		beans.put("list", list);
		String tempPath = "";
		String toFile = "";
		tempPath = session.getServletContext().getRealPath("/") + "/template/excelExport/system_user.xls";
		toFile = session.getServletContext().getRealPath("/") + "/template/excelExport/temporary/system_user.xls";
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformXLS(tempPath, beans, toFile);
		FileUtil.downFile(response, toFile, "青锋系统用户基础信息_" + DateTimeUtil.getDateTimeStr() + ".xls");
		File file = new File(toFile);
		file.delete();
		file.deleteOnExit();
	}


	/** 
	 * @Description: selectUser 选择单用户 
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-24 22:37 
	 */ 
	@RequestMapping(value = "/selectOneUser", method = RequestMethod.GET)
	public String selectUser(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/user/user_selectOneUser";
	}

	/** 
	 * @Description: selectMoreUser 选择多用户
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-24 22:45
	 */ 
	@RequestMapping(value = "/selectMoreUser", method = RequestMethod.GET)
	public String selectMoreUser(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/user/user_selectMoreUser";
	}


	/** 
	 * @Description: delUserOrganize 
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-25 15:33 
	 */ 
	@RequestMapping(value = "/delUserOrganize", method = RequestMethod.GET)
	public void delUserOrganize(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		userService.delUserOrganize(pd);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/** 
	 * @Description: toAssignRoleAuth
	 * @Param: [map, request] 
	 * @return: java.lang.String 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 16:34 
	 */ 
	@RequestMapping(value = "/toAssignRoleAuth", method = RequestMethod.GET)
	public String toAssignRoleAuth(ModelMap map,HttpServletRequest request)  {
		PageData pd = new PageData(request);
		pd.put("user_id",pd.get("id"));
		List<PageData> roleLs = roleService.findSimpleList(pd);
		map.put("roleLs",JsonToMap.list2json(roleLs));

		List<PageData> myRoleLs = userService.findUserRoleList(pd);
		map.put("myRoleLs",JsonToMap.list2json(myRoleLs));

		List<PageData> orgList = userService.findUserOrganize(pd);
		map.put("orgList",orgList);
		map.put("pd",pd);
		return "web/system/user/user_auth";
	}


	/** 
	 * @Description: updateAuth
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 16:40 
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
			pd.put("user_id",pd.get("id"));
			pd.put("role_ids", Arrays.asList(role_ids));
			userService.delUserRole(pd);
			if(Verify.verifyIsNotNull(pd.get("role_ids"))){
				String user_id = pd.get("id").toString();
				List<PageData> list = new ArrayList<PageData>();
				//执行保存
				for (int i = 0; i < role_ids.length; i++) {
					PageData p = new PageData();
					//主键id
					p.put("id",GuidUtil.getUuid());
					p.put("role_id",role_ids[i]);
					p.put("user_id",user_id);
					p.put("create_time",time);
					p.put("create_user",user.get("id"));
					p.put("update_time",time);
					list.add(p);
				}
				userService.saveUserRole(list);
			}
			//处理数据权限
			userService.updateAuthForParam(pd);

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

	/**
	 * @Description: findTreeTableList
	 * @Param: [request, response]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-26 17:40
	 */
	@RequestMapping(value = "/findTreeTableList", method = RequestMethod.GET)
	public void findTreeTableList(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		if(user.get("type").equals("0")){//管理员
			pd.put("org_cascade","org");
		}else{
			pd.put("org_cascade",organize.get("org_cascade"));
		}
		List<PageData> list = organizeService.findTreeTableList(pd);
		//查询用户的数据权限数据
		PageData p = userService.findUserOrganizeInfo(pd);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setData(list);
		json.setObject(p);
		json.setSuccess(true);
		this.writeJson(response,json);
	}


	/** 
	 * @Description: findUserOrganizeInfo
	 * @Param: [request, response] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-26 17:45 
	 */ 
	@RequestMapping(value = "/findUserOrganizeInfo", method = RequestMethod.GET)
	public void findUserOrganizeInfo(HttpServletRequest request, HttpServletResponse response) throws Exception  {
		PageData pd = new PageData(request);

		PageData p = userService.findUserOrganizeInfo(pd);
		Json json = new Json();
		json.setMsg("获取数据成功。");
		json.setData(p);
		json.setSuccess(true);
		this.writeJson(response,json);
	}


	//====================================个人信息及密码重置=============================================

	/**
	 * @Description: toMyUpdate 跳转个人信息编辑页面
	 * @Param: [map, request]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-28 16:04
	 */
	@RequestMapping(value = "/toMyUpdate", method = RequestMethod.GET)
	public String toMyUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/login/user_update";
	}


	/**
	 * @Description: myUupdate 个人信息编辑
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-28 16:04
	 */
	@RequestMapping(value = "/myUupdate", method = RequestMethod.POST)
	public void myUupdate(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("update_user",user.get("id"));
		userService.update(pd);
		//更新成功重新刷新用户session
		pd.put("login_id",user.get("id"));
		PageData uPd = loginService.findUserInfo(pd);
		session.setAttribute("loginUser", uPd);
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}

	/**
	 * @Description: toMyResetPwd 个人密码重置
	 * @Param: [map, request, session]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-28 16:24
	 */
	@RequestMapping(value = "/toMyResetPwd", method = RequestMethod.GET)
	public String toMyResetPwd(ModelMap map,HttpServletRequest request,HttpSession session)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/system/login/user_resetPwd";
	}


	/**
	 * @Description: updateMyPwd 更新个人密码重置
	 * @Param: [request, response, session]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2020-9-28 16:24
	 */
	@RequestMapping(value = "/updateMyPwd", method = RequestMethod.POST)
	public void updateMyPwd(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception  {
		PageData pd = new PageData(request);
		Json json = new Json();
		PageData user = (PageData) session.getAttribute("loginUser");
		if(PasswordUtil.encrypt(pd.get("old_password").toString(), user.get("login_name").toString()).equals(user.get("login_password").toString())){
			String time = DateTimeUtil.getDateTimeStr();
			pd.put("login_password",PasswordUtil.encrypt(pd.get("login_password").toString(), user.get("login_name").toString()));
			pd.put("update_time",time);
			userService.update(pd);
			//更新成功重新刷新用户session
			pd.put("login_id",user.get("id"));
			PageData uPd = loginService.findUserInfo(pd);
			session.setAttribute("loginUser", uPd);
			json.setSuccess(true);
			json.setMsg("操作成功。");
		}else{
			json.setSuccess(false);
			json.setMsg("旧密码不正确，请重新输入。");
		}
		this.writeJson(response,json);
	}


	/**
	 * @Description: toSwitchOrganize 切换组织
	 * @Param: [map, request, session]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-28 16:56
	 */
	@RequestMapping(value = "/toSwitchOrganize", method = RequestMethod.GET)
	public String toSwitchOrganize(ModelMap map,HttpServletRequest request,HttpSession session)  {
		PageData pd = new PageData(request);
		PageData user = (PageData) session.getAttribute("loginUser");
		pd.put("user_id",user.get("id"));
		List<PageData> list = userService.findUserOrganize(pd);
		map.put("list",list);
		map.put("pd",pd);
		return "web/system/login/switch_organize";
	}


	/** 
	 * @Description: updateSwitchOrganize 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-28 17:03 
	 */ 
	@RequestMapping(value = "/updateSwitchOrganize", method = RequestMethod.POST)
	public void updateSwitchOrganize(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		String organize_id = pd.get("organize_id").toString();
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		if(!organize.get("organize_id").equals(organize_id)){
			PageData user = (PageData) session.getAttribute("loginUser");
			//将所有的个人信息use_status更新为：1
			PageData param = new PageData();
			param.put("user_id",user.get("id"));
			param.put("use_status","1");
			param.put("update_time",DateTimeUtil.getDateTimeStr());
			userService.updateUserOrgUseStatus(param);
			param.put("use_status","0");
			param.put("organize_id",organize_id);
			userService.updateUserOrgUseStatus(param);
			//更新当前组织session信息
			PageData orgPd = userService.findUserOrganizeInfo(param);
			session.setAttribute("loginOrganize", orgPd);
		}
		json.setSuccess(true);
		json.setMsg("切换成功。");
		this.writeJson(response,json);
	}


	/**
	 * @Description: toSwitchTheme
	 * @Param: [map, request, session]
	 * @return: java.lang.String
	 * @Author: anxingtao
	 * @Date: 2020-9-28 21:23
	 */
	@RequestMapping(value = "/toSwitchTheme", method = RequestMethod.GET)
	public String toSwitchTheme(ModelMap map,HttpServletRequest request,HttpSession session)  {
		PageData pd = new PageData(request);
		List<PageData> list = themeService.findList(pd);
		map.put("list",list);
		map.put("pd",pd);
		return "web/system/login/switch_theme";
	}


	/** 
	 * @Description: updateSwitchTheme 
	 * @Param: [request, response, session] 
	 * @return: void 
	 * @Author: anxingtao
	 * @Date: 2020-9-29 10:14
	 */ 
	@RequestMapping(value = "/updateSwitchTheme", method = RequestMethod.POST)
	public void updateSwitchTheme(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		String theme_id = pd.get("theme_id").toString();
		PageData user = (PageData) session.getAttribute("loginUser");
		if(!user.get("theme_id").equals(theme_id)){
			//将所有的个人信息use_status更新为：1
			PageData param = new PageData();
			param.put("id",user.get("id"));
			param.put("theme_id",theme_id);
			param.put("update_time",DateTimeUtil.getDateTimeStr());
			userService.update(param);
			//更新成功重新刷新用户session
			pd.put("login_id",user.get("id"));
			PageData uPd = loginService.findUserInfo(pd);
			session.setAttribute("loginUser", uPd);
		}
		json.setSuccess(true);
		json.setMsg("切换成功。");
		this.writeJson(response,json);
	}




}
