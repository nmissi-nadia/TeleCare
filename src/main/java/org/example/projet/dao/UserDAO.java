package org.example.projet.dao;


import org.example.projet.model.User;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

public class UserDAO {
    public User findByLogin(String login) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.login = :login", User.class)
                    .setParameter("login", login)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public void save(User u) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(u);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
