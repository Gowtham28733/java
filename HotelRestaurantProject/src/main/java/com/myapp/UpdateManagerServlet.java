package com.myapp;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateManager")
public class UpdateManagerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String password = request.getParameter("password");

            Connection con = DBConnection.getConnection();
            PreparedStatement ps;
             
            
            
            if (phone == null || !phone.matches("\\d{10}")) {
                response.getWriter().println("Phone number must be exactly 10 digits");
                return;
            }
            
            if (status != null && !status.trim().equals("")) {
                ps = con.prepareStatement("UPDATE managers SET status=? WHERE id=?");
                ps.setString(1, status);
                ps.setInt(2, id);
            } else if (password != null && !password.trim().equals("")) {
                ps = con.prepareStatement("UPDATE managers SET phone=?, password=? WHERE id=?");
                ps.setString(1, phone);
                ps.setString(2, password);
                ps.setInt(3, id);
            } else {
                ps = con.prepareStatement("UPDATE managers SET phone=? WHERE id=?");
                ps.setString(1, phone);
                ps.setInt(2, id);
            }

            ps.executeUpdate();
            ps.close();
            con.close();

            response.sendRedirect("manage-manager.jsp");

        } catch (Exception e) {
            response.getWriter().println("Manager Update Error: " + e.getMessage());
        }
    }
}