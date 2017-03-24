package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
import pageDB_model.PageDBServlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
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

@WebServlet("/api/addcat")


public class AddCategory extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        Map<String, String> output = new HashMap<String, String>();
        /* Ensure name is unique  */
        List<String> params = new ArrayList<String>();
        params.add(reqParams.get("name"));
        int count = dm.executeAggregateQuery(DataModel.SELECT_NAME_COUNT, params);
        if (count != 0) {
            String msg = String.format("Name {%s} already taken", reqParams.get("name"));
            output.put("error", msg);
            return output;
        }

        /* Ensure label is unique  */
        params = new ArrayList<String>();
        params.add(reqParams.get("label"));
        count = dm.executeAggregateQuery(DataModel.SELECT_LABEL_COUNT, params);
        if (count != 0) {
            String msg = String.format("Label {%s} already taken", reqParams.get("label"));
            output.put("error", msg);
            return output;
        }

        /* Ensure parent_id exists  */
        params = new ArrayList<String>();
        params.add(reqParams.get("parent_id"));
        count = dm.executeAggregateQuery(Category.SELECT_ID_COUNT, params);

        if (count == 0) {
            String msg = String.format("Parent Id {%s} does not exist", reqParams.get("parent_id"));
            output.put("error", msg);
            return output;
        }

        params = new ArrayList<String>();
        params.add(reqParams.get("parent_id"));
        params.add(reqParams.get("name"));
        params.add(reqParams.get("label"));
        count = dm.executeUpdate(Category.INSERT, params);
        if (count == 0) {
            String msg = String.format("Unable to insert new record");
            output.put("error", msg);
            return output;
        }

        output.put("success", "Successfully inserted new record");
        return output;
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        /* the map returned */
        Map<String, String> output = new HashMap<String, String>();
        PrintWriter out = null;
        try {
            response.setContentType("application/json");
            //response.setCharacterEncoding("UTF-8");
            out = response.getWriter();

            /* clean request parameters */
            Map<String, String> reqParams = new HashMap<String, String>();
            reqParams.put("name", request.getParameter("name"));
            reqParams.put("label", request.getParameter("label"));
            reqParams.put("parent_id", request.getParameter("parent_id"));
            this.checkRequestParams(reqParams);

            this.dm = new DataModel();
            output = this.checkPageDB(dm, reqParams);

        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error AddCategory\n" + trace);
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
