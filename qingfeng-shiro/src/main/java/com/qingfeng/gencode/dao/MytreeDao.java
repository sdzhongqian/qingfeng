package com.qingfeng.gencode.dao;

import com.qingfeng.base.dao.CrudDao;
import com.qingfeng.util.PageData;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Title: MytreeDao
 * @ProjectName qingfeng
 * @Description: MytreeDao
 * @author anxingtao
 * @date 2020-9-22 22:42
 */
@Mapper
public interface MytreeDao extends CrudDao<PageData> {

    /**
    * @Description: updateStatus
    * @Param: [pd]
    * @return: void
    * @Author: anxingtao
    * @Date: 2020-10-13 11:10
    */
    void updateStatus(PageData pd);



    /**
    * @Description: findContainChildList
    * @Param: [pd]
    * @return: java.util.List<com.qingfeng.util.PageData>
    * @Author: anxingtao
    * @Date: 2020-10-15 23:34
    */
    List<PageData> findContainChildList(PageData pd);

}
