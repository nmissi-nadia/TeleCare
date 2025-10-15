package org.example.projet.servlet;

import org.example.projet.dao.UserDAO;
import org.example.projet.model.User;
import org.example.projet.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Récupérer et afficher le message de succès s'il existe
        HttpSession session = req.getSession(false);
        // indication de la page de login /app/login
        req.setAttribute("loginPage", req.getContextPath() + "/app/login");
        if (session != null) {
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                req.setAttribute("successMessage", successMessage);
                // Nettoyer le message après l'avoir récupéré
                session.removeAttribute("successMessage");
            }
        }

        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String login = req.getParameter("login");
        String pass = req.getParameter("password");

        // Validation basique
        if (login == null || login.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            req.setAttribute("error", "Veuillez saisir votre login et mot de passe");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        User u = userDAO.findByLogin(login.trim());

        if (u != null && SecurityUtil.verify(pass, u.getMotDePasse())) {
    System.out.println("Login réussi pour rôle : " + u.getRole());  
    HttpSession session = req.getSession(true);
    session.setAttribute("currentUser", u);
    session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    
    // Redirection basée sur le rôle avec switch case
    switch (u.getRole()) {
        case "INFIRMIER":
            resp.sendRedirect(req.getContextPath() + "/app/infirmier/dashboard");
            break;
        case "SPECIALISTE":
            resp.sendRedirect(req.getContextPath() + "/jsp/specialiste_dashboard.jsp");
            break;
        case "GENERALISTE":
            resp.sendRedirect(req.getContextPath() + "/jsp/medecin_dashboard.jsp");
            break;
        default:
            System.out.println("Rôle inconnu : " + u.getRole());  // Log pour rôles inattendus
            resp.sendRedirect(req.getContextPath() + "/jsp/home.jsp");
            break;
    }
} else {
    System.out.println("Échec d'authentification pour login : " + login);  // Log pour échec
    req.setAttribute("error", "Login ou mot de passe incorrect");
    req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
}
    }
}