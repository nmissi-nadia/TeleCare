package org.example.projet.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import org.example.projet.model.CreneauSpecialiste;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.util.JPAUtil;

import java.time.LocalDate;
import java.util.List;

public class CreneauSpecialisteDAO {

    // ✅ Ajouter un créneau
    public void ajouter(CreneauSpecialiste creneau) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(creneau);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de l’ajout du créneau : " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // ✅ Mettre à jour un créneau
    public void update(CreneauSpecialiste creneau) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(creneau);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la mise à jour du créneau : " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // ✅ Supprimer un créneau
    public void supprimer(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            CreneauSpecialiste c = em.find(CreneauSpecialiste.class, id);
            if (c != null) {
                em.remove(c);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la suppression du créneau : " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // ✅ Trouver un créneau par ID
    public CreneauSpecialiste findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(CreneauSpecialiste.class, id);
        } finally {
            em.close();
        }
    }

    // ✅ Trouver les créneaux d’un spécialiste
    public List<CreneauSpecialiste> findBySpecialiste(MedecinSpecialiste specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<CreneauSpecialiste> query = em.createQuery(
                    "SELECT c FROM CreneauSpecialiste c WHERE c.specialiste = :spec ORDER BY c.dateDisponibilite, c.heureDebut",
                    CreneauSpecialiste.class
            );
            query.setParameter("spec", specialiste);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ Trouver les créneaux disponibles par spécialité
    public List<CreneauSpecialiste> findDisponiblesBySpecialite(String specialite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<CreneauSpecialiste> query = em.createQuery(
                    "SELECT c FROM CreneauSpecialiste c " +
                    "WHERE c.specialiste.specialite = :specialite " +
                    "AND c.disponible = true " +
                    "ORDER BY c.dateDisponibilite, c.heureDebut",
                    CreneauSpecialiste.class
            );
            query.setParameter("specialite", specialite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ Trouver les créneaux disponibles à une date précise
    public List<CreneauSpecialiste> findDisponiblesByDate(LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<CreneauSpecialiste> query = em.createQuery(
                    "SELECT c FROM CreneauSpecialiste c WHERE c.dateDisponibilite = :date AND c.disponible = true",
                    CreneauSpecialiste.class
            );
            query.setParameter("date", date);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ✅ Mettre à jour la disponibilité (lorsqu’un créneau est réservé)
    public void updateDisponibilite(Long id, boolean disponible) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            CreneauSpecialiste c = em.find(CreneauSpecialiste.class, id);
            if (c != null) {
                c.setDisponible(disponible);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la mise à jour de la disponibilité : " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
