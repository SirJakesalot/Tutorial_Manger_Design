package pageDB_model;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;

import java.util.Map;

import com.google.gson.Gson;

//import org.apache.commons.lang3.exception.ExceptionUtils;

public class PageDBServlet extends HttpServlet {
    public DataModel dm = null;
    public static void checkRequestParams(Map<String, String> params) throws ServletException {
        for (Map.Entry<String, String> entry: params.entrySet()) {
            String val = entry.getValue();
            if (val == null || val.isEmpty()) {
                Gson gson = new Gson();
                String msg = String.format("null or empty param {%s} in %s", entry.getKey(), gson.toJson(params));
                throw new ServletException(msg);
            }
        }
    }
}
