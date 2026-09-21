package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addManager")
public class AddManagerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int branchId =
                Integer.parseInt(
                    request.getParameter("branchId")
                );

            String name =
                request.getParameter("name");

            String username =
                request.getParameter("username");

            String password =
                request.getParameter("password");

            String phone =
                request.getParameter("phone");

            Connection con =
                DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(

                    "INSERT INTO managers" +
                    "(branch_id,name,username,password,phone,status) " +
                    "VALUES(?,?,?,?,?,?)"

                );

            ps.setInt(1, branchId);
            ps.setString(2, name);
            ps.setString(3, username);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setString(6, "Active");

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-manager.jsp");

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                "Manager Add Error: " + e.getMessage()
            );
        }
    }
}