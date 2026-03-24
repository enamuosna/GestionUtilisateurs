<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String initiales = u.getPrenom().substring(0,1).toUpperCase()
                     + u.getNom().substring(0,1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>

<%@ include file="commun/header.jsp" %>

<div class="container">

    <%-- WELCOME --%>
    <div class="welcome">
        <div class="avatar-lg"><%= initiales %></div>
        <h2>Bienvenue, <%= u.getFullName() %></h2>
        <div class="email">
            <i class="fa-solid fa-envelope"></i>
            <%= u.getEmail() %>
        </div>
        <div class="badge <%= "ADMIN".equals(u.getRole()) ? "badge-admin" : "badge-user" %>">
            <i class="fa-solid <%= "ADMIN".equals(u.getRole())
                                   ? "fa-user-shield" : "fa-user" %>"></i>
            <%= u.getRole() %>
        </div>
    </div>

</div>


<%@ include file="commun/modal-form.jsp" %>


<%@ include file="commun/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>