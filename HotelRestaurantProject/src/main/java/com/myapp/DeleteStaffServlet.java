package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;

@WebServlet("/deleteStaff")
public class DeleteStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM staff WHERE id=?"
            );

            ps.setInt(1, id);
            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(getStaffRedirect(request));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(getStaffRedirect(request) + "?error=delete");
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