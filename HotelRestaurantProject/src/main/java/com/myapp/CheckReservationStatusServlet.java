package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/checkReservationStatus")
public class CheckReservationStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT status FROM reservation_settings WHERE branch_id=?"
            );

            ps.setInt(1, branchId);

            ResultSet rs = ps.executeQuery();

            String status = "Open";

            if (rs.next()) {
                status = rs.getString("status");
            }

            rs.close();
            ps.close();
            con.close();

            response.getWriter().write(status);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Open");
        }
    }
}