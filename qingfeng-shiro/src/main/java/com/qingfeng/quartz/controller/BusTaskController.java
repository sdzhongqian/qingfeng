package com.qingfeng.quartz.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.quartz.model.QuartzEntity;
import com.qingfeng.quartz.service.BusTaskService;
import com.qingfeng.util.*;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * @Title: BusTaskController
 * @ProjectName wdata
 * @Description: 业务任务
 * @author anxingtao
 * @date 2020-10-2 12:04
 */
@Controller
@RequestMapping(value = "/quartz/busTask")
public class BusTaskController extends BaseController {

	@Autowired
	private BusTaskService busTaskService;
	@Autowired @Qualifier("Scheduler")
	private Scheduler scheduler;

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
		return "web/quartz/busTask/busTask_list";
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
		List<PageData> list = busTaskService.findListPage(page);
		int num = busTaskService.findListSize(page);
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

    	List<PageData> list = busTaskService.findList(pd);
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
		PageData p = busTaskService.findInfo(pd);
		map.addAttribute("p",p);
		map.put("pd",pd);
		return "web/quartz/busTask/busTask_info";
	}


	/**
	* @Description: toAdd
	* @Param: [map, request]
	* @return: java.lang.String
	* @Author: anxingtao
	* @Date: 2018-9-3 15:01
	*/
	@RequestMapping(value = "/toAdd", method = RequestMethod.GET)
		public String toAdd(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		map.put("pd",pd);
		return "web/quartz/busTask/busTask_add";
	}

	/**
	* @Description: save
	* @Param: [request, response, session]
	* @return: void
	* @Author: anxingtao
	* @Date: 2018-9-3 15:01
	*/
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void save(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
		PageData pd = new PageData(request);
		//主键id
		pd.put("id", GuidUtil.getUuid());
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("create_time", time);
		pd.put("trigger_time",time);
		//处理数据权限
		PageData user = (PageData) session.getAttribute("loginUser");
		PageData organize = (PageData) session.getAttribute("loginOrganize");
		pd.put("create_user",user.get("id"));
		pd.put("create_organize",organize.get("organize_id"));

		//处理业务
		String type = pd.getString("type");
//		if(type.equals("1")){//类型为1 ----后续可根据type拓展
			pd.put("job_group",organize.get("organize_id"));//根据组织进行分组
			pd.put("job_class_name","com.qingfeng.quartz.job.MessageJob");
			pd.put("trigger_state","Y");
//		}
		Json json = new Json();
		PageData p = busTaskService.findInfoForNameAndGroup(pd);
		if(Verify.verifyIsNotNull(p)){
			json.setSuccess(false);
			json.setMsg("操作失败，标题已存在。");
		}else{
			pd.put("triggerName","");
			int num = busTaskService.save(pd);
			if(num==1){
				try {
					QuartzEntity quartz = new QuartzEntity();
					quartz.setJobName(pd.get("job_name").toString());
					quartz.setJobGroup(pd.get("job_group").toString());
					quartz.setDescription(pd.get("description").toString()+"#"+pd.get("notice_user").toString());
					quartz.setCronExpression(pd.get("cron_expression").toString());
					quartz.setJobClassName(pd.get("job_class_name").toString());

					//获取Scheduler实例、废弃、使用自动注入的scheduler、否则spring的service将无法注入
					//Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
					//如果是修改  展示旧的 任务
					if(quartz.getOldJobGroup()!=null){
						JobKey key = new JobKey(quartz.getOldJobName(),quartz.getOldJobGroup());
						scheduler.deleteJob(key);
					}
					Class cls = Class.forName(quartz.getJobClassName()) ;
					cls.newInstance();
					//构建job信息
					JobDetail job = JobBuilder.newJob(cls).withIdentity(quartz.getJobName(),
							quartz.getJobGroup())
							.withDescription(quartz.getDescription()).build();
					// 触发时间点
					CronScheduleBuilder cronScheduleBuilder = CronScheduleBuilder.cronSchedule(quartz.getCronExpression());
					Trigger trigger = TriggerBuilder.newTrigger().withIdentity("trigger"+quartz.getJobName(), quartz.getJobGroup())
							.startNow().withSchedule(cronScheduleBuilder).build();
					//交由Scheduler安排触发
					scheduler.scheduleJob(job, trigger);

					json.setSuccess(true);
					json.setMsg("操作成功。");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		this.writeJson(response,json);
	}

	/**
	* @Description: toUpdate
	* @Param: [map, request]
	* @return: java.lang.String
	* @Author: anxingtao
	* @Date: 2018-9-3 15:02
	*/
	@RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
	public String toUpdate(ModelMap map, HttpServletRequest request)  {
		PageData pd = new PageData(request);
		PageData p = busTaskService.findInfo(pd);
		map.put("p",p);
		map.put("pd",pd);
		return "web/quartz/busTask/busTask_update";
	}

	/**
	* @Description: update
	* @Param: [request, response]
	* @return: void
	* @Author: anxingtao
	* @Date: 2018-9-3 15:03
	*/
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public void update(HttpServletRequest request, HttpServletResponse response,HttpSession session) throws IOException  {
		PageData pd = new PageData(request);

		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		pd.put("trigger_time",time);
        PageData user = (PageData) session.getAttribute("loginUser");
        pd.put("update_user",user.get("id"));
		pd.put("trigger_state","Y");

		Json json = new Json();
		PageData p = busTaskService.findInfoForNameAndGroup(pd);
		if(Verify.verifyIsNotNull(p)){
			json.setSuccess(false);
			json.setMsg("操作失败，标题已存在。");
		}else{
			int num = busTaskService.update(pd);
			if(num==1){
				try {
					QuartzEntity quartz = new QuartzEntity();
					quartz.setJobName(pd.get("job_name").toString());
					quartz.setJobGroup(pd.get("job_group").toString());
					quartz.setDescription(pd.get("description").toString()+"#"+pd.get("notice_user").toString());
					quartz.setCronExpression(pd.get("cron_expression").toString());
					quartz.setJobClassName(pd.get("job_class_name").toString());
					quartz.setOldJobName(pd.get("oldJobName").toString());
					quartz.setOldJobGroup(pd.get("oldJobGroup").toString());

					System.out.println(quartz.toString());
					System.out.println(quartz.getCronExpression());
					//获取Scheduler实例、废弃、使用自动注入的scheduler、否则spring的service将无法注入
					//Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
					//如果是修改  展示旧的 任务
					if(quartz.getOldJobGroup()!=null){
						JobKey key = new JobKey(quartz.getOldJobName(),quartz.getOldJobGroup());
						scheduler.deleteJob(key);
					}
					Class cls = Class.forName(quartz.getJobClassName()) ;
					cls.newInstance();
					//构建job信息
					JobDetail job = JobBuilder.newJob(cls).withIdentity(quartz.getJobName(),
							quartz.getJobGroup())
							.withDescription(quartz.getDescription()).build();
					// 触发时间点
					CronScheduleBuilder cronScheduleBuilder = CronScheduleBuilder.cronSchedule(quartz.getCronExpression());
					Trigger trigger = TriggerBuilder.newTrigger().withIdentity("trigger"+quartz.getJobName(), quartz.getJobGroup())
							.startNow().withSchedule(cronScheduleBuilder).build();
					//交由Scheduler安排触发
					scheduler.scheduleJob(job, trigger);
					json.setSuccess(true);
					json.setMsg("操作成功。");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		this.writeJson(response,json);
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
		try {
			String[] ids = pd.get("ids").toString().split(",");
			pd.put("ids", Arrays.asList(ids));
			List<PageData> list = busTaskService.findList(pd);
			for (int i = 0; i < list.size(); i++) {
				TriggerKey triggerKey = TriggerKey.triggerKey(list.get(i).get("job_name").toString(), list.get(i).get("job_group").toString());
				// 停止触发器
				scheduler.pauseTrigger(triggerKey);
				// 移除触发器
				scheduler.unscheduleJob(triggerKey);
				// 删除任务
				scheduler.deleteJob(JobKey.jobKey(list.get(i).get("job_name").toString(), list.get(i).get("job_group").toString()));
			}
			busTaskService.del(ids);
		} catch (Exception e) {
			e.printStackTrace();
		}
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		this.writeJson(response,json);
	}


	/**
	 * @Description: execution
	 * @Param: [request, response]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2019-6-5 17:34
	 */
	@RequestMapping(value = "/execution", method = RequestMethod.GET)
	public void execution(HttpServletRequest request,HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("执行成功。");
		try {
			JobKey key = new JobKey(pd.get("jobname").toString(),pd.get("jobgroup").toString());
			scheduler.triggerJob(key);
		} catch (SchedulerException e) {
			e.printStackTrace();
			json.setSuccess(false);
			json.setMsg("操作失败。");
		}
		this.writeJson(response,json);
	}


	/**
	 * @Description: stopOrRestore
	 * @Param: [request, response]
	 * @return: void
	 * @Author: anxingtao
	 * @Date: 2019-6-5 17:40
	 */
	@RequestMapping(value = "/stopOrRestore", method = RequestMethod.GET)
	public void stopOrRestore(HttpServletRequest request,HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		Json json = new Json();
		json.setSuccess(true);
		json.setMsg("操作成功。");
		try {
			JobKey key = new JobKey(pd.get("jobname").toString(),pd.get("jobgroup").toString());
			System.out.println(pd.get("type"));
			if(pd.get("type").equals("N")){
				scheduler.pauseJob(key);
				System.out.println("停止。。。。。");
				pd.put("trigger_state","N");
			}else if(pd.get("type").equals("Y")){
				scheduler.resumeJob(key);
				System.out.println("启动。。。。。");
				pd.put("trigger_state","Y");
				pd.put("trigger_time",DateTimeUtil.getDateTimeStr());
			}
			pd.put("update_time",DateTimeUtil.getDateTimeStr());
			System.out.println(pd.toString());
			busTaskService.update(pd);
		} catch (SchedulerException e) {
			e.printStackTrace();
			json.setSuccess(false);
			json.setMsg("操作失败。");
		}
		this.writeJson(response,json);
	}


	/**
	* @Description: updateStatus
	* @Param: [request, response]
	* @return: void
	* @Author: anxingtao
	* @Date: 2018-9-3 15:04
	*/
	@RequestMapping(value = "/updateStatus", method = RequestMethod.GET)
	public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException  {
		PageData pd = new PageData(request);
		String time = DateTimeUtil.getDateTimeStr();
		pd.put("update_time", time);
		busTaskService.update(pd);

		Json json = new Json();
		json.setSuccess(true);
		json.setFlag("操作成功。");
		this.writeJson(response,json);
	}


}
