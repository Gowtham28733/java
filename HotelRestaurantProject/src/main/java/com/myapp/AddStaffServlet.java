package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addStaff")
public class AddStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));

            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            int accessFood = request.getParameter("access_food") != null ? 1 : 0;
            int accessOrders = request.getParameter("access_orders") != null ? 1 : 0;
            int accessReservations = request.getParameter("access_reservations") != null ? 1 : 0;
            int accessServices = request.getParameter("access_services") != null ? 1 : 0;
            int accessPayment = request.getParameter("access_payment") != null ? 1 : 0;
            int accessReviews = request.getParameter("access_reviews") != null ? 1 : 0;
            int accessStock = request.getParameter("access_stock") != null ? 1 : 0;

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO staff " +
                "(branch_id, name, username, password, phone, status, " +
                "access_food, access_orders, access_reservations, access_services, " +
                "access_payment, access_reviews, access_stock) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setInt(1, branchId);
            ps.setString(2, name);
            ps.setString(3, username);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setString(6, "Active");
            ps.setInt(7, accessFood);
            ps.setInt(8, accessOrders);
            ps.setInt(9, accessReservations);
            ps.setInt(10, accessServices);
            ps.setInt(11, accessPayment);
            ps.setInt(12, accessReviews);
            ps.setInt(13, accessStock);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(getStaffRedirect(request));

        } catch (Exception e) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Staff Add Error</h1>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
    private String getStaffRedirect(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session != null &&
            session.getAttribute("manager") != null) {

            return "manager-staff.jsp";
        }

        return "manage-staff.jsp";
    }
}