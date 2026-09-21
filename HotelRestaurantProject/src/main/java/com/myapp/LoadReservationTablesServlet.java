package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/loadReservationTables")
public class LoadReservationTablesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT id, table_name " +
                "FROM reservation_tables " +
                "WHERE branch_id=? AND status='Active' " +
                "ORDER BY id ASC"
            );

            ps.setInt(1, branchId);

            ResultSet rs = ps.executeQuery();

            StringBuilder options = new StringBuilder();

            options.append("<option value=''>Select Table Type</option>");

            while (rs.next()) {
                options.append("<option value='")
                       .append(rs.getInt("id"))
                       .append("'>")
                       .append(rs.getString("table_name"))
                       .append("</option>");
            }

            rs.close();
            ps.close();
            con.close();

            response.getWriter().write(options.toString());

        } catch (Exception e) {
            response.getWriter().write("<option value=''>Table Error</option>");
        }
    }
}