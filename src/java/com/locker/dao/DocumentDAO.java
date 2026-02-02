package com.locker.dao;

import com.locker.entity.Document;
import com.locker.util.HibernateUtil;
import java.util.Collections;
import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class DocumentDAO {

    public boolean save(Document d) {
        Transaction tx = null;
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();
            s.save(d);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (tx != null) tx.rollback();
            return false;
        } finally {
            if (s != null) s.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Document> listByUser(int uid) {
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();

            // ✅ ASC => 1 then 2 then 3 (oldest on TOP)
            Query q = s.createQuery("from Document where userId = :u order by docId asc");
            q.setInteger("u", uid);

            return (List<Document>) q.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            if (s != null) s.close();
        }
    }

    public Document findById(int id) {
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            return (Document) s.get(Document.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (s != null) s.close();
        }
    }

    // ✅ DELETE (only if doc belongs to that user)
public boolean deleteById(int docId, int userId) {
    Transaction tx = null;
    Session s = null;
    try {
        s = HibernateUtil.getSessionFactory().openSession();
        tx = s.beginTransaction();

        Query q = s.createQuery("delete from Document where docId = :d and userId = :u");
        q.setInteger("d", docId);
        q.setInteger("u", userId);

        int rows = q.executeUpdate();
        tx.commit();
        return rows > 0;

    } catch (Exception e) {
        e.printStackTrace();
        if (tx != null) tx.rollback();
        return false;
    } finally {
        if (s != null) s.close();
    }
}
}
