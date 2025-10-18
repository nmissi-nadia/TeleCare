package org.example.projet.dao;

import jakarta.persistence.EntityManager;
import org.example.projet.model.CreneauSpecialiste;
import org.example.projet.model.User;
import org.example.projet.util.JPAUtil;

import java.time.LocalDate;
import java.util.List;

public class CreneauSpecialisteDAO {

    // ➕ Ajouter un créneau
    public void ajouter(CreneauSpecialiste creneau) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(creneau);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    // 🔄 Mettre à jour un créneau (dispo, tarif, etc.)
    public void update(CreneauSpecialiste creneau) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(creneau);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    // 🔍 Trouver tous les créneaux d’un spécialiste (disponibles ou non)
    public List<CreneauSpecialiste> findBySpecialiste(User specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM CreneauSpecialiste c WHERE c.specialiste = :specialiste ORDER BY c.dateDisponibilite, c.heureDebut",
                            CreneauSpecialiste.class)
                    .setParameter("specialiste", specialiste)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 🔍 Trouver les créneaux disponibles d’un spécialiste spécifique
    public List<CreneauSpecialiste> findDisponiblesBySpecialiste(Long specialisteId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM CreneauSpecialiste c WHERE c.specialiste.id = :sid AND c.disponible = true ORDER BY c.dateDisponibilite, c.heureDebut",
                            CreneauSpecialiste.class)
                    .setParameter("sid", specialisteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 🔍 Trouver les créneaux disponibles par date (optionnel)
    public List<CreneauSpecialiste> findDisponiblesByDate(LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM CreneauSpecialiste c WHERE c.dateDisponibilite = :date AND c.disponible = true ORDER BY c.heureDebut",
                            CreneauSpecialiste.class)
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 🔍 Trouver un créneau précis par son ID
    public CreneauSpecialiste findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(CreneauSpecialiste.class, id);
        } finally {
            em.close();
        }
    }
}
