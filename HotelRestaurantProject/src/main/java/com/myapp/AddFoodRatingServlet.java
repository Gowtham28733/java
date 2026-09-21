package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addFoodRating")
public class AddFoodRatingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String review = request.getParameter("review");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO food_ratings(food_id, rating, review) VALUES(?,?,?)"
            );

            ps.setInt(1, foodId);
            ps.setInt(2, rating);
            ps.setString(3, review);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("food-details.jsp?id=" + foodId + "&rated=success");

        } catch (Exception e) {
            response.getWriter().println("Rating Error: " + e.getMessage());
        }
    }
}