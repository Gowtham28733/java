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

Integer accessOrders = (Integer) session.getAttribute("access_orders");
Integer accessFood = (Integer) session.getAttribute("access_food");
Integer accessServices = (Integer) session.getAttribute("access_services");
Integer accessReservations = (Integer) session.getAttribute("access_reservations");
Integer accessPayment = (Integer) session.getAttribute("access_payment");

if ((accessOrders == null || accessOrders != 1) && (accessPayment == null || accessPayment != 1)) {
    response.sendRedirect("staff-no-access.jsp");
    return;
}

if (accessFood == null) accessFood = 0;
if (accessServices == null) accessServices = 0;
if (accessReservations == null) accessReservations = 0;
if (accessPayment == null) accessPayment = 0;
if (accessOrders == null) accessOrders = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Orders</title>
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

        <% if (accessReservations == 1) { %>
            <a href="staff-reservations.jsp">Reservations</a>
        <% } %>

        <% if (accessPayment == 1) { %>
            <a href="staff-orders.jsp">Payment</a>
        <% } %>

        <a href="staff-logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

<h1 class="owner-title no-print">Staff Customer Orders</h1>

<div class="order-search-box no-print">
    <input type="text" id="orderSearch"
           placeholder="Search customer name, phone, order id, status..."
           onkeyup="filterOrders()">
</div>

<div id="noOrderMsg"
     style="display:none; text-align:center; color:#5a2d0c; font-weight:bold; margin-top:20px;">
    No orders found ❌
</div>

<%
try {
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM orders ORDER BY id ASC");
    ResultSet rs = ps.executeQuery();

    boolean hasOrders = false;

    while (rs.next()) {
        hasOrders = true;

        int orderId = rs.getInt("id");
        String status = rs.getString("status");

        if (status == null) {
            status = "Pending";
        }
%>

<div class="order-card" id="order-<%= orderId %>">

    <div class="print-logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <h2>Royal Taste Hotel</h2>
        <p>Coimbatore, India</p>
    </div>

    <div class="order-head">
        <h2>Order #<%= orderId %></h2>
        <span><%= rs.getTimestamp("created_at") %></span>
    </div>

    <p><b>Customer:</b> <%= rs.getString("customer_name") %></p>
    <p><b>Phone:</b> <%= rs.getString("phone") %></p>
    <p><b>Payment:</b> <%= rs.getString("payment_method") %></p>

    <p>
        <b>Status:</b>
        <span class="status <%= status.toLowerCase() %>">
            <%= status %>
        </span>
    </p>

    <table class="bill-table">
        <thead>
        <tr>
            <th>Item</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Total</th>
        </tr>
        </thead>

        <tbody>
        <%
        PreparedStatement itemPs = con.prepareStatement("SELECT * FROM order_items WHERE order_id = ?");
        itemPs.setInt(1, orderId);
        ResultSet itemRs = itemPs.executeQuery();

        while (itemRs.next()) {
        %>

        <tr>
            <td><%= itemRs.getString("item_name") %></td>
            <td>₹<%= itemRs.getDouble("price") %></td>
            <td><%= itemRs.getInt("qty") %></td>
            <td>₹<%= itemRs.getDouble("total") %></td>
        </tr>

        <%
        }

        itemRs.close();
        itemPs.close();
        %>
        </tbody>
    </table>

    <h3 class="admin-total">Grand Total: ₹<%= rs.getDouble("grand_total") %></h3>

    <div class="owner-action-buttons no-print">

        <button class="print-btn owner-print-btn" onclick="printOrder('order-<%= orderId %>')">
            🖨️ Print Bill
        </button>

        <% if (accessOrders == 1) { %>

            <% if ("Pending".equals(status)) { %>
            <form action="<%= request.getContextPath() %>/updateOrderStatus" method="post" class="status-form">
                <input type="hidden" name="orderId" value="<%= orderId %>">

                <button type="submit" name="status" value="Accepted" class="accept-btn">
                    Accept
                </button>

                <button type="submit" name="status" value="Rejected" class="reject-btn">
                    Reject
                </button>
            </form>
            <% } else if ("Accepted".equals(status)) { %>
            <form action="<%= request.getContextPath() %>/updateOrderStatus" method="post" class="status-form">
                <input type="hidden" name="orderId" value="<%= orderId %>">

                <button type="submit" name="status" value="Delivered" class="deliver-btn">
                    Mark Delivered
                </button>
            </form>
            <% } %>

        <% } %>

    </div>

</div>

<%
    }

    if (!hasOrders) {
%>
<div class="empty-admin">
    <h2>No orders found</h2>
</div>
<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
%>
<div class="empty-admin">
    <h2>Error loading orders</h2>
    <p><%= e.getMessage() %></p>
</div>
<%
}
%>

</section>

<script>
function filterOrders() {
    let input = document.getElementById("orderSearch");
    let filter = input.value.toLowerCase();
    let cards = document.querySelectorAll(".order-card");
    let found = false;

    cards.forEach(function(card) {
        let text = card.innerText.toLowerCase();

        if (text.includes(filter)) {
            card.style.display = "block";
            found = true;
        } else {
            card.style.display = "none";
        }
    });

    let msg = document.getElementById("noOrderMsg");

    if (msg) {
        msg.style.display = found ? "none" : "block";
    }
}

function printOrder(id) {
    var orderCard = document.getElementById(id);

    if (!orderCard) {
        alert("Order not found");
        return;
    }

    var content = orderCard.innerHTML;
    var w = window.open("", "_blank", "width=900,height=700");

    w.document.open();

    w.document.write(
        "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "<title>Print Bill</title>" +
        "<style>" +
        "body{font-family:Arial,sans-serif;background:white;color:black;padding:25px;margin:0;}" +
        ".owner-action-buttons,.no-print,form,button{display:none!important;}" +
        ".order-card{width:100%!important;background:white!important;color:black!important;box-shadow:none!important;border:none!important;padding:0!important;}" +
        ".print-logo{display:block!important;text-align:center!important;border-bottom:1px dashed black;padding-bottom:10px;margin-bottom:12px;}" +
        ".print-logo img{width:85px;height:85px;object-fit:contain;display:block;margin:0 auto;}" +
        ".print-logo h2{margin:5px 0;font-size:24px;color:black;}" +
        ".print-logo p{margin:0;font-size:14px;color:black;}" +
        ".order-head{text-align:center;border-bottom:1px dashed black;padding-bottom:10px;margin-bottom:12px;}" +
        ".order-head h2{margin:5px 0;font-size:22px;color:black;}" +
        ".order-head span{font-size:14px;color:black;}" +
        "p{font-size:15px;margin:7px 0;color:black;}" +
        ".status{color:black!important;background:white!important;border:none!important;padding:0!important;}" +
        ".bill-table{width:100%;border-collapse:collapse;margin-top:15px;}" +
        ".bill-table th,.bill-table td{border:1px solid black;padding:9px;text-align:center;color:black;font-size:14px;}" +
        ".bill-table th{background:#eeeeee;font-weight:bold;}" +
        ".admin-total{text-align:right;margin-top:15px;font-size:20px;color:black;border-top:2px solid black;padding-top:10px;}" +
        ".thank-you{margin-top:22px;text-align:center;font-size:15px;font-weight:bold;border-top:1px dashed black;padding-top:12px;color:black;}" +
        "</style>" +
        "</head>" +
        "<body>" +
        "<div class='order-card'>" +
        content +
        "</div>" +
        "<div class='thank-you'>" +
        "------------------------------ <br>" +
        "Thank You! Visit Again 😊" +
        "</div>" +
        "</body>" +
        "</html>"
    );

    w.document.close();

    setTimeout(function () {
        w.focus();
        w.print();
    }, 700);
}
</script>

</body>
</html>