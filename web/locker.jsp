<%@page import="java.util.List"%>
<%@page import="com.locker.dao.DocumentDAO"%>
<%@page import="com.locker.entity.Document"%>
<%@page import="com.locker.util.CryptoUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Locker</title>
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            min-height:100vh;
            background: radial-gradient(circle at top, #111827 0%, #060913 55%, #000 100%);
            color:#e5e7eb;
        }

        .nav{
            position:sticky; top:0; z-index:10;
            background: rgba(0,0,0,0.45);
            border-bottom: 1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        .nav-inner{
            width:1100px; max-width:95%;
            margin:0 auto;
            padding:14px 0;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
        }
        .brand{
            display:flex; align-items:center; gap:10px;
            font-weight:900; letter-spacing:.4px;
        }
        .logo{
            width:42px; height:42px;
            border-radius:12px;
            display:flex; align-items:center; justify-content:center;
            background: linear-gradient(135deg,#22c55e,#2d89ef);
            color:#0b1220;
            font-weight:900;
        }
        .right{
            display:flex; align-items:center; gap:10px; flex-wrap:wrap;
        }
        .chip{
            padding:8px 12px;
            border-radius:999px;
            background: rgba(255,255,255,0.08);
            border:1px solid rgba(255,255,255,0.12);
            color:#e5e7eb;
            font-weight:800;
            font-size:13px;
        }
        .logout{
            padding:10px 14px;
            border-radius:12px;
            text-decoration:none;
            font-weight:900;
            background: rgba(239,68,68,0.18);
            border:1px solid rgba(239,68,68,0.28);
            color:#fecaca;
            transition:.2s;
        }
        .logout:hover{transform:translateY(-1px); opacity:.95;}

        .wrap{
            width:1100px; max-width:95%;
            margin:22px auto 40px;
        }

        .grid{
            display:grid;
            grid-template-columns: 1.1fr .9fr;
            gap:16px;
        }
        @media(max-width:900px){
            .grid{grid-template-columns:1fr;}
        }

        .card{
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.10);
            border-radius:18px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding:18px;
        }

        h2,h3{margin:0 0 10px;}
        .muted{color:#9ca3af; font-size:13px; margin:0 0 10px; line-height:1.5;}

        label{
            display:block;
            margin-top:12px;
            font-weight:900;
            font-size:13px;
            color:#e2e8f0;
        }
        input,textarea{
            width:100%;
            padding:12px;
            margin-top:8px;
            border-radius:12px;
            border:1px solid rgba(255,255,255,0.14);
            background: rgba(255,255,255,0.06);
            color:#fff;
            outline:none;
        }
        textarea{resize:vertical;}

        .btn{
            display:inline-block;
            padding:12px 16px;
            border-radius:12px;
            border:1px solid transparent;
            font-weight:900;
            cursor:pointer;
            background: linear-gradient(135deg,#2d89ef,#4f46e5);
            color:#fff;
            box-shadow: 0 10px 24px rgba(45,137,239,.22);
            transition:.2s;
        }
        .btn:hover{transform:translateY(-1px); opacity:.96;}

        .msg{
            margin-top:12px;
            padding:12px;
            border-radius:14px;
            border:1px solid transparent;
            font-weight:800;
            font-size:13px;
        }
        .ok{
            background: rgba(34,197,94,0.14);
            border-color: rgba(34,197,94,0.24);
            color:#bbf7d0;
        }
        .err{
            background: rgba(239,68,68,0.14);
            border-color: rgba(239,68,68,0.24);
            color:#fecaca;
        }

        .viewbox{
            margin-top:12px;
            padding:14px;
            border-radius:14px;
            border:1px solid rgba(255,255,255,0.10);
            background: rgba(255,255,255,0.05);
        }
        pre{
            margin:0;
            white-space:pre-wrap;
            color:#e5e7eb;
            font-family: Consolas, monospace;
            font-size:13px;
        }

        table{
            width:100%;
            border-collapse:separate;
            border-spacing:0;
            overflow:hidden;
            border-radius:16px;
            border:1px solid rgba(255,255,255,0.10);
            margin-top:10px;
            background: rgba(255,255,255,0.04);
        }
        th,td{
            padding:12px;
            border-bottom:1px solid rgba(255,255,255,0.08);
            text-align:left;
            font-size:13px;
        }
        th{
            background: rgba(255,255,255,0.06);
            font-weight:900;
            color:#e5e7eb;
        }
        tr:last-child td{border-bottom:none;}

        .actions a{
            color:#93c5fd;
            text-decoration:none;
            font-weight:900;
            margin-right:10px;
        }
        .actions a:hover{text-decoration:underline;}

        .del{ color:#fecaca !important; }
    </style>
</head>
<body>

<%
Integer uidObj = (Integer) session.getAttribute("uid");
String uname = (String) session.getAttribute("uname");
if(uidObj == null){
    response.sendRedirect("login.jsp");
    return;
}
int uid = uidObj;

String msg="", err="", viewText="", verifyMsg="";
String m = request.getParameter("m");
if("del".equals(m))   msg = "Document deleted ✅";
if("saved".equals(m)) msg = "Document saved securely ✅";

DocumentDAO ddao = new DocumentDAO();

/* ===================== SAVE (PRG FIX) ===================== */
if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("saveDoc") != null){

    // ✅ Vigenere on doc name (Polyalphabetic)
    String docNamePlain = request.getParameter("docName");
    String docName = CryptoUtil.vigenereEncrypt(docNamePlain, "LOCKERKEY");

    String plain = request.getParameter("content");

    try{
        String encrypted = CryptoUtil.aesEncrypt(plain); // AES
        String hash = CryptoUtil.sha256(plain);          // SHA-256

        Document d = new Document();
        d.setUserId(uid);
        d.setDocName(docName);           // encrypted name stored in DB
        d.setEncryptedData(encrypted);
        d.setFileHash(hash);

        boolean ok = ddao.save(d);
        if(ok){
            // ✅ PRG: refresh pe duplicate save nahi hoga
            response.sendRedirect("locker.jsp?m=saved");
            return;
        }else{
            err = "Failed to save document ❌ (check Output)";
        }
    }catch(Exception ex){
        err = "ERROR: " + ex.getMessage();
        ex.printStackTrace();
    }
}

/* ===================== DELETE (PRG FIX) ===================== */
String delIdStr = request.getParameter("delId");
if(delIdStr != null){
    try{
        int did = Integer.parseInt(delIdStr);
        boolean ok = ddao.deleteById(did, uid);

        if(ok){
            response.sendRedirect("locker.jsp?m=del");
            return;
        }else{
            err = "Delete failed ❌";
        }
    }catch(Exception ex){
        err = "ERROR: " + ex.getMessage();
        ex.printStackTrace();
    }
}

/* ===================== VIEW ===================== */
String viewIdStr = request.getParameter("viewId");
if(viewIdStr != null){
    try{
        int did = Integer.parseInt(viewIdStr);
        Document d = ddao.findById(did);
        if(d == null || d.getUserId()!=uid){
            err = "Invalid document access!";
        }else{
            String decrypted = CryptoUtil.aesDecrypt(d.getEncryptedData());
            String showName  = CryptoUtil.vigenereDecrypt(d.getDocName(), "LOCKERKEY");
            viewText = "Document: " + showName + "\n\n" + decrypted;
        }
    }catch(Exception ex){
        err = "ERROR: " + ex.getMessage();
        ex.printStackTrace();
    }
}

/* ===================== VERIFY ===================== */
String verifyIdStr = request.getParameter("verifyId");
if(verifyIdStr != null){
    try{
        int did = Integer.parseInt(verifyIdStr);
        Document d = ddao.findById(did);
        if(d == null || d.getUserId()!=uid){
            err = "Invalid document access!";
        }else{
            String decrypted = CryptoUtil.aesDecrypt(d.getEncryptedData());
            String newHash = CryptoUtil.sha256(decrypted);
            if(newHash.equals(d.getFileHash())){
                verifyMsg = "✅ Integrity OK: Hash matches (No tampering)";
            }else{
                verifyMsg = "❌ Tampering Detected: Hash mismatch!";
            }
        }
    }catch(Exception ex){
        err = "ERROR: " + ex.getMessage();
        ex.printStackTrace();
    }
}

List<Document> docs = ddao.listByUser(uid);
%>

<div class="nav">
    <div class="nav-inner">
        <div class="brand">
            <div class="logo">DL</div>
            <div>SECURE LOCKER</div>
        </div>
        <div class="right">
            <div class="chip">Welcome, <%=uname%> ✅</div>
            <a class="logout" href="logout.jsp">Logout</a>
        </div>
    </div>
</div>

<div class="wrap">

    <div class="grid">

        <div class="card">
            <h2>Save New Document</h2>

            <form method="post">
                <label>Document Name</label>
                <input type="text" name="docName" placeholder="Aadhaar Notes / Marks Sheet Text" required />

                <label>Document Content (Text)</label>
                <textarea name="content" rows="7" placeholder="Type your document content here..." required></textarea>

                <input type="hidden" name="saveDoc" value="1"/>
                <button class="btn" type="submit">Save Securely</button>
            </form>

            <% if(msg.length()>0){ %><div class="msg ok"><%=msg%></div><% } %>
            <% if(err.length()>0){ %><div class="msg err"><%=err%></div><% } %>
            <% if(verifyMsg.length()>0){ %><div class="msg ok"><%=verifyMsg%></div><% } %>
        </div>

        <div class="card">
            <h3>Decrypted View</h3>
            <p class="muted">Click “View” from table to see decrypted content here.</p>

            <div class="viewbox">
                <% if(viewText.length()>0){ %>
                    <pre><%=viewText%></pre>
                <% } else { %>
                    <pre>No document selected.</pre>
                <% } %>
            </div>
        </div>

    </div>

    <div class="card" style="margin-top:16px;">
        <h3>Your Saved Documents</h3>
        <p class="muted">All documents stored as encrypted data in database.</p>

        <table>
            <tr>
                <th style="width:90px;">Sr No</th>
                <th>Name</th>
                <th style="width:280px;">Actions</th>
            </tr>

            <%
int sr = 1;
for(Document d : docs){
%>
<tr>
    <td><%=sr++%></td>
    <td><%= CryptoUtil.vigenereDecrypt(d.getDocName(),"LOCKERKEY") %></td>
    <td class="actions">
        <a href="locker.jsp?viewId=<%=d.getDocId()%>">View</a>
        <a href="locker.jsp?verifyId=<%=d.getDocId()%>">Verify</a>
        <a class="del" href="locker.jsp?delId=<%=d.getDocId()%>"
           onclick="return confirm('Delete this document?');">Delete</a>
    </td>
</tr>
<%
}
%>
        </table>
    </div>

</div>

</body>
</html>
