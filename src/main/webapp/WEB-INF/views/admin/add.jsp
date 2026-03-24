<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un utilisateur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<main class="main-content">
<div class="form-container">
    <h1 class="form-title">&#10133; Ajouter un utilisateur</h1>

    <% String erreur = (String) request.getAttribute("erreur");
       if (erreur != null && !erreur.isEmpty()) { %>
        <div class="msg erreur"><%= erreur %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/admin/add">
        <div class="form-group">
            <label>Pr&eacute;nom</label>
            <input type="text" name="prenom" placeholder="Pr&eacute;nom" required>
        </div>
        <div class="form-group">
            <label>Nom</label>
            <input type="text" name="nom" placeholder="Nom" required>
        </div>
        <div class="form-group">
            <label>Login</label>
            <input type="text" name="login" placeholder="Identifiant unique" required>
        </div>
        <div class="form-group">
            <label>Mot de passe</label>
            <input type="password" name="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
        </div>
        <div class="form-group">
            <label>R&ocirc;le</label>
            <select name="role">
                <option value="USER">USER</option>
                <option value="ADMIN">ADMIN</option>
            </select>
        </div>
        <button type="submit" class="btn-submit">Ajouter</button>
    </form>
</div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
