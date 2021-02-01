package com.qingfeng.system.service;

import com.qingfeng.base.service.CrudService;
import com.qingfeng.system.dao.UserDao;
import com.qingfeng.util.Page;
import com.qingfeng.util.PageData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Title: UserService
 * @ProjectName com.qingfeng
 * @Description: 用户SERVICE层
 * @author anxingtao
 * @date 2020-9-22 22:44
 */
@Service
@Transactional
public class UserService extends CrudService<UserDao,PageData> {

    @Autowired
    protected UserDao userdao;

    /**
     * @Description: saveUserOrganize
     * @Param: [pd]
     * @return: void
     * @Author: anxingtao
     * @Date: 2020-9-25 14:53
     */
    public void saveUserOrganize(PageData pd){
        userdao.saveUserOrganize(pd);
    }

    /** 
     * @Description: findUserOrganize
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData>
     * @Author: anxingtao
     * @Date: 2020-9-25 15:25
     */ 
    public List<PageData> findUserOrganize(PageData pd){
        return userdao.findUserOrganize(pd);
    }
    
    /** 
     * @Description: delUserOrganize
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-25 15:34 
     */ 
    public void delUserOrganize(PageData pd){
        userdao.delUserOrganize(pd);
    }

    /** 
     * @Description: updateUserOrganize 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-25 16:03
     */ 
    public void updateUserOrganize(PageData pd){
        userdao.updateUserOrganize(pd);
    }

    /** 
     * @Description: findUserRoleList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData>
     * @Author: anxingtao
     * @Date: 2020-9-26 16:57
     */ 
    public List<PageData> findUserRoleList(PageData pd){
        return userdao.findUserRoleList(pd);
    }

    /** 
     * @Description: delUserRole 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:35 
     */ 
    public void delUserRole(PageData pd){
        userdao.delUserRole(pd);
    }

    /** 
     * @Description: saveUserRole 
     * @Param: [list] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:36 
     */ 
    public void saveUserRole(List<PageData> list){
        userdao.saveUserRole(list);
    }


    /**
     * @Description: findUserOrganizeInfo
     * @Param: [pd] 
     * @return: com.qingfeng.util.PageData
     * @Author: anxingtao
     * @Date: 2020-9-26 17:46 
     */ 
    public PageData findUserOrganizeInfo(PageData pd){
        return userdao.findUserOrganizeInfo(pd);
    }

    /** 
     * @Description: updateAuthForParam
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-27 0:30
     */ 
    public void updateAuthForParam(PageData pd){
        userdao.updateAuthForParam(pd);
    }

    /** 
     * @Description: delUserGroup 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-28 9:26
     */ 
    public void delUserGroup(PageData pd){
        userdao.delUserGroup(pd);
    }

    /** 
     * @Description: findUserList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData>
     * @Author: anxingtao
     * @Date: 2020-9-28 15:59
     */ 
    public List<PageData> findUserList(PageData pd){
        return userdao.findUserList(pd);
    }

    /** 
     * @Description: updateUserOrgUseStatus
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-28 17:21
     */ 
    public void updateUserOrgUseStatus(PageData pd){
        userdao.updateUserOrgUseStatus(pd);
    }


    /** 
     * @Description: findRoleUserList 查询用户角色信息
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData>
     * @Author: anxingtao
     * @Date: 2020-9-30 9:50
     */ 
    public List<PageData> findRoleUserList(PageData pd){
        return userdao.findRoleUserList(pd);
    }

    /** 
     * @Description: findUserOnlineList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData>
     * @Author: anxingtao
     * @Date: 2020-10-3 8:51
     */ 
    public List<PageData> findUserOnlineListPage(Page page){
        return userdao.findUserOnlineListPage(page);
    }

    
}