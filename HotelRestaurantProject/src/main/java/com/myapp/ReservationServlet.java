package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));
            int tableNo = Integer.parseInt(request.getParameter("tableNo"));

            String customerName = request.getParameter("name");
            String phone = request.getParameter("phone");
            String bookingDate = request.getParameter("bookingDate");
            String bookingTime = request.getParameter("bookingTime");
            int guests = Integer.parseInt(request.getParameter("guests"));
            String message = request.getParameter("message");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO reservations " +
                "(branch_id, customer_name, phone, reservation_date, reservation_time, guests, message, table_no, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')"
            );

            ps.setInt(1, branchId);
            ps.setString(2, customerName);
            ps.setString(3, phone);
            ps.setString(4, bookingDate);
            ps.setString(5, bookingTime);
            ps.setInt(6, guests);
            ps.setString(7, message);
            ps.setInt(8, tableNo);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("reservation.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reservation.jsp?error=1");
        }
    }
}