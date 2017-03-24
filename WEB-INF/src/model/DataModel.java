package pageDB_model;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;

import org.apache.commons.lang3.exception.ExceptionUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
  * DataModel mediates all access to the database. Safely executing queries and
  * returning their coresponding model objects.
  * @author Jake Armentrout
  */
public class DataModel {
    /* JDBC driver name and database url */
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL      = "jdbc:mysql:///pageDB?useSSL=false";

    /* tutorial database admin credentials */
    static final String USER = "pageDB_admin";
    static final String PASS = "m@n@g3r";

    /* queries */
    public static final String SELECT_NAME_COUNT = "SELECT COUNT(*) FROM (SELECT name FROM categories UNION SELECT name FROM pages) AS names WHERE name=?;";
    public static final String SELECT_LABEL_COUNT = "SELECT COUNT(*) FROM (SELECT label FROM categories UNION SELECT label FROM pages) AS labels WHERE label=?;";

    /* used to open and hold a database connection */
    public Connection conn        = null;
    public PreparedStatement stmt = null;
    public ResultSet rs           = null;

    /**
     * Constructs a DataModel object. Establishes and holds a connection to the
     * local tutorial database.
     */
    public DataModel() throws Exception {
        this.conn = getConnection();
        //this.closeConnection();
    }

    /**
     * Establishes a local connection to the tutorial database. Return null if
     * fail to open connection.
     * @return Connection Open connection to the local tutorial database.
     */
    public Connection getConnection() throws Exception {
        Class.forName(this.JDBC_DRIVER).newInstance();
        return DriverManager.getConnection(this.DB_URL, this.USER, this.PASS);
    }

    /**
     * Closes any open database connection.
     */
    public void closeConnection() {
        try {
            if (this.rs != null)   { this.rs.close(); }
            if (this.stmt != null) { this.stmt.close(); }
            if (this.conn != null) { this.conn.close(); }
        } catch (Exception e) {
            ;
        }
    }
    public static void log(String message, Exception e) {
        System.out.println(message + "\n" + ExceptionUtils.getStackTrace(e));
    }
    public static void log(String query, List<String> params) {
        if (params != null) {
            System.out.println(query + " : " + params.toString());
        } else {
            System.out.println(query + " : null");
        }
    }

    public int executeUpdate(String update, List<String> params) throws SQLException {
        log(update, params);
        this.stmt = this.conn.prepareStatement(update);
        if (params != null) {
            for (int i = 0; i < params.size(); ++i) {
                this.stmt.setString(i + 1, params.get(i));
            }
        }
        return this.stmt.executeUpdate();
    }

    public void executeQuery(String query, List<String> params) throws SQLException {
        log(query, params);
        this.stmt = this.conn.prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.size(); ++i) {
                this.stmt.setString(i + 1, params.get(i));
            }
        }
        this.rs = this.stmt.executeQuery();
    }

    public int executeAggregateQuery(String query, List<String> params) throws SQLException {
        executeQuery(query, params);
        int count = 0;
        if (this.rs.isBeforeFirst()) {
            this.rs.next();
            count = this.rs.getInt(1);
        }
        return count;
    }

    public TreeNode getTree() throws SQLException {
        /* container for Category objects
         * e.g. {Category Id : Category} */
        Map<String, Category> cats = new HashMap<String, Category>();
        /* container for Category lineage
         * e.g. {Category Parent Id : [Category Child Ids]} */
        Map<String, List<String>> lineage = new HashMap<String, List<String>>();

        /* query database to fill lineage and cats */
        executeQuery(Category.SELECT_ALL, null);

        if (this.rs.isBeforeFirst()) {
            while (this.rs.next()) {
                Category cat = new Category(this.rs);
                cats.put(cat.id(), cat);
                if (!lineage.containsKey(cat.parent_id())) {
                    lineage.put(cat.parent_id(), new ArrayList<String>());
                }
                lineage.get(cat.parent_id()).add(cat.id());
            }
        }

        // no categories or no root node found
        if (cats.isEmpty() || lineage.get(null) == null) {
            return null;
        }

        /* container to hold each page's category 
         * e.g. {Category Id : [Page]} */
        Map<String, List<Page>> pages = new HashMap<String, List<Page>>();

        /* query database and fill pages container */
        executeQuery(Page.SELECT_ALL, null);
        if (this.rs.isBeforeFirst()) {
            while (this.rs.next()) {
                Page page = new Page(this.rs);
                if (!pages.containsKey(page.category_id())) {
                    pages.put(page.category_id(), new ArrayList<Page>());
                }
                pages.get(page.category_id()).add(page);
            }
        }


        /* build the tree, starting from null's child */
        TreeNode tree = TreeNode.buildTree(lineage, cats, pages, lineage.get(null).get(0));
        tree.print();

        return tree;
    }
}



