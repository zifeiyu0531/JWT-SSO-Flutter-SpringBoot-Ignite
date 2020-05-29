package com.web.sso.model;

public class Service {
    private int serviceType;

    public Service(){};

    public Service(int serviceType){
        this.serviceType = serviceType;
    }

    public int getServiceType() {
        return serviceType;
    }

    public void setServiceType(int serviceType) {
        this.serviceType = serviceType;
    }

}
