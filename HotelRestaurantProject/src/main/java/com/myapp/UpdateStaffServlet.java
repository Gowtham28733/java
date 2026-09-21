package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateStaff")
public class UpdateStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            String status = request.getParameter("status");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            Connection con = DBConnection.getConnection();

            if (status != null && !status.trim().equals("")) {

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE staff SET status=? WHERE id=?"
                );

                ps.setString(1, status);
                ps.setInt(2, id);

                ps.executeUpdate();
                ps.close();

            } else {

                if (phone == null || !phone.matches("\\d{10}")) {
                    con.close();
                    response.getWriter().println("Phone number must be exactly 10 digits");
                    return;
                }

                int food = request.getParameter("access_food") != null ? 1 : 0;
                int orders = request.getParameter("access_orders") != null ? 1 : 0;
                int reservations = request.getParameter("access_reservations") != null ? 1 : 0;
                int services = request.getParameter("access_services") != null ? 1 : 0;
                int payment = request.getParameter("access_payment") != null ? 1 : 0;
                int reviews = request.getParameter("access_reviews") != null ? 1 : 0;
                int stock = request.getParameter("access_stock") != null ? 1 : 0;

                PreparedStatement ps;

                if (password != null && !password.trim().equals("")) {

                    ps = con.prepareStatement(
                        "UPDATE staff SET phone=?, password=?, access_food=?, access_orders=?, access_reservations=?, access_services=?, access_payment=?, access_reviews=?, access_stock=? WHERE id=?"
                    );

                    ps.setString(1, phone);
                    ps.setString(2, password);
                    ps.setInt(3, food);
                    ps.setInt(4, orders);
                    ps.setInt(5, reservations);
                    ps.setInt(6, services);
                    ps.setInt(7, payment);
                    ps.setInt(8, reviews);
                    ps.setInt(9, stock);
                    ps.setInt(10, id);

                } else {

                    ps = con.prepareStatement(
                        "UPDATE staff SET phone=?, access_food=?, access_orders=?, access_reservations=?, access_services=?, access_payment=?, access_reviews=?, access_stock=? WHERE id=?"
                    );

                    ps.setString(1, phone);
                    ps.setInt(2, food);
                    ps.setInt(3, orders);
                    ps.setInt(4, reservations);
                    ps.setInt(5, services);
                    ps.setInt(6, payment);
                    ps.setInt(7, reviews);
                    ps.setInt(8, stock);
                    ps.setInt(9, id);
                }

                ps.executeUpdate();
                ps.close();
            }

            con.close();
            response.sendRedirect(getStaffRedirect(request));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(getStaffRedirect(request) + "?error=update");
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