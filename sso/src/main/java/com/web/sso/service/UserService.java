package com.web.sso.service;

import com.web.sso.model.User;

public interface UserService {
    /**
     * Save Person to Ignite DB
     * @param user User Object
     * @return The User object saved in Ignite DB.
     */
    User insertUser(User user);

    /**
     * Find a User from Ignite DB with name.
     * @param username User name.
     * @return The person found in Ignite DB
     */
    User findUserByUsername(String username);
}
