package sn.gesusers.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import sn.gesusers.beans.Utilisateur;

import java.io.IOException;


@WebFilter(urlPatterns = {"/views/*", "/users", "/admin/*", "/user/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) resp;

        HttpSession session = request.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        String uri = request.getRequestURI();

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!u.isAdmin()) {
            String action = request.getParameter("action");
            boolean isWrite = "create".equals(action) || "update".equals(action) || "delete".equals(action);
            boolean isAdminPath = uri.contains("/admin/add") || uri.contains("/admin/update") || uri.contains("/admin/delete");
            if (isWrite || isAdminPath) {
                response.sendRedirect(request.getContextPath() + "/users");
                return;
            }
        }

        chain.doFilter(req, resp);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
