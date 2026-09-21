<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
Integer customerBranchId =
        (Integer) session.getAttribute("customerBranchId");

if (customerBranchId == null) {
    response.sendRedirect("index.jsp");
    return;
}

String selectedBranchName = "";
String selectedBranchLocation = "";

try {

    Connection branchCon = DBConnection.getConnection();

    PreparedStatement branchPs = branchCon.prepareStatement(

        "SELECT branch_name, location " +
        "FROM branches " +
        "WHERE id=? AND status='Active'"

    );

    branchPs.setInt(1, customerBranchId);

    ResultSet branchRs = branchPs.executeQuery();

    if (branchRs.next()) {

        selectedBranchName =
                branchRs.getString("branch_name");

        selectedBranchLocation =
                branchRs.getString("location");

    } else {

        response.sendRedirect("index.jsp");
        return;
    }

    branchRs.close();
    branchPs.close();
    branchCon.close();

} catch (Exception e) {

    e.printStackTrace();
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Payment</title>

<link rel="stylesheet" href="style.css">

</head>

<body onload="loadBill()">

<section class="payment-section">

<div class="payment-card">

<h1>Payment Details</h1>

<table class="bill-table">

<thead>

<tr>
    <th>Item</th>
    <th>Price</th>
    <th>Qty</th>
    <th>Total</th>
    <th>Remove</th>
</tr>

</thead>

<tbody id="billBody"></tbody>

</table>

<h2 id="grandTotal">Total: ₹0</h2>

<form action="<%= request.getContextPath() %>/placeOrder"
      method="post"
      onsubmit="return prepareOrderData()">

<input type="hidden"
       name="branchId"
       value="<%= customerBranchId %>">

<input type="text"
       value="<%= selectedBranchName %> - <%= selectedBranchLocation %>"
       readonly>

<input type="text"
       name="customerName"
       placeholder="Customer Name"
       pattern="[A-Za-z ]+"
       oninput="this.value=this.value.replace(/[^A-Za-z ]/g,'')"
       required>

<input type="text"
       name="phone"
       placeholder="Phone Number"
       maxlength="10"
       minlength="10"
       pattern="[0-9]{10}"
       inputmode="numeric"
       oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);"
       title="Enter exactly 10 digit phone number"
       required>

<select name="paymentMethod"
        id="paymentMethod"
        onchange="showPaymentBox()"
        required>

    <option value="">Select Payment Method</option>
    <option value="Cash">Cash</option>
    <option value="QR Payment">QR Payment</option>
    <option value="Card">Card</option>

</select>

<!-- QR PAYMENT -->

<div class="qr-payment-box"
     id="qrPaymentBox"
     style="display:none;">

<h3>Scan QR To Pay</h3>

<%
String qrImage = "images/my-qr.png";

try {

    Connection qrCon = DBConnection.getConnection();

    PreparedStatement qrPs =
            qrCon.prepareStatement(
                    "SELECT qr_image FROM payment_settings WHERE id=1"
            );

    ResultSet qrRs = qrPs.executeQuery();

    if (qrRs.next()) {

        qrImage = qrRs.getString("qr_image");
    }

    qrRs.close();
    qrPs.close();
    qrCon.close();

} catch (Exception e) {

    qrImage = "images/my-qr.png";
}
%>

<img src="<%= qrImage %>" alt="QR Payment">

<input type="text"
       name="upiTransactionId"
       id="upiTransactionId"
       placeholder="UPI Transaction ID">

</div>

<!-- CARD PAYMENT -->

<div class="card-payment-box"
     id="cardPaymentBox"
     style="display:none;">

<h3>Card Payment</h3>

<input type="text"
       name="cardName"
       id="cardName"
       placeholder="Card Holder Name">

<input type="text"
       name="cardNumber"
       id="cardNumber"
       placeholder="Card Number">

<input type="text"
       name="expiryDate"
       id="expiryDate"
       placeholder="MM/YY">

<input type="password"
       name="cvv"
       id="cvv"
       placeholder="CVV">

</div>

<input type="hidden"
       name="cartData"
       id="cartData">

<button type="submit">
    Pay & Place Order
</button>

</form>

</div>

</section>

<script src="order.js"></script>

</body>
</html>