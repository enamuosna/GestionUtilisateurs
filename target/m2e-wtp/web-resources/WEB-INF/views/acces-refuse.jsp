<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acc&egrave;s refus&eacute;</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/fragments/header.jsp"/>
<div class="page-403">
    <h1>&#128274;</h1>
    <h2>Acc&egrave;s refus&eacute; &mdash; 403</h2>
    <p>Vous n'avez pas les droits n&eacute;cessaires pour acc&eacute;der &agrave; cette page.</p>
    <a href="${pageContext.request.contextPath}/admin/list">&larr; Retour &agrave; l'accueil</a>
</div>
<jsp:include page="/WEB-INF/fragments/footer.jsp"/>
