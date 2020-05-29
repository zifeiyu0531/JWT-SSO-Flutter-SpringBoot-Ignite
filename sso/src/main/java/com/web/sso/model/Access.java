package com.web.sso.model;

public enum Access {
    ADMIN, MEMBER;

   @Override
    public String toString(){
        return this.name();
    }
}
