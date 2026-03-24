<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<div class="login-wrapper">
    <div class="login-box">
        <h1 class="login-title">&#128101; Connexion</h1>
        <p class="login-subtitle">Gestion des Utilisateurs</p>

        <% String erreur = (String) request.getAttribute("erreur");
           if (erreur != null && !erreur.isEmpty()) { %>
            <div class="msg erreur"><%= erreur %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label>Login</label>
                <input type="text" name="login"
                       value="<%= request.getAttribute("loginSaisi") != null ? request.getAttribute("loginSaisi") : "" %>"
                       placeholder="Votre identifiant" autofocus>
            </div>
            <div class="form-group">
                <label>Mot de passe</label>
                <input type="password" name="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;">
            </div>
            <button type="submit" class="btn-submit">Se connecter</button>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
