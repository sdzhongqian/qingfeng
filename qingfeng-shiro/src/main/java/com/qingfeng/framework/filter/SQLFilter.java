package com.qingfeng.framework.filter;

import org.apache.commons.lang3.StringUtils;

/**
 * @ProjectName SQLFilter
 * @author Administrator
 * @version 1.0.0
 * @Description 防止前端排序字段直接使用字段用于sql造成sql注入
 * @createTime 2021/7/18 0018 21:12
 */
public class SQLFilter implements CharacterFilter {
    /**
     * sql字符过滤
     */
    private static final String[] KEY_WORDS = {"master", "truncate", "insert", "select", "delete", "update", "declare", "alter", "drop"};

    /**
     * 是否抛出异常
     * <p>
     * 为 false 直接替换为""
     */
    private final boolean throwException;

    public SQLFilter(boolean throwException) {
        this.throwException = throwException;
    }

    /**
     * SQL注入过滤
     *
     * @param str 待验证的字符串
     */
    public String sqlInject(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        //去掉'|"|;|\字符
        str = StringUtils.replace(str, "'", "");
        str = StringUtils.replace(str, "\"", "");
        str = StringUtils.replace(str, ";", "");
        str = StringUtils.replace(str, "\\", "");
        //转换成小写
        str = str.toLowerCase();
        //判断是否包含非法字符
        for (String keyword : KEY_WORDS) {
            if (str.contains(keyword)) {
                if (this.throwException) {
                    System.out.println("包含非法字符");
                }
                str = str.replace(keyword, "");
            }
        }
        return str;
    }

    @Override
    public String filter(String input) {
        return this.sqlInject(input);
    }
}
