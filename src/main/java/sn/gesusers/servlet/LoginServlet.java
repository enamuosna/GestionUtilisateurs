package sn.gesusers.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import sn.gesusers.beans.Utilisateur;
import sn.gesusers.dao.UtilisateurDAO;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
	private UtilisateurDAO dao;
    @Override public void init() { dao = new UtilisateurDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("/logout".equals(req.getServletPath())) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("utilisateur") != null) {
            resp.sendRedirect(req.getContextPath() + "/users");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String identifiant = req.getParameter("email");
        if (identifiant == null || identifiant.isBlank())
            identifiant = req.getParameter("login");

        String password = req.getParameter("password");

        if (isBlank(identifiant) || isBlank(password)) {
            req.setAttribute("erreur", "Veuillez remplir tous les champs.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        Utilisateur u = dao.authentifier(identifiant.trim(), password.trim());
        if (u == null) {
            u = dao.authentifierParEmail(identifiant.trim(), password.trim());
        }

        if (u != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("utilisateur", u);
            session.setMaxInactiveInterval(30 * 60);
            resp.sendRedirect(req.getContextPath() + "/users");
        } else {
            req.setAttribute("erreur", "Identifiants incorrects.");
            req.setAttribute("emailSaisi", identifiant);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
