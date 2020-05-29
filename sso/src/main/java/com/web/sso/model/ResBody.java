package com.web.sso.model;

public class ResBody<T> {
    private String status_code;

    private String message;

    private T data;

    public ResBody() {}

    public ResBody(String status_code, String message, T data) {
        this.status_code = status_code;
        this.message = message;
        this.data = data;
    }

    public String getStatuscode() {
        return status_code;
    }

    public void setStatuscode(String status_code) {
        this.status_code = status_code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
