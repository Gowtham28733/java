package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateReservationStatus")
public class UpdateReservationStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE reservations SET status=? WHERE id=?"
            );

            ps.setString(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("restaurant-reservations.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("restaurant-reservations.jsp?error=status");
        }
    }
}