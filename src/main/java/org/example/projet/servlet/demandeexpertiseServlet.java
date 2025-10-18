package org.example.projet.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.example.projet.dao.*;
import org.example.projet.model.*;
import org.example.projet.util.JPAUtil;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/app/consultation/expertise")
public class demandeexpertiseServlet extends HttpServlet {

    private final DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();
    private final ConsultationDAO consultationDAO = new ConsultationDAO();
    private final CreneauSpecialisteDAO creneauDAO = new CreneauSpecialisteDAO();
    private final UserDAO specialisteDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"GENERALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins généralistes");
            return;
        }

        // Récupérer patientId s’il est présent
        String patientIdParam = req.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.isEmpty()) {
            req.setAttribute("patientId", patientIdParam);
        }

        String action = req.getParameter("action");
        if ("searchSpecialistes".equals(action)) {
            handleSearchSpecialistes(req);
        } else if ("slots".equals(action)) {
            handleSlots(req);
        }

        req.setAttribute("specialites", specialites());
        req.getRequestDispatcher("/jsp/consultaion_expertise.jsp").forward(req, resp);
    }

    private void handleSearchSpecialistes(HttpServletRequest req) {
        String specialite = req.getParameter("specialite");
        String maxTarifParam = req.getParameter("maxTarif");
        String patientIdParam = req.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.isEmpty()) {
            req.setAttribute("patientId", patientIdParam);
        }
        Double maxTarif = null;
        if (maxTarifParam != null && !maxTarifParam.isEmpty()) {
            try {
                maxTarif = Double.parseDouble(maxTarifParam);
            } catch (NumberFormatException ignored) {}
        }

            List<MedecinSpecialiste> all = specialisteDAO.findAllSpe();
            final Double maxTarifFinal = maxTarif;
            all.removeIf(m ->
                    (specialite != null && !specialite.isEmpty() && !specialite.equalsIgnoreCase(m.getSpecialite())) ||
                            (maxTarifFinal != null && m.getTarifExpertise() != null && m.getTarifExpertise() > maxTarifFinal)
            );

        req.setAttribute("specialistes", all);
    }

    private void handleSlots(HttpServletRequest req) {
        String specialisteIdParam = req.getParameter("specialisteId");
        if (specialisteIdParam == null) return;
        String patientIdParam = req.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.isEmpty()) {
            req.setAttribute("patientId", patientIdParam);
        }

        try {
            Long specialisteId = Long.parseLong(specialisteIdParam);
            MedecinSpecialiste specialiste = specialisteDAO.findByIdSpe(specialisteId);

            if (specialiste != null) {
                List<CreneauSpecialiste> creneaux =
                        creneauDAO.findBySpecialiste(specialiste);

                req.setAttribute("selectedSpecialiste", specialiste);
                req.setAttribute("creneaux", creneaux);
            }

        } catch (NumberFormatException e) {
            System.err.println("Erreur ID spécialiste : " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"GENERALISTE".equals(currentUser.getRole())) {
            resp.sendError(403, "Accès refusé - Réservé aux médecins généralistes");
            return;
        }

        try {
            Long specialisteId = Long.parseLong(req.getParameter("specialisteId"));
            String patientId = req.getParameter("patientId");
            String raison = req.getParameter("raison");
            String observations = req.getParameter("observations");

            MedecinSpecialiste specialiste = specialisteDAO.findByIdSpe(specialisteId);

            // Créer la demande d’expertise
            DemandeExpertise demande = new DemandeExpertise();
            demande.setDateCreation(LocalDateTime.now());
            demande.setMedecinGeneraliste((MedecinGeneraliste) currentUser);
            demande.setMedecinSpecialiste(specialiste);
            demande.setSpecialiteDemandee(specialiste.getSpecialite());
            demande.setRaison(raison);
            demande.setObservations(observations);

            demandeDAO.ajouter(demande);

            session.setAttribute("successMessage", "✅ Demande d’expertise créée avec succès !");
            resp.sendRedirect(req.getContextPath() + "/app/medecin/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur : " + e.getMessage());
            req.getRequestDispatcher("/jsp/consultaion_expertise.jsp").forward(req, resp);
        }
    }

    private List<String> specialites() {
        return List.of(
                "CARDIOLOGIE",
                "DERMATOLOGIE",
                "PEDIATRIE",
                "NEUROLOGIE",
                "OPHTALMOLOGIE",
                "GYNECOLOGIE",
                "URGENTISTE"
        );
    }
}
