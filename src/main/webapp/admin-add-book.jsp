<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.booksurvey.bean.BookDAO" %>
<%@ page import="com.booksurvey.model.Book" %>
<%@ page import="java.util.List" %>

<%
    // 检查登录状态
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String message = "";
    BookDAO bookDAO = new BookDAO();

    // 处理表单提交
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String bookcode = request.getParameter("bookcode");
        String bookname = request.getParameter("bookname");
        String bookauthor = request.getParameter("bookauthor");
        String bookpriceStr = request.getParameter("bookprice");
        String bookcountStr = request.getParameter("bookcount");
        String bookdate = request.getParameter("bookdate");
        String booktablecol = request.getParameter("booktablecol");

        // 验证
        if (bookcode == null || bookcode.trim().isEmpty()) {
            message = "<div class='alert error'>图书编号不能为空！</div>";
        } else if (bookDAO.isBookCodeExists(bookcode)) {
            message = "<div class='alert error'>图书编号已存在！</div>";
        } else if (bookname == null || bookname.trim().isEmpty()) {
            message = "<div class='alert error'>图书名称不能为空！</div>";
        } else {
            try {
                double bookprice = Double.parseDouble(bookpriceStr);
                int bookcount = Integer.parseInt(bookcountStr);

                Book book = new Book();
                book.setBookcode(bookcode);
                book.setBookname(bookname);
                book.setBookauthor(bookauthor);
                book.setBookprice(bookprice);
                book.setBookcount(bookcount);
                book.setBookdate(bookdate);
                book.setBooktablecol(booktablecol);

                if (bookDAO.addBook(book)) {
                    response.sendRedirect("admin-manage.jsp");
                    return;
                } else {
                    message = "<div class='alert error'>添加失败，请重试！</div>";
                }
            } catch (NumberFormatException e) {
                message = "<div class='alert error'>价格和库存必须是数字！</div>";
            }
        }
    }

    List<String> categories = bookDAO.getAllCategories();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加图书</title>
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
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #333;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
        }

        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            padding: 40px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .input-hint {
            font-size: 0.85em;
            color: #999;
            margin-top: 5px;
        }

        .custom-category {
            display: none;
            margin-top: 10px;
        }

        .custom-category.show {
            display: block;
        }
    </style>
    <script>
        function toggleCustomCategory() {
            var select = document.getElementById('category-select');
            var customInput = document.getElementById('custom-category');
            var hiddenInput = document.getElementById('booktablecol');

            if (select.value === 'custom') {
                customInput.classList.add('show');
                hiddenInput.value = '';
            } else {
                customInput.classList.remove('show');
                hiddenInput.value = select.value;
            }
        }

        function updateCategory() {
            var customValue = document.getElementById('custom-category-input').value;
            document.getElementById('booktablecol').value = customValue;
        }

        function validateForm() {
            var bookcode = document.getElementById('bookcode').value.trim();
            var bookname = document.getElementById('bookname').value.trim();

            if (bookcode === '') {
                alert('请输入图书编号！');
                return false;
            }

            if (bookname === '') {
                alert('请输入图书名称！');
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>➕ 添加新图书</h1>
        <p>填写以下信息以添加图书到系统</p>
    </div>

    <div class="form-card">
        <%= message %>

        <form method="post" action="admin-add-book.jsp" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="add">
            <input type="hidden" id="booktablecol" name="booktablecol" value="">

            <div class="form-row">
                <div class="form-group">
                    <label for="bookcode">
                        图书编号 <span class="required">*</span>
                    </label>
                    <input type="text" id="bookcode" name="bookcode" required
                           placeholder="例如：BK008">
                    <div class="input-hint">唯一标识，不可重复</div>
                </div>

                <div class="form-group">
                    <label for="bookname">
                        图书名称 <span class="required">*</span>
                    </label>
                    <input type="text" id="bookname" name="bookname" required
                           placeholder="请输入图书名称">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="bookauthor">作者</label>
                    <input type="text" id="bookauthor" name="bookauthor"
                           placeholder="请输入作者名称">
                </div>

                <div class="form-group">
                    <label for="bookprice">价格（元）</label>
                    <input type="number" id="bookprice" name="bookprice"
                           step="0.01" min="0" value="0" placeholder="0.00">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="bookcount">库存数量</label>
                    <input type="number" id="bookcount" name="bookcount"
                           min="0" value="0" placeholder="0">
                </div>

                <div class="form-group">
                    <label for="bookdate">出版日期</label>
                    <input type="date" id="bookdate" name="bookdate">
                </div>
            </div>

            <div class="form-group full-width">
                <label for="category-select">图书类别</label>
                <select id="category-select" onchange="toggleCustomCategory()">
                    <option value="">请选择类别</option>
                    <% for (String cat : categories) { %>
                    <option value="<%= cat %>"><%= cat %></option>
                    <% } %>
                    <option value="custom">+ 自定义类别</option>
                </select>

                <div id="custom-category" class="custom-category">
                    <input type="text" id="custom-category-input"
                           placeholder="输入新类别名称"
                           onchange="updateCategory()">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">✓ 保存图书</button>
                <button type="button" class="btn btn-secondary"
                        onclick="window.location.href='admin-manage.jsp'">
                    ✕ 取消
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>