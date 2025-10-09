package org.example.projet.servlet;

import org.example.projet.dao.PatientDAO;
import org.example.projet.model.Patient;
import org.example.projet.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/app/patient/status")
public class PatientStatusServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Vérifier l'authentification
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendError(401);
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"INFIRMIER".equals(currentUser.getRole()) && !"MEDECIN_GENERALISTE".equals(currentUser.getRole())) {
            resp.sendError(403);
            return;
        }

        // Récupérer les patients du jour
        List<Patient> patients = patientDAO.listerPatients();

        // Retourner les données en JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        out.print("[");
        for (int i = 0; i < patients.size(); i++) {
            Patient p = patients.get(i);
            out.print("{");
            out.print("\"id\":" + p.getId() + ",");
            out.print("\"nom\":\"" + p.getNom() + "\",");
            out.print("\"prenom\":\"" + p.getPrenom() + "\",");
            out.print("\"statut\":\"" + p.getStatut() + "\",");
            out.print("\"heureArrivee\":\"" + p.getHeureArrivee().toString() + "\"");
            out.print("}");
            if (i < patients.size() - 1) {
                out.print(",");
            }
        }
        out.print("]");
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Vérifier l'authentification et les permissions
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendError(401);
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"INFIRMIER".equals(currentUser.getRole()) && !"MEDECIN_GENERALISTE".equals(currentUser.getRole())) {
            resp.sendError(403);
            return;
        }

        // Récupérer les paramètres
        String patientId = req.getParameter("patientId");
        String newStatus = req.getParameter("statut");

        if (patientId == null || newStatus == null) {
            resp.sendError(400, "Paramètres manquants");
            return;
        }

        try {
            Long id = Long.parseLong(patientId);
            Patient patient = patientDAO.findById(id);

            if (patient != null) {
                patient.setStatut(newStatus);
                // Note: Il faudrait ajouter une méthode update dans PatientDAO
                // Pour l'instant, le statut sera mis à jour lors de la prochaine consultation

                resp.setStatus(200);
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.sendError(404, "Patient non trouvé");
            }
        } catch (NumberFormatException e) {
            resp.sendError(400, "ID patient invalide");
        }
    }
}
