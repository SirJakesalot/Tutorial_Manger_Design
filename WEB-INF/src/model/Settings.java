package pageDB_model;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Settings {
    private String site_label;
    private String main_page_content;
    private String head_snippet;
    private String foot_snippet;

    /* page get functions */
    public String site_label() {return this.site_label; }
    public String main_page_content() {return this.main_page_content; }
    public String head_snippet() {return this.head_snippet; }
    public String foot_snippet() {return this.foot_snippet; }

    /* page set functions */
    public String site_label(String new_label) { this.site_label = new_label; return site_label(); }
    public String main_page_content(String new_content) {
        this.main_page_content = new_content;
        return main_page_content();
    }
    public String head_snippet(String new_snippet) { this.head_snippet = new_snippet; return head_snippet(); }
    public String foot_snippet(String new_snippet) { this.foot_snippet = new_snippet; return foot_snippet(); }

    /* read query result into Page obj */
    public Settings(ResultSet rs) throws SQLException {
        site_label(rs.getString("site_label"));
        main_page_content(rs.getString("main_page_content")); 
        head_snippet(rs.getString("head_snippet"));
        foot_snippet(rs.getString("foot_snippet"));
    }
}
