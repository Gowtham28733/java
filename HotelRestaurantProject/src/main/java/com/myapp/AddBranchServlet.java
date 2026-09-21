package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addBranch")
public class AddBranchServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String branchName = request.getParameter("branchName");
        String location = request.getParameter("location");
        String phone = request.getParameter("phone");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO branches(branch_name, location, phone) VALUES(?,?,?)"
            );
            ps.setString(1, branchName);
            ps.setString(2, location);
            ps.setString(3, phone);
            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-branches.jsp");
        } catch (Exception e) {
            response.getWriter().println("Branch Add Error: " + e.getMessage());
        }
    }
}