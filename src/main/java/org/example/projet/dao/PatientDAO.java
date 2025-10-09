package org.example.projet.dao;

import org.example.projet.model.Patient;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class PatientDAO {
    public void ajouter(Patient p) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(p);
            em.getTransaction().commit();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    public List<Patient> listerPatientsDuJour() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalDateTime start = today.atStartOfDay();
            LocalDateTime end = today.atTime(LocalTime.MAX);
            return em.createQuery("SELECT p FROM Patient p WHERE p.heureArrivee BETWEEN :start AND :end ORDER BY p.heureArrivee", Patient.class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    public List<Patient> listerPatients() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Récupérer TOUS les patients (pas seulement ceux du jour)
            return em.createQuery("SELECT p FROM Patient p ORDER BY p.heureArrivee DESC", Patient.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Patient findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Patient.class, id);
        } finally {
            em.close();
        }
    }
}
