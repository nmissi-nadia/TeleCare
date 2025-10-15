package org.example.projet.dao;

import org.example.projet.model.Consultation;
import org.example.projet.model.Patient;
import org.example.projet.model.User;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class ConsultationDAO {
    public void ajouter(Consultation c) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(c);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void update(Consultation c) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(c);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    public List<Consultation> listerConsultationsDuJour() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalDateTime start = today.atStartOfDay();
            LocalDateTime end = today.atTime(LocalTime.MAX);
            return em.createQuery("SELECT c FROM Consultation c WHERE c.dateConsultation BETWEEN :start AND :end ORDER BY c.dateConsultation", Consultation.class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .getResultList();
        } finally {
            em.close();
        }
    }
        public Consultation findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Consultation.class, id);
        } finally {
            em.close();
        }
    }



    public List<Consultation> findByPatient(Patient patient) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT c FROM Consultation c WHERE c.patient = :patient ORDER BY c.dateConsultation DESC",
                Consultation.class)
                .setParameter("patient", patient)
                .getResultList();
        } finally {
            em.close();
        }
    }
    public List<Consultation> findByMedecinAndStatut(User medecin, String statut) {
    EntityManager em = JPAUtil.getEntityManager();
    try {
        return em.createQuery(
            "SELECT c FROM Consultation c WHERE c.medecin = :medecin AND c.statut = :statut ORDER BY c.dateConsultation DESC",
            Consultation.class)
            .setParameter("medecin", medecin)
            .setParameter("statut", statut)
            .getResultList();
    } finally {
        em.close();
    }
}
}
