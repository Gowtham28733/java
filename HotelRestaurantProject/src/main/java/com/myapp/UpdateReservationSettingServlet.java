package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateReservationSetting")
public class UpdateReservationSettingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));
            String status = request.getParameter("status");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO reservation_settings (branch_id, status) " +
                "VALUES (?, ?) " +
                "ON DUPLICATE KEY UPDATE status=?"
            );

            ps.setInt(1, branchId);
            ps.setString(2, status);
            ps.setString(3, status);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("restaurant-reservations.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("restaurant-reservations.jsp?error=setting");
        }
    }
}