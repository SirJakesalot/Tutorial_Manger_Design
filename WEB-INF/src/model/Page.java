package pageDB_model;

import java.sql.ResultSet;
import java.sql.SQLException;


public class Page {
    private String id;
    private String name;
    private String label;
    private String category_id;

    /* SQL statements */
    public static final String SELECT_ALL  = "SELECT id,name,label,pc.category_id as category_id FROM pages LEFT JOIN (SELECT * FROM page_categories) AS pc ON id=pc.page_id;";
    public static final String INSERT      = "INSERT INTO pages VALUES (?,?);";
    public static final String INSERT_LINK = "INSERT INTO page_categories VALUES (?,?);";
    public static final String DELETE_ID   = "DELETE FROM pages WHERE id=?;";

    /* category get functions */
    public String id() { return this.id; }
    public String name() { return this.name; }
    public String label() { return this.label; }
    public String category_id() { return this.category_id; }

    /* category set functions */
    public String id(String new_id) { this.id = new_id; return id(); }
    public String name(String new_name) { this.name = new_name; return name(); }
    public String label(String new_label) { this.label = new_label; return label(); }
    public String category_id(String new_id) { this.category_id = new_id; return category_id(); }

    public Page(ResultSet rs) throws SQLException {
       id(rs.getString("id"));
       name(rs.getString("name")); 
       label(rs.getString("label"));
       category_id(rs.getString("category_id"));
    }
    public void print() {
        System.out.println("Page {id: " + id() + ", name: " + name() + ", label: " + label() + ", category_id: " + category_id());
    }
/*
    public boolean equals(Object o) {
        if (o == null) return false;
        if (!(o instanceof) Page) return false;

        Page other = (Page) o;
        if (id() != other.id()) return false;
        if (name() != other.name()) return false;
        if (label() != other.label()) return false;
        if (category_id() != other.category_id()) return false;
        return true;
    }

    public int hashCode() {
        return category_id().hashCode();
    }
*/
}
