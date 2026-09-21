package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/deleteManager")
public class DeleteManagerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id =
                Integer.parseInt(
                    request.getParameter("id")
                );

            Connection con =
                DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(
                    "DELETE FROM managers WHERE id=?"
                );

            ps.setInt(1, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-manager.jsp");

        } catch(Exception e){

            e.printStackTrace();
        }
    }
}