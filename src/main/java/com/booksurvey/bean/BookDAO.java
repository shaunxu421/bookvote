package com.booksurvey.bean;

import com.booksurvey.model.Book;
import com.booksurvey.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    /**
     * 获取指定类别的所有图书
     */
    public List<Book> getBooksByCategory(String category) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, IFNULL(v.vote_count, 0) as vote_count " +
                "FROM booktable b " +
                "LEFT JOIN book_votes v ON b.bookcode = v.bookcode " +
                "WHERE b.booktablecol = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setBookid(rs.getInt("bookid"));
                book.setBookcode(rs.getString("bookcode"));
                book.setBookname(rs.getString("bookname"));
                book.setBookprice(rs.getDouble("bookprice"));
                book.setBookcount(rs.getInt("bookcount"));
                book.setBookdate(rs.getString("bookdate"));
                book.setBookauthor(rs.getString("bookauthor"));
                book.setBooktablecol(rs.getString("booktablecol"));
                book.setVoteCount(rs.getInt("vote_count"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return books;
    }

    /**
     * 获取所有图书
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, IFNULL(v.vote_count, 0) as vote_count " +
                "FROM booktable b " +
                "LEFT JOIN book_votes v ON b.bookcode = v.bookcode";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setBookid(rs.getInt("bookid"));
                book.setBookcode(rs.getString("bookcode"));
                book.setBookname(rs.getString("bookname"));
                book.setBookprice(rs.getDouble("bookprice"));
                book.setBookcount(rs.getInt("bookcount"));
                book.setBookdate(rs.getString("bookdate"));
                book.setBookauthor(rs.getString("bookauthor"));
                book.setBooktablecol(rs.getString("booktablecol"));
                book.setVoteCount(rs.getInt("vote_count"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return books;
    }

    /**
     * 获取所有图书类别
     */
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT booktablecol FROM booktable ORDER BY booktablecol";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                categories.add(rs.getString("booktablecol"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return categories;
    }

    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        DBUtil.closeConnection(conn);
    }
    // 在原有BookDAO.java中添加以下方法

    /**
     * 添加图书
     */
    public boolean addBook(Book book) {
        String sql = "INSERT INTO booktable (bookcode, bookname, bookprice, bookcount, bookdate, bookauthor, booktablecol) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getBookcode());
            pstmt.setString(2, book.getBookname());
            pstmt.setDouble(3, book.getBookprice());
            pstmt.setInt(4, book.getBookcount());
            pstmt.setString(5, book.getBookdate());
            pstmt.setString(6, book.getBookauthor());
            pstmt.setString(7, book.getBooktablecol());

            int result = pstmt.executeUpdate();

            // 同时在投票表中创建记录
            if (result > 0) {
                String voteSql = "INSERT INTO book_votes (bookcode, vote_count) VALUES (?, 0)";
                pstmt.close();
                pstmt = conn.prepareStatement(voteSql);
                pstmt.setString(1, book.getBookcode());
                pstmt.executeUpdate();
            }

            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 更新图书信息
     */
    public boolean updateBook(Book book) {
        String sql = "UPDATE booktable SET bookname=?, bookprice=?, bookcount=?, bookdate=?, bookauthor=?, booktablecol=? " +
                "WHERE bookcode=?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getBookname());
            pstmt.setDouble(2, book.getBookprice());
            pstmt.setInt(3, book.getBookcount());
            pstmt.setString(4, book.getBookdate());
            pstmt.setString(5, book.getBookauthor());
            pstmt.setString(6, book.getBooktablecol());
            pstmt.setString(7, book.getBookcode());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 删除图书
     */
    public boolean deleteBook(String bookcode) {
        String sql = "DELETE FROM booktable WHERE bookcode=?";
        String voteSql = "DELETE FROM book_votes WHERE bookcode=?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            // 先删除投票记录
            pstmt = conn.prepareStatement(voteSql);
            pstmt.setString(1, bookcode);
            pstmt.executeUpdate();
            pstmt.close();

            // 再删除图书
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookcode);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 根据bookcode获取图书
     */
    public Book getBookByCode(String bookcode) {
        String sql = "SELECT b.*, IFNULL(v.vote_count, 0) as vote_count " +
                "FROM booktable b " +
                "LEFT JOIN book_votes v ON b.bookcode = v.bookcode " +
                "WHERE b.bookcode = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookcode);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Book book = new Book();
                book.setBookid(rs.getInt("bookid"));
                book.setBookcode(rs.getString("bookcode"));
                book.setBookname(rs.getString("bookname"));
                book.setBookprice(rs.getDouble("bookprice"));
                book.setBookcount(rs.getInt("bookcount"));
                book.setBookdate(rs.getString("bookdate"));
                book.setBookauthor(rs.getString("bookauthor"));
                book.setBooktablecol(rs.getString("booktablecol"));
                book.setVoteCount(rs.getInt("vote_count"));
                return book;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return null;
    }

    /**
     * 检查bookcode是否存在
     */
    public boolean isBookCodeExists(String bookcode) {
        String sql = "SELECT COUNT(*) FROM booktable WHERE bookcode = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookcode);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return false;
    }
}