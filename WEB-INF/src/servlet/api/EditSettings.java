package pageDB_api;

import pageDB_model.DataModel;
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

@WebServlet("/api/editsettings")


public class EditSettings extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        Map<String, String> output = new HashMap<String, String>();
        List<String> params = new ArrayList<String>();
        params.add(reqParams.get("site_label"));
        params.add(reqParams.get("main_page_content"));
        params.add(reqParams.get("head_snippet"));
        params.add(reqParams.get("foot_snippet"));

        int count = dm.executeUpdate("CALL UpdateSettings(?,?,?,?);", params);
        if (count == 0) {
            String msg = String.format("Unable to update settings");
            output.put("error", msg);
            return output;
        }

        output.put("success", "Successfully updated settings");
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
            reqParams.put("site_label", request.getParameter("site_label"));
            this.checkRequestParams(reqParams);
            reqParams.put("main_page_content", request.getParameter("main_page_content"));
            reqParams.put("head_snippet", request.getParameter("head_snippet"));
            reqParams.put("foot_snippet", request.getParameter("foot_snippet"));

            this.dm = new DataModel();
            output = this.checkPageDB(dm, reqParams);
        } catch(PageDBServletException e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error EditSettings\n" + trace);
            output.put("error", e.getMessage());
        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error EditSettings\n" + trace);
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
