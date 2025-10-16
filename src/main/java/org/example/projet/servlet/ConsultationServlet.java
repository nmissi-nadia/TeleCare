package org.example.projet.servlet;

import org.example.projet.dao.ActeDAO;
import org.example.projet.dao.ConsultationDAO;
import org.example.projet.dao.PatientDAO;
import org.example.projet.dao.UserDAO;
import org.example.projet.model.Acte;
import org.example.projet.model.Consultation;
import org.example.projet.model.DemandeExpertise;
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
            if (!"EN_ATTENTE".equals(patient.getStatut()) && !"EN_COURS".equals(patient.getStatut()) && !"URGENT".equals(patient.getStatut()) && !"EN_ATTENTE_EXPERTISE".equals(patient.getStatut())) {
                resp.sendError(400, "Le patient n'est pas en attente de consultation");
                return;
            }
            //si le patient est en attente de consultation, on le met en cours
            if ("EN_ATTENTE".equals(patient.getStatut()) || "URGENT".equals(patient.getStatut())) {
                patient.setStatut("EN_COURS");
                patientDAO.update(patient);
            }

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
        if (!"GENERALISTE".equals(currentUser.getRole()) && !"SPECIALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé");
            return;
        }

        String patientIdParam = req.getParameter("patientId");
        String consultationType = req.getParameter("type");
        String observations = req.getParameter("observations");
        String diagnostic = req.getParameter("diagnostic");
        String traitement = req.getParameter("traitement");
        String raison = req.getParameter("raison");
        String specialite = req.getParameter("specialite");
        String[] actesIds = req.getParameterValues("actes");

        if (patientIdParam == null || consultationType == null) {
            req.setAttribute("error", "Informations manquantes");
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

            // Gestion selon le type de consultation
            switch (consultationType) {
                case "DIRECTE":
                    if (observations == null || diagnostic == null || traitement == null) {
                        req.setAttribute("error", "Tous les champs sont obligatoires pour une consultation directe");
                        doGet(req, resp);
                        return ;
                    }
                    consultation.setObservations(observations);
                    consultation.setDiagnostic(diagnostic);
                    consultation.setTraitement(traitement);
                    consultation.setStatut("TERMINE");

                    // Ajouter les actes si sélectionnés
                    if (actesIds != null) {
                        for (String acteId : actesIds) {
                            Acte acte = acteDAO.findById(Long.parseLong(acteId));
                            if (acte != null) {
                                consultation.ajouterActe(acte);
                            }
                        }
                    }

                    patient.setStatut("TERMINE");
                    break;

                case "EXPERTISE":
                    if (observations == null || diagnostic == null || raison == null || specialite == null) {
                        req.setAttribute("error", "Tous les champs sont obligatoires pour une demande d'expertise");
                        doGet(req, resp);
                        return;
                    }

                    // Créer une demande d'expertise
                    DemandeExpertise demande = new DemandeExpertise();
                    demande.setConsultation(consultation);
                    demande.setMedecinGeneraliste((org.example.projet.model.MedecinGeneraliste) currentUser);
                    demande.setRaison(raison);
                    demande.setSpecialiteDemandee(specialite);
                    demande.setStatut("EN_ATTENTE");
                    demande.setObservations(observations);
                    demande.setDiagnostic(diagnostic);

                    // demandeExpertiseDAO.ajouter(demande);

                    consultation.setObservations(observations);
                    consultation.setDiagnostic(diagnostic);
                    consultation.setStatut("EN_ATTENTE_EXPERTISE");
                    patient.setStatut("EN_ATTENTE_EXPERTISE");
                    break;

                case "ANNULATION":
                    if (raison == null) {
                        req.setAttribute("error", "La raison d'annulation est obligatoire");
                        doGet(req, resp);
                        return;
                    }

                    consultation.setObservations("Consultation annulée: " + raison);
                    consultation.setStatut("ANNULEE");
                    patient.setStatut("EN_ATTENTE");
                    break;

                default:
                    req.setAttribute("error", "Type de consultation invalide");
                    doGet(req, resp);
                    return;
            }

            consultationDAO.ajouter(consultation);
            patientDAO.updateStatut(patient);
            String message = "";
            switch (consultationType) {
                case "DIRECTE":
                    message = "Consultation directe terminée avec succès";
                    break;
                case "EXPERTISE":
                    message = "Demande d'expertise envoyée";
                    break;
                case "ANNULATION":
                    message = "Consultation annulée";
                    break;
            }

            resp.sendRedirect(req.getContextPath() + "/app/medecin/dashboard?success=" + java.net.URLEncoder.encode(message, "UTF-8"));

        } catch (NumberFormatException e) {
            resp.sendError(400, "Données invalides");
        } catch (Exception e) {
            req.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(req, resp);
        }
    }
}   