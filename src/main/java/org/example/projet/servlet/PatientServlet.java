package org.example.projet.servlet;

import org.example.projet.dao.PatientDAO;
import org.example.projet.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/app/patient")
public class PatientServlet extends jakarta.servlet.http.HttpServlet {
    private PatientDAO dao = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Patient> patients = dao.listerPatientsDuJour();
        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/jsp/patient_list.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        Patient p = new Patient();
        p.setNom(nom);
        p.setPrenom(prenom);
        p.setHeureArrivee(LocalDateTime.now());
        p.setStatut("EN_ATTENTE");
        dao.ajouter(p);
        resp.sendRedirect(req.getContextPath() + "/app/patient");
    }
}
