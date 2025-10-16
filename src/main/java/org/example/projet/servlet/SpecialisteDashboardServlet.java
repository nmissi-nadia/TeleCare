package org.example.projet.servlet;

import org.example.projet.dao.*;
import org.example.projet.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/specialiste/dashboard")
public class SpecialisteDashboardServlet extends HttpServlet {
    private DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();
    private ConsultationDAO consultationDAO = new ConsultationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"SPECIALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins spécialistes");
            return;
        }

        try {
            String specialite = getSpecialiteFromUser(currentUser);
            List<DemandeExpertise> demandesEnAttente = demandeDAO.findBySpecialite(specialite);

            List<Consultation> consultationsEnCours = consultationDAO.findByMedecinAndStatut(currentUser, "EN_COURS_EXPERTISE");

            List<Consultation> expertisesTerminees = consultationDAO.findByMedecinAndStatut(currentUser, "TERMINE_EXPERTISE");

            req.setAttribute("demandesEnAttente", demandesEnAttente);
            req.setAttribute("consultationsEnCours", consultationsEnCours);
            req.setAttribute("expertisesTerminees", expertisesTerminees);
            req.setAttribute("specialite", specialite);

            req.getRequestDispatcher("/jsp/specialiste_dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());
            req.getRequestDispatcher("/jsp/home.jsp").forward(req, resp);
        }
    }

    private String getSpecialiteFromUser(User user) {
        String role = user.getRole();
        switch (role) {
            case "CARDIOLOGUE": return "CARDIOLOGIE";
            case "DERMATOLOGUE": return "DERMATOLOGIE";
            case "NEUROLOGUE": return "NEUROLOGIE";
            case "OPHTALMOLOGUE": return "OPHTALMOLOGIE";
            case "PEDIATRE": return "PEDIATRIE";
            case "GYNECOLOGUE": return "GYNECOLOGIE";
            case "URGENTISTE": return "URGENTISTE";
            default: return "GENERALISTE";
        }
    }
}