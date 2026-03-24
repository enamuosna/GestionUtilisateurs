package sn.gesusers.beans;

import java.io.Serializable;

public class Utilisateur implements Serializable {
    private static final long serialVersionUID = 1L;

    private int     id;
    private String  nom;
    private String  prenom;
    private String  email;
    private String  password;
    private String  role;      
    private boolean actif;

    public Utilisateur() {}
    public int     getId()       { return id; }
    public void    setId(int id) { this.id = id; }

    public String  getNom()           { return nom; }
    public void    setNom(String nom) { this.nom = nom; }

    public String  getPrenom()              { return prenom; }
    public void    setPrenom(String p)      { this.prenom = p; }

    public String  getEmail()               { return email; }
    public void    setEmail(String e)       { this.email = e; }

    public String  getPassword()            { return password; }
    public void    setPassword(String pw)   { this.password = pw; }

    public String  getRole()               { return role; }
    public void    setRole(String role)    { this.role = role; }

    public boolean isActif()               { return actif; }
    public void    setActif(boolean actif) { this.actif = actif; }

    private String login;

    public String  getLogin()            { return login; }
    public void    setLogin(String l)    { this.login = l; }

    public boolean isAdmin()      { return "ADMIN".equals(this.role); }
    public String  getFullName()  { return prenom + " " + nom; }
}
