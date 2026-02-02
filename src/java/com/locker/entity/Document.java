package com.locker.entity;

import javax.persistence.*;

@Entity
@Table(name="DOCUMENTS")
public class Document {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="DOC_ID")
    private int docId;

    @Column(name="USER_ID", nullable=false)
    private int userId;

    @Column(name="DOC_NAME", nullable=false)
    private String docName;

    @Lob
    @Column(name="ENCRYPTED_DATA", nullable=false)
    private String encryptedData;

    @Column(name="FILE_HASH", nullable=false, length=64)
    private String fileHash;

    public int getDocId() { return docId; }
    public void setDocId(int docId) { this.docId = docId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDocName() { return docName; }
    public void setDocName(String docName) { this.docName = docName; }

    public String getEncryptedData() { return encryptedData; }
    public void setEncryptedData(String encryptedData) { this.encryptedData = encryptedData; }

    public String getFileHash() { return fileHash; }
    public void setFileHash(String fileHash) { this.fileHash = fileHash; }
}
