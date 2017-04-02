package pageDB_model;

import java.sql.ResultSet;
import java.sql.SQLException;


public class Category {
    private String id;
    private String parent_id;
    private String name;
    private String label;

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

    /* read query results into Category obj */
    public Category(ResultSet rs) throws SQLException {
       id(rs.getString("id"));
       parent_id(rs.getString("parent_id"));
       name(rs.getString("name")); 
       label(rs.getString("label"));
    }

    /* print the String representation of a Category */
    public void print() {
        System.out.println("Cat {id: " + id() +
                           ", parent_id: " + parent_id() +
                           ", name: " + name() +
                           ", label: " + label());
    }
}
