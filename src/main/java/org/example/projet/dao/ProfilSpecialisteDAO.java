package org.example.projet.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import org.example.projet.model.ProfilSpecialiste;
import org.example.projet.model.User;
import org.example.projet.util.JPAUtil;

import java.util.List;

public class ProfilSpecialisteDAO {

    public void ajouter(ProfilSpecialiste profil) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(profil);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void update(ProfilSpecialiste profil) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(profil);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public ProfilSpecialiste findBySpecialiste(User specialiste) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM ProfilSpecialiste p WHERE p.specialiste = :specialiste",
                            ProfilSpecialiste.class)
                    .setParameter("specialiste", specialiste)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<ProfilSpecialiste> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM ProfilSpecialiste p", ProfilSpecialiste.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
