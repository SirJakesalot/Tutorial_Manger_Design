package pageDB_model;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import java.util.Map;
import com.google.gson.Gson;


public class PageDBServlet extends HttpServlet {
    public DataModel dm = null;

    public static void checkRequestParams(Map<String, String> params) throws ServletException {
        for (Map.Entry<String, String> entry: params.entrySet()) {
            String val = entry.getValue();
            if (val == null || val.isEmpty()) {
                Gson gson = new Gson();
                String msg = String.format("%s cannot be null or empty!", entry.getKey());
                throw new PageDBServletException(msg);
            }
        }
    }
}
