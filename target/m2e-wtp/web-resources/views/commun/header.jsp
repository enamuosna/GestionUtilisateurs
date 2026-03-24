
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sn.gesusers.beans.Utilisateur" %>
<%
    Utilisateur connecteHeader = (Utilisateur) session.getAttribute("utilisateur");
    String pagineCourante = request.getRequestURI();
    String ctx = request.getContextPath();
    boolean isAdmin = (connecteHeader != null && connecteHeader.isAdmin());
%>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    .navbar {
        background: linear-gradient(135deg, #0f2027, #2c5364);
        padding: 0 32px;
        display: flex; align-items: center; justify-content: space-between;
        box-shadow: 0 2px 12px rgba(0,0,0,0.3);
        height: 62px; position: sticky; top: 0; z-index: 100;
    }
    .navbar-brand { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .navbar-brand i  { color:#00c6ff; font-size:22px; }
    .navbar-brand h1 { color:#fff; font-size:17px; font-weight:700; }

    .nav-menu { display:flex; align-items:center; gap:4px; }
    .nav-item {
        display:flex; align-items:center; gap:7px;
        color:rgba(255,255,255,0.65); text-decoration:none;
        padding:8px 16px; border-radius:8px;
        font-size:13px; font-weight:500;
        transition:background 0.2s, color 0.2s; cursor:pointer;
    }
    .nav-item i { font-size:14px; }
    .nav-item:hover { background:rgba(255,255,255,0.1); color:#fff; }
    .nav-item.active { background:rgba(0,198,255,0.15); color:#00c6ff; font-weight:600; }
    button.nav-item {
        background:none; border:none;
        font-family:inherit; line-height:inherit;
    }
    button.nav-item:hover { background:rgba(255,255,255,0.1); color:#fff; }

    .nav-right { display:flex; align-items:center; gap:16px; }
    .user-badge {
        display:flex; align-items:center; gap:10px;
        background:rgba(255,255,255,0.06);
        border:1px solid rgba(255,255,255,0.12);
        border-radius:10px; padding:7px 14px;
    }
    .user-avatar {
        width:32px; height:32px; border-radius:50%;
        background:linear-gradient(135deg,#00c6ff,#0072ff);
        display:flex; align-items:center; justify-content:center;
        color:#fff; font-size:12px; font-weight:700;
    }
    .user-details { display:flex; flex-direction:column; }
    .user-name  { color:#fff; font-size:13px; font-weight:600; }
    .user-role  { color:#00c6ff; font-size:10px; font-weight:600; text-transform:uppercase; }
    .btn-logout {
        display:flex; align-items:center; gap:7px;
        color:#ff6b6b; text-decoration:none; font-size:13px; font-weight:600;
        padding:8px 14px;
        border:1px solid rgba(255,107,107,0.35);
        border-radius:8px; transition:background 0.2s;
    }
    .btn-logout:hover { background:rgba(255,107,107,0.12); }
</style>

<nav class="navbar">

    <a href="<%= ctx %>/users" class="navbar-brand">
        <i class="fa-solid fa-users-gear"></i>
        <h1>Gestion des Utilisateurs</h1>
    </a>

    <div class="nav-menu">
        <a href="<%= ctx %>/users"
           class="nav-item <%= pagineCourante.contains("/users") ? "active" : "" %>">
            <i class="fa-solid fa-house"></i> Accueil
        </a>

        <% if (isAdmin) { %>
            <a href="<%= ctx %>/users"
               class="nav-item <%= pagineCourante.contains("/users") ? "active" : "" %>">
                <i class="fa-solid fa-users"></i> Utilisateurs
            </a>
            <button onclick="ouvrirModalForm()" class="nav-item">
                <i class="fa-solid fa-user-plus"></i> Ajouter
            </button>
        <% } %>
    </div>

    <div class="nav-right">
        <% if (connecteHeader != null) {
            String ini = "";
            if (connecteHeader.getPrenom() != null && !connecteHeader.getPrenom().isEmpty())
                ini += connecteHeader.getPrenom().substring(0,1).toUpperCase();
            if (connecteHeader.getNom() != null && !connecteHeader.getNom().isEmpty())
                ini += connecteHeader.getNom().substring(0,1).toUpperCase();
        %>
            <div class="user-badge">
                <div class="user-avatar"><%= ini %></div>
                <div class="user-details">
                    <span class="user-name"><%= connecteHeader.getFullName() %></span>
                    <span class="user-role">
                        <i class="fa-solid fa-circle" style="font-size:7px"></i>
                        <%= connecteHeader.getRole() %>
                    </span>
                </div>
            </div>
        <% } %>
        <a href="<%= ctx %>/logout" class="btn-logout">
            <i class="fa-solid fa-right-from-bracket"></i> D&eacute;connexion
        </a>
    </div>

</nav>
