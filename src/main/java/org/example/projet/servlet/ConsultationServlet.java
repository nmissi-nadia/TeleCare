package org.example.projet.servlet;

import org.example.projet.dao.ActeDAO;
import org.example.projet.dao.ConsultationDAO;
import org.example.projet.dao.PatientDAO;
import org.example.projet.dao.UserDAO;
import org.example.projet.model.Acte;
import org.example.projet.model.Consultation;
import org.example.projet.model.Patient;
import org.example.projet.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/consultation")
public class ConsultationServlet extends HttpServlet {
    private ConsultationDAO consultationDAO = new ConsultationDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private UserDAO userDAO = new UserDAO();
    private ActeDAO acteDAO = new ActeDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String patientIdParam = req.getParameter("patientId");

        if (patientIdParam == null) {
            resp.sendError(400, "Paramètre patientId manquant");
            return;
        }

        try {
            Long patientId = Long.parseLong(patientIdParam);
            Patient patient = patientDAO.findById(patientId);

            if (patient == null) {
                resp.sendError(404, "Patient non trouvé");
                return;
            }

            // Vérifier que le statut du patient permet une consultation
            if (!"EN_ATTENTE".equals(patient.getStatut()) && !"EN_COURS".equals(patient.getStatut())) {
                resp.sendError(400, "Le patient n'est pas en attente de consultation");
                return;
            }

            // Récupérer tous les actes disponibles pour le formulaire
            List<Acte> actes = acteDAO.listerTous();
            req.setAttribute("actes", actes);

            req.setAttribute("patient", patient);
            req.getRequestDispatcher("/jsp/consultation_form.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(400, "ID de patient invalide");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!("MEDECIN_GENERALISTE".equals(currentUser.getRole()) || "MEDECIN_SPECIALISTE".equals(currentUser.getRole()))) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins");
            return;
        }

        String patientIdParam = req.getParameter("patientId");
        String observations = req.getParameter("observations");
        String diagnostic = req.getParameter("diagnostic");
        String traitement = req.getParameter("traitement");
        String statut = req.getParameter("statut");
        String[] actesIds = req.getParameterValues("actes");

        // Validation basique
        if (patientIdParam == null || observations == null || diagnostic == null) {
            req.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            doGet(req, resp);
            return;
        }

        try {
            Long patientId = Long.parseLong(patientIdParam);
            Patient patient = patientDAO.findById(patientId);

            if (patient == null) {
                resp.sendError(404, "Patient non trouvé");
                return;
            }

            // Créer la consultation
            Consultation consultation = new Consultation();
            consultation.setPatient(patient);
            consultation.setMedecin(currentUser);
            consultation.setObservations(observations);
            consultation.setDiagnostic(diagnostic);
            consultation.setTraitement(traitement);
            consultation.setStatut(statut != null ? statut : "EN_COURS");

            // Ajouter les actes sélectionnés
            if (actesIds != null) {
                for (String acteId : actesIds) {
                    Acte acte = acteDAO.findById(Long.parseLong(acteId));
                    if (acte != null) {
                        consultation.ajouterActe(acte);
                    }
                }
            }

            consultationDAO.ajouter(consultation);

            if ("TERMINE".equals(consultation.getStatut())) {
                patient.setStatut("TERMINE");
                patientDAO.updateStatut(patient);
            } else {
                patient.setStatut("EN_COURS");
                patientDAO.updateStatut(patient);
            }

            resp.sendRedirect(req.getContextPath() + "/app/medecin/dashboard");

        } catch (NumberFormatException e) {
            resp.sendError(400, "Données de formulaire invalides");
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la création de la consultation: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
