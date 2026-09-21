package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteFood")
public class DeleteFoodServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM foods WHERE id=?"
            );

            ps.setInt(1, id);
            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-food.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting food: " + e.getMessage());
        }
    }
}