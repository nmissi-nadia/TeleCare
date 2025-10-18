package org.example.projet.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.projet.dao.DemandeExpertiseDAO;
import org.example.projet.model.DemandeExpertise;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.model.User;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/app/expertise/details")
public class ExpertiseDetailsServlet extends HttpServlet {

    private final DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"SPECIALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(400, "Paramètre 'id' manquant");
            return;
        }

        Long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(400, "Paramètre 'id' invalide");
            return;
        }

        DemandeExpertise demande = demandeDAO.findById(id);
        if (demande == null) {
            resp.sendError(404, "Demande introuvable");
            return;
        }

        // Autorisation: spécialité
        MedecinSpecialiste spec = (MedecinSpecialiste) currentUser;
        if (demande.getSpecialiteDemandee() == null ||
            !demande.getSpecialiteDemandee().equalsIgnoreCase(spec.getSpecialite())) {
            resp.sendError(403, "Vous n'êtes pas autorisé à consulter cette demande");
            return;
        }

        req.setAttribute("demande", demande);
        req.getRequestDispatcher("/jsp/details_expertise.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        if (!"SPECIALISTE".equals(currentUser.getRole())) {
            resp.sendError(403);
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(400);
            return;
        }
        Long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(400);
            return;
        }

        DemandeExpertise demande = demandeDAO.findById(id);
        if (demande == null) {
            resp.sendError(404);
            return;
        }

        // Autorisation: spécialité
        MedecinSpecialiste spec = (MedecinSpecialiste) currentUser;
        if (demande.getSpecialiteDemandee() == null ||
            !demande.getSpecialiteDemandee().equalsIgnoreCase(spec.getSpecialite())) {
            resp.sendError(403);
            return;
        }

        String action = req.getParameter("action");
        if ("repondre".equals(action)) {
            String diagnostic = req.getParameter("diagnostic");
            String observationsSpec = req.getParameter("observationsSpec");
            if (diagnostic != null && !diagnostic.isBlank()) {
                demande.setDiagnostic(diagnostic);
            }
            if (observationsSpec != null && !observationsSpec.isBlank()) {
                demande.setObservations(observationsSpec);
            }
            demande.setDateReponse(LocalDateTime.now());
            demandeDAO.update(demande);
            resp.sendRedirect(req.getContextPath() + "/app/expertise/details?id=" + demande.getId());
            return;

        } else if ("accepter".equals(action)) {
            demande.setStatut("ACCEPTEE");
            demande.setDateReponse(LocalDateTime.now());
            demandeDAO.update(demande);
            resp.sendRedirect(req.getContextPath() + "/app/expertise/details?id=" + demande.getId());
            return;

        } else if ("refuser".equals(action)) {
            String raisonRefus = req.getParameter("raisonRefus");
            demande.setStatut("REFUSEE");
            demande.setRaisonRefus(raisonRefus);
            demande.setDateReponse(LocalDateTime.now());
            demandeDAO.update(demande);
            resp.sendRedirect(req.getContextPath() + "/app/expertise/details?id=" + demande.getId());
            return;
        }

        resp.sendError(400);
    }
}