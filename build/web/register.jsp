<%@page import="com.locker.dao.UserDAO"%>
<%@page import="com.locker.entity.User"%>
<%@page import="com.locker.util.CryptoUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            padding:40px 16px;

            /* ✅ PURPLE THEME BG (not blue) */
            background: radial-gradient(circle at top, #a855f7 0%, #2b0a3d 55%, #07020a 100%);
        }

        .box{
            width:520px;
            max-width:95%;
            padding:28px 28px 22px;
            border-radius:18px;
            text-align:center;
            color:#fff;

            background:rgba(255,255,255,0.12);
            border:1px solid rgba(255,255,255,0.20);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            box-shadow:0 22px 60px rgba(0,0,0,0.45);
        }

        .logo{
            width:64px;height:64px;
            border-radius:16px;
            margin:0 auto 12px;
            display:flex;align-items:center;justify-content:center;
            font-weight:900;
            background:linear-gradient(135deg,#a855f7,#ec4899);
        }

        h2{margin:8px 0 6px;font-size:28px;font-weight:900;}
        .sub{margin:0 0 18px;color:rgba(255,255,255,.85);font-size:13px;}

        label{
            display:block;
            text-align:left;
            margin-top:12px;
            font-weight:800;
            color:rgba(255,255,255,.90);
            font-size:13px;
        }

        input{
            width:100%;
            padding:12px 12px;
            margin-top:8px;
            border-radius:12px;
            border:1px solid rgba(255,255,255,0.22);
            background:rgba(255,255,255,0.10);
            color:#fff;
            outline:none;
        }
        input::placeholder{color:rgba(255,255,255,.65);}

        .btn{
            width:100%;
            padding:14px 16px;
            margin-top:18px;
            border-radius:12px;
            border:1px solid transparent;
            font-weight:900;
            font-size:16px;
            cursor:pointer;
            color:#fff;

            /* ✅ Purple-Pink button */
            background:linear-gradient(135deg,#a855f7,#ec4899);
            box-shadow:0 10px 24px rgba(236,72,153,.25);
            transition:.2s;
        }
        .btn:hover{transform:translateY(-1px);opacity:.97;}

        .msg{
            margin-top:14px;
            padding:12px;
            border-radius:12px;
            text-align:left;
            font-weight:700;
            font-size:13px;
        }
        .ok{
            background:rgba(34,197,94,.18);
            border:1px solid rgba(34,197,94,.30);
            color:#dcfce7;
        }
        .err{
            background:rgba(239,68,68,.18);
            border:1px solid rgba(239,68,68,.30);
            color:#fee2e2;
        }

        .link{
            margin-top:14px;
            text-align:center;
            font-weight:800;
        }
        .link a{
            color:#fbcfe8;
            text-decoration:none;
        }
        .link a:hover{text-decoration:underline;}

        .row2{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:12px;
        }
        @media(max-width:520px){
            .row2{grid-template-columns:1fr;}
        }
    </style>
</head>
<body>

<div class="box">
    <div class="logo">DL</div>
    <h2>Register</h2>
    <div class="sub">Create your Secure Digital Locker account</div>

<%
String msg = "";
String err = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String fullName = request.getParameter("fullName");
    String email    = request.getParameter("email");
    String phone    = request.getParameter("phone");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    UserDAO dao = new UserDAO();

    try {
        if (dao.findByUsername(username) != null) {
            err = "Username already exists!";
        } else if (dao.findByEmail(email) != null) {
            err = "Email already exists!";
        } else {
            User u = new User();
            u.setFullName(fullName);
            u.setEmail(email);
            u.setPhone(phone);
            u.setUsername(username);
            u.setPasswordHash(CryptoUtil.sha256(password));

            boolean ok = dao.register(u);
            if (ok) msg = "Registered Successfully!";
            else err = "Registration Failed! (Check Output for error)";
        }
    } catch (Exception ex) {
        err = "ERROR: " + ex.getMessage();
        ex.printStackTrace();
    }
}
%>

    <form method="post">
        <label>Full Name</label>
        <input type="text" name="fullName" placeholder="Enter full name" required />

        <div class="row2">
            <div>
                <label>Email</label>
                <input type="email" name="email" placeholder="Enter email" required />
            </div>
            <div>
                <label>Phone</label>
                <input type="text" name="phone" pattern="[0-9]{10}" title="Enter 10 digit phone" placeholder="10 digit phone" required />
            </div>
        </div>

        <label>Username</label>
        <input type="text" name="username" placeholder="Create username" required />

        <label>Password</label>
        <input type="password" name="password" placeholder="Create password" required />

        <button class="btn" type="submit">Create Account</button>
    </form>

    <% if(msg.length()>0){ %>
      <div class="msg ok"><%=msg%></div>
    <% } %>

    <% if(err.length()>0){ %>
      <div class="msg err"><%=err%></div>
    <% } %>

    <div class="link">
      Already have an account? <a href="login.jsp">Go to Login</a>
    </div>
</div>

</body>
</html>
