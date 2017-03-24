package pageDB_model;

import java.sql.ResultSet;
import java.sql.SQLException;


public class Category {
    private String id;
    private String parent_id;
    private String name;
    private String label;

    /* SQL statements */
    public static final String SELECT_ALL = "SELECT * FROM categories;";
    public static final String SELECT_ID_COUNT = "SELECT COUNT(*) FROM categories WHERE id=?;";
    public static final String INSERT     = "INSERT INTO categories(parent_id, name, label) VALUES (?,?,?);";
    public static final String DELETE_ID  = "DELETE FROM categories WHERE id=?;";

    /* category get functions */
    public String id() { return this.id; }
    public String parent_id() { return this.parent_id; }
    public String name() { return this.name; }
    public String label() { return this.label; }

    /* category set functions */
    public String id(String new_id) { this.id = new_id; return id(); }
    public String parent_id(String new_id) { this.parent_id = new_id; return parent_id(); }
    public String name(String new_name) { this.name = new_name; return name(); }
    public String label(String new_label) { this.label = new_label; return label(); }

    public Category(ResultSet rs) throws SQLException {
       id(rs.getString("id"));
       parent_id(rs.getString("parent_id"));
       name(rs.getString("name")); 
       label(rs.getString("label"));
    }
    public void print() {
        System.out.println("Cat {id: " + id() + ", parent_id: " + parent_id() + ", name: " + name() + ", label: " + label());
    }
/*
    public boolean equals(Object o) {
        if (o == null) return false;
        if (!(o instanceof) Category) return false;

        Category other = (Category) o;
        if (id() != other.id()) return false;
        if (parent_id() != other.parent_id()) return false;
        if (name() != other.name()) return false;
        if (label() != other.label()) return false;
        return true;
    }

    public int hashCode() {
        return id().hashCode();
    }
*/
}
