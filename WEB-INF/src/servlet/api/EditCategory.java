package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
import pageDB_model.TreeNode;
import pageDB_model.PageDBServlet;
import pageDB_model.PageDBServletException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.SQLException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.apache.commons.lang3.exception.ExceptionUtils;

@WebServlet("/api/editcat")


public class EditCategory extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        Map<String, String> output = new HashMap<String, String>();
        String id = reqParams.get("id");
        String nm = reqParams.get("name");
        String lbl = reqParams.get("label");
        String pid = reqParams.get("parent_id");

        /* Ensure name is unique  */
        List<String> params = new ArrayList<String>();
        params.add(id);
        params.add(nm);
        int count = dm.executeAggregateQuery("CALL CountNameExceptCatId(?,?);", params);
        if (count != 0) {
            String msg = String.format("Name {%s} already taken", nm);
            output.put("error", msg);
            return output;
        }

        /* Ensure label is unique  */
        params = new ArrayList<String>();
        params.add(id);
        params.add(lbl);
        count = dm.executeAggregateQuery("CALL CountLabelExceptCatId(?,?);", params);
        if (count != 0) {
            String msg = String.format("Label {%s} already taken", lbl);
            output.put("error", msg);
            return output;
        }

        /* Ensure id exists */
        params = new ArrayList<String>();
        params.add(id);
        count = dm.executeAggregateQuery("CALL CountCatId(?);", params);
        if (count == 0) {
            String msg = String.format("Category Id {%s} does not exist", id);
            output.put("error", msg);
            return output;
        }

        /* Ensure parent_id exists */
        System.out.println("type: " + pid.getClass().getName() + ", val: " + pid);
        if (!pid.equals("null")) {
            params = new ArrayList<String>();
            params.add(pid);
            count = dm.executeAggregateQuery("CALL CountCatId(?);", params);
            if (count == 0) {
                String msg = String.format("Parent Category Id {%s} does not exist", pid);
                output.put("error", msg);
                return output;
            }

            TreeNode tree = dm.getTree();
            if (!checkParentId(tree, id, pid)) {
                String msg = String.format("Parent Category Id cannot be a subcategory of {%s}", nm);
                output.put("error", msg);
                return output;
            }
        }
        params = new ArrayList<String>();
        params.add(id);
        params.add(nm);
        params.add(lbl);
        if (!pid.equals("null")) {
            params.add(pid);
            count = dm.executeUpdate("CALL UpdateSubcat(?,?,?,?);", params);
        } else {
            count = dm.executeUpdate("CALL UpdateRootCat(?,?,?);", params);
        }
        if (count == 0) {
            String msg = String.format("Unable to update record");
            output.put("error", msg);
            return output;
        }
        output.put("success", "Successfully updated record");
        return output;
    }

    /* return true if the new parent is not a subcategory of the category itself */
    private boolean checkParentId(TreeNode node, String id, String pid) {
        if (node.cat() != null) {
            if (node.cat().id().equals(pid)) {
                return true;
            }
            if (!node.cat().id().equals(id)) {
                boolean chk = false;
                for (TreeNode child : node.children()) {
                    if (checkParentId(child, id, pid)) {
                        return true;
                    }
                }
            }
        }
        return false ;
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        /* the map returned */
        Map<String, String> output = new HashMap<String, String>();
        PrintWriter out = null;
        try {
            response.setContentType("application/json");
            out = response.getWriter();

            /* clean request parameters */
            Map<String, String> reqParams = new HashMap<String, String>();
            reqParams.put("id", request.getParameter("id"));
            reqParams.put("name", request.getParameter("name"));
            reqParams.put("label", request.getParameter("label"));
            reqParams.put("parent_id", request.getParameter("parent_id"));
            this.checkRequestParams(reqParams);

            this.dm = new DataModel();
            output = this.checkPageDB(dm, reqParams);
        } catch(PageDBServletException e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error EditCategory\n" + trace);
            output.put("error", e.getMessage());
        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error EditCategory\n" + trace);
            output.put("error", trace);
        } finally {
            if (this.dm != null) { this.dm.closeConnection(); }
            Gson gson = new Gson();
            out.write(gson.toJson(output));
            out.close();
        }
    }
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        doPost(request, response);
    }
}
