package pageDB_api;

import pageDB_model.DataModel;
import pageDB_model.Category;
import pageDB_model.Page;
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

@WebServlet("/api/getpagecontent")


public class GetPageContent extends PageDBServlet {

    private Map<String, String> checkPageDB(DataModel dm, Map<String, String> reqParams) throws SQLException {
        String id = reqParams.get("id");

        Map<String, String> output = new HashMap<String, String>();
        /* Ensure id exists */
        List<String> params = new ArrayList<String>();
        params.add(id);
        int count = dm.executeAggregateQuery("CALL CountPageId(?);", params);
        if (count == 0) {
            String msg = String.format("Page Id {%s} does not exist", id);
            output.put("error", msg);
            return output;
        }

        Page pg = dm.getPageForQuery("CALL GetPageById(?);", params);

        if (pg == null) {
            String msg = String.format("Unable to retrieve page");
            output.put("error", msg);
            return output;
        }
        if (pg.content() == null) {
            pg.content("");
        }

        output.put("content", pg.content());
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
        } catch(PageDBServletException e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error GetPageContent\n" + trace);
            output.put("error", e.getMessage());
        } catch(Exception e) {
            String trace = ExceptionUtils.getStackTrace(e);
            System.out.println("Error GetPageContent\n" + trace);
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
