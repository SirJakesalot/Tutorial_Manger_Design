package pageDB_pages;

import pageDB_model.DataModel;
import pageDB_model.TreeNode;
import pageDB_model.Category;
import pageDB_model.Page;

import java.io.IOException;

import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("*.html")

public class PageContent extends HttpServlet {

    public boolean getCrumbs(TreeNode node, String name, List<TreeNode> crumbs) {
        if (node == null) { return false; }

        if (node.cat() != null) {
            crumbs.add(node);
            if (node.cat().name().equals(name)) {
                return true;
            }
            for(TreeNode child : node.children()) {
                if (getCrumbs(child, name, crumbs)) {
                    return true;
                }
            }
            crumbs.remove(crumbs.size() - 1);
        } else if (node.page() != null) {
            crumbs.add(node);
            if (node.page().name().equals(name)) {
                return true;
            }
            crumbs.remove(crumbs.size() - 1);
        }

        return false;
    }

    public List<TreeNode> getCatChildren(TreeNode node, String cid) {
        if (node == null) { return null; }
        if (node.cat() != null) {
          if (node.cat().id().equals(cid)) {
              return node.children(); 
          }
          List<TreeNode> children = null;
          for (TreeNode child : node.children()) {
              children = getCatChildren(child, cid);
              if (children != null) {
                  return children;
              }
          }
        }
        return null;
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DataModel dm = null;
        try {
            dm = new DataModel();
            TreeNode tree = dm.getTree();

            String name = request.getServletPath();
            name = name.substring(1, name.length() - 5);
            List<String> params = new ArrayList<String>();
            params.add(name);

            Page pg = dm.getPageForQuery("CALL GetPageByName(?);", params);
            if (pg != null) {
                request.setAttribute("page", pg);
            } else {
                Category cat = dm.getCatForQuery("CALL GetCatByName(?);", params);
                List<TreeNode> children = getCatChildren(tree, cat.id());
                request.setAttribute("category", cat);
                request.setAttribute("children", children);
            }

            List<TreeNode> crumbs = new ArrayList<TreeNode>();
            getCrumbs(tree, name, crumbs);

            request.setAttribute("title", "Tutorial Page");
            request.setAttribute("crumbs", crumbs);
            request.setAttribute("tree", tree);
        } catch (Exception e) {
            DataModel.log("PageContent doGet", e);
            request.setAttribute("error", "PageContent error");
        } finally {
            dm.closeConnection();
            request.getRequestDispatcher("jsp/page-content.jsp").forward(request, response);
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{ 
        doGet(request, response);
    }
}
