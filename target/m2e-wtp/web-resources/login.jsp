<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion — Gestion Utilisateurs</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

<div class="card">

    <%-- Logo --%>
    <div class="logo">
        <div class="logo-icon">
            <i class="fa-solid fa-users-gear"></i>
        </div>
        <h1>Gestion <span>Utilisateurs</span></h1>
    </div>
    <p class="subtitle">
        <i class="fa-solid fa-lock" style="margin-right:5px;color:#00c6ff"></i>
        Connectez-vous à votre espace
    </p>

    <%-- Erreur --%>
    <% String erreur = (String) request.getAttribute("erreur"); %>
    <% if (erreur != null) { %>
        <div class="error-box">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <%= erreur %>
        </div>
    <% } %>

    <%-- Formulaire --%>
    <form id="loginForm"
          action="${pageContext.request.contextPath}/login"
          method="post">

        <div class="form-group">
            <label for="email">
                <i class="fa-solid fa-envelope"></i> Adresse Email
            </label>
            <div class="input-wrapper">
                <i class="fa-solid fa-envelope field-icon"></i>
                <input type="email" id="email" name="email"
                       placeholder="exemple@domaine.com"
                       value="${emailSaisi}" required>
            </div>
        </div>

        <div class="form-group">
            <label for="password">
                <i class="fa-solid fa-lock"></i> Mot de passe
            </label>
            <div class="input-wrapper">
                <i class="fa-solid fa-lock field-icon"></i>
                <input type="password" id="password" name="password"
                       placeholder="••••••••" required>
                <i class="fa-solid fa-eye toggle-password"
                   id="togglePassword"></i>
            </div>
        </div>

        <button type="submit" id="submitBtn" class="btn">
            <div class="spinner" id="btnSpinner"></div>
            <i class="fa-solid fa-right-to-bracket" id="btnIcon"></i>
            <span id="btnText">Se connecter</span>
        </button>

    </form>

</div>

<%@ include file="views/commun/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
</body>
</html>