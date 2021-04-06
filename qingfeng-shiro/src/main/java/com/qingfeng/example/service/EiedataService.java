package com.qingfeng.example.service;

import com.qingfeng.base.service.CrudService;
import com.qingfeng.example.dao.EiedataDao;
import com.qingfeng.util.PageData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Title:EiedataService
 * @ProjectName com.qingfeng
 * @Description: SERVICE层
 * @author anxingtao
 * @date 2020-9-22 22:44
 */
@Service
@Transactional
public class EiedataService extends CrudService<EiedataDao,PageData> {

    @Autowired
    protected EiedataDao eiedatadao;

    /**
    * @Description: updateStatus
    * @Param: [pd]
    * @return: void
    * @Author: anxingtao
    * @Date: 2020-10-13 11:10
    */
    public void updateStatus(PageData pd){
    eiedatadao.updateStatus(pd);
    }


    /**
     * @title: saveImportList
     * @description: saveImportList
     * @author: Administrator
     * @date: 2021/4/5 0005 18:58
     */
    public Integer saveImportList(List<PageData> list){
        return eiedatadao.saveImportList(list);
    }

}