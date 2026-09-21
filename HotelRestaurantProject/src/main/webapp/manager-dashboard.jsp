<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String manager = (String) session.getAttribute("manager");
Integer branchId = (Integer) session.getAttribute("branchId");

if (manager == null || branchId == null) {
    response.sendRedirect("manager-login.jsp");
    return;
}

String branchName = "";
String branchLocation = "";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT branch_name, location FROM branches WHERE id=?"
    );

    ps.setInt(1, branchId);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        branchName = rs.getString("branch_name");
        branchLocation = rs.getString("location");
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    branchName = "Branch";
    branchLocation = "";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png">
        <span>Royal Taste Manager</span>
    </div>

    <nav>
        <a href="manager-dashboard.jsp">Dashboard</a>
        <a href="manager-logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="owner-dashboard-page">

    <h1 class="owner-title">Welcome <%= manager %></h1>

    <h2 class="owner-title">
        Branch: <%= branchName %> - <%= branchLocation %>
    </h2>

    <div class="owner-dashboard-section">

        <div class="owner-card">
            <h2>Manage Staff</h2>
            <p>Add staff and give access for your branch.</p>
            <a href="manager-staff.jsp">Open Staff</a>
        </div>

        <div class="owner-card">
            <h2>Manage Food</h2>
            <p>Manage food only for your branch.</p>
            <a href="manage-food.jsp">Open Food</a>
        </div>

        <div class="owner-card">

    <i class="fa-solid fa-qrcode"></i>

    <h2>QR Payment</h2>

    <p>
        View payment details and QR payments
        only for your branch.
    </p>

    <a href="admin-payment.jsp">
        Open Payment
    </a>

</div>

<div class="owner-card">

    <i class="fa-solid fa-bell-concierge"></i>

    <h2>Restaurant Services</h2>

    <p>
        View restaurant services
        for your branch.
    </p>

    <a href="owner-services.jsp">
        Open Services
    </a>

</div>

<div class="owner-card">

    <i class="fa-solid fa-cart-shopping"></i>

    <h2>Customer Orders</h2>

    <p>
        View customer orders
        only for your branch.
    </p>

    <a href="restaurant-orders.jsp">
        Open Orders
    </a>

</div>

<div class="owner-card">

    <i class="fa-solid fa-calendar-check"></i>

    <h2>Reservations</h2>

    <p>
        View reservation table bookings
        only for your branch.
    </p>

    <a href="restaurant-reservations.jsp">
        Open Reservations
    </a>

</div>

<div class="owner-card">

    <i class="fa-solid fa-star"></i>

    <h2>Food Reviews</h2>

    <p>
        View customer ratings and reviews
        only for your branch.
    </p>

    <a href="food-reviews.jsp">
        Open Reviews
    </a>

</div>

<div class="owner-card">
    <i class="fa-solid fa-boxes-stacked"></i>

    <h2>Food Stock</h2>

    <p>
        Update food quantity and stock
        only for your branch.
    </p>

    <a href="manage-food.jsp">
        Open Stock
    </a>
</div>

    </div>

</section>

</body>
</html>