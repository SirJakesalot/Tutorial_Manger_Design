package pageDB_model;

import java.util.Map;
import java.util.List;
import java.util.ArrayList;

public class TreeNode {
    private Category cat;
    private Page page;
    private List<TreeNode> children;

    /* TreeNode get functions */
    public Category cat() { return this.cat; }
    public Page page() { return this.page; }
    public List<TreeNode> children() { return this.children; }

    /* TreeNode set methods */
    public Category cat(Category new_cat) { this.cat = new_cat; return cat(); }
    public Page page(Page new_pg) { this.page = new_pg; return page(); }
    public List<TreeNode> children(List<TreeNode> new_children) {
        this.children = new_children;
        return children();
    }

    /* category node */
    public TreeNode(Category new_cat) {
        cat(new_cat);
        page(null);
        children(new ArrayList<TreeNode>());
    }

    /* tutorial node */
    public TreeNode(Page new_page) {
        cat(null);
        page(new_page);
    }

    public void addChild(TreeNode node) {
        this.children.add(node);
    }
    public void addChild(Category cat) {
        this.children.add(new TreeNode(cat));
    }
    public void addChild(Page page) {
        this.children.add(new TreeNode(page));
    }

    public static TreeNode buildTree(Map<String, List<String>> lineage, Map<String, Category> cats, Map<String, List<Page>> pages, String id) {
        TreeNode n = new TreeNode(cats.get(id));
        if (pages.get(id) != null) {
            for (Page pg : pages.get(id)) {
                n.addChild(pg);
            }
        }
        if (lineage.get(id) != null) {
            for (String child : lineage.get(id)) {
                n.addChild(buildTree(lineage, cats, pages, child));
            }
        }
        return n;
    }

    public void print() {
        // cat is always at the root
        //cat().print();
        System.out.println(cat().name());
        for (TreeNode node : children()) {
            node.print(1);
        }
    }

    private void print(int spc) {
        String spcs = String.format("%" + spc + "s","");
        System.out.print(spcs);
        if (cat() == null) {
            //page().print();
            System.out.println("+" + page().name());
        } else {
            //cat().print();
            System.out.println("-" + cat().name());
            for (TreeNode node : children()) {
                node.print(spc + 1);
            }
        }
    }
}
