<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Bill</title>
    <link rel="stylesheet" href="style.css">
</head>

<body onload="loadBill()">

<header>
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste</span>
    </div>
</header>

<section class="bill-page">

    <h1>Your Order Bill</h1>

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
 
        <tbody id="billBody">
        <tr>
            <td colspan="5">No items ordered yet</td>
        </tr>
        </tbody>
    </table>

    <h2 id="grandTotal">Total: ₹0</h2>

    <div class="bill-buttons">
    <button type="button" onclick="clearCart()">Clear Cart</button>

    <button type="button" onclick="goPayment('<%= request.getContextPath() %>')">
        Proceed Payment
    </button>
</div>

</section>

<script src="order.js"></script>

</body>
</html>