package com.myapp;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ownerLogin")
public class OwnerLoginServlet extends HttpServlet {
	
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        if ("admin".equals(user) && "1234".equals(pass)) {

            HttpSession session = request.getSession();
            session.setAttribute("owner", user);

            response.sendRedirect("owner-dashboard.jsp");

        } else {
            response.getWriter().println("Invalid Login!");
        }
    }
}