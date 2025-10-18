package org.example.projet.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.projet.dao.CreneauSpecialisteDAO;
import org.example.projet.dao.UserDAO;
import org.example.projet.model.CreneauSpecialiste;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.model.User;
import org.example.projet.util.JPAUtil;

import jakarta.persistence.EntityManager;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/app/specialiste/profil")
public class ProfilSpecialisteServlet extends HttpServlet {
    private final CreneauSpecialisteDAO creneauDAO = new CreneauSpecialisteDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"SPECIALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins spécialistes");
            return;
        }

        User fresh = userDAO.findById(currentUser.getId());
        if (!(fresh instanceof MedecinSpecialiste)) {
            resp.sendError(403, "Profil non spécialiste");
            return;
        }
        MedecinSpecialiste specialiste = (MedecinSpecialiste) fresh;

        List<CreneauSpecialiste> creneaux = creneauDAO.findBySpecialiste(specialiste);
        req.setAttribute("specialiste", specialiste);
        req.setAttribute("creneaux", creneaux);

        req.getRequestDispatcher("/jsp/profil_specialiste.jsp").forward(req, resp);
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
            resp.sendError(403, "Accès refusé - Réservé aux médecins spécialistes");
            return;
        }

        User fresh = userDAO.findById(currentUser.getId());
        if (!(fresh instanceof MedecinSpecialiste)) {
            resp.sendError(403, "Profil non spécialiste");
            return;
        }
        MedecinSpecialiste specialiste = (MedecinSpecialiste) fresh;

        String specialite = req.getParameter("specialite");
        String tarifExpertiseParam = req.getParameter("tarifExpertise");
        String dateParam = req.getParameter("date");
        String heureDebutParam = req.getParameter("heureDebut");
        String heureFinParam = req.getParameter("heureFin");
        String tarifParam = req.getParameter("tarif");

        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            MedecinSpecialiste managed = em.find(MedecinSpecialiste.class, specialiste.getId());
            if (specialite != null && !specialite.isEmpty()) {
                managed.setSpecialite(specialite);
            }
            if (tarifExpertiseParam != null && !tarifExpertiseParam.isEmpty()) {
                try { managed.setTarifExpertise(Double.parseDouble(tarifExpertiseParam)); } catch (NumberFormatException ignored) {}
            }
            em.merge(managed);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new ServletException(e);
        } finally {
            if (em.isOpen()) em.close();
        }

        if (dateParam != null && !dateParam.isEmpty() &&
                heureDebutParam != null && !heureDebutParam.isEmpty() &&
                heureFinParam != null && !heureFinParam.isEmpty() &&
                tarifParam != null && !tarifParam.isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(dateParam);
                LocalTime hDebut = LocalTime.parse(heureDebutParam);
                LocalTime hFin = LocalTime.parse(heureFinParam);
                Double tarif = Double.parseDouble(tarifParam);

                CreneauSpecialiste c = new CreneauSpecialiste(specialiste, date, hDebut, hFin, tarif);
                creneauDAO.ajouter(c);
            } catch (Exception e) {
                req.getSession().setAttribute("error", "Créneau invalide: " + e.getMessage());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/app/specialiste/profil");
    }
}