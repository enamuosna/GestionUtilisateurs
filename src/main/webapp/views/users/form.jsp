<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<%
    Utilisateur connecte = (Utilisateur) session.getAttribute("utilisateur");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Utilisateur user = (Utilisateur)    request.getAttribute("user");
    boolean edition = (Boolean) request.getAttribute("modeEdition");
    String  erreur  = (String)  request.getAttribute("erreur");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><%= edition ? "Modifier" : "Nouvel" %> Utilisateur</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/form.css">
</head>
<body>


<%@ include file="../commun/header.jsp" %>

<div class="container">
    <div class="card">

        <div class="card-header">
            <i class="fa-solid <%= edition ? "fa-user-pen" : "fa-user-plus" %>"></i>
            <h2><%= edition ? "Modifier un utilisateur" : "Créer un utilisateur" %></h2>
        </div>

        <div class="card-body">


            <% if (erreur != null) { %>
                <div class="alert-error">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <%= erreur %>
                </div>
            <% } %>

            <form id="userForm"
                  action="${pageContext.request.contextPath}/users"
                  method="post">

                <input type="hidden" name="action"
                       value="<%= edition ? "update" : "create" %>">
                <% if (edition) { %>
                    <input type="hidden" name="id" value="<%= user.getId() %>">
                <% } %>

        
                <div class="form-group">
                    <label>
                        <i class="fa-solid fa-id-card"></i> Nom
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-id-card field-icon"></i>
                        <input type="text" id="nom" name="nom"
                               value="<%= user.getNom() != null ? user.getNom() : "" %>"
                               placeholder="Ex: Diallo" required>
                    </div>
                </div>

               
                <div class="form-group">
                    <label>
                        <i class="fa-solid fa-id-card"></i> Prénom
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-id-card field-icon"></i>
                        <input type="text" id="prenom" name="prenom"
                               value="<%= user.getPrenom() != null ? user.getPrenom() : "" %>"
                               placeholder="Ex: Mamadou" required>
                    </div>
                </div>

               
                <div class="form-group">
                    <label>
                        <i class="fa-solid fa-envelope"></i> Adresse Email
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-envelope field-icon"></i>
                        <input type="email" id="email" name="email"
                               value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                               placeholder="exemple@domaine.com" required>
                    </div>
                </div>

               
                <div class="form-group">
                    <label>
                        <i class="fa-solid fa-lock"></i> Mot de passe
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock field-icon"></i>
                        <input type="password" id="password" name="password"
                               <%= edition ? "" : "required" %>
                               placeholder="<%= edition
                                   ? "Laisser vide = ne pas changer"
                                   : "Minimum 6 caractères" %>">
                        <i class="fa-solid fa-eye toggle-password"
                           id="togglePassword"></i>
                    </div>

                    
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <div class="strength-label">
                            <i class="fa-solid fa-shield-halved"
                               style="color:#94a3b8;font-size:11px"></i>
                            <span id="strengthLabel"></span>
                        </div>
                    </div>

                    <% if (edition) { %>
                        <p class="hint">
                            <i class="fa-solid fa-circle-info"></i>
                            Laissez vide pour conserver le mot de passe actuel.
                        </p>
                    <% } %>
                </div>

                
                <div class="form-group">
                    <label>
                        <i class="fa-solid fa-tag"></i> Rôle
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-tag field-icon"></i>
                        <select name="role">
                            <option value="USER"
                                <%= "USER".equals(user.getRole()) ? "selected" : "" %>>
                                Utilisateur
                            </option>
                            <option value="ADMIN"
                                <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>
                                Administrateur
                            </option>
                        </select>
                    </div>
                </div>

                
                <div class="form-group">
                    <div class="toggle-row">
                        <div class="toggle-label">
                            <i class="fa-solid fa-circle-half-stroke"></i>
                            Compte actif
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="actif"
                                   <%= user.isActif() || !edition ? "checked" : "" %>>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                
                <div class="btn-row">
                    <a href="${pageContext.request.contextPath}/users"
                       class="btn-cancel">
                        <i class="fa-solid fa-xmark"></i> Annuler
                    </a>
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid <%= edition
                                              ? "fa-floppy-disk"
                                              : "fa-user-plus" %>"></i>
                        <%= edition ? "Enregistrer" : "Créer l'utilisateur" %>
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>


<%@ include file="../commun/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/form.js"></script>
</body>
</html>