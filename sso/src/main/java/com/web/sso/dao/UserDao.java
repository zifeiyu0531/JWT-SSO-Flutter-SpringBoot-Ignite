package com.web.sso.dao;

import com.web.sso.model.User;
import org.apache.ignite.springdata.repository.IgniteRepository;
import org.apache.ignite.springdata.repository.config.RepositoryConfig;

@RepositoryConfig(cacheName = "UserCache")
public interface UserDao extends IgniteRepository<User, Long> {
    /**
     * Find a user with name in Ignite DB.
     * @param username User name.
     * @return The user whose name is the given name.
     */
    User findByUsername(String username);
}
