<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String owner = (String) session.getAttribute("owner");
String admin = (String) session.getAttribute("admin");
String staff = (String) session.getAttribute("staff");
String manager = (String) session.getAttribute("manager");

Integer branchId = (Integer) session.getAttribute("branchId");

boolean isOwnerAdmin =
(owner != null || admin != null);

boolean isStaff =
(staff != null || manager != null);

Integer staffBranchId = branchId;

if (owner == null && admin == null && staff == null && manager == null) {
    response.sendRedirect("manager-login.jsp");
    return;
}

String dashboardLink = "owner-dashboard.jsp";
String logoutLink = "logout.jsp";
String panelTitle = "Royal Taste Owner";

if (manager != null) {
    dashboardLink = "manager-dashboard.jsp";
    logoutLink = "manager-logout.jsp";
    panelTitle = "Royal Taste Manager";
} else if (staff != null) {
    dashboardLink = "staff-dashboard.jsp";
    logoutLink = "staff-logout.jsp";
    panelTitle = "Royal Taste Staff";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Orders</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header no-print">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span><%= panelTitle %></span>
    </div>

    <nav>
        <a href="<%= dashboardLink %>">Dashboard</a>
        <a href="<%= logoutLink %>" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

<h1 class="owner-title no-print">Customer Orders</h1>

<div class="order-search-box no-print">
    <input type="text"
           id="orderSearch"
           placeholder="Search customer name, phone, order id, branch, status..."
           onkeyup="filterOrders()">
</div>

<div class="owner-export-buttons no-print">
    <button onclick="downloadOrdersExcel()" class="accept-btn">⬇ Excel Sheet</button>
    <button onclick="downloadOrdersPDF()" class="print-btn owner-print-btn">📄 PDF</button>
</div>

<div id="noOrderMsg"
     style="display:none; text-align:center; color:#5a2d0c; font-weight:bold; margin-top:20px;">
    No orders found ❌
</div>

<%
try {

    Connection con = DBConnection.getConnection();

    PreparedStatement ps;

    if (owner != null || admin != null) {

        ps = con.prepareStatement(
            "SELECT o.*, b.branch_name, b.location " +
            "FROM orders o " +
            "LEFT JOIN branches b ON o.branch_id = b.id " +
            "ORDER BY o.id ASC"
        );

    } else {

        ps = con.prepareStatement(
            "SELECT o.*, b.branch_name, b.location " +
            "FROM orders o " +
            "LEFT JOIN branches b ON o.branch_id = b.id " +
            "WHERE o.branch_id = ? " +
            "ORDER BY o.id ASC"
        );

        ps.setInt(1, staffBranchId);
    }

    ResultSet rs = ps.executeQuery();

    boolean hasOrders = false;

    while (rs.next()) {
        hasOrders = true;

        int orderId = rs.getInt("id");

        String customerName = rs.getString("customer_name");
        String phone = rs.getString("phone");
        String paymentMethod = rs.getString("payment_method");
        String paymentStatus = rs.getString("payment_status");
        String orderStatus = rs.getString("order_status");

        if (orderStatus == null || orderStatus.trim().equals("")) {
            orderStatus = "Order Placed";
        }

        String statusClass = orderStatus.replace(" ", "").toLowerCase();

        String branchName = rs.getString("branch_name");
        String branchLocation = rs.getString("location");

        if (branchName == null) branchName = "No Branch";
        if (branchLocation == null) branchLocation = "";

        double grandTotal = rs.getDouble("grand_total");

        Timestamp orderDate = rs.getTimestamp("order_date");
%>

<div class="order-card searchable-order" id="order-<%= orderId %>">

    <div class="print-logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <h2>Royal Taste Hotel</h2>
        <p>Coimbatore, India</p>
    </div>

    <div class="order-head">
        <h2>Order #<span class="order-serial"></span></h2>
        <span><%= orderDate %></span>
    </div>

    <p><b>Customer:</b> <%= customerName %></p>
    <p><b>Phone:</b> <%= phone %></p>

    <p>
        <b>Branch:</b>
        <%= branchName %>
        <%= branchLocation.equals("") ? "" : " - " + branchLocation %>
    </p>

    <p><b>Payment:</b> <%= paymentMethod %></p>
    <p><b>Payment Status:</b> <%= paymentStatus %></p>

    <p>
        <b>Status:</b>
        <span class="status <%= statusClass %>">
            <%= orderStatus %>
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
        PreparedStatement itemPs = con.prepareStatement(
            "SELECT * FROM order_items WHERE order_id = ?"
        );

        itemPs.setInt(1, orderId);

        ResultSet itemRs = itemPs.executeQuery();

        boolean hasItems = false;

        while (itemRs.next()) {
            hasItems = true;
        %>

        <tr>
            <td><%= itemRs.getString("item_name") %></td>
            <td>₹<%= itemRs.getDouble("price") %></td>
            <td><%= itemRs.getInt("qty") %></td>
            <td>₹<%= itemRs.getDouble("total") %></td>
        </tr>

        <%
        }

        if (!hasItems) {
        %>

        <tr>
            <td colspan="4">No items found</td>
        </tr>

        <%
        }

        itemRs.close();
        itemPs.close();
        %>

        </tbody>
    </table>

    <h3 class="admin-total">
        Grand Total: ₹<%= grandTotal %>
    </h3>

    <div class="owner-action-buttons no-print">

        <button class="print-btn owner-print-btn"
                onclick="printOrder('order-<%= orderId %>')">
            🖨️ Print Bill
        </button>

        <%
        if ("Pending".equalsIgnoreCase(orderStatus)
                || "Order Placed".equalsIgnoreCase(orderStatus)) {
        %>

        <form action="<%= request.getContextPath() %>/updateOrderStatus"
              method="post"
              class="status-form">

            <input type="hidden" name="orderId" value="<%= orderId %>">

            <button type="submit"
                    name="status"
                    value="Accepted"
                    class="accept-btn">
                Accept
            </button>

            <button type="submit"
                    name="status"
                    value="Rejected"
                    class="reject-btn">
                Reject
            </button>

        </form>

        <%
        } else if ("Accepted".equalsIgnoreCase(orderStatus)) {
        %>

        <form action="<%= request.getContextPath() %>/updateOrderStatus"
              method="post"
              class="status-form">

            <input type="hidden" name="orderId" value="<%= orderId %>">

            <button type="submit"
                    name="status"
                    value="Delivered"
                    class="deliver-btn">
                Mark Delivered
            </button>

        </form>

        <%
        }
        %>

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
    e.printStackTrace();
}
%>
<div id="orderPages" class="table-pagination no-print"></div>
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
        ".status{color:black!important;background:white!important;border:none!important;padding:0!important;box-shadow:none!important;}" +
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

function downloadOrdersExcel() {

    let cards = document.querySelectorAll(".order-card");

    if (cards.length === 0) {
        alert("No orders found");
        return;
    }

    let csv = "";

    csv += "Order ID,Customer,Phone,Branch,Payment,Payment Status,Status,Item,Price,Qty,Total,Grand Total\n";

    cards.forEach(function(card) {

        if (card.style.display === "none") {
            return;
        }

        let orderId = "";
        let customer = "";
        let phone = "";
        let branch = "";
        let payment = "";
        let paymentStatus = "";
        let status = "";
        let grandTotal = "";

        let head = card.querySelector(".order-head h2");
        if (head) {
            orderId = head.innerText.replace("Order #", "").trim();
        }

        card.querySelectorAll("p").forEach(function(p) {
            let text = p.innerText.trim();

            if (text.startsWith("Customer:")) customer = text.replace("Customer:", "").trim();
            if (text.startsWith("Phone:")) phone = text.replace("Phone:", "").trim();
            if (text.startsWith("Branch:")) branch = text.replace("Branch:", "").trim();
            if (text.startsWith("Payment:")) payment = text.replace("Payment:", "").trim();
            if (text.startsWith("Payment Status:")) paymentStatus = text.replace("Payment Status:", "").trim();
            if (text.startsWith("Status:")) status = text.replace("Status:", "").trim();
        });

        let totalBox = card.querySelector(".admin-total");
        if (totalBox) {
            grandTotal = totalBox.innerText.replace("Grand Total:", "").trim();
        }

        card.querySelectorAll(".bill-table tbody tr").forEach(function(row) {

            let cols = row.querySelectorAll("td");

            if (cols.length === 4) {

                csv +=
                    '"' + orderId + '",' +
                    '"' + customer + '",' +
                    '"' + phone + '",' +
                    '"' + branch + '",' +
                    '"' + payment + '",' +
                    '"' + paymentStatus + '",' +
                    '"' + status + '",' +
                    '"' + cols[0].innerText.trim() + '",' +
                    '"' + cols[1].innerText.trim() + '",' +
                    '"' + cols[2].innerText.trim() + '",' +
                    '"' + cols[3].innerText.trim() + '",' +
                    '"' + grandTotal + '"\n';
            }
        });
    });

    let blob = new Blob(["\ufeff" + csv], {
        type: "text/csv;charset=utf-8;"
    });

    let link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "customer_orders.csv";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
</script>

<script src="pagination.js?v=10"></script>

<script>
window.addEventListener("load", function () {

    paginateCards(".order-card", "orderPages", 5);

    let orders = document.querySelectorAll(".order-card");

    orders.forEach(function(card, index) {

        let serial = card.querySelector(".order-serial");

        if (serial) {
            serial.innerText = index + 1;
        }

    });

});
</script>

</body>
</html>