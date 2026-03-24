<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sn.gesusers.beans.Utilisateur, java.util.List, java.util.ArrayList" %>
<%
    Utilisateur connecte = (Utilisateur) session.getAttribute("utilisateur");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    boolean listIsAdmin = connecte.isAdmin();

    @SuppressWarnings("unchecked")
    List<Utilisateur> users = (List<Utilisateur>) request.getAttribute("users");
    if (users == null) users = new ArrayList<>();

    String succes   = request.getParameter("succes");
    String errFlash = (String) session.getAttribute("erreur");
    if (errFlash != null) session.removeAttribute("erreur");

 
    Object totAttr = request.getAttribute("totalUsers");
    int totalUsers = (totAttr != null) ? (Integer) totAttr : users.size();

    Object admAttr = request.getAttribute("nbAdmins");
    int nbAdmins = (admAttr != null) ? (Integer) admAttr : 0;

    Object actAttr = request.getAttribute("nbActifs");
    int nbActifs = (actAttr != null) ? (Integer) actAttr : 0;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Utilisateurs</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list.css">
</head>
<body>

<input type="hidden" id="appContext" value="${pageContext.request.contextPath}">

<%@ include file="../commun/header.jsp" %>

<div class="container">


    <% if (errFlash != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-triangle-exclamation"></i> <%= errFlash %>
        </div>
    <% } %>
    <% if ("cree".equals(succes)) { %>
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Utilisateur créé avec succès.</div>
    <% } else if ("modifie".equals(succes)) { %>
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Utilisateur modifié avec succès.</div>
    <% } else if ("supprime".equals(succes)) { %>
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Utilisateur supprimé avec succès.</div>
    <% } %>

  
    <% if (listIsAdmin) { %>
    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-icon blue"><i class="fa-solid fa-users"></i></div>
            <div class="stat-info">
                <div class="value"><%= totalUsers %></div>
                <div class="label">Total utilisateurs</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
            <div class="stat-info">
                <div class="value"><%= nbActifs %></div>
                <div class="label">Comptes actifs</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red"><i class="fa-solid fa-user-shield"></i></div>
            <div class="stat-info">
                <div class="value"><%= nbAdmins %></div>
                <div class="label">Administrateurs</div>
            </div>
        </div>
    </div>
    <% } %>


    <div class="section-header">
        <h2>
            <i class="fa-solid fa-list-ul"></i>
            Liste des utilisateurs (<%= totalUsers %>)
        </h2>
    </div>

 
    <div class="card">

        <table id="usersTable">
            <thead>
                <tr>
                    <th><i class="fa-solid fa-hashtag"></i> #</th>
                    <th><i class="fa-solid fa-user"></i> Nom complet</th>
                    <th><i class="fa-solid fa-envelope"></i> Email</th>
                    <th><i class="fa-solid fa-tag"></i> Rôle</th>
                    <th><i class="fa-solid fa-circle-half-stroke"></i> Statut</th>
                    <% if (listIsAdmin) { %>
                    <th><i class="fa-solid fa-sliders"></i> Actions</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
            <% if (users.isEmpty()) { %>
                <tr>
                    <td colspan="<%= listIsAdmin ? 6 : 5 %>">
                        <div class="empty">
                            <i class="fa-solid fa-users-slash"></i> Aucun utilisateur trouvé.
                        </div>
                    </td>
                </tr>
            <% } else {
                for (Utilisateur u : users) {
                    String ini = "";
                    if (u.getPrenom() != null && !u.getPrenom().isEmpty()) ini += u.getPrenom().substring(0,1).toUpperCase();
                    if (u.getNom()    != null && !u.getNom().isEmpty())    ini += u.getNom().substring(0,1).toUpperCase();
                    String nom    = u.getNom()    != null ? u.getNom().replace("'","\\'")    : "";
                    String prenom = u.getPrenom() != null ? u.getPrenom().replace("'","\\'") : "";
                    String email  = u.getEmail()  != null ? u.getEmail()  : "";
                    String fn     = (prenom + " " + nom).trim();
            %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td>
                        <div class="nom-cell">
                            <div class="avatar"><%= ini %></div>
                            <strong><%= fn %></strong>
                        </div>
                    </td>
                    <td>
                        <i class="fa-regular fa-envelope" style="color:#94a3b8;margin-right:6px"></i>
                        <%= email %>
                    </td>
                    <td>
                        <span class="badge <%= "ADMIN".equals(u.getRole()) ? "badge-admin" : "badge-user" %>">
                            <i class="fa-solid <%= "ADMIN".equals(u.getRole()) ? "fa-user-shield" : "fa-user" %>"></i>
                            <%= u.getRole() %>
                        </span>
                    </td>
                    <td>
                        <span class="badge <%= u.isActif() ? "badge-on" : "badge-off" %>">
                            <i class="fa-solid <%= u.isActif() ? "fa-circle-check" : "fa-circle-xmark" %>"></i>
                            <%= u.isActif() ? "Actif" : "Inactif" %>
                        </span>
                    </td>
                    <% if (listIsAdmin) { %>
                    <td>
                        <div class="actions">
                            <button class="btn-edit"
                                    onclick="ouvrirModalEdit('<%= u.getId() %>','<%= nom %>','<%= prenom %>','<%= email %>','<%= u.getRole() %>','<%= u.isActif() %>','<%= u.getLogin() != null ? u.getLogin() : "" %>')">
                                <i class="fa-solid fa-pen-to-square"></i> Modifier
                            </button>
                            <button class="btn-delete"
                                    onclick="ouvrirModal(<%= u.getId() %>, '<%= fn.replace("'","\\'") %>')">
                                <i class="fa-solid fa-trash-can"></i> Supprimer
                            </button>
                        </div>
                    </td>
                    <% } %>
                </tr>
            <% } } %>
            </tbody>
        </table>

    </div>
</div>


<% if (listIsAdmin) { %>
<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-icon"><i class="fa-solid fa-trash-can"></i></div>
        <h3>Confirmer la suppression</h3>
        <p>Vous êtes sur le point de supprimer<br>
           <strong id="modalNom"></strong>.<br>
           Cette action est <strong>irréversible</strong>.</p>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="fermerModal()">
                <i class="fa-solid fa-xmark"></i> Annuler
            </button>
            <a id="modalConfirmBtn" href="#" class="btn-modal-confirm">
                <i class="fa-solid fa-trash-can"></i> Supprimer
            </a>
        </div>
    </div>
</div>
<%@ include file="../commun/modal-edit.jsp" %>
<%@ include file="../commun/modal-form.jsp" %>
<% } %>

<%@ include file="../commun/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/list.js"></script>
</body>
</html>
