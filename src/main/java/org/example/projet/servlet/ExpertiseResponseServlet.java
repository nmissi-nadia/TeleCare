package org.example.projet.servlet;

import org.example.projet.dao.*;
import org.example.projet.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/app/expertise/repondre")
public class ExpertiseResponseServlet extends HttpServlet {
    private DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();
    private ConsultationDAO consultationDAO = new ConsultationDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String demandeIdParam = req.getParameter("demandeId");
        String response = req.getParameter("response");

        if (demandeIdParam == null || response == null) {
            resp.sendError(400, "Paramètres manquants");
            return;
        }

        try {
            Long demandeId = Long.parseLong(demandeIdParam);
            DemandeExpertise demande = demandeDAO.findById(demandeId);

            if (demande == null) {
                resp.sendError(404, "Demande d'expertise non trouvée");
                return;
            }

            if ("ACCEPTER".equals(response)) {
                accepterExpertise(demande, currentUser, req, resp);
            } else if ("REFUSER".equals(response)) {
                refuserExpertise(demande, currentUser, req, resp);
            } else {
                resp.sendError(400, "Réponse invalide");
            }

        } catch (NumberFormatException e) {
            resp.sendError(400, "ID de demande invalide");
        }
    }

    private void accepterExpertise(DemandeExpertise demande, User specialiste, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Récupérer les données de la consultation originale
            Consultation consultationOriginale = demande.getConsultation();
            
            // Créer une nouvelle consultation d'expertise
            Consultation consultation = new Consultation();
            consultation.setPatient(consultationOriginale.getPatient());
            consultation.setMedecin(specialiste);
            consultation.setObservations(consultationOriginale.getObservations());
            consultation.setDiagnostic(consultationOriginale.getDiagnostic());
            consultation.setTraitement(consultationOriginale.getTraitement());
            consultation.setStatut("EN_COURS_EXPERTISE");
            consultation.setDateConsultation(LocalDateTime.now());

            // Lier la demande à la consultation
            demande.setConsultation(consultation);
            demande.setStatut("ACCEPTEE");
            demande.setDateReponse(LocalDateTime.now());
            demande.setMedecinSpecialiste((MedecinSpecialiste) specialiste);

            consultationDAO.ajouter(consultation);
            demandeDAO.update(demande);

            req.getSession().setAttribute("successMessage", "Demande d'expertise acceptée avec succès");
            resp.sendRedirect(req.getContextPath() + "/app/specialiste/dashboard");

        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de l'acceptation: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/app/specialiste/dashboard?error=accept_error");
        }
    }

    private void refuserExpertise(DemandeExpertise demande, User specialiste, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            demande.setStatut("REFUSEE");
            demande.setDateReponse(LocalDateTime.now());
            demande.setRaisonRefus("Refusée par le spécialiste");
            demande.setMedecinSpecialiste((MedecinSpecialiste) specialiste);

            demandeDAO.update(demande);

            req.getSession().setAttribute("successMessage", "Demande d'expertise refusée");
            resp.sendRedirect(req.getContextPath() + "/app/specialiste/dashboard");

        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du refus: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/app/specialiste/dashboard?error=refuse_error");
        }
    }
}