package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
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

@WebServlet("/api/addpage")


public class AddPage extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        Map<String, String> output = new HashMap<String, String>();
        /* Ensure name is unique  */
        List<String> params = new ArrayList<String>();
        params.add(reqParams.get("name"));
        int count = dm.executeAggregateQuery("CALL CountName(?);", params);
        if (count != 0) {
            String msg = String.format("Name {%s} already taken", reqParams.get("name"));
            output.put("error", msg);
            return output;
        }

        /* Ensure label is unique  */
        params = new ArrayList<String>();
        params.add(reqParams.get("label"));
        count = dm.executeAggregateQuery("CALL CountLabel(?);", params);
        if (count != 0) {
            String msg = String.format("Label {%s} already taken", reqParams.get("label"));
            output.put("error", msg);
            return output;
        }

        /* Ensure parent_id exists  */
        params = new ArrayList<String>();
        params.add(reqParams.get("parent_id"));
        count = dm.executeAggregateQuery("CALL CountCatId(?);", params);

        if (count == 0) {
            String msg = String.format("Parent category id {%s} does not exist", reqParams.get("parent_id"));
            output.put("error", msg);
            return output;
        }

        params = new ArrayList<String>();
        params.add(reqParams.get("name"));
        params.add(reqParams.get("label"));
        params.add(reqParams.get("parent_id"));
        count = dm.executeUpdate("CALL InsertPage(?,?,?);", params);
        if (count == 0) {
            String msg = String.format("Unable to insert new page");
            output.put("error", msg);
            return output;
        }

        output.put("success", "Successfully inserted new page");
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
            reqParams.put("name", request.getParameter("name"));
            reqParams.put("label", request.getParameter("label"));
            reqParams.put("parent_id", request.getParameter("parent_id"));
            this.checkRequestParams(reqParams);

            this.dm = new DataModel();
            output = this.checkPageDB(dm, reqParams);

        } catch(PageDBServletException e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error AddPage\n" + trace);
            output.put("error", e.getMessage());
        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error AddPage\n" + trace);
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
