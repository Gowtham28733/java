package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/deleteBranch")
public class DeleteBranchServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM branches WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-branches.jsp");
        } catch (Exception e) {
            response.getWriter().println("Branch Delete Error: " + e.getMessage());
        }
    }
}