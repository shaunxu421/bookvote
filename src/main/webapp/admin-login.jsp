<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="adminBean" class="com.booksurvey.bean.AdminBean" scope="page"/>

<%
    String action = request.getParameter("action");
    String message = "";

    if ("login".equals(action)) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null && !username.isEmpty() && !password.isEmpty()) {
            boolean loginSuccess = adminBean.login(username, password);

            if (loginSuccess) {
                // 登录成功，保存session
                session.setAttribute("adminUsername", username);
                session.setAttribute("adminName", adminBean.getAdminName(username));
                response.sendRedirect("admin-manage.jsp");
                return;
            } else {
                message = "<div class='alert error'>用户名或密码错误！</div>";
            }
        } else {
            message = "<div class='alert error'>请输入用户名和密码！</div>";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 50px 40px;
            width: 100%;
            max-width: 450px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-header h1 {
            color: #333;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #666;
            font-size: 1em;
        }

        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-size: 0.95em;
        }

        .alert.error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 0.95em;
        }

        .form-group input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 0.95em;
            transition: color 0.3s;
        }

        .back-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .default-info {
            background: #fff8dc;
            border: 1px solid #ffd700;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 25px;
            font-size: 0.9em;
            color: #856404;
        }

        .default-info strong {
            display: block;
            margin-bottom: 8px;
            color: #664d03;
        }

        .icon {
            font-size: 3em;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <div class="icon">🔐</div>
        <h1>管理员登录</h1>
        <p>图书管理系统</p>
    </div>

    <%= message %>

    <div class="default-info">
        <strong>💡 默认登录信息</strong>
        用户名：admin<br>
        密码：admin
    </div>

    <form method="post" action="admin-login.jsp">
        <input type="hidden" name="action" value="login">

        <div class="form-group">
            <label for="username">👤 用户名</label>
            <input type="text" id="username" name="username" required
                   placeholder="请输入用户名" autofocus>
        </div>

        <div class="form-group">
            <label for="password">🔑 密码</label>
            <input type="password" id="password" name="password" required
                   placeholder="请输入密码">
        </div>

        <button type="submit" class="login-btn">登录</button>
    </form>

    <div class="back-link">
        <a href="vote.jsp">← 返回投票页面</a>
    </div>
</div>
</body>
</html>