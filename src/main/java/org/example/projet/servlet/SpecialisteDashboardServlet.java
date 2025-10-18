package org.example.projet.servlet;

import org.example.projet.dao.*;
import org.example.projet.model.*;
import org.example.projet.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/app/specialiste/dashboard")
public class SpecialisteDashboardServlet extends HttpServlet {

    private final DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();
    private final ConsultationDAO consultationDAO = new ConsultationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        if (!"SPECIALISTE".equalsIgnoreCase(currentUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé - réservé aux médecins spécialistes");
            return;
        }
        MedecinSpecialiste specialist = (currentUser instanceof MedecinSpecialiste)
        ? (MedecinSpecialiste) currentUser
        : null;
            if (specialist == null) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Type d'utilisateur inattendu pour un spécialiste");
                return;
            }

        try {
            
            String specialite = specialist.getSpecialite();

            List<DemandeExpertise> demandesEnAttente = demandeDAO.findBySpecialite(specialite);

            List<Consultation> consultationsEnCours =
                    consultationDAO.findByMedecinAndStatut(currentUser, "EN_COURS_EXPERTISE");

            List<Consultation> expertisesTerminees =
                    consultationDAO.findByMedecinAndStatut(currentUser, "TERMINE_EXPERTISE");

            int totalDemandes = (demandesEnAttente != null ? demandesEnAttente.size() : 0)
                    + (expertisesTerminees != null ? expertisesTerminees.size() : 0);

            req.setAttribute("specialite", specialite);
            req.setAttribute("demandesEnAttente", demandesEnAttente);
            req.setAttribute("consultationsEnCours", consultationsEnCours);
            req.setAttribute("expertisesTerminees", expertisesTerminees);
            req.setAttribute("totalDemandes", totalDemandes);

            req.getRequestDispatcher("/jsp/specialiste_dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement du dashboard : " + e.getMessage());
            req.getRequestDispatcher("/jsp/home.jsp").forward(req, resp);
        }
    }
}
