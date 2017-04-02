package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
import pageDB_model.TreeNode;
import pageDB_model.PageDBServlet;

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

        /* Ensure name is unique  */
        List<String> params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        params.add(reqParams.get("name"));
        int count = dm.executeAggregateQuery("CALL CountNameExceptCatId(?,?);", params);
        if (count != 0) {
            String msg = String.format("Name {%s} already taken", reqParams.get("name"));
            output.put("error", msg);
            return output;
        }

        /* Ensure label is unique  */
        params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        params.add(reqParams.get("label"));
        count = dm.executeAggregateQuery("CALL CountLabelExceptCatId(?,?);", params);
        if (count != 0) {
            String msg = String.format("Label {%s} already taken", reqParams.get("label"));
            output.put("error", msg);
            return output;
        }

        /* Ensure id exists */
        params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        count = dm.executeAggregateQuery("CALL CountCatId(?);", params);
        if (count == 0) {
            String msg = String.format("Category Id {%s} does not exist", reqParams.get("id"));
            output.put("error", msg);
            return output;
        }

        /* Ensure parent_id exists */
        params = new ArrayList<String>();
        params.add(reqParams.get("parent_id"));
        count = dm.executeAggregateQuery("CALL CountCatId(?);", params);
        if (count == 0) {
            String msg = String.format("Parent Category Id {%s} does not exist", reqParams.get("parent_id"));
            output.put("error", msg);
            return output;
        }

        TreeNode tree = dm.getTree();
        if (!checkIfNotChild(tree, reqParams.get("id"), reqParams.get("parent_id"))) {
            String msg = String.format("Parent Category Id cannot be a subcategory of {%s}", reqParams.get("name"));
            output.put("error", msg);
            return output;
        }
        /*
        params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        params.add(reqParams.get("name"));
        params.add(reqParams.get("label"));
        count = dm.executeUpdate("CALL UpdateCat(?,?,?);", params);
        if (count == 0) {
            String msg = String.format("Unable to update record");
            output.put("error", msg);
            return output;
        }
        */
        output.put("success", "Successfully updated record");
        return output;
    }

    /* return true if the new parent is not a subcategory of the category itself */
    private boolean checkIfNotChild(TreeNode node, String id, String parent_id) {
        if (node.cat() != null) {
            System.out.println(node.cat().id() + ", " + id);
            if (node.cat().id() == parent_id) {
                System.out.println("Found id == parent_id!!!!!!!!!!!!!");
                return true;
            }
            if (node.cat().id() != id) {
                boolean chk = false;
                for (TreeNode child : node.children()) {
                    chk = chk || checkIfNotChild(child, id, parent_id);
                }
                return chk;
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
