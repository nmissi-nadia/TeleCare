package org.example.projet.servlet;

import org.example.projet.dao.UserDAO;
import org.example.projet.model.Infirmier;
import org.example.projet.model.MedecinGeneraliste;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.model.User;
import org.example.projet.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Rediriger vers la page d'inscription
        resp.sendRedirect(req.getContextPath() + "/jsp/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        // Récupération et validation des paramètres
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        // Validation des champs obligatoires
        if (nom == null || nom.trim().isEmpty()) {
            errors.add("Le nom est obligatoire");
        }

        if (prenom == null || prenom.trim().isEmpty()) {
            errors.add("Le prénom est obligatoire");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.add("L'email est obligatoire");
        } else if (!isValidEmail(email)) {
            errors.add("Format d'email invalide");
        }

        if (password == null || password.length() < 8) {
            errors.add("Le mot de passe doit contenir au moins 8 caractères");
        } else if (!isValidPassword(password)) {
            errors.add("Le mot de passe doit contenir au moins une majuscule et un chiffre");
        }

        if (role == null || role.trim().isEmpty()) {
            errors.add("Le rôle est obligatoire");
        } else if (!isValidRole(role)) {
            errors.add("Rôle invalide");
        }

        // Vérifier si l'email existe déjà
        if (email != null && userDAO.findByLogin(email) != null) {
            errors.add("Cette adresse email est déjà utilisée");
        }

        // Si il y a des erreurs, retourner à la page d'inscription
        if (!errors.isEmpty()) {
            req.setAttribute("error", String.join("<br>", errors));
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Créer l'utilisateur selon le rôle
            User newUser = createUserByRole(role, nom, prenom, email, password);

            // Sauvegarder l'utilisateur
            userDAO.save(newUser);

            // Rediriger vers la page de connexion avec un message de succès
            req.getSession().setAttribute("successMessage", "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");

        } catch (Exception e) {
            // En cas d'erreur lors de la sauvegarde
            errors.add("Erreur lors de la création du compte : " + e.getMessage());
            req.setAttribute("error", String.join("<br>", errors));
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }

    private User createUserByRole(String role, String nom, String prenom, String email, String password) {
        User user;

        switch (role) {
            case "INFIRMIER":
                user = new Infirmier();
                break;
            case "MEDECIN_GENERALISTE":
                user = new MedecinGeneraliste();
                break;
            case "MEDECIN_SPECIALISTE":
                user = new MedecinSpecialiste();
                break;
            default:
                throw new IllegalArgumentException("Rôle invalide : " + role);
        }

        user.setNom(nom.trim());
        user.setPrenom(prenom.trim());
        user.setLogin(email.trim());
        user.setMotDePasse(SecurityUtil.hashPassword(password));
        user.setRole(role);

        return user;
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }

    private boolean isValidPassword(String password) {
        // Au moins une majuscule et un chiffre
        return password.matches(".*[A-Z].*") && password.matches(".*[0-9].*");
    }

    private boolean isValidRole(String role) {
        return role.equals("INFIRMIER") ||
               role.equals("MEDECIN_GENERALISTE") ||
               role.equals("MEDECIN_SPECIALISTE");
    }
}