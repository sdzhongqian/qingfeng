package com.qingfeng.framework.servlet;

import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;

/**
 * Created by anxingtao on 2018-8-19.
 */
//@WebListener
public class Customlister implements ServletRequestListener {
    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        System.out.println("1");
    }
    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        System.out.println("2");
    }
}