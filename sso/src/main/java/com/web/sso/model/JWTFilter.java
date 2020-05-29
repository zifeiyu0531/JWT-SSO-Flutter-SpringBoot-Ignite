package com.web.sso.model;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JWTFilter extends GenericFilterBean {

    public void doFilter(final ServletRequest req, final ServletResponse res, final FilterChain chain)
            throws IOException, ServletException {

        final HttpServletRequest request = (HttpServletRequest) req;
        final HttpServletResponse response = (HttpServletResponse) res;

        final String authHeader = request.getHeader("authorization");

        if ("OPTIONS".equals(request.getMethod())){
            response.setStatus(HttpServletResponse.SC_OK);
            chain.doFilter(req, res);
        }else{
            // Check the authorization, check if the token is started by "Bearer "
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                throw new ServletException("Missing or invalid Authorization header");
            }

            final String token = authHeader.substring(7);

            try {
                final Claims claims = Jwts.parser().setSigningKey("secret").parseClaimsJws(token).getBody();
                int serviceType = Integer.parseInt(request.getHeader("ServiceType"));
                String access = claims.get("access").toString();
                if(access.equals("ADMIN") || (access.equals("MEMBER") && serviceType == 1)){
                    request.setAttribute("Access", 1);
                }else{
                    request.setAttribute("Access", 0);
                }
                request.getRequestDispatcher("/secure/JwtCorrect").forward(request, response);
            } catch (Exception e) {
                request.getRequestDispatcher("/secure/JwtException").forward(request, response);
            }

            chain.doFilter(req, res);
        }
    }
}
