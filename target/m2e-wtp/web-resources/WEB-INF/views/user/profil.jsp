<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mon profil</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<main class="main-content">
<div class="form-container">
    <h1 class="form-title">&#128100; Mon profil</h1>

    <% String succes = (String) request.getAttribute("succes");
       if (succes != null) { %>
        <div class="msg succes"><%= succes %></div>
    <% }
       String erreur = (String) request.getAttribute("erreur");
       if (erreur != null) { %>
        <div class="msg erreur"><%= erreur %></div>
    <% }
       Utilisateur u = (Utilisateur) request.getAttribute("utilisateur");
       if (u == null) u = (Utilisateur) session.getAttribute("utilisateur");
    %>

    <div class="info-privilege">
        &#8505; Vous pouvez modifier votre nom, pr&eacute;nom et mot de passe.
        Le login et le r&ocirc;le sont g&eacute;r&eacute;s par l'administrateur.
    </div>

    <form method="post" action="${pageContext.request.contextPath}/user/profil">
        <div class="form-group">
            <label>Login <span class="readonly-label">(non modifiable)</span></label>
            <input type="text" value="<%= u != null ? u.getLogin() : "" %>" disabled class="readonly">
        </div>
        <div class="form-group">
            <label>R&ocirc;le <span class="readonly-label">(non modifiable)</span></label>
            <input type="text" value="<%= u != null ? u.getRole() : "" %>" disabled class="readonly">
        </div>
        <div class="form-group">
            <label>Pr&eacute;nom</label>
            <input type="text" name="prenom" value="<%= u != null ? u.getPrenom() : "" %>" required>
        </div>
        <div class="form-group">
            <label>Nom</label>
            <input type="text" name="nom" value="<%= u != null ? u.getNom() : "" %>" required>
        </div>
        <div class="form-group">
            <label>Nouveau mot de passe</label>
            <input type="password" name="password" placeholder="Nouveau mot de passe" required>
        </div>
        <button type="submit" class="btn-submit">Enregistrer</button>
    </form>
</div>
</main>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
