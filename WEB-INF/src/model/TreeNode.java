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

    /* page node */
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

    /*
     * lineage: parent category -> sub categories
     * cats: category id -> Category obj
     * pages: category id -> List of page children
     * id: category id that we are currently observing
    **/
    public static TreeNode buildTree(Map<String, List<String>> lineage,
                                     Map<String, Category> cats,
                                     Map<String, List<Page>> pages,
                                     String id) {
        /* create node for the observed id */
        TreeNode node = new TreeNode(cats.get(id));
        /* add page children first */
        if (pages.get(id) != null) {
            for (Page pg : pages.get(id)) {
                node.addChild(pg);
            }
        }
        /* add the result of recurring on the child category id */
        if (lineage.get(id) != null) {
            for (String child : lineage.get(id)) {
                node.addChild(buildTree(lineage, cats, pages, child));
            }
        }
        /* return that tree bruh */
        return node;
    }

    /* print the tree starting at the root */
    public void print() {
        /* root is always a Category */
        System.out.println(cat().name());
        for (TreeNode node : children()) {
            node.print(1);
        }
    }

    /* print current node with that number of spaces */
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
