<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier un utilisateur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<main class="main-content">
<div class="form-container">
    <h1 class="form-title">&#9998; Modifier un utilisateur</h1>

    <% String erreur = (String) request.getAttribute("erreur");
       if (erreur != null && !erreur.isEmpty()) { %>
        <div class="msg erreur"><%= erreur %></div>
    <% }
       Utilisateur u = (Utilisateur) request.getAttribute("utilisateur");
       if (u == null) { response.sendRedirect(request.getContextPath() + "/admin/list"); return; }
       String role = u.getRole() != null ? u.getRole() : "USER";
    %>

    <form method="post" action="${pageContext.request.contextPath}/admin/update">
        <input type="hidden" name="id" value="<%= u.getId() %>">
        <div class="form-group">
            <label>Pr&eacute;nom</label>
            <input type="text" name="prenom" value="<%= u.getPrenom() %>" required>
        </div>
        <div class="form-group">
            <label>Nom</label>
            <input type="text" name="nom" value="<%= u.getNom() %>" required>
        </div>
        <div class="form-group">
            <label>Login</label>
            <input type="text" name="login" value="<%= u.getLogin() != null ? u.getLogin() : "" %>" required>
        </div>
        <div class="form-group">
            <label>Mot de passe</label>
            <input type="password" name="password" value="<%= u.getPassword() != null ? u.getPassword() : "" %>" required>
        </div>
        <div class="form-group">
            <label>R&ocirc;le</label>
            <select name="role">
                <option value="USER"  <%= "USER".equals(role)  ? "selected" : "" %>>USER</option>
                <option value="ADMIN" <%= "ADMIN".equals(role) ? "selected" : "" %>>ADMIN</option>
            </select>
        </div>
        <button type="submit" class="btn-submit">Enregistrer</button>
    </form>
</div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
