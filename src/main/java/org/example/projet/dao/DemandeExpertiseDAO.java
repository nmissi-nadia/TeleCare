package org.example.projet.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import org.example.projet.model.Consultation;
import org.example.projet.model.DemandeExpertise;
import org.example.projet.util.JPAUtil;

import java.util.List;

public class DemandeExpertiseDAO {

    public void ajouter(DemandeExpertise demande) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(demande);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(DemandeExpertise demande) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(demande);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public DemandeExpertise findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(DemandeExpertise.class, id);
        } finally {
            em.close();
        }
    }

    public DemandeExpertise findByConsultation(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d WHERE d.consultation = :consultation",
                            DemandeExpertise.class)
                    .setParameter("consultation", consultation)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findByStatut(String statut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d WHERE d.statut = :statut ORDER BY d.dateCreation DESC",
                            DemandeExpertise.class)
                    .setParameter("statut", statut)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialite(String specialite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d WHERE d.specialiteDemandee = :specialite AND d.statut = 'EN_ATTENTE'",
                            DemandeExpertise.class)
                    .setParameter("specialite", specialite)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
