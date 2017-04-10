package pageDB_pages;

import pageDB_model.DataModel;
import pageDB_model.TreeNode;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/settings")

public class SettingsPage extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DataModel dm = null;
        try {
            dm = new DataModel();
            TreeNode tree = dm.getTree();
            request.setAttribute("title", "Tutorial Site Settings Page");
            request.setAttribute("tree", tree);
        } catch (Exception e) {
            DataModel.log("SettingsPage doGet", e);
            request.setAttribute("error", "SettingsPage error");
        } finally {
            dm.closeConnection();
            request.getRequestDispatcher("jsp/settings.jsp").forward(request, response);
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{ 
        doGet(request, response);
    }
}
