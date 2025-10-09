package org.example.projet.servlet;
import org.example.projet.dao.PatientDAO;
import org.example.projet.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/app/patient")
public class PatientServlet extends jakarta.servlet.http.HttpServlet {
    private PatientDAO dao = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Patient> patients = dao.listerPatients();
        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/jsp/patient_list.jsp").forward(req, resp);
    }

        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");

        // Récupération des paramètres de date
        String dateNaissanceStr = req.getParameter("dateNaissance");
        String heureArriveeStr = req.getParameter("heureArrivee");

        Patient p = new Patient();
        p.setNom(nom);
        p.setPrenom(prenom);

        // Traitement de la date de naissance
        if (dateNaissanceStr != null && !dateNaissanceStr.isEmpty()) {
            try {
                LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
                p.setDateNaissance(dateNaissance);
            } catch (Exception e) {
                // Log error or handle invalid date format
            }
        }

        // Traitement du numéro de sécurité sociale
        String numSecuriteSociale = req.getParameter("numSecuriteSociale");
        if (numSecuriteSociale != null && !numSecuriteSociale.isEmpty()) {
            p.setNumSecuriteSociale(numSecuriteSociale);
        }

        // Traitement des signes vitaux
        try {
            String tensionStr = req.getParameter("tension");
            if (tensionStr != null && !tensionStr.isEmpty()) {
                p.setTension(Double.parseDouble(tensionStr));
            }

            String frequenceCardiaqueStr = req.getParameter("frequenceCardiaque");
            if (frequenceCardiaqueStr != null && !frequenceCardiaqueStr.isEmpty()) {
                p.setFrequenceCardiaque(Integer.parseInt(frequenceCardiaqueStr));
            }

            String temperatureStr = req.getParameter("temperature");
            if (temperatureStr != null && !temperatureStr.isEmpty()) {
                p.setTemperature(Double.parseDouble(temperatureStr));
            }

            String frequenceRespiratoireStr = req.getParameter("frequenceRespiratoire");
            if (frequenceRespiratoireStr != null && !frequenceRespiratoireStr.isEmpty()) {
                p.setFrequenceRespiratoire(Integer.parseInt(frequenceRespiratoireStr));
            }
        } catch (NumberFormatException e) {
            // Log error or handle invalid number format
        }

        // Traitement de l'heure d'arrivée
        if (heureArriveeStr != null && !heureArriveeStr.isEmpty()) {
            try {
                LocalDateTime heureArrivee = LocalDateTime.parse(heureArriveeStr);
                p.setHeureArrivee(heureArrivee);
            } catch (Exception e) {
                // Si le format n'est pas correct, utiliser l'heure actuelle
                p.setHeureArrivee(LocalDateTime.now());
            }
        } else {
            p.setHeureArrivee(LocalDateTime.now());
        }

        // Traitement du statut
        String statut = req.getParameter("statut");
        if (statut != null && !statut.isEmpty()) {
            p.setStatut(statut);
        } else {
            p.setStatut("EN_ATTENTE");
        }

        dao.ajouter(p);
        resp.sendRedirect(req.getContextPath() + "/app/patient");
    }
}
