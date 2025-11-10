<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.booksurvey.bean.BookDAO" %>
<%@ page import="com.booksurvey.model.Book" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>

<%
    BookDAO bookDAO = new BookDAO();
    List<Book> books = bookDAO.getAllBooks();

    // 按投票数排序（降序）
    Collections.sort(books, new Comparator<Book>() {
        public int compare(Book b1, Book b2) {
            return Integer.compare(b2.getVoteCount(), b1.getVoteCount());
        }
    });

    // 计算总票数
    int totalVotes = 0;
    for (Book book : books) {
        totalVotes += book.getVoteCount();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>投票统计结果</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
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

        .summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }

        .summary h2 {
            margin-bottom: 15px;
        }

        .summary-stats {
            display: flex;
            justify-content: center;
            gap: 50px;
            font-size: 1.2em;
        }

        .summary-stats div {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .summary-stats .number {
            font-size: 2em;
            font-weight: bold;
            margin-top: 10px;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .results-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .results-table th {
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }

        .results-table tbody tr {
            border-bottom: 1px solid #eee;
            transition: background 0.3s;
        }

        .results-table tbody tr:hover {
            background: #f8f9fa;
        }

        .results-table tbody tr:nth-child(even) {
            background: #fafafa;
        }

        .results-table tbody tr:nth-child(even):hover {
            background: #f0f0f0;
        }

        .results-table td {
            padding: 15px;
            color: #333;
        }

        .rank {
            font-weight: bold;
            font-size: 1.2em;
        }

        .rank-1 {
            color: #FFD700;
        }

        .rank-2 {
            color: #C0C0C0;
        }

        .rank-3 {
            color: #CD7F32;
        }

        .vote-bar {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .bar-container {
            flex: 1;
            background: #e0e0e0;
            height: 25px;
            border-radius: 12px;
            overflow: hidden;
        }

        .bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 10px;
            color: white;
            font-size: 0.9em;
            font-weight: bold;
        }

        .percentage {
            min-width: 50px;
            text-align: right;
            font-weight: bold;
            color: #667eea;
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
        }

        .back-link a {
            display: inline-block;
            padding: 15px 40px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-size: 1.1em;
            transition: all 0.3s;
        }

        .back-link a:hover {
            background: #5568d3;
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 1.3em;
        }

        .medal {
            font-size: 1.5em;
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>📊 投票统计结果</h1>
    <p class="subtitle">图书满意度调查统计</p>

    <div class="summary">
        <h2>📈 投票概览</h2>
        <div class="summary-stats">
            <div>
                <span>参与投票图书</span>
                <span class="number"><%= books.size() %></span>
            </div>
            <div>
                <span>总投票数</span>
                <span class="number"><%= totalVotes %></span>
            </div>
        </div>
    </div>

    <% if (books.isEmpty()) { %>
    <div class="no-data">
        暂无投票数据
    </div>
    <% } else { %>
    <table class="results-table">
        <thead>
        <tr>
            <th style="width: 80px;">排名</th>
            <th style="width: 120px;">图书编号</th>
            <th>图书名称</th>
            <th style="width: 150px;">作者</th>
            <th style="width: 120px;">类别</th>
            <th style="width: 350px;">得票情况</th>
        </tr>
        </thead>
        <tbody>
        <%
            int rank = 1;
            for (Book book : books) {
                double percentage = totalVotes > 0 ? (book.getVoteCount() * 100.0 / totalVotes) : 0;
                String rankClass = "";
                String medal = "";

                if (rank == 1) {
                    rankClass = "rank-1";
                    medal = "🥇";
                } else if (rank == 2) {
                    rankClass = "rank-2";
                    medal = "🥈";
                } else if (rank == 3) {
                    rankClass = "rank-3";
                    medal = "🥉";
                }
        %>
        <tr>
            <td class="rank <%= rankClass %>">
                <span class="medal"><%= medal %></span>
                <%= rank %>
            </td>
            <td><%= book.getBookcode() %></td>
            <td><strong><%= book.getBookname() %></strong></td>
            <td><%= book.getBookauthor() %></td>
            <td><%= book.getBooktablecol() %></td>
            <td>
                <div class="vote-bar">
                    <div class="bar-container">
                        <div class="bar-fill" style="width: <%= percentage %>%">
                            <%= book.getVoteCount() %> 票
                        </div>
                    </div>
                    <span class="percentage"><%= String.format("%.1f", percentage) %>%</span>
                </div>
            </td>
        </tr>
        <%
                rank++;
            }
        %>
        </tbody>
    </table>
    <% } %>

    <div class="back-link">
        <a href="vote.jsp">⬅️ 返回投票</a>
    </div>
</div>
</body>
</html>