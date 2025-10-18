package org.example.projet.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.projet.dao.DemandeExpertiseDAO;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.model.User;

import java.io.IOException;

@WebServlet("/app/specialiste/demandes")
public class SpecialisteDemandesServlet extends HttpServlet {

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
            resp.sendError(403);
            return;
        }

        MedecinSpecialiste specialiste = (MedecinSpecialiste) currentUser;
        req.setAttribute("demandes", demandeDAO.findBySpecialite(specialiste.getSpecialite()));
        req.getRequestDispatcher("/jsp/reponce_expertise.jsp").forward(req, resp);
    }
}