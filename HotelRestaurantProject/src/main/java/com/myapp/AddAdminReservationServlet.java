package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addAdminReservation")
public class AddAdminReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));
            String customerName = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String reservationDate = request.getParameter("reservationDate");
            String reservationTime = request.getParameter("reservationTime");
            int guests = Integer.parseInt(request.getParameter("guests"));
            String message = request.getParameter("message");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO reservations " +
                "(branch_id, customer_name, phone, reservation_date, reservation_time, guests, message, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'Accepted')"
            );

            ps.setInt(1, branchId);
            ps.setString(2, customerName);
            ps.setString(3, phone);
            ps.setString(4, reservationDate);
            ps.setString(5, reservationTime);
            ps.setInt(6, guests);
            ps.setString(7, message);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("restaurant-reservations.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("restaurant-reservations.jsp?error=add");
        }
    }
}