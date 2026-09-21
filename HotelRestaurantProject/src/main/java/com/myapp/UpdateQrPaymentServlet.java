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

@WebServlet("/updateQrPayment")
@MultipartConfig
public class UpdateQrPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Part qrPart = request.getPart("qrFile");

            if (qrPart == null || qrPart.getSize() == 0) {
                response.getWriter().println("No QR file selected");
                return;
            }

            String fileName = System.currentTimeMillis() + "_" + qrPart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("/images");

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            qrPart.write(uploadPath + File.separator + fileName);

            String qrPath = "images/" + fileName;

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE payment_settings SET qr_image=? WHERE id=1"
            );

            ps.setString(1, qrPath);

            int row = ps.executeUpdate();

            if (row == 0) {
                PreparedStatement insertPs = con.prepareStatement(
                    "INSERT INTO payment_settings(id, qr_image) VALUES(1, ?)"
                );

                insertPs.setString(1, qrPath);
                insertPs.executeUpdate();
                insertPs.close();
            }

            ps.close();
            con.close();

            response.sendRedirect("admin-payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>QR Upload Error</h2>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}