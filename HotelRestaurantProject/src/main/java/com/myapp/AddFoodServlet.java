package com.myapp;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addFood")
@MultipartConfig
public class AddFoodServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));
            int stockQty = Integer.parseInt(request.getParameter("stockQty"));

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String details = request.getParameter("details");
            double price = Double.parseDouble(request.getParameter("price"));

            String category = request.getParameter("category");
            String newCategory = request.getParameter("newCategory");
            String foodStatus = request.getParameter("foodStatus");

            if ("new".equals(category)) {
                category = newCategory;
            }

            Part imagePart = request.getPart("imageFile");

            String imagePath = "images/no-image.png";

            if (imagePart != null &&
                imagePart.getSubmittedFileName() != null &&
                !imagePart.getSubmittedFileName().trim().equals("")) {

                String fileName =
                        System.currentTimeMillis() + "_" +
                        imagePart.getSubmittedFileName();

                String uploadPath =
                        getServletContext().getRealPath("/images");

                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                imagePart.write(uploadPath + File.separator + fileName);

                imagePath = "images/" + fileName;
            }

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO foods " +
                "(branch_id, name, description, details, price, category, image, stock_qty, food_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setInt(1, branchId);
            ps.setString(2, name);
            ps.setString(3, description);
            ps.setString(4, details);
            ps.setDouble(5, price);
            ps.setString(6, category);
            ps.setString(7, imagePath);
            ps.setInt(8, stockQty);
            ps.setString(9, foodStatus);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-food.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Food Add Error</h2>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}