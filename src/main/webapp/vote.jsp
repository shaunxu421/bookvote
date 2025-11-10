<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.booksurvey.bean.BookDAO" %>
<%@ page import="com.booksurvey.model.Book" %>
<jsp:useBean id="voteBean" class="com.booksurvey.bean.VoteBean" scope="page"/>

<%
    // 处理投票请求
    String action = request.getParameter("action");
    String message = "";

    if ("vote".equals(action)) {
        String bookcode = request.getParameter("bookcode");
        if (bookcode != null && !bookcode.isEmpty()) {
            boolean success = voteBean.vote(bookcode);
            if (success) {
                message = "<div class='alert success'>投票成功！</div>";
            } else {
                message = "<div class='alert error'>投票失败，请重试。</div>";
            }
        }
    }

    // 获取图书列表
    BookDAO bookDAO = new BookDAO();
    String category = request.getParameter("category");
    List<Book> books;

    if (category != null && !category.isEmpty()) {
        books = bookDAO.getBooksByCategory(category);
    } else {
        books = bookDAO.getAllBooks();
    }

    List<String> categories = bookDAO.getAllCategories();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书满意度投票</title>
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
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
            font-size: 2.5em;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
        }

        .filter-section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .filter-section label {
            font-weight: bold;
            color: #555;
        }

        .filter-section select {
            padding: 10px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: border-color 0.3s;
        }

        .filter-section select:hover {
            border-color: #667eea;
        }

        .filter-section button {
            padding: 10px 25px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            transition: background 0.3s;
        }

        .filter-section button:hover {
            background: #5568d3;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .book-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 20px;
            transition: all 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-color: #667eea;
        }

        .book-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .book-info {
            color: #666;
            line-height: 1.8;
            margin-bottom: 15px;
        }

        .book-info div {
            margin: 5px 0;
        }

        .vote-section {
            border-top: 1px solid #eee;
            padding-top: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .vote-count {
            font-size: 1.1em;
            color: #667eea;
            font-weight: bold;
        }

        .vote-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1em;
            transition: all 0.3s;
        }

        .vote-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .result-link {
            text-align: center;
            margin-top: 30px;
        }

        .result-link a {
            display: inline-block;
            padding: 15px 40px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-size: 1.1em;
            transition: all 0.3s;
        }

        .result-link a:hover {
            background: #218838;
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .no-books {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>📚 图书满意度投票</h1>
    <p class="subtitle">请为您喜欢的图书投票</p>

    <%= message %>

    <form method="get" class="filter-section">
        <label for="category">按类别筛选：</label>
        <select name="category" id="category">
            <option value="">全部类别</option>
            <% for (String cat : categories) { %>
            <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>>
                <%= cat %>
            </option>
            <% } %>
        </select>
        <button type="submit">筛选</button>
    </form>

    <% if (books.isEmpty()) { %>
    <div class="no-books">
        暂无图书数据
    </div>
    <% } else { %>
    <div class="books-grid">
        <% for (Book book : books) { %>
        <div class="book-card">
            <div class="book-title"><%= book.getBookname() %></div>
            <div class="book-info">
                <div><strong>编号：</strong><%= book.getBookcode() %></div>
                <div><strong>作者：</strong><%= book.getBookauthor() %></div>
                <div><strong>价格：</strong>¥<%= String.format("%.2f", book.getBookprice()) %></div>
                <div><strong>类别：</strong><%= book.getBooktablecol() %></div>
                <div><strong>出版日期：</strong><%= book.getBookdate() %></div>
            </div>
            <div class="vote-section">
                <span class="vote-count">❤️ <%= book.getVoteCount() %> 票</span>
                <form method="post" action="vote.jsp" style="margin: 0;">
                    <input type="hidden" name="action" value="vote">
                    <input type="hidden" name="bookcode" value="<%= book.getBookcode() %>">
                    <input type="hidden" name="category" value="<%= category != null ? category : "" %>">
                    <button type="submit" class="vote-btn">投票</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <div class="result-link">
        <a href="result.jsp">📊 查看统计结果</a>
        <a href="admin-login.jsp" style="background: #6c757d; margin-left: 15px;">🔐 管理员登录</a>
    </div>
</div>
</body>
</html>