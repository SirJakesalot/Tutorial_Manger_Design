package pageDB_pages;

import pageDB_model.DataModel;
import pageDB_model.Settings;
import pageDB_model.TreeNode;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/main")

public class MainPage extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DataModel dm = null;
        try {
            dm = new DataModel();
            TreeNode tree = dm.getTree();
            Settings settings = dm.getSettings();
            request.setAttribute("title", "Tutorial Site Main Page");
            request.setAttribute("tree", tree);
            request.setAttribute("settings", settings);
        } catch (Exception e) {
            DataModel.log("MainPage doGet", e);
            request.setAttribute("error", "MainPage error");
        } finally {
            dm.closeConnection();
            request.getRequestDispatcher("jsp/main.jsp").forward(request, response);
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{ 
        doGet(request, response);
    }
}
