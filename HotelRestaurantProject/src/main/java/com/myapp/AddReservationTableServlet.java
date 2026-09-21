package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addReservationTable")
public class AddReservationTableServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));
            String tableName = request.getParameter("tableName");
            int capacity = Integer.parseInt(request.getParameter("capacity"));

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO reservation_tables(branch_id, table_name, capacity, status) VALUES(?,?,?,'Active')"
            );

            ps.setInt(1, branchId);
            ps.setString(2, tableName);
            ps.setInt(3, capacity);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("restaurant-reservations.jsp?table=added");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("restaurant-reservations.jsp?error=table");
        }
    }
}