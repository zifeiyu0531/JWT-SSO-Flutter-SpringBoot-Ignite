package com.web.sso.controller;

import com.web.sso.model.Access;
import com.web.sso.model.ResBody;
import com.web.sso.model.User;
import com.web.sso.model.Userlog;
import com.web.sso.service.UserService;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/log")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * User register with whose username and password
     * @param userlog
     * @return Success message
     * @throws ServletException
     */
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ResBody register(@RequestBody() Userlog userlog) throws ServletException {

        ResBody result = new ResBody();

        // Check if the username is used
        if(userService.findUserByUsername(userlog.getUsername()) != null){
            result.setStatuscode("004");
            result.setMessage("username is used");
            result.setData(" ");
            return result;
        }

        // Give a default access : MEMBER
        List<Access> roles = new ArrayList<Access>();
        roles.add(Access.MEMBER);
        String accessStr = roles.get(0).toString();

        // Create Jwt token
        String jwtToken = Jwts.builder().setSubject(userlog.getUsername()).claim("access", accessStr).setIssuedAt(new Date())
                .signWith(SignatureAlgorithm.HS256, "secret").compact();
        // Create a person in ignite
        userService.insertUser(new User(userlog.getUsername(), userlog.getPassword(), roles));

        result.setStatuscode("201");
        result.setMessage(accessStr);
        result.setData(jwtToken);
        return result;
    }

    /**
     * Check user`s login info, then create a jwt token returned to front end
     * @param userlog
     * @return jwt token
     * @throws ServletException
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ResBody login(@RequestBody() Userlog userlog) throws ServletException {

        ResBody result = new ResBody();

        if(userService.findUserByUsername(userlog.getUsername()) == null){
            result.setStatuscode("002");
            result.setMessage("no user"+userlog.getUsername());
            result.setData(" ");
            return result;
        }

        // Check if the password is wrong
        if(!userlog.getPassword().equals(userService.findUserByUsername(userlog.getUsername()).getPassword())){
            result.setStatuscode("003");
            result.setMessage("password is wrong");
            result.setData(" ");
            return result;
        }

        User user = userService.findUserByUsername(userlog.getUsername());
        List<Access> access = user.getRoles();
        String accessStr = access.get(0).toString();

        // Create Jwt token
        String jwtToken = Jwts.builder().setSubject(userlog.getUsername()).claim("access", accessStr).setIssuedAt(new Date())
                .signWith(SignatureAlgorithm.HS256, "secret").compact();

        result.setStatuscode("200");
        result.setMessage(accessStr);
        result.setData(jwtToken);
        return result;
    }
}
