package com.myapp;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/managerLogin")
public class ManagerLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM managers WHERE username=? AND password=? AND status='Active'"
            );

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();

                session.setAttribute("manager", rs.getString("username"));
                session.setAttribute("managerId", rs.getInt("id"));
                session.setAttribute("branchId", rs.getInt("branch_id"));

                response.sendRedirect("manager-dashboard.jsp");
            } else {
                response.sendRedirect("manager-login.jsp?error=invalid");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Manager Login Error: " + e.getMessage());
        }
    }
}