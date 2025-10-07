package org.example.projet.dao;

import org.example.projet.model.Consultation;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;

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
}
