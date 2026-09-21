<%@ page contentType="text/html;charset=UTF-8" %>
<%
String owner = (String) session.getAttribute("owner");

if (owner == null) {
    response.sendRedirect("owner-login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Owner Dashboard</title>

    <link rel="stylesheet" href="style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<header class="owner-header">

    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste Owner</span>
    </div>

    <nav>
        <a href="manage-branches.jsp">Branches</a>
        <a href="manage-staff.jsp">Staff</a>
        <a href="admin-payment.jsp">QR Payment</a>
        <a href="admin-site-settings.jsp">Settings</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </nav>

</header>

<section class="owner-dashboard-page">

    <div class="owner-dashboard-section">

        <div class="owner-card">
            <i class="fa-solid fa-code-branch"></i>

            <h2>Manage Branches</h2>

            <p>
                Add new branches, delete branches,
                and control branch-wise hotel data.
            </p>

            <a href="manage-branches.jsp">
                Open Branches
            </a>
        </div>
        
        <div class="owner-card">
    <h2>Site Settings</h2>
    <p>Change restaurant name and logo.</p>
    <a href="admin-site-settings.jsp">Open Settings</a>
</div>

        <div class="owner-card">
            <i class="fa-solid fa-utensils"></i>

            <h2>Manage Food</h2>

            <p>
                Add new foods, update prices,
                change food images and categories.
            </p>

            <a href="manage-food.jsp">
                Open Food
            </a>
        </div>

        <div class="owner-card">
            <i class="fa-solid fa-user-shield"></i>

            <h2>Manage Staff</h2>

            <p>
                Add staff, assign branch access,
                and give permission for food, orders and payments.
            </p>

            <a href="manage-staff.jsp">
                Open Staff
            </a>
        </div>

        <div class="owner-card">
            <i class="fa-solid fa-qrcode"></i>

            <h2>QR Payment</h2>

            <p>
                Upload and change payment QR image
                for customer UPI payment.
            </p>

            <a href="admin-payment.jsp">
                Open Payment
            </a>
        </div>
        
        <div class="owner-card">
    <i class="fa-solid fa-user-tie"></i>

    <h2>Manage Managers</h2>

    <p>
        Add branch managers, assign branch access,
        and allow managers to control their branch staff.
    </p>

    <a href="manage-manager.jsp">
        Open Managers
    </a>
</div>

        <div class="owner-card">
            <i class="fa-solid fa-bell-concierge"></i>

            <h2>Restaurant Services</h2>

            <p>
                Add luxury dining services shown in
                index home page scroll section.
            </p>

            <a href="owner-services.jsp">
                Open Services
            </a>
        </div>

        <div class="owner-card">
            <i class="fa-solid fa-cart-shopping"></i>

            <h2>Customer Orders</h2>

            <p>
                View customer food orders,
                print bills and update delivery status.
            </p>

            <a href="restaurant-orders.jsp">
                Open Orders
            </a>
        </div>

        <div class="owner-card">
            <i class="fa-solid fa-calendar-check"></i>

            <h2>Reservations</h2>

            <p>
                View all customer table bookings
                and reservation details instantly.
            </p>

            <a href="restaurant-reservations.jsp">
                Open Reservations
            </a>
        </div>
        
        <div class="owner-card">
    <h2>Food Reviews</h2>
    <p>View customer ratings and reviews.</p>
    <a href="food-reviews.jsp">Open Reviews</a>
    
</div>

    </div>

</section>

</body>
</html>