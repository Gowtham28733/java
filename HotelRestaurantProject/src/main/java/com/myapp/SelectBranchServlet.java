package com.myapp;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/selectBranch")
public class SelectBranchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int branchId =
                Integer.parseInt(
                    request.getParameter("branchId")
                );

            String branchName =
                request.getParameter("branchName");

            String branchLocation =
                request.getParameter("branchLocation");

            HttpSession session =
                request.getSession();

            session.setAttribute(
                "customerBranchId",
                branchId
            );

            session.setAttribute(
                "customerBranchName",
                branchName
            );

            session.setAttribute(
                "customerBranchLocation",
                branchLocation
            );

            response.sendRedirect("index.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("index.jsp");
        }
    }
}