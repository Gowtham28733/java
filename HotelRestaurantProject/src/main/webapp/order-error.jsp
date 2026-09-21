<%@ page contentType="text/html;charset=UTF-8" %>

<%
String msg = request.getParameter("msg");

if (msg == null || msg.trim().equals("")) {
    msg = "Something went wrong while placing your order.";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Error</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<section class="order-error-page">

    <div class="order-error-card">

        <h1>Order Error</h1>

        <p><%= msg %></p>

        <a href="bill.jsp" class="back-food-btn">
            Back To Cart
        </a>

        <a href="main-course.jsp" class="back-food-btn">
            Continue Order
        </a>

    </div>

</section>

</body>
</html>