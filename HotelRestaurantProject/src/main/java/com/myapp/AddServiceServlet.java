package com.myapp;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addService")
@MultipartConfig
public class AddServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String buttonText = request.getParameter("buttonText");
        String buttonLink = request.getParameter("buttonLink");

        if (buttonText == null || buttonText.trim().equals("")) {
            buttonText = "Book Now";
        }

        if (buttonLink == null || buttonLink.trim().equals("")) {
            buttonLink = "reservation.jsp";
        }

        String imagePath = "images/default-service.jpg";

        Part filePart = request.getPart("imageFile");

        if (filePart != null &&
            filePart.getSubmittedFileName() != null &&
            !filePart.getSubmittedFileName().trim().equals("")) {

            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + fileName);

            imagePath = "images/" + fileName;
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO restaurant_services " +
                "(title, description, image, button_text, button_link) " +
                "VALUES (?, ?, ?, ?, ?)"
            );

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, imagePath);
            ps.setString(4, buttonText);
            ps.setString(5, buttonLink);

            ps.executeUpdate();

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("owner-services.jsp");
    }
}