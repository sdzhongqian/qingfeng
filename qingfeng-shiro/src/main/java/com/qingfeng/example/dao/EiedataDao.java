package com.qingfeng.example.dao;

import com.qingfeng.base.dao.CrudDao;
import com.qingfeng.util.PageData;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Title: EiedataDao
 * @ProjectName com.qingfeng
 * @Description: EiedataDao
 * @author anxingtao
 * @date 2020-9-22 22:42
 */
@Mapper
public interface EiedataDao extends CrudDao<PageData> {

    /**
    * @Description: updateStatus
    * @Param: [pd]
    * @return: void
    * @Author: anxingtao
    * @Date: 2020-10-13 11:10
    */
    public void updateStatus(PageData pd);

    /**
     * @title: saveImportList
     * @description: saveImportList
     * @author: Administrator
     * @date: 2021/4/5 0005 18:58
     */
    public Integer saveImportList(List<PageData> list);


}
