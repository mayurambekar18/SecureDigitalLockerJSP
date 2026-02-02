package com.locker.dao;

import com.locker.entity.User;
import com.locker.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.Query;

public class UserDAO {

    public boolean register(User user) {
        Transaction tx = null;
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();
            s.save(user);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace(); // ✅ NOW YOU WILL SEE REAL ERROR IN OUTPUT
            if (tx != null) tx.rollback();
            return false;
        } finally {
            if (s != null) s.close();
        }
    }

    public User findByUsername(String username) {
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            Query q = s.createQuery("from User where username = :u");
            q.setString("u", username);
            return (User) q.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (s != null) s.close();
        }
    }

    public User findByEmail(String email) {
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            Query q = s.createQuery("from User where email = :e");
            q.setString("e", email);
            return (User) q.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (s != null) s.close();
        }
    }
}
