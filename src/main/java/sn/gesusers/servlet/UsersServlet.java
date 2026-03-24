package sn.gesusers.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import sn.gesusers.beans.Utilisateur;
import sn.gesusers.dao.UtilisateurDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/users"})
public class UsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
	private UtilisateurDAO dao;
    @Override public void init() { dao = new UtilisateurDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur connecte = utilisateurConnecte(req);
        if (connecte == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<Utilisateur> tous = dao.findAll();

        int totalUsers = tous.size();
        int admins = 0, actifs = 0;
        for (Utilisateur u : tous) {
            if (u.isAdmin()) admins++;
            if (u.isActif()) actifs++;
        }

        req.setAttribute("users",      tous);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("nbAdmins",   admins);
        req.setAttribute("nbActifs",   actifs);

        req.getRequestDispatcher("/views/users/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Utilisateur connecte = utilisateurConnecte(req);
        if (connecte == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        String ctx    = req.getContextPath();

        switch (action != null ? action : "") {

            case "create" -> {
                if (!connecte.isAdmin()) { resp.sendRedirect(ctx + "/users"); return; }
                Utilisateur u = buildFromRequest(req);
                u.setActif(req.getParameter("actif") != null);
                boolean ok = dao.create(u);
                if (ok) {
                    resp.sendRedirect(ctx + "/users?succes=cree");
                } else {
                    req.getSession().setAttribute("erreur",
                        "Erreur lors de la création. Login/email déjà utilisé ?");
                    resp.sendRedirect(ctx + "/users");
                }
            }

            case "update" -> {
                if (!connecte.isAdmin()) { resp.sendRedirect(ctx + "/users"); return; }
                Utilisateur u = buildFromRequest(req);
                u.setId(parseInt(req.getParameter("id"), -1));
                u.setActif(req.getParameter("actif") != null);
                boolean ok = dao.update(u);
                resp.sendRedirect(ctx + "/users?succes=" + (ok ? "modifie" : "erreur"));
            }

            case "delete" -> {
                if (!connecte.isAdmin()) { resp.sendRedirect(ctx + "/users"); return; }
                int id = parseInt(req.getParameter("id"), -1);
                if (id > 0 && id != connecte.getId()) dao.delete(id);
                resp.sendRedirect(ctx + "/users?succes=supprime");
            }

            default -> resp.sendRedirect(ctx + "/users");
        }
    }

    private Utilisateur buildFromRequest(HttpServletRequest req) {
        Utilisateur u = new Utilisateur();
        u.setNom(trim(req.getParameter("nom")));
        u.setPrenom(trim(req.getParameter("prenom")));
        u.setEmail(trim(req.getParameter("email")));
        u.setLogin(trim(req.getParameter("login")));
        u.setPassword(req.getParameter("password"));
        String role = trim(req.getParameter("role"));
        u.setRole(role.isEmpty() ? "USER" : role);
        return u;
    }

    private Utilisateur utilisateurConnecte(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Utilisateur) s.getAttribute("utilisateur") : null;
    }

    private String trim(String s) { return s != null ? s.trim() : ""; }

    private int parseInt(String s, int defaut) {
        try { return Integer.parseInt(s); } catch (Exception e) { return defaut; }
    }
}
