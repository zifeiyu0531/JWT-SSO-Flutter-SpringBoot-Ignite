package com.web.sso.model;

import org.apache.ignite.cache.query.annotations.QuerySqlField;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

public class User {
    private static final AtomicLong ID_GEN = new AtomicLong();

    @QuerySqlField(index = true)
    private long id;

    @QuerySqlField(index = true)
    private String username;

    @QuerySqlField
    private String password;

    @QuerySqlField
    private List<Access> roles;

    public User() {}

    public User(long id, String name, String password, List<Access> roles) {
        this.id = id;
        this.username = name;
        this.password = password;
        this.roles = roles;
    }

    public User(String name, String password, List<Access> roles) {
        this.id = ID_GEN.incrementAndGet();
        this.username = name;
        this.password = password;
        this.roles = roles;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<Access> getRoles() {
        return roles;
    }

    public void setRoles(List<Access> roles) {
        this.roles = roles;
    }

    @Override
    public String toString(){
        return "Person [id=" + id +
                ", username=" + username +
                ", password=" + password +
                ", roles=" + roles.toString() + "]";
    }
}
