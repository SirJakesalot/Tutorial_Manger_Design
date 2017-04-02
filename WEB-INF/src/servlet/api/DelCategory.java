package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
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

@WebServlet("/api/delcat")

public class DelCategory extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        Map<String, String> output = new HashMap<String, String>();

        /* Ensure exists and unique */
        List<String> params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        int count = dm.executeAggregateQuery("CALL CountCatId(?);", params);
        if (count == 0) {
            String msg = "This category does not exist";
            output.put("error", msg);
            return output;
        } else if (count > 1) {
            String msg = "This category has id conflicts";
            output.put("error", msg);
            return output;
        }

        /* Ensure no children  */
        params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        count = dm.executeAggregateQuery("CALL CountParentId(?);", params);
        if (count != 0) {
            String msg = "This category is not empty";
            output.put("error", msg);
            return output;
        }

        params = new ArrayList<String>();
        params.add(reqParams.get("id"));
        count = dm.executeUpdate("CALL DeleteCatById(?);", params);
        if (count == 0) {
            String msg = String.format("Unable to delete category");
            output.put("error", msg);
            return output;
        }

        output.put("success", "Successfully deleted category");
        return output;
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
            this.checkRequestParams(reqParams);

            this.dm = new DataModel();
            output = this.checkPageDB(dm, reqParams);

        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error DelCategory\n" + trace);
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
