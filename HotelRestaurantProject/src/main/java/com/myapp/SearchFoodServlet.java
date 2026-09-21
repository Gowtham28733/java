package com.myapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/searchFood")
public class SearchFoodServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        String keyword = request.getParameter("keyword");

        HttpSession session = request.getSession(false);

        if (session == null) return;

        Integer branchId =
            (Integer) session.getAttribute("customerBranchId");

        if (branchId == null || keyword == null || keyword.trim().equals("")) {
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM foods " +
                "WHERE branch_id=? " +
                "AND (name LIKE ? OR category LIKE ? OR description LIKE ? OR details LIKE ?) " +
                "ORDER BY id ASC"
            );

            String searchText = "%" + keyword.trim() + "%";

            ps.setInt(1, branchId);
            ps.setString(2, searchText);
            ps.setString(3, searchText);
            ps.setString(4, searchText);
            ps.setString(5, searchText);

            ResultSet rs = ps.executeQuery();

            boolean found = false;

            while (rs.next()) {
                found = true;

                int id = rs.getInt("id");
                String name = rs.getString("name");
                String image = rs.getString("image");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stockQty = rs.getInt("stock_qty");

                String foodStatus = rs.getString("food_status");

                if (foodStatus == null || foodStatus.trim().equals("")) {
                    foodStatus = "Active";
                }

                out.println("<div class='food-card food-scroll-item'>");

                out.println("<a href='food-details.jsp?id=" + id + "'>");
                out.println("<img src='" + request.getContextPath() + "/" + image + "'>");
                out.println("</a>");

                out.println("<h3>" + name + "</h3>");
                out.println("<p>" + description + "</p>");
                out.println("<span>₹" + price + "</span>");

                out.println("<div class='order-box'>");

                if (stockQty <= 0 || "Out of Stock".equalsIgnoreCase(foodStatus)) {

                    out.println("<span class='out-stock-badge'>Out of Stock</span>");

                    out.println("<button type='button' class='order-btn out-stock-btn' disabled>");
                    out.println("Out of Stock");
                    out.println("</button>");

                } else {

                    out.println("<p class='stock-text'>Available: " + stockQty + "</p>");

                    out.println("<button type='button' class='order-btn' onclick=\"window.location.href='food-details.jsp?id=" + id + "'\">");
                    out.println("Add");
                    out.println("</button>");
                }

                out.println("</div>");
                out.println("</div>");
            }

            if (!found) {
                out.println("<h2 style='text-align:center;color:#5a2d0c;width:100%;'>No food found</h2>");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2 style='text-align:center;color:red;width:100%;'>Search error: " + e.getMessage() + "</h2>");
        }
    }
}