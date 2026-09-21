<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String staff = (String) session.getAttribute("staff");
Integer staffBranchId = (Integer) session.getAttribute("branchId");

if (staff == null || staffBranchId == null) {
    response.sendRedirect("staff-login.jsp");
    return;
}

Integer accessReservations = (Integer) session.getAttribute("access_reservations");
Integer accessFood = (Integer) session.getAttribute("access_food");
Integer accessServices = (Integer) session.getAttribute("access_services");
Integer accessOrders = (Integer) session.getAttribute("access_orders");
Integer accessPayment = (Integer) session.getAttribute("access_payment");

if (accessReservations == null || accessReservations != 1) {
    response.sendRedirect("staff-no-access.jsp");
    return;
}

if (accessFood == null) accessFood = 0;
if (accessServices == null) accessServices = 0;
if (accessOrders == null) accessOrders = 0;
if (accessPayment == null) accessPayment = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Reservations</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header class="owner-header no-print">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste Staff</span>
    </div>

    <nav>
        <a href="staff-dashboard.jsp">Dashboard</a>

        <% if (accessFood == 1) { %>
            <a href="staff-manage-food.jsp">Manage Food</a>
        <% } %>

        <% if (accessServices == 1) { %>
            <a href="staff-services.jsp">Services</a>
        <% } %>

        <% if (accessOrders == 1) { %>
            <a href="staff-orders.jsp">Orders</a>
        <% } %>

        <a href="staff-reservations.jsp">Reservations</a>

        <% if (accessPayment == 1) { %>
            <a href="staff-orders.jsp">Payment</a>
        <% } %>

        <a href="staff-logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

    <h1 class="owner-title no-print">Staff Customer Reservations</h1>

    <div class="order-search-box no-print">
        <input type="text" id="reserveSearch"
               placeholder="Search name, phone, date..."
               onkeyup="filterReservations()">
    </div>

    <div id="noReserveMsg"
         style="display:none; text-align:center; color:#5a2d0c; font-weight:bold; margin-top:20px;">
        No reservations found ❌
    </div>

    <table class="bill-table" id="reservationTable">
        <thead>
        <tr>
            <th>ID</th>
            <th>Customer Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Table Type</th>
            <th>Date</th>
            <th>Time</th>
            <th>Guests</th>
            <th>Booked At</th>
        </tr>
        </thead>

        <tbody>
        <%
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM reservations ORDER BY id ASC"
            );

            ResultSet rs = ps.executeQuery();

            boolean hasData = false;

            while (rs.next()) {
                hasData = true;
        %>

        <tr class="reservation-row">
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("table_type") %></td>
            <td><%= rs.getString("date") %></td>
            <td><%= rs.getString("time") %></td>
            <td><%= rs.getInt("guests") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>

        <%
            }

            if (!hasData) {
        %>
        <tr>
            <td colspan="9">No reservations found</td>
        </tr>
        <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="9">Error: <%= e.getMessage() %></td>
        </tr>
        <%
        }
        %>
        </tbody>
    </table>

</section>

<script>
function filterReservations() {
    let input = document.getElementById("reserveSearch");
    let filter = input.value.toLowerCase();
    let rows = document.querySelectorAll(".reservation-row");
    let found = false;

    rows.forEach(function(row) {
        let text = row.innerText.toLowerCase();

        if (text.includes(filter)) {
            row.style.display = "";
            found = true;
        } else {
            row.style.display = "none";
        }
    });

    let msg = document.getElementById("noReserveMsg");

    if (msg) {
        msg.style.display = found ? "none" : "block";
    }
}
</script>

</body>
</html>