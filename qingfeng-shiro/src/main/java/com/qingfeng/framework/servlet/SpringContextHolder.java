package com.qingfeng.framework.servlet;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

/**
 * 注入
 */
@Component
@Lazy(false)
public class SpringContextHolder implements ApplicationContextAware {

    private static ApplicationContext applicationContext;

    @Autowired
    @Override
    public void setApplicationContext(ApplicationContext ac) throws BeansException {
        SpringContextHolder.applicationContext = ac;
//        System.out.println("###################################################################");
//        System.out.println("ID:"+SpringContextHolder.getApplicationContext().getId());
//        System.out.println("getApplicationName:"+SpringContextHolder.getApplicationContext().getApplicationName());
//        System.out.println("applicationContext:"+SpringContextHolder.applicationContext);
    }

    public static ApplicationContext getApplicationContext() {
        assertApplicationContext();
        return applicationContext;
    }

    @SuppressWarnings("unchecked")
    public static <T> T getBean(String beanName) {
        assertApplicationContext();
        return (T) applicationContext.getBean(beanName);
    }

    public static <T> T getBean(Class<T> requiredType) {
        assertApplicationContext();
        return applicationContext.getBean(requiredType);
    }

    private static void assertApplicationContext() {
        if (SpringContextHolder.applicationContext == null) {
            throw new RuntimeException("applicaitonContext属性为null,请检查是否注入了SpringContextHolder!");
        }
    }

}