<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    String ctx = request.getContextPath();
    String prenomInit = "";
    String nomInit    = "";
    if (u != null && u.getPrenom() != null && !u.getPrenom().isEmpty())
        prenomInit = u.getPrenom().substring(0, 1).toUpperCase();
    if (u != null && u.getNom() != null && !u.getNom().isEmpty())
        nomInit = u.getNom().substring(0, 1).toUpperCase();
%>
<nav class="navbar">
    <div class="navbar-brand">
        <span class="brand-icon">&#128101;</span>
        <span class="brand-title">Gestion des Utilisateurs</span>
    </div>

    <ul class="navbar-links">
        <% if (u != null) { %>
            <li>
                <a href="<%= ctx %>/admin/list" class="nav-link">&#127968; Accueil</a>
            </li>
            <% if (u.isAdmin()) { %>
                <li>
                    <a href="<%= ctx %>/admin/list" class="nav-link nav-active">&#128101; Utilisateurs</a>
                </li>
                <li>
                    <a href="<%= ctx %>/admin/add" class="nav-link nav-add">&#10133; Ajouter</a>
                </li>
            <% } %>
        <% } %>
    </ul>

    <div class="navbar-user">
        <% if (u == null) { %>
            <a href="<%= ctx %>/login" class="btn-login">Connexion</a>
        <% } else { %>
            <div class="user-avatar"><%= prenomInit + nomInit %></div>
            <div class="user-info">
                <span class="user-name"><%= u.getPrenom() %> <%= u.getNom() %></span>
                <span class="<%= u.isAdmin() ? "badge-admin" : "badge-user" %>">
                    &bull; <%= u.getRole() %>
                </span>
            </div>
            <a href="<%= ctx %>/logout" class="btn-logout">&#8618; D&eacute;connexion</a>
        <% } %>
    </div>
</nav>
