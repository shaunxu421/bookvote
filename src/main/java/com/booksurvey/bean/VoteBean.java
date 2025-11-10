package com.booksurvey.bean;

import com.booksurvey.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VoteBean {

    /**
     * 为指定图书投票
     */
    public boolean vote(String bookcode) {
        String checkSql = "SELECT vote_count FROM book_votes WHERE bookcode = ?";
        String insertSql = "INSERT INTO book_votes (bookcode, vote_count) VALUES (?, 1)";
        String updateSql = "UPDATE book_votes SET vote_count = vote_count + 1 WHERE bookcode = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // 检查是否存在记录
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, bookcode);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 记录存在，更新投票数
                rs.close();
                pstmt.close();
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setString(1, bookcode);
                pstmt.executeUpdate();
            } else {
                // 记录不存在，插入新记录
                rs.close();
                pstmt.close();
                pstmt = conn.prepareStatement(insertSql);
                pstmt.setString(1, bookcode);
                pstmt.executeUpdate();
            }

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }

    /**
     * 获取指定图书的投票数
     */
    public int getVoteCount(String bookcode) {
        String sql = "SELECT vote_count FROM book_votes WHERE bookcode = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookcode);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("vote_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return 0;
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
}