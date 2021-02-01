package com.qingfeng.framework.shiro.service;

import com.qingfeng.base.entity.AuthUser;
import com.qingfeng.base.service.CrudService;
import com.qingfeng.framework.shiro.realm.ShiroRealm;
import com.qingfeng.framework.servlet.SpringContextHolder;
import com.qingfeng.system.dao.AreaDao;
import com.qingfeng.system.service.MenuService;
import com.qingfeng.system.service.UserService;
import com.qingfeng.util.PageData;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.mgt.RealmSecurityManager;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.mgt.DefaultFilterChainManager;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @Title: ShiroService
 * @ProjectName wdata
 * @Description: Shiro
 * @author anxingtao
 * @date 2020-9-30 9:10
 */
@Service
@Transactional
public class ShiroService extends CrudService<AreaDao,PageData> {

    @Autowired
    private MenuService menuService;
    @Autowired
    private UserService userService;

    /**
     * 初始化权限
     */
    public Map<String, String> loadFilterChainDefinitions() {
        /*
            配置访问权限
            - anon:所有url都都可以匿名访问
            - authc: 需要认证才能进行访问（此处指所有非匿名的路径都需要登陆才能访问）
            - user:配置记住我或认证通过可以访问
         */
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<String, String>();
        // 配置退出过滤器,其中的具体的退出代码Shiro已经替我们实现了
        filterChainDefinitionMap.put("/system/login/**", "anon");
        filterChainDefinitionMap.put("/passport/login", "anon");
        filterChainDefinitionMap.put("/favicon.ico", "anon");
        filterChainDefinitionMap.put("/error", "anon");
        filterChainDefinitionMap.put("/assets/**", "anon");
        filterChainDefinitionMap.put("/resources/**", "anon");
        // 加载数据库中配置的资源权限列表
        PageData pd = new PageData();
        pd.put("type","menu");
        List<PageData> menuList = menuService.findList(pd);
        for (PageData mPd : menuList) {
            if (!StringUtils.isEmpty(mPd.get("url")) && !StringUtils.isEmpty(mPd.get("code"))) {
                String permission = "perms[" + mPd.get("code")+"List" + "]";
                filterChainDefinitionMap.put(mPd.get("url").toString(), permission);
                System.out.println("#####################:"+mPd.get("url").toString()+"##"+permission);
            }
        }
        // 本例子中并不存在什么特别关键的操作，所以直接使用user认证。
        filterChainDefinitionMap.put("/**", "kickout,authc,onlineSession,syncOnlineSession");
        return filterChainDefinitionMap;
    }



    /**
     * 重新加载权限
     */
    public void updatePermission() {
        ShiroFilterFactoryBean shirFilter = SpringContextHolder.getBean(ShiroFilterFactoryBean.class);
        synchronized (shirFilter) {
            AbstractShiroFilter shiroFilter = null;
            try {
                shiroFilter = (AbstractShiroFilter) shirFilter.getObject();
            } catch (Exception e) {
                throw new RuntimeException("get ShiroFilter from shiroFilterFactoryBean error!");
            }

            PathMatchingFilterChainResolver filterChainResolver = (PathMatchingFilterChainResolver) shiroFilter.getFilterChainResolver();
            DefaultFilterChainManager manager = (DefaultFilterChainManager) filterChainResolver.getFilterChainManager();

            // 清空老的权限控制
            manager.getFilterChains().clear();

            shirFilter.getFilterChainDefinitionMap().clear();
            shirFilter.setFilterChainDefinitionMap(loadFilterChainDefinitions());
            // 重新构建生成
            Map<String, String> chains = shirFilter.getFilterChainDefinitionMap();
            for (Map.Entry<String, String> entry : chains.entrySet()) {
                String url = entry.getKey();
                String chainDefinition = entry.getValue().trim().replace(" ", "");
                manager.createChain(url, chainDefinition);
            }
        }
    }



    /**
     * 重新加载用户权限
     *
     * @param user
     */
    public void reloadAuthorizingByUserId(AuthUser user) {
        RealmSecurityManager rsm = (RealmSecurityManager) SecurityUtils.getSecurityManager();
        ShiroRealm shiroRealm = (ShiroRealm) rsm.getRealms().iterator().next();
        Subject subject = SecurityUtils.getSubject();
        String realmName = subject.getPrincipals().getRealmNames().iterator().next();
        SimplePrincipalCollection principals = new SimplePrincipalCollection(user, realmName);
        subject.runAs(principals);
        shiroRealm.getAuthorizationCache().remove(subject.getPrincipals());
        subject.releaseRunAs();

        System.out.println("用户"+user.getName()+"的权限更新成功！！");
    }

    /**
     * 重新加载所有拥有roleId角色的用户的权限
     * @param role_id
     */
    public void reloadAuthorizingByRoleId(String role_id) {
        PageData pd = new PageData();
        pd.put("role_id",role_id);
        List<PageData> userList = userService.findRoleUserList(pd);
        if (CollectionUtils.isEmpty(userList)) {
            return;
        }
        for (PageData user : userList) {
            AuthUser au = new AuthUser();
            au.setId(user.get("id").toString());
            au.setLogin_name(user.get("login_name").toString());
            au.setName(user.get("name").toString());
            reloadAuthorizingByUserId(au);
        }
    }



}