package org.example.projet.dao;

import org.example.projet.model.Acte;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

public class ActeDAO {
    public void ajouter(Acte acte) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(acte);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Acte> listerTous() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Acte a ORDER BY a.categorie, a.libelle", Acte.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Acte findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Acte.class, id);
        } finally {
            em.close();
        }
    }

    public List<Acte> findByCategorie(String categorie) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Acte a WHERE a.categorie = :categorie ORDER BY a.libelle", Acte.class)
                    .setParameter("categorie", categorie)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}