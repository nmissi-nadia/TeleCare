package org.example.projet.servlet;

import org.example.projet.dao.PatientDAO;
import org.example.projet.dao.ConsultationDAO;
import org.example.projet.model.Patient;
import org.example.projet.model.User;
import org.example.projet.model.Consultation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/medecin/dashboard")
public class MedecinDashboardServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private ConsultationDAO consultationDAO = new ConsultationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!("GENERALISTE".equals(currentUser.getRole()) || "SPECIALISTE".equals(currentUser.getRole()))) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins");
            return;
        }
        // patients urgents
        List<Patient> urgentPatients = patientDAO.listerPatientsUrgents();
//patients en attente
        List<Patient> patientsEnAttente = patientDAO.listerPatientsEnAttente();

        // consultaion par jour
        List<Consultation> consultationsDuJour = consultationDAO.listerConsultationsDuJour();

        // stats
        long consultationsAujourdhui = consultationsDuJour.size();
        long patientsEnAttenteCount = patientsEnAttente.size();
        long consultationsTerminees = consultationsDuJour.stream()
            .filter(c -> "TERMINE".equals(c.getStatut()))
            .count();
        req.setAttribute("urgentPatients",urgentPatients);
        req.setAttribute("patientsEnAttente", patientsEnAttente);
        req.setAttribute("consultationsDuJour", consultationsDuJour);
        req.setAttribute("stats", new int[]{(int)consultationsAujourdhui, (int)patientsEnAttenteCount, (int)consultationsTerminees});
        req.setAttribute("currentUser", currentUser);

        req.getRequestDispatcher("/jsp/medecin_dashboard.jsp").forward(req, resp);
    }
}