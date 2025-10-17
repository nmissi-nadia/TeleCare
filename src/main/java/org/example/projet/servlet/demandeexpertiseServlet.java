package org.example.projet.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.example.projet.dao.*;
import org.example.projet.model.*;
import jakarta.persistence.EntityManager;
import org.example.projet.util.JPAUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/app/consultation/expertise")
public class demandeexpertiseServlet extends HttpServlet {
    private final DemandeExpertiseDAO demandeDAO = new DemandeExpertiseDAO();
    private final ConsultationDAO consultationDAO = new ConsultationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String action = req.getParameter("action");
        if (action != null) {
            switch (action) {
                case "searchSpecialistes":
                    handleSearchSpecialistes(req, resp);
                    return;
                case "slots":
                    handleSlots(req, resp);
                    return;
                case "detail":
                    handleConsultationDetail(req, resp);
                    return;
                default:
                    resp.sendError(400, "Action invalide");
                    return;
            }
        }

        String consultationIdParam = req.getParameter("consultationId");
        if (consultationIdParam != null) {
            try {
                Long consultationId = Long.parseLong(consultationIdParam);
                Consultation consultation = consultationDAO.findById(consultationId);
                if (consultation != null) {
                    req.setAttribute("consultation", consultation);
                    req.setAttribute("patient", consultation.getPatient());
                }
            } catch (NumberFormatException ignored) {}
        }

        req.setAttribute("specialites", specialites());
        req.getRequestDispatcher("/jsp/consultaion_expertise.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String patientIdParam = req.getParameter("patientId");
        String consultationIdParam = req.getParameter("consultationId");
        String specialiteDemandee = req.getParameter("specialiteDemandee");
        String raison = req.getParameter("raison");
        String observations = req.getParameter("observations");

        if (consultationIdParam == null || specialiteDemandee == null || raison == null) {
            resp.sendError(400, "Paramètres manquants");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdParam);
            Consultation consultation = consultationDAO.findById(consultationId);
            if (consultation == null) {
                resp.sendError(404, "Consultation introuvable");
                return;
            }

            DemandeExpertise demande = new DemandeExpertise();
            demande.setConsultation(consultation);
            demande.setMedecinGeneraliste((MedecinGeneraliste) currentUser);
            demande.setSpecialiteDemandee(specialiteDemandee);
            demande.setRaison(raison);
            demande.setObservations(observations);
            demande.setDateCreation(LocalDateTime.now());
            demande.setStatut("EN_ATTENTE");

            demandeDAO.ajouter(demande);

            session.setAttribute("successMessage", "Demande d'expertise créée avec succès");
            resp.sendRedirect(req.getContextPath() + "/app/infirmier/dashboard");
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la création de la demande: " + e.getMessage());
            resp.sendError(500, "Erreur interne");
        }
    }

    private void handleSearchSpecialistes(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String specialite = req.getParameter("specialite");
        String maxTarifParam = req.getParameter("maxTarif");
        Double maxTarif = null;
        try { if (maxTarifParam != null && !maxTarifParam.isEmpty()) maxTarif = Double.parseDouble(maxTarifParam); } catch (NumberFormatException ignored) {}

        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<MedecinSpecialiste> all = em.createQuery("SELECT m FROM MedecinSpecialiste m", MedecinSpecialiste.class).getResultList();
            List<MedecinSpecialiste> filtered = all.stream()
                    .filter(m -> specialite == null || specialite.isEmpty() || specialite.equalsIgnoreCase(m.getSpecialite()))
                    .sorted(Comparator.comparing(MedecinSpecialiste::getTarifExpertise, Comparator.nullsLast(Comparator.naturalOrder())))
                    .collect(Collectors.toList());

            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("[");
            for (int i = 0; i < filtered.size(); i++) {
                MedecinSpecialiste m = filtered.get(i);
                out.print("{"
                        + "\"id\":" + m.getId() + ","
                        + "\"nom\":\"" + escape(m.getNom()) + "\","
                        + "\"prenom\":\"" + escape(m.getPrenom()) + "\","
                        + "\"specialite\":\"" + escape(m.getSpecialite()) + "\","
                        + "\"tarif\":" + (m.getTarifExpertise() == null ? "null" : m.getTarifExpertise())
                        + "}");
                if (i < filtered.size() - 1) out.print(",");
            }
            out.print("]");
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    private void handleSlots(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String specialisteIdParam = req.getParameter("specialisteId");
        if (specialisteIdParam == null) { resp.sendError(400, "specialisteId manquant"); return; }
        LocalDateTime base = LocalDateTime.now().plusDays(1).withHour(9).withMinute(0).withSecond(0).withNano(0);
        List<LocalDateTime> slots = new ArrayList<>();
        for (int i = 0; i < 6; i++) { slots.add(base.plusMinutes(30L * i)); }
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("[");
        for (int i = 0; i < slots.size(); i++) {
            out.print("{\"start\":\"" + slots.get(i).format(fmt) + "\"}");
            if (i < slots.size() - 1) out.print(",");
        }
        out.print("]");
    }

    private void handleConsultationDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String consultationIdParam = req.getParameter("consultationId");
        if (consultationIdParam == null) { resp.sendError(400, "consultationId manquant"); return; }
        try {
            Long id = Long.parseLong(consultationIdParam);
            Consultation c = consultationDAO.findById(id);
            if (c == null) { resp.sendError(404, "Consultation introuvable"); return; }
            c.calculerCoutTotal();

            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{"
                    + "\"id\":" + c.getId() + ","
                    + "\"patient\":\"" + escape(c.getPatient().getNom() + " " + c.getPatient().getPrenom()) + "\","
                    + "\"date\":\"" + c.getDateConsultation() + "\","
                    + "\"statut\":\"" + escape(c.getStatut()) + "\","
                    + "\"cout\":" + c.getCout()
                    + "}");
        } catch (NumberFormatException e) {
            resp.sendError(400, "ID invalide");
        }
    }

    private List<String> specialites() {
        return Arrays.asList(
                "CARDIOLOGIE",
                "DERMATOLOGIE",
                "NEUROLOGIE",
                "OPHTALMOLOGIE",
                "PEDIATRIE",
                "GYNECOLOGIE",
                "URGENTISTE",
                "GENERALISTE"
        );
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}