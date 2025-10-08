package org.example.projet.servlet;

import org.example.projet.dao.ConsultationDAO;
import org.example.projet.dao.PatientDAO;
import org.example.projet.model.Consultation;
import org.example.projet.model.Patient;
import org.example.projet.model.MedecinGeneraliste;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/app/consultation")
public class ConsultationServlet extends jakarta.servlet.http.HttpServlet {
    private ConsultationDAO dao = new ConsultationDAO();
    private PatientDAO patientDAO = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pid = req.getParameter("patientId");
        if (pid != null) {
            Patient p = patientDAO.listerPatientsDuJour().stream().filter(x -> x.getId().toString().equals(pid)).findFirst().orElse(null);
            req.setAttribute("patient", p);
            req.getRequestDispatcher("/jsp/consultation_form.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/app/patient");
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String csrf = req.getParameter("csrf");
        HttpSession s = req.getSession(false);
        if (s == null || csrf == null || !csrf.equals(s.getAttribute("csrfToken"))) {
            resp.sendError(403); return;
        }
        String patientId = req.getParameter("patientId");
        String observations = req.getParameter("observations");
        String diagnostic = req.getParameter("diagnostic");
        Patient p = patientDAO.listerPatientsDuJour().stream().filter(x -> x.getId().toString().equals(patientId)).findFirst().orElse(null);
        if (p == null) { resp.sendRedirect(req.getContextPath()+"/app/patient"); return; }
        Consultation c = new Consultation();
        c.setPatient(p);
        c.setDateConsultation(LocalDateTime.now());
        c.setObservations(observations);
        c.setDiagnostic(diagnostic);
        c.setStatut("TERMINEE");
        c.setCout(150.0);
        dao.ajouter(c);
        p.setStatut("TERMINEE");
        resp.sendRedirect(req.getContextPath()+"/app/patient");
    }
}
