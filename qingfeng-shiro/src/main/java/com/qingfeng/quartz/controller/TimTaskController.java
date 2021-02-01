package com.qingfeng.quartz.controller;

import com.qingfeng.base.controller.BaseController;
import com.qingfeng.quartz.model.QuartzEntity;
import com.qingfeng.quartz.service.TimTaskService;
import com.qingfeng.util.Json;
import com.qingfeng.util.Page;
import com.qingfeng.util.PageData;
import com.qingfeng.util.Verify;
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
import java.util.List;

/**
 * @Title: timTaskController
 * @ProjectName wdata
 * @Description: 定时器任务
 * @author anxingtao
 * @date 2020-10-1 21:54
 */
@Controller
@RequestMapping(value = "/quartz/timTask")
public class TimTaskController extends BaseController {

    @Autowired @Qualifier("Scheduler")
    private Scheduler scheduler;
    @Autowired
    private TimTaskService timTaskService;

    /**
     * @Description: index
     * @Param: [map, request, response]
     * @return: java.lang.String
     * @Author: anxingtao
     * @Date: 2019-6-5 15:10
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(ModelMap map,HttpServletRequest request, HttpServletResponse response) throws IOException {
        PageData pd = new PageData(request);
        map.put("pd",pd);
        return "web/quartz/timTask/timTask_list";
    }

    /**
     * @Description: findByPage
     * @Param: [request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2018-8-24 11:51
     */
    @RequestMapping(value = "/findListPage", method = RequestMethod.GET)
    public void findListPage(Page page, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        PageData pd = new PageData(request);
        //{limit=10, page=1}
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
        System.out.println("11111111111111111111111111");
        List<PageData> list = timTaskService.findListPage(page);

        int num = timTaskService.findListSize(page);
        Json json = new Json();
        json.setMsg("获取数据成功。");
        json.setCode(0);
        json.setCount(num);
        json.setData(list);
        json.setSuccess(true);
        this.writeJson(response,json);
    }



    /**
     * @Description: findInfo
     * @Param: [map]
     * @return: java.lang.String
     * @Author: anxingtao
     * @Date: 2018-8-24 11:53
     */
    @RequestMapping(value = "/findInfo", method = RequestMethod.GET)
    public String findInfo(ModelMap map,HttpServletRequest request)  {
        PageData pd = new PageData(request);
        map.addAttribute("pd",pd);
        return "web/quartz/timTask/timTask_info";
    }


    /**
     * @Description: toAdd
     * @Param: [map, request]
     * @return: java.lang.String
     * @Author: anxingtao
     * @Date: 2018-8-24 12:58
     */
    @RequestMapping(value = "/toAdd", method = RequestMethod.GET)
    public String toAdd(ModelMap map,HttpServletRequest request)  {
        PageData pd = new PageData(request);
        return "web/quartz/timTask/timTask_add";
    }

    /**
     * @Description: save
     * @Param: [request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2018-8-24 13:02
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public void save(QuartzEntity quartz, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException  {
        PageData pd = new PageData(request);
        Json json = new Json();
        json.setSuccess(true);
        json.setMsg("操作成功。");
        try {
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
        } catch (Exception e) {
            e.printStackTrace();
            json.setSuccess(false);
            json.setMsg("操作失败。");
        }
        this.writeJson(response,json);
    }

    /**
     * @Description: toUpdate
     * @Param: [map, request]
     * @return: java.lang.String
     * @Author: anxingtao
     * @Date: 2018-8-24 13:02
     */
    @RequestMapping(value = "/toUpdate", method = RequestMethod.GET)
    public String toUpdate(ModelMap map,HttpServletRequest request)  {
        PageData pd = new PageData(request);
        map.addAttribute("pd",pd);
        return "web/quartz/timTask/timTask_update";
    }

    /**
     * @Description: update
     * @Param: [request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2018-8-24 13:03
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public void update(QuartzEntity quartz,HttpServletRequest request,HttpServletResponse response) throws IOException  {
        PageData pd = new PageData(request);
        Json json = new Json();
        json.setSuccess(true);
        json.setMsg("操作成功。");
        try {
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
        } catch (Exception e) {
            e.printStackTrace();
            json.setSuccess(false);
            json.setMsg("操作失败。");
        }
        this.writeJson(response,json);
    }


    /**
     * @Description: del
     * @Param: [request, response]
     * @return: void
     * @Author: anxingtao
     * @Date: 2018-8-27 14:46
     */
    @RequestMapping(value = "/del", method = RequestMethod.GET)
    public void del(HttpServletRequest request,HttpServletResponse response) throws IOException  {
        PageData pd = new PageData(request);
        Json json = new Json();
        json.setSuccess(true);
        json.setMsg("操作成功。");
        try {
            String jobnames[] = pd.get("jobnames").toString().split(",");
            String jobgroups[] = pd.get("jobgroups").toString().split(",");
            for (int i = 0; i < jobnames.length; i++) {
                TriggerKey triggerKey = TriggerKey.triggerKey(jobnames[i], jobgroups[i]);
                // 停止触发器
                scheduler.pauseTrigger(triggerKey);
                // 移除触发器
                scheduler.unscheduleJob(triggerKey);
                // 删除任务
                scheduler.deleteJob(JobKey.jobKey(jobnames[i], jobgroups[i]));
                System.out.println("removeJob:"+JobKey.jobKey(jobnames[i]));
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.setSuccess(false);
            json.setMsg("操作失败。");
        }
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
        json.setMsg("操作成功。");
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
            if(pd.get("type").equals("stop")){
                scheduler.pauseJob(key);
            }else if(pd.get("type").equals("restore")){
                scheduler.resumeJob(key);
            }
        } catch (SchedulerException e) {
            e.printStackTrace();
            json.setSuccess(false);
            json.setMsg("操作失败。");
        }
        this.writeJson(response,json);
    }

}
