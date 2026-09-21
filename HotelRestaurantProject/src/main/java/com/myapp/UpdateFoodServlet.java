package com.myapp;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateFood")
@MultipartConfig
public class UpdateFoodServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int branchId = Integer.parseInt(request.getParameter("branchId"));

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String details = request.getParameter("details");
            String category = request.getParameter("category");
            String foodStatus = request.getParameter("foodStatus");

            double price = Double.parseDouble(request.getParameter("price"));
            int stockQty = Integer.parseInt(request.getParameter("stockQty"));

            String oldImage = request.getParameter("oldImage");
            String imagePath = oldImage;

            Part imagePart = request.getPart("imageFile");

            if (imagePart != null && imagePart.getSize() > 0) {

                String submittedFileName = imagePart.getSubmittedFileName();

                if (submittedFileName != null && !submittedFileName.trim().equals("")) {

                    String fileName = Paths.get(submittedFileName).getFileName().toString();

                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";

                    File uploadDir = new File(uploadPath);

                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    imagePart.write(uploadPath + File.separator + fileName);

                    imagePath = "images/" + fileName;
                }
            }

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
            	    "UPDATE foods SET branch_id=?, name=?, description=?, details=?, price=?, category=?, image=?, stock_qty=?, food_status=? WHERE id=?"
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
            ps.setInt(10, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("manage-food.jsp");

        } catch (Exception e) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Food Update Error</h1>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}