<%@ page contentType="text/html;charset=UTF-8" %>

<%
String staffName = (String) session.getAttribute("staffName");
String branchName = (String) session.getAttribute("branchName");
String branchLocation = (String) session.getAttribute("branchLocation");

if (staffName == null) {
    response.sendRedirect("staff-login.jsp");
    return;
}

if (branchName == null) {
    branchName = "No Branch";
}

if (branchLocation == null) {
    branchLocation = "";
}

Integer accessFood = (Integer) session.getAttribute("access_food");
Integer accessOrders = (Integer) session.getAttribute("access_orders");
Integer accessReservations = (Integer) session.getAttribute("access_reservations");
Integer accessServices = (Integer) session.getAttribute("access_services");
Integer accessPayment = (Integer) session.getAttribute("access_payment");
Integer accessStock = (Integer) session.getAttribute("access_stock");
Integer accessReviews = (Integer) session.getAttribute("access_reviews");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard</title>

    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header">

    <div class="logo">
        <img src="images/logo.png" alt="Logo">
        <span>Royal Taste Staff</span>
    </div>

    <nav>
        <a href="staff-dashboard.jsp">Dashboard</a>

        <a href="staff-logout.jsp"
           class="logout-btn">
            Logout
        </a>
    </nav>

</header>

<section class="owner-dashboard-page">

    <h1 class="owner-title">
        Welcome <%= staffName %>
    </h1>

    <h2 style="
        text-align:center;
        color:#5a2d0c;
        margin-bottom:35px;
        font-size:34px;
        font-weight:bold;
    ">
        Branch:
        <%= branchName %> -
        <%= branchLocation %>
    </h2>

    <div class="owner-dashboard-section">

        <% if (accessFood != null && accessFood == 1) { %>

        <div class="owner-card">

            <h2>Manage Food</h2>

            <p>
                Manage food only for your branch.
            </p>

            <a href="manage-food.jsp">
                Open Food
            </a>

        </div>

        <% } %>



        <% if (accessOrders != null && accessOrders == 1) { %>

        <div class="owner-card">

            <h2>Branch Orders</h2>

            <p>
                View branch orders.
            </p>

            <a href="restaurant-orders.jsp">
                Open Orders
            </a>
            
        </div>

        <% } %>



        <% if (accessReservations != null && accessReservations == 1) { %>

        <div class="owner-card">

            <h2>Reservations</h2>

            <p>
                View branch reservations.
            </p>

            <a href="restaurant-reservations.jsp">
                Open Reservations
            </a>

        </div>

        <% } %>



        <% if (accessServices != null && accessServices == 1) { %>

        <div class="owner-card">

            <h2>Services</h2>

            <p>
                Manage services.
            </p>

            <a href="owner-services.jsp">
                Open Services
            </a>

        </div>

        <% } %>



        <% if (accessPayment != null && accessPayment == 1) { %>

        <div class="owner-card">

            <h2>QR Payment</h2>

            <p>
                Manage payment QR.
            </p>

            <a href="admin-payment.jsp">
                Open Payment
            </a>

        </div>

        <% } %>



        <% if (accessStock != null && accessStock == 1) { %>

        <div class="owner-card">

            <h2>Food Stock</h2>

            <p>
                Manage food stock quantity.
            </p>

            <a href="manage-food.jsp">
                Open Stock
            </a>

        </div>

        <% } %>



        <% if (accessReviews != null && accessReviews == 1) { %>

        <div class="owner-card">

            <h2>Food Reviews</h2>

            <p>
                View customer ratings and reviews.
            </p>

            <a href="food-reviews.jsp">
                Open Reviews
            </a>

        </div>

        <% } %>

    </div>

</section>

</body>
</html>