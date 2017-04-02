package pageDB_model;

import java.sql.ResultSet;
import java.sql.SQLException;


public class Page {
    private String id;
    private String name;
    private String label;
    private String category_id;

    /* page get functions */
    public String id() { return this.id; }
    public String name() { return this.name; }
    public String label() { return this.label; }
    public String category_id() { return this.category_id; }

    /* page set functions */
    public String id(String new_id) { this.id = new_id; return id(); }
    public String name(String new_name) { this.name = new_name; return name(); }
    public String label(String new_label) { this.label = new_label; return label(); }
    public String category_id(String new_id) { this.category_id = new_id; return category_id(); }

    /* read query result into Page obj */
    public Page(ResultSet rs) throws SQLException {
       id(rs.getString("id"));
       name(rs.getString("name")); 
       label(rs.getString("label"));
       category_id(rs.getString("category_id"));
    }
    public void print() {
        System.out.println("Page {id: " + id() +
                           ", name: " + name() +
                           ", label: " + label() +
                           ", category_id: " + category_id());
    }
}
