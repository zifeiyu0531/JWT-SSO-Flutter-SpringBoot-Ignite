package com.web.sso.controller;

import com.web.sso.model.ResBody;
import com.web.sso.model.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * Test the jwt, if the token is valid then return "Login Successful"
 * If is not valid, the request will be intercepted by JwtFilter
 **/
@RestController
@RequestMapping("/secure")
public class JWTController {

    @RequestMapping("/user")
    public void checkJwt(HttpServletRequest request) {

    }

    @RequestMapping("/JwtException")
    public ResBody JwtException(HttpServletRequest request){
        ResBody resBody = new ResBody();
        resBody.setStatuscode("001");
        resBody.setMessage("Token error");
        resBody.setData(" ");
        return resBody;
    }

    @RequestMapping("/JwtCorrect")
    public ResBody JwtCorrect(HttpServletRequest request){
        String access = request.getAttribute("Access").toString();
        ResBody resBody = new ResBody();
        resBody.setStatuscode("200");
        resBody.setMessage(access);
        resBody.setData(" ");
        return resBody;
    }
}
