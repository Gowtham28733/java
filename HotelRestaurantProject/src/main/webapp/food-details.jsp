<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String idStr = request.getParameter("id");

if(idStr == null || idStr.trim().equals("")){
    response.sendRedirect("index.jsp");
    return;
}

int foodId = Integer.parseInt(idStr);
%>

<!DOCTYPE html>
<html>
<head>

    <title>Food Details</title>

    <link rel="stylesheet" href="style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<header>

    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste</span>
    </div>

    <nav>
        <a href="index.jsp">Home</a>
        <a href="main-course.jsp">Main Course</a>
        <a href="starters.jsp">Starters</a>
        <a href="dessert.jsp">Dessert</a>
        <a href="cold-drinks.jsp">Cold Drinks</a>
        <a href="fresh-juice.jsp">Fresh Juice</a>
        <a href="reservation.jsp" class="reserve-btn">Reservation</a>
    </nav>

</header>

<a href="bill.jsp" class="cart-icon">
    <i class="fa-solid fa-cart-shopping"></i>
    <span id="cartCount">0</span>
</a>

<%
try {

    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM foods WHERE id=?"
    );

    ps.setInt(1, foodId);

    ResultSet rs = ps.executeQuery();

    if(rs.next()) {

        String foodName = rs.getString("name");

        String safeFoodName = foodName
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"");

        double price = rs.getDouble("price");

        String details = rs.getString("details");

        if(details == null || details.trim().equals("")){
            details = rs.getString("description");
        }

        PreparedStatement avgPs = con.prepareStatement(
            "SELECT IFNULL(AVG(rating),0) AS avg_rating, COUNT(*) AS total_rating FROM food_ratings WHERE food_id=?"
        );

        avgPs.setInt(1, foodId);

        ResultSet avgRs = avgPs.executeQuery();

        double avgRating = 0;
        int totalRating = 0;

        if(avgRs.next()){
            avgRating = avgRs.getDouble("avg_rating");
            totalRating = avgRs.getInt("total_rating");
        }

        avgRs.close();
        avgPs.close();
%>

<section class="food-detail-page">

    <div class="food-detail-card">

        <!-- IMAGE -->

        <div class="food-detail-img">

            <img src="<%= rs.getString("image") %>"
                 alt="<%= foodName %>">

        </div>

        <!-- DETAILS -->

        <div class="food-detail-info">

            <span class="food-detail-category">
                <%= rs.getString("category") %>
            </span>

            <h1>
                <%= foodName %>
            </h1>

            <!-- RATING -->

            <div class="food-rating">
                ⭐ <%= String.format("%.1f", avgRating) %> / 5
                (<%= totalRating %> Ratings)
            </div>

            <h2>
                ₹<%= price %>
            </h2>

            <p class="food-detail-desc">
                <%= details %>
            </p>

            <!-- ORDER BOX -->

            <div class="detail-order-box">

                <div class="qty-wrapper">

                    <button type="button"
                            onclick="decreaseQty('detailQty')">
                        −
                    </button>

                    <input type="number"
                           id="detailQty"
                           value="1"
                           min="1">

                    <button type="button"
                            onclick="increaseQty('detailQty')">
                        +
                    </button>

                </div>

                <button type="button"
                        class="order-btn"
                        onclick="addToCart('<%= safeFoodName %>', <%= price %>, 'detailQty')">

                    <i class="fa-solid fa-cart-shopping"></i>
                    Add To Cart

                </button>

            </div>

            <!-- SUCCESS MESSAGE -->

            <% if ("success".equals(request.getParameter("rated"))) { %>

                <p class="rating-success">
                    Thank you for your rating!
                </p>

            <% } %>

            <!-- CUSTOMER RATING -->

            <form action="<%= request.getContextPath() %>/addFoodRating"
                  method="post"
                  class="customer-rating-form">

                <input type="hidden"
                       name="foodId"
                       value="<%= foodId %>" />

                <h3>Give Your Rating</h3>

                <div class="rating-row">

                    <select name="rating" required>

                        <option value="">
                            Select Rating
                        </option>

                        <option value="5">
                            ⭐⭐⭐⭐⭐ Excellent
                        </option>

                        <option value="4">
                            ⭐⭐⭐⭐ Good
                        </option>

                        <option value="3">
                            ⭐⭐⭐ Average
                        </option>

                        <option value="2">
                            ⭐⭐ Poor
                        </option>

                        <option value="1">
                            ⭐ Bad
                        </option>

                    </select>

                    <input type="text"
                           name="review"
                           placeholder="Write your review">

                </div>

                <button type="submit">
                    Submit Rating
                </button>

            </form>

            <!-- BACK BUTTON -->

            <a href="javascript:history.back()"
               class="back-food-btn">

                <i class="fa-solid fa-arrow-left"></i>
                Back

            </a>

        </div>

    </div>

</section>

<%
    } else {
%>

<section class="food-detail-page">

    <div class="food-detail-card">

        <h2>Food Not Found</h2>

    </div>

</section>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch(Exception e) {
%>

<section class="food-detail-page">

    <div class="food-detail-card">

        <h2>Error : <%= e.getMessage() %></h2>

    </div>

</section>

<%
}
%>

<script src="order.js"></script>

</body>
</html>