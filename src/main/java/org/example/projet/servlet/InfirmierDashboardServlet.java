package org.example.projet.servlet;

import org.example.projet.dao.PatientDAO;
import org.example.projet.model.Patient;
import org.example.projet.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/infirmier/dashboard")
public class InfirmierDashboardServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Vérifier que l'utilisateur est bien un infirmier
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"INFIRMIER".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé - Réservé aux infirmiers");
            return;
        }

        // Récupérer les patients du jour
        List<Patient> patients = patientDAO.listerPatientsDuJour();

        // Statistiques pour l'infirmier
        long patientsEnAttente = patients.stream().filter(p -> "EN_ATTENTE".equals(p.getStatut())).count();
        long patientsEnCours = patients.stream().filter(p -> "EN_COURS".equals(p.getStatut())).count();
        long patientsTermines = patients.stream().filter(p -> "TERMINE".equals(p.getStatut())).count();
        long patientsUrgents = patients.stream().filter(p -> "URGENT".equals(p.getStatut())).count();

        req.setAttribute("patients", patients);
        req.setAttribute("stats", new int[]{(int)patientsEnAttente, (int)patientsEnCours, (int)patientsTermines, (int)patientsUrgents});
        req.setAttribute("currentUser", currentUser);

        req.getRequestDispatcher("/jsp/infirmier_dashboard.jsp").forward(req, resp);
    }
}
