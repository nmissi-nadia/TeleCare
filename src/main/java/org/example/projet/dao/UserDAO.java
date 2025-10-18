package org.example.projet.dao;


import org.example.projet.model.User;
import org.example.projet.model.MedecinSpecialiste;
import org.example.projet.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;

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
    //function findById
    public User findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }
    public List<User> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
        } finally {
            em.close();
        }
    }
    public List<MedecinSpecialiste> findAllSpe() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM MedecinSpecialiste u", MedecinSpecialiste.class).getResultList();
        } finally {
            em.close();
        }
    }
    public MedecinSpecialiste findByIdSpe(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(MedecinSpecialiste.class, id);
        } finally {
            em.close();
        }
    }

}
