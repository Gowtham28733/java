package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/toggleStaffStatus")
public class ToggleStaffStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("status");

        String newStatus;

        if ("Active".equals(currentStatus)) {
            newStatus = "Inactive";
        } else {
            newStatus = "Active";
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE staff SET status=? WHERE id=?"
            );

            ps.setString(1, newStatus);
            ps.setInt(2, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-staff.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-staff.jsp?error=status");
        }
    }
}