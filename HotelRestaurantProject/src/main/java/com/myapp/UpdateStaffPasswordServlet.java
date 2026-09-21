package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateStaffPassword")
public class UpdateStaffPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String password = request.getParameter("password");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE staff SET password=? WHERE id=?"
            );

            ps.setString(1, password);
            ps.setInt(2, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-staff.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-staff.jsp?error=password");
        }
    }
}