package pageDB_api;

import pageDB_model.DataModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
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

public class AddCategory extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        PrintWriter out = null;
        DataModel dm = null;
        Map<String, String> map = new HashMap<String, String>();
        try {
            response.setContentType("application/json");
            //response.setCharacterEncoding("UTF-8");
            out = response.getWriter();

            String name = request.getParameter("name");
            if (name == null || name.length() == 0) {
                throw new ServletException("null or empty category name");
            }
            dm = new DataModel();
            List<String> params = new ArrayList<String>();
            params.add(name);
            int catCount = dm.executeUpdate("SELECT * FROM categories WHERE name=?;", params);
            map.put("status", "success");
            map.put("message", "m1: " + Integer.toString(catCount));
        } catch(Exception e) {
            System.out.println("Error AddCategory\n" + ExceptionUtils.getStackTrace(e));
            map.put("status", "error");
            map.put("message", "m2");
        } finally {
            if (dm != null) { dm.closeConnection(); }
            Gson gson = new Gson();
            out.write(gson.toJson(map));
            
            out.close();
        }

    }
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        doPost(request, response);
    }

}
