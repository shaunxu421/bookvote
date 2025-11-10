package com.booksurvey.model;

public class Book {
    private int bookid;
    private String bookcode;
    private String bookname;
    private double bookprice;
    private int bookcount;
    private String bookdate;
    private String bookauthor;
    private String booktablecol;
    private int voteCount;  // 投票数

    // 无参构造函数
    public Book() {}

    // 全参构造函数
    public Book(int bookid, String bookcode, String bookname, double bookprice,
                int bookcount, String bookdate, String bookauthor,
                String booktablecol, int voteCount) {
        this.bookid = bookid;
        this.bookcode = bookcode;
        this.bookname = bookname;
        this.bookprice = bookprice;
        this.bookcount = bookcount;
        this.bookdate = bookdate;
        this.bookauthor = bookauthor;
        this.booktablecol = booktablecol;
        this.voteCount = voteCount;
    }

    // Getter和Setter方法
    public int getBookid() {
        return bookid;
    }

    public void setBookid(int bookid) {
        this.bookid = bookid;
    }

    public String getBookcode() {
        return bookcode;
    }

    public void setBookcode(String bookcode) {
        this.bookcode = bookcode;
    }

    public String getBookname() {
        return bookname;
    }

    public void setBookname(String bookname) {
        this.bookname = bookname;
    }

    public double getBookprice() {
        return bookprice;
    }

    public void setBookprice(double bookprice) {
        this.bookprice = bookprice;
    }

    public int getBookcount() {
        return bookcount;
    }

    public void setBookcount(int bookcount) {
        this.bookcount = bookcount;
    }

    public String getBookdate() {
        return bookdate;
    }

    public void setBookdate(String bookdate) {
        this.bookdate = bookdate;
    }

    public String getBookauthor() {
        return bookauthor;
    }

    public void setBookauthor(String bookauthor) {
        this.bookauthor = bookauthor;
    }

    public String getBooktablecol() {
        return booktablecol;
    }

    public void setBooktablecol(String booktablecol) {
        this.booktablecol = booktablecol;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }
}