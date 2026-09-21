<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
Integer selectedBranchId = (Integer) session.getAttribute("customerBranchId");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Royal Taste Hotel</title>

    <link rel="stylesheet" href="style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<header>
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste</span>
    </div>

    <nav>
        <a href="index.jsp">Home</a>
        <a href="main-course.jsp">Main Course</a>
        <a href="starters.jsp">Starters</a>
        <a href="dessert.jsp">Dessert</a>
        <a href="cold-drinks.jsp">Cold Drinks</a>
        <a href="fresh-juice.jsp">Fresh Juice</a>
        <a href="reservation.jsp" class="reserve-btn">Reservation</a>
    </nav>

    <form action="set-branch.jsp"
          method="post"
          class="branch-select-form">

        <select name="branchId"
                required
                onchange="this.form.submit()">

            <option value="">Select Branch</option>

            <%
            try {
                Connection branchCon = DBConnection.getConnection();

                PreparedStatement branchPs = branchCon.prepareStatement(
                    "SELECT * FROM branches WHERE status='Active' ORDER BY id ASC"
                );

                ResultSet branchRs = branchPs.executeQuery();

                while (branchRs.next()) {
                    int branchId = branchRs.getInt("id");
            %>

            <option value="<%= branchId %>"
                    <%= selectedBranchId != null && selectedBranchId == branchId ? "selected" : "" %>>

                <%= branchRs.getString("branch_name") %>
                -
                <%= branchRs.getString("location") %>

            </option>

            <%
                }

                branchRs.close();
                branchPs.close();
                branchCon.close();

            } catch (Exception e) {
            %>

            <option value="">Branch Error</option>

            <%
            }
            %>

        </select>

    </form>
</header>

<section class="hero">
    <div class="hero-center-card">
        <h1>Royal Taste Hotel</h1>
        <p>Experience luxury dining with fresh food and premium taste.</p>
    </div>
</section>

<section class="index-services-section" id="services">

    <div class="index-services-overlay">

        <div class="index-services-title">
            <h1>Our Restaurant Services</h1>
            <p>We provide premium food services for every special moment.</p>
        </div>

        <div class="index-services-grid">

            <%
            try {
                Connection con = DBConnection.getConnection();

                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM restaurant_services ORDER BY id ASC"
                );

                ResultSet rs = ps.executeQuery();

                boolean hasService = false;

                while (rs.next()) {
                    hasService = true;
            %>

            <div class="index-service-card">

                <div class="index-service-img">
                    <img src="<%= rs.getString("image") %>"
                         alt="<%= rs.getString("title") %>">
                </div>

                <h2><%= rs.getString("title") %></h2>

                <p><%= rs.getString("description") %></p>

                <%
String serviceLink = rs.getString("button_link");

if (serviceLink == null || serviceLink.trim().equals("")) {
    serviceLink = "reservation.jsp";
}
%>

<a href="<%= serviceLink %>">
    <%= rs.getString("button_text") %>
</a>

            </div>

            <%
                }

                if (!hasService) {
            %>

            <h2 style="color:white; text-align:center;">
                No services available
            </h2>

            <%
                }

                rs.close();
                ps.close();
                con.close();

            } catch (Exception e) {
            %>

            <h2 style="color:white; text-align:center;">
                Error loading services: <%= e.getMessage() %>
            </h2>

            <%
            }
            %>

        </div>

    </div>

</section>

<div class="scroll-dot-wrapper service-dots"></div>

<footer class="footer">
    <div class="footer-container">

        <div class="footer-box">
            <h2>Royal Taste Hotel</h2>
            <p>Experience luxury dining with fresh food and premium taste.</p>
        </div>

        <div class="footer-box">
            <h3>Quick Links</h3>
            <a href="main-course.jsp">Main Course</a>
            <a href="starters.jsp">Starters</a>
            <a href="dessert.jsp">Dessert</a>
            <a href="cold-drinks.jsp">Cold Drinks</a>
            <a href="fresh-juice.jsp">Fresh Juice</a>
            <a href="reservation.jsp">Reservation</a>
        </div>

        <div class="footer-box">
            <h3>Contact</h3>
            <p>Email: royal@taste.com</p>
            <p>Phone: +91 7339060316</p>
            <p>Location: Coimbatore, India</p>
        </div>

        <div class="footer-box">
            <h3>Follow Us</h3>

            <div class="social-icons">
                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                <a href="#"><i class="fa-brands fa-twitter"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
            </div>
        </div>

    </div>
</footer>

<script src="scroll-load.js?v=6000"></script>

</body>
</html>