package com.myapp;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/updateSiteSettings")
@MultipartConfig
public class UpdateSiteSettingsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String restaurantName =
                    request.getParameter("restaurantName");

            String oldLogo =
                    request.getParameter("oldLogo");

            String logoPath = oldLogo;

            Part logoPart =
                    request.getPart("logoFile");

            if (logoPart != null &&
                logoPart.getSubmittedFileName() != null &&
                !logoPart.getSubmittedFileName().trim().equals("")) {

                String fileName =
                        System.currentTimeMillis()
                        + "_"
                        + logoPart.getSubmittedFileName();

                String uploadPath =
                        getServletContext().getRealPath("/images");

                File uploadDir =
                        new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                logoPart.write(
                        uploadPath + File.separator + fileName
                );

                logoPath =
                        "images/" + fileName;
            }

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                        "UPDATE site_settings " +
                        "SET restaurant_name=?, logo_image=? " +
                        "WHERE id=1"
                    );

            ps.setString(1, restaurantName);
            ps.setString(2, logoPath);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(
                    "admin-site-settings.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<h2>Site Settings Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}