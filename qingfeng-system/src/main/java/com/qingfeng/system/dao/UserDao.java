package com.qingfeng.system.dao;

import com.qingfeng.base.dao.CrudDao;
import com.qingfeng.util.Page;
import com.qingfeng.util.PageData;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Title: UserDao
 * @ProjectName qingfeng
 * @Description: 用户DAO层
 * @author anxingtao
 * @date 2020-9-22 22:43
 */
@Mapper
public interface UserDao extends CrudDao<PageData> {

    /** 
     * @Description: saveUserOrganize 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-25 14:53 
     */ 
    public void saveUserOrganize(PageData pd);

    /** 
     * @Description: findUserOrganize
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData> 
     * @Author: anxingtao
     * @Date: 2020-9-25 15:25
     */ 
    public List<PageData> findUserOrganize(PageData pd);

    /** 
     * @Description: delUserOrganize 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-25 15:34 
     */ 
    public void delUserOrganize(PageData pd);

    /** 
     * @Description: updateUserOrganize 
     * @Param: [pd] 
     * @return: void
     * @Author: anxingtao
     * @Date: 2020-9-25 16:03
     */ 
    public void updateUserOrganize(PageData pd);

    /** 
     * @Description: findUserRoleList 
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData> 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:36 
     */ 
    public List<PageData> findUserRoleList(PageData pd);

    /** 
     * @Description: delUserRole 
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:36 
     */ 
    public void delUserRole(PageData pd);

    /** 
     * @Description: saveUserRole
     * @Param: [list] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-26 16:57
     */ 
    public void saveUserRole(List<PageData> list);


    /** 
     * @Description: findUserOrganizeInfo
     * @Param: [pd] 
     * @return: com.qingfeng.util.PageData 
     * @Author: anxingtao
     * @Date: 2020-9-26 17:46 
     */ 
    public PageData findUserOrganizeInfo(PageData pd);

    /** 
     * @Description: updateAuthForParam
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-27 0:30
     */ 
    public void updateAuthForParam(PageData pd);

    /** 
     * @Description: delUserGroup
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-28 9:28
     */ 
    public void delUserGroup(PageData pd);

    /** 
     * @Description: findUserList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData> 
     * @Author: anxingtao
     * @Date: 2020-9-28 15:59
     */ 
    public List<PageData> findUserList(PageData pd);

    /** 
     * @Description: updateUserOrgUseStatus
     * @Param: [pd] 
     * @return: void 
     * @Author: anxingtao
     * @Date: 2020-9-28 17:24
     */ 
    public void updateUserOrgUseStatus(PageData pd);


    /** 
     * @Description: findRoleUserList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData> 
     * @Author: anxingtao
     * @Date: 2020-9-30 9:50
     */ 
    public List<PageData> findRoleUserList(PageData pd);

    /**
     * @Description: findUserOnlineList
     * @Param: [pd] 
     * @return: java.util.List<com.qingfeng.util.PageData> 
     * @Author: anxingtao
     * @Date: 2020-10-3 8:26 
     */ 
    public List<PageData> findUserOnlineListPage(Page page);
    
}
