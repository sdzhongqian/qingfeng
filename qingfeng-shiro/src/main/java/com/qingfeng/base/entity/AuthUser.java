package com.qingfeng.base.entity;

import lombok.Data;

import java.io.Serializable;

/**
 * Created by anxingtao on 2020-9-30.
 */
@Data
public class AuthUser implements Serializable {

    public String id;
    public String login_name;
    public String name;

}
