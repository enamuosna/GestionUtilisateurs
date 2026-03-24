package sn.gesusers.dao;

import sn.gesusers.beans.Utilisateur;
import sn.gesusers.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    private Utilisateur map(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setId(rs.getInt("id"));
        u.setNom(rs.getString("nom"));
        u.setPrenom(rs.getString("prenom"));
        u.setRole(rs.getString("role"));
        u.setActif(rs.getBoolean("actif"));
        try { u.setEmail(rs.getString("email")); } catch (SQLException ignored) {}
        try { u.setLogin(rs.getString("login")); } catch (SQLException ignored) {}
        return u;
    }

    private String hashPw(String raw) {
        if (raw == null || raw.isBlank()) return BCrypt.hashpw("change moi", BCrypt.gensalt());
        return raw.startsWith("$2") ? raw : BCrypt.hashpw(raw, BCrypt.gensalt());
    }

    private String genererLogin(String email, String nom, String prenom) {
        String base;
        if (email != null && email.contains("@")) {
            base = email.split("@")[0].replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        } else if (prenom != null && nom != null) {
            base = (prenom.charAt(0) + nom).replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        } else if (nom != null) {
            base = nom.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        } else {
            base = "user";
        }
        String login = base;
        int suffix = 1;
        while (loginExiste(login, -1)) {
            login = base + suffix++;
        }
        return login;
    }


    public Utilisateur authentifier(String login, String password) {
        String sql = "SELECT * FROM utilisateurs WHERE login = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, login);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hash = rs.getString("password");
                boolean ok = hash.startsWith("$2")
                           ? BCrypt.checkpw(password, hash)
                           : password.equals(hash);
                if (ok) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Utilisateur authentifierParEmail(String email, String password) {
        String sql = "SELECT * FROM utilisateurs WHERE email = ? AND actif = TRUE";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hash = rs.getString("password");
                boolean ok = hash.startsWith("$2")
                           ? BCrypt.checkpw(password, hash)
                           : password.equals(hash);
                if (ok) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Utilisateur> findAll() {
        List<Utilisateur> liste = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery(
                 "SELECT * FROM utilisateurs ORDER BY id")) {
            while (rs.next()) liste.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }


    public Utilisateur findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT * FROM utilisateurs WHERE id = ?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }


    public boolean create(Utilisateur u) {
        
        String login = (u.getLogin() != null && !u.getLogin().isBlank())
                     ? u.getLogin()
                     : genererLogin(u.getEmail(), u.getNom(), u.getPrenom());

        String role = (u.getRole() != null && !u.getRole().isBlank()) ? u.getRole() : "USER";


        String sql = "INSERT INTO utilisateurs(nom,prenom,email,login,password,role,actif) "
                   + "VALUES(?,?,?,?,?,?::role_type,?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getNom() != null ? u.getNom() : "");
            ps.setString(2, u.getPrenom() != null ? u.getPrenom() : "");
            ps.setString(3, u.getEmail() != null ? u.getEmail() : "");
            ps.setString(4, login);
            ps.setString(5, hashPw(u.getPassword()));
            ps.setString(6, role);
            ps.setBoolean(7, u.isActif());

            boolean ok = ps.executeUpdate() > 0;
            System.out.println("[UtilisateurDAO.create] login=" + login + " ok=" + ok);
            return ok;

        } catch (SQLException e) {
            System.err.println("[UtilisateurDAO.create] ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }


    public boolean update(Utilisateur u) {
        boolean changePw = (u.getPassword() != null && !u.getPassword().isBlank());
        String role = (u.getRole() != null && !u.getRole().isBlank()) ? u.getRole() : "USER";

        String sql = changePw
            ? "UPDATE utilisateurs SET nom=?,prenom=?,email=?,login=?,password=?,role=?::role_type,actif=? WHERE id=?"
            : "UPDATE utilisateurs SET nom=?,prenom=?,email=?,login=?,role=?::role_type,actif=? WHERE id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getNom() != null ? u.getNom() : "");
            ps.setString(2, u.getPrenom() != null ? u.getPrenom() : "");
            ps.setString(3, u.getEmail() != null ? u.getEmail() : "");
            ps.setString(4, u.getLogin() != null ? u.getLogin() : "");

            if (changePw) {
                ps.setString(5, hashPw(u.getPassword()));
                ps.setString(6, role);
                ps.setBoolean(7, u.isActif());
                ps.setInt(8, u.getId());
            } else {
                ps.setString(5, role);
                ps.setBoolean(6, u.isActif());
                ps.setInt(7, u.getId());
            }
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UtilisateurDAO.update] ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfil(Utilisateur u) {
        boolean changePw = (u.getPassword() != null && !u.getPassword().isBlank());
        String sql = changePw
            ? "UPDATE utilisateurs SET nom=?,prenom=?,password=? WHERE id=?"
            : "UPDATE utilisateurs SET nom=?,prenom=? WHERE id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            if (changePw) {
                ps.setString(3, hashPw(u.getPassword()));
                ps.setInt(4, u.getId());
            } else {
                ps.setInt(3, u.getId());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UtilisateurDAO.updateProfil] ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "DELETE FROM utilisateurs WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean loginExiste(String login, int excludeId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT id FROM utilisateurs WHERE login=? AND id!=?")) {
            ps.setString(1, login);
            ps.setInt(2, excludeId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean emailExiste(String email, int excludeId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT id FROM utilisateurs WHERE email=? AND id!=?")) {
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
