<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.booksurvey.bean.BookDAO" %>
<%@ page import="com.booksurvey.model.Book" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 检查登录状态
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");

    // 处理操作
    String action = request.getParameter("action");
    String message = "";
    BookDAO bookDAO = new BookDAO();

    if ("delete".equals(action)) {
        String bookcode = request.getParameter("bookcode");
        if (bookDAO.deleteBook(bookcode)) {
            message = "<div class='alert success'>删除成功！</div>";
        } else {
            message = "<div class='alert error'>删除失败！</div>";
        }
    } else if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("admin-login.jsp");
        return;
    }

    // 获取图书列表
    String category = request.getParameter("category");
    String search = request.getParameter("search");
    List<Book> books;

    if (category != null && !category.isEmpty()) {
        books = bookDAO.getBooksByCategory(category);
    } else {
        books = bookDAO.getAllBooks();
    }

    // 搜索过滤
    // 搜索过滤
    if (search != null && !search.isEmpty()) {
        List<Book> filteredBooks = new ArrayList<>();
        for (Book book : books) {
            if (book.getBookname().contains(search) ||
                    book.getBookcode().contains(search) ||
                    book.getBookauthor().contains(search)) {
                filteredBooks.add(book);
            }
        }
        books = filteredBooks;
    }

    List<String> categories = bookDAO.getAllCategories();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 1.8em;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .welcome {
            font-size: 1em;
        }

        .logout-btn {
            padding: 8px 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid white;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 0.9em;
        }

        .logout-btn:hover {
            background: white;
            color: #667eea;
        }

        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
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

        .actions-bar {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-filter {
            display: flex;
            gap: 10px;
            flex: 1;
            flex-wrap: wrap;
        }

        .search-filter input,
        .search-filter select {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95em;
        }

        .search-filter input {
            flex: 1;
            min-width: 200px;
        }

        .search-filter button {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-filter button:hover {
            background: #5568d3;
        }

        .add-btn {
            padding: 12px 30px;
            background: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: all 0.3s;
            display: inline-block;
        }

        .add-btn:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .books-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8f9fa;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .action-btns {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 6px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-edit {
            background: #007bff;
            color: white;
        }

        .btn-edit:hover {
            background: #0056b3;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 1.2em;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            text-align: center;
        }

        .stat-card .number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin: 10px 0;
        }

        .stat-card .label {
            color: #666;
            font-size: 1em;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .nav-links a {
            padding: 10px 20px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }

        .nav-links a:hover {
            background: #667eea;
            color: white;
        }
    </style>
    <script>
        function confirmDelete(bookcode, bookname) {
            if (confirm('确定要删除图书《' + bookname + '》吗？\n\n删除后将无法恢复！')) {
                window.location.href = 'admin-manage.jsp?action=delete&bookcode=' + encodeURIComponent(bookcode);
            }
        }
    </script>
</head>
<body>
<div class="header">
    <h1>📚 图书管理系统</h1>
    <div class="header-right">
        <span class="welcome">欢迎，<strong><%= adminName %></strong></span>
        <a href="admin-manage.jsp?action=logout" class="logout-btn">退出登录</a>
    </div>
</div>

<div class="container">
    <%= message %>

    <div class="nav-links">
        <a href="vote.jsp" target="_blank">📊 查看投票页面</a>
        <a href="result.jsp" target="_blank">📈 查看统计结果</a>
    </div>

    <div class="stats">
        <div class="stat-card">
            <div class="label">📚 图书总数</div>
            <div class="number"><%= bookDAO.getAllBooks().size() %></div>
        </div>
        <div class="stat-card">
            <div class="label">📖 图书类别</div>
            <div class="number"><%= categories.size() %></div>
        </div>
        <div class="stat-card">
            <div class="label">🔍 当前显示</div>
            <div class="number"><%= books.size() %></div>
        </div>
    </div>

    <div class="actions-bar">
        <form method="get" class="search-filter">
            <input type="text" name="search" placeholder="搜索图书名称、编号或作者..."
                   value="<%= search != null ? search : "" %>">
            <select name="category">
                <option value="">全部类别</option>
                <% for (String cat : categories) { %>
                <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>>
                    <%= cat %>
                </option>
                <% } %>
            </select>
            <button type="submit">搜索</button>
        </form>
        <a href="admin-add-book.jsp" class="add-btn">➕ 添加图书</a>
    </div>

    <div class="books-table">
        <% if (books.isEmpty()) { %>
        <div class="no-data">暂无图书数据</div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>编号</th>
                <th>书名</th>
                <th>作者</th>
                <th>价格</th>
                <th>库存</th>
                <th>类别</th>
                <th>出版日期</th>
                <th>投票数</th>
                <th style="width: 150px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <% for (Book book : books) { %>
            <tr>
                <td><strong><%= book.getBookcode() %></strong></td>
                <td><%= book.getBookname() %></td>
                <td><%= book.getBookauthor() %></td>
                <td>¥<%= String.format("%.2f", book.getBookprice()) %></td>
                <td><%= book.getBookcount() %></td>
                <td><%= book.getBooktablecol() %></td>
                <td><%= book.getBookdate() %></td>
                <td><span style="color: #667eea; font-weight: bold;"><%= book.getVoteCount() %> 票</span></td>
                <td>
                    <div class="action-btns">
                        <a href="admin-edit-book.jsp?bookcode=<%= book.getBookcode() %>"
                           class="btn btn-edit">编辑</a>
                        <button onclick="confirmDelete('<%= book.getBookcode() %>', '<%= book.getBookname() %>')"
                                class="btn btn-delete">删除</button>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>