package pageDB_pages;

import pageDB_model.DataModel;
import pageDB_model.TreeNode;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/manage-pages")


public class ManagePagesPage extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        DataModel dm = null;
        try {
            dm = new DataModel();
            TreeNode tree = dm.getTree();
            request.setAttribute("title", "Manage Pages");
            request.setAttribute("tree", tree);
        } catch (Exception e) {
            DataModel.log("MainPage doGet", e);
            request.setAttribute("err", "ManagePagesPage error");
        } finally {
            dm.closeConnection();
            request.getRequestDispatcher("jsp/manage-pages.jsp").forward(request, response);
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException { 
        doGet(request, response);
    }
}
