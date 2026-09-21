<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String orderIdStr = request.getParameter("orderId");

if (orderIdStr == null || orderIdStr.trim().equals("")) {
    out.println("<h2>Invalid Order</h2>");
    return;
}

int orderId = Integer.parseInt(orderIdStr);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Bill</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<section class="success-bill-page">
    <div class="success-bill-card">

        <div class="print-logo">
            <img src="images/logo.png" alt="Royal Taste Logo">
            <h2>Royal Taste Hotel</h2>
            <p>Coimbatore, India</p>
        </div>

        <h1 class="print-title">Order Placed Successfully 🎉</h1>

        <h2 class="print-order-id">
            Customer Order ID: #<%= orderId %>
        </h2>

        <table class="print-bill-table">
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
                double grandTotal = 0;

                try {
                    Connection con = DBConnection.getConnection();

                    PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM order_items WHERE order_id=?"
                    );
                    ps.setInt(1, orderId);

                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        double total = rs.getDouble("total");
                        grandTotal += total;
            %>

            <tr>
                <td><%= rs.getString("item_name") %></td>
                <td>₹<%= rs.getDouble("price") %></td>
                <td><%= rs.getInt("qty") %></td>
                <td>₹<%= total %></td>
            </tr>

            <%
                    }

                    rs.close();
                    ps.close();
                    con.close();

                } catch (Exception e) {
            %>
            <tr>
                <td colspan="4">Error: <%= e.getMessage() %></td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <h2 class="success-total">Grand Total: ₹<%= grandTotal %></h2>

        <div class="bill-action-buttons no-print">
    <button onclick="window.print()" class="print-btn-same">Print / Save PDF</button>
    <a href="index.jsp" class="success-btn-same">Back to Home</a>
    </div>
</section>

<script>
    localStorage.removeItem("cart");
</script>

</body>
</html>