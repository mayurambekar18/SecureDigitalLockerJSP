<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Secure Digital Locker</title>
  <style>
    *{box-sizing:border-box;}
    body{
      margin:0;
      font-family:Arial,sans-serif;
      min-height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;

      /* ✅ BLUE BACKGROUND */
      background: radial-gradient(circle at top, #2d6bff 0%, #0b1b3a 55%, #050a14 100%);
    }

    .card{
      width:560px;
      max-width:92%;
      padding:34px 34px 30px;
      border-radius:18px;

      background:rgba(255,255,255,0.12);
      border:1px solid rgba(255,255,255,0.20);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      box-shadow:0 22px 60px rgba(0,0,0,0.45);

      text-align:center;
      color:#fff;
    }

    .logo{
      width:64px;height:64px;
      border-radius:16px;
      margin:0 auto 14px;
      display:flex;align-items:center;justify-content:center;
      font-weight:900;
      background:linear-gradient(135deg,#2d89ef,#4f46e5);
    }

    h2{margin:8px 0 6px;font-size:32px;font-weight:900;}
    p{margin:0 0 22px;color:rgba(255,255,255,.85);font-size:14px;}

    .btn{
      display:block;width:100%;
      padding:14px 16px;
      margin:14px 0;
      border-radius:12px;
      text-decoration:none;
      font-weight:900;font-size:18px;
      border:1px solid transparent;
      transition:.2s;
    }
    .btn.login{
      background:linear-gradient(135deg,#2d89ef,#1d4ed8);
      color:#fff;
      box-shadow:0 10px 24px rgba(45,137,239,.25);
    }
    .btn.register{
      background:rgba(255,255,255,0.14);
      border-color:rgba(255,255,255,0.22);
      color:#fff;
    }
    .btn:hover{transform:translateY(-1px);opacity:.97;}
  </style>
</head>
<body>

<div class="card">
  <div class="logo">DL</div>
  <h2>Secure Digital Locker</h2>
  <p>Store documents safely • Simple • Secure</p>

  <a class="btn login" href="login.jsp">🔒 Login</a>
  <a class="btn register" href="register.jsp">📝 Registration </a>
</div>

</body>
</html>
