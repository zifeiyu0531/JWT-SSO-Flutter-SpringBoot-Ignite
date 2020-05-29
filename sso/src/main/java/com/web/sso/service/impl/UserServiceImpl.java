package com.web.sso.service.impl;

import com.web.sso.dao.UserDao;
import com.web.sso.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.web.sso.service.UserService;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private UserDao userDao;

    /**
     * Save Person to Ignite DB
     * @param user User object.
     * @return The Person object saved in Ignite DB.
     */
    public User insertUser(User user) {
        // If this username is not used then return null, if is used then return this Person
        return userDao.save(user.getId(), user);
    }

    /**
     * Find a Person from Ignite DB with name.
     * @param username User name.
     * @return The person found in Ignite DB
     */
    public User findUserByUsername(String username){
        return userDao.findByUsername(username);
    }
}
