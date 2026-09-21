package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/staffLogin")
public class StaffLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT s.*, b.branch_name, b.location " +
                "FROM staff s " +
                "LEFT JOIN branches b ON s.branch_id = b.id " +
                "WHERE s.username=? AND s.password=? AND s.status='Active'"
            );

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();

                session.removeAttribute("owner");
                session.removeAttribute("admin");

                session.setAttribute("staff", rs.getString("username"));
                session.setAttribute("staffId", rs.getInt("id"));
                session.setAttribute("staffName", rs.getString("name"));
                session.setAttribute("branchId", rs.getInt("branch_id"));
                session.setAttribute("branchName", rs.getString("branch_name"));
                session.setAttribute("branchLocation", rs.getString("location"));

                session.setAttribute("access_food", rs.getInt("access_food"));
                session.setAttribute("access_orders", rs.getInt("access_orders"));
                session.setAttribute("access_reservations", rs.getInt("access_reservations"));
                session.setAttribute("access_services", rs.getInt("access_services"));
                session.setAttribute("access_payment", rs.getInt("access_payment"));
                session.setAttribute("access_reviews", rs.getInt("access_reviews"));
                session.setAttribute("access_stock", rs.getInt("access_stock"));

                rs.close();
                ps.close();
                con.close();

                response.sendRedirect("staff-dashboard.jsp");
                return;

            } else {
                rs.close();
                ps.close();
                con.close();

                response.sendRedirect("staff-login.jsp?error=invalid");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff-login.jsp?error=server");
        }
    }
}