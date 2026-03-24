<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, sn.gesusers.beans.Utilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des utilisateurs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<main class="main-content">


<% String succes = (String) session.getAttribute("succes");
   if (succes != null) { session.removeAttribute("succes"); %>
    <div class="alert alert-succes"><%= succes %></div>
<% }
   String errFlash = (String) session.getAttribute("erreur");
   if (errFlash != null) { session.removeAttribute("erreur"); %>
    <div class="alert alert-erreur"><%= errFlash %></div>
<% } %>

<%
    Utilisateur connecte = (Utilisateur) session.getAttribute("utilisateur");
    List<Utilisateur> liste = (List<Utilisateur>) request.getAttribute("utilisateurs");
    Long nbAdmins = (Long) request.getAttribute("nbAdmins");
    if (nbAdmins == null) nbAdmins = 0L;
    int total = (liste != null) ? liste.size() : 0;
%>


<% if (connecte != null && connecte.isAdmin()) { %>
<div class="stats-grid">
    <div class="stat-card">
        <span class="stat-icon stat-total">&#128101;</span>
        <div>
            <div class="stat-number"><%= total %></div>
            <div class="stat-label">Total utilisateurs</div>
        </div>
    </div>
    <div class="stat-card">
        <span class="stat-icon stat-actif">&#9989;</span>
        <div>
            <div class="stat-number"><%= total %></div>
            <div class="stat-label">Comptes actifs</div>
        </div>
    </div>
    <div class="stat-card">
        <span class="stat-icon stat-admin">&#128273;</span>
        <div>
            <div class="stat-number"><%= nbAdmins %></div>
            <div class="stat-label">Administrateurs</div>
        </div>
    </div>
</div>
<% } %>

<div class="section-header">
    <h1 class="section-title">&#8801; Liste des utilisateurs (<%= total %>)</h1>
</div>

<% if (liste == null || liste.isEmpty()) { %>
    <p class="vide">Aucun utilisateur enregistr&eacute;.</p>
<% } else { %>
<div class="table-wrapper">
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Nom complet</th>
                <th>Login</th>
                <th>R&ocirc;le</th>
                <% if (connecte != null && connecte.isAdmin()) { %>
                <th>Actions</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
        <% for (Utilisateur u : liste) {
               String prenomI = (u.getPrenom() != null && !u.getPrenom().isEmpty()) ? u.getPrenom().substring(0,1).toUpperCase() : "";
               String nomI    = (u.getNom()    != null && !u.getNom().isEmpty())    ? u.getNom().substring(0,1).toUpperCase()    : "";
               String ctx     = request.getContextPath();
        %>
            <tr>
                <td class="td-id"><%= u.getId() %></td>
                <td class="td-nom">
                    <div class="user-row">
                        <div class="avatar-sm"><%= prenomI + nomI %></div>
                        <span><%= u.getPrenom() %> <%= u.getNom() %></span>
                    </div>
                </td>
                <td><%= u.getLogin() %></td>
                <td>
                    <span class="<%= u.isAdmin() ? "badge-admin" : "badge-user" %>">
                        <%= u.getRole() %>
                    </span>
                </td>
                <%-- Boutons Actions : ADMIN uniquement --%>
                <% if (connecte != null && connecte.isAdmin()) { %>
                <td class="td-actions">
                    <a href="<%= ctx %>/admin/update?id=<%= u.getId() %>" class="btn-modifier">
                        &#9998; Modifier
                    </a>
                    <% if (connecte.getId() != u.getId()) { %>
                    <a href="<%= ctx %>/admin/delete?id=<%= u.getId() %>" class="btn-supprimer"
                       onclick="return confirm('Supprimer <%= u.getPrenom() %> <%= u.getNom() %> ?')">
                        &#128465; Supprimer
                    </a>
                    <% } %>
                </td>
                <% } %>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
<% } %>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
