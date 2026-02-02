<%@page import="com.locker.dao.UserDAO"%>
<%@page import="com.locker.entity.User"%>
<%@page import="com.locker.util.CryptoUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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

            /* ✅ ORANGE THEME BG */
            background: radial-gradient(circle at top, #fb923c 0%, #3b1a05 55%, #120803 100%);
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

            /* ✅ orange logo */
            background:linear-gradient(135deg,#fb923c,#f97316);
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

            /* ✅ orange button */
            background:linear-gradient(135deg,#fb923c,#f97316);
            box-shadow:0 10px 24px rgba(249,115,22,.28);
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
        .err{
            background:rgba(239,68,68,.18);
            border:1px solid rgba(239,68,68,.30);
            color:#fee2e2;
        }
        .ok{
            background:rgba(34,197,94,.18);
            border:1px solid rgba(34,197,94,.30);
            color:#dcfce7;
        }

        .link{
            margin-top:14px;
            text-align:center;
            font-weight:800;
        }
        .link a{
            color:#ffedd5; /* light orange */
            text-decoration:none;
        }
        .link a:hover{text-decoration:underline;}
    </style>
</head>
<body>

<div class="box">
    <div class="logo">DL</div>
    <h2>Login</h2>
    <div class="sub">Access your Secure Digital Locker</div>

<%
String msg="", err="";
if("POST".equalsIgnoreCase(request.getMethod())){
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    UserDAO dao = new UserDAO();
    User u = dao.findByUsername(username);

    if(u==null){
        err = "User not found!";
    }else if(!u.getPasswordHash().equals(CryptoUtil.sha256(password))){
        err = "Wrong password!";
    }else{
        session.setAttribute("uid", u.getUserId());
        session.setAttribute("uname", u.getUsername());
        response.sendRedirect("locker.jsp");
        return;
    }
}
%>

    <form method="post">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter username" required />

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required />

        <button class="btn" type="submit">Login</button>
    </form>

    <% if(err.length()>0){ %>
      <div class="msg err"><%=err%></div>
    <% } %>

    <% if(msg.length()>0){ %>
      <div class="msg ok"><%=msg%></div>
    <% } %>

    <div class="link">
        New user? <a href="register.jsp">Go to Register</a>
    </div>
</div>

</body>
</html>
