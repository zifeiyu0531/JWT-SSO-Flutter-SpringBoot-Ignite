package com.web.sso.config;

import com.web.sso.model.*;
import com.web.sso.service.UserService;
import org.apache.ignite.Ignite;
import org.apache.ignite.Ignition;
import org.apache.ignite.configuration.CacheConfiguration;
import org.apache.ignite.configuration.IgniteConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

@Configuration
public class IgniteConfig {
    /**
     * 初始化ignite节点信息
     * @return Ignite
     */
    @Bean
    public Ignite igniteInstance(){
        // 配置一个节点的Configuration
        IgniteConfiguration cfg = new IgniteConfiguration();

        // 设置该节点名称
        cfg.setIgniteInstanceName("springDataNode");

        // 启用Peer类加载器
        cfg.setPeerClassLoadingEnabled(true);

        // 创建一个Cache的配置，名称为UserCache
        CacheConfiguration ccfg = new CacheConfiguration("UserCache");

        // 设置这个Cache的键值对模型
        ccfg.setIndexedTypes(Long.class, User.class);

        // 把这个Cache放入springDataNode这个Node中
        cfg.setCacheConfiguration(ccfg);

        // 启动这个节点
        return Ignition.start(cfg);
    }


    @Autowired
    UserService userService;

    @Bean
    public int insertUser(){

        List<Access> member_roles = new ArrayList<Access>();
        member_roles.add(Access.MEMBER);

        List<Access> admin_roles = new ArrayList<Access>();
        admin_roles.add(Access.ADMIN);

        // add data
        userService.insertUser(new User("111", "111", member_roles));
        userService.insertUser(new User("222", "222", admin_roles));
        userService.insertUser(new User("333", "333", admin_roles));

        return 0;
    }
}
