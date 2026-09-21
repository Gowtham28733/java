<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
Integer customerBranchId = (Integer) session.getAttribute("customerBranchId");

if (customerBranchId == null) {
    response.sendRedirect("index.jsp");
    return;
}

String pageTitle = "Main Course";
String categoryName = "Main Course";
String qtyPrefix = "main_q";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Main Course</title>
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

<section class="page-banner">
    <h1><%= pageTitle %></h1>
    <p>Hot, spicy, and delicious hotel special dishes.</p>
</section>

<div class="food-search-box">
    <input type="text"
           id="foodSearch"
           placeholder="Search all foods..."
           onkeyup="searchAllFoodsFromDB()">
</div>

<section id="searchResultBox"
         class="food-grid search-food-grid"
         style="display:none;">
</section>

<div class="search-food-dots"></div>

<section class="food-grid" id="mainCourseBox">

<%
try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM foods WHERE category=? AND branch_id=? ORDER BY id ASC"
    );

    ps.setString(1, categoryName);
    ps.setInt(2, customerBranchId);

    ResultSet rs = ps.executeQuery();

    int q = 1;
    boolean hasFood = false;

    while (rs.next()) {
        hasFood = true;

        String qtyId = qtyPrefix + q;

        String foodName = rs.getString("name");
        if (foodName == null) foodName = "";

        String safeFoodName = foodName
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"");

        double price = rs.getDouble("price");

        int stockQty = rs.getInt("stock_qty");

        String foodStatus = rs.getString("food_status");

        if (foodStatus == null || foodStatus.trim().equals("")) {
            foodStatus = "Active";
        }
%>
<div class="food-card food-scroll-item">

    <a href="food-details.jsp?id=<%= rs.getInt("id") %>">
        <img src="<%= request.getContextPath() %>/<%= rs.getString("image") %>"
             alt="<%= foodName %>"
             onerror="this.src='<%= request.getContextPath() %>/images/no-image.png'">
    </a>

    <h3><%= foodName %></h3>

    <p><%= rs.getString("description") %></p>

    <span>₹<%= price %></span>

    <div class="order-box">

        <% if (stockQty <= 0 || "Out of Stock".equalsIgnoreCase(foodStatus)) { %>

            <span class="out-stock-badge">Out of Stock</span>

            <button type="button"
                    class="order-btn out-stock-btn"
                    disabled>
                Out of Stock
            </button>

        <% } else { %>

            <p class="stock-text">Available: <%= stockQty %></p>

            <button type="button"
        class="order-btn"
        onclick="window.location.href='food-details.jsp?id=<%= rs.getInt("id") %>'">
    Add
</button>

        <% } %>

    </div>

</div>

<%
        q++;
    }

    if (!hasFood) {
%>

<h2 style="text-align:center; color:#5a2d0c;">No foods available in this branch</h2>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
%>

<h2 style="text-align:center; color:red;">
    Error loading foods: <%= e.getMessage() %>
</h2>

<%
}
%>

</section>

<div class="scroll-dot-wrapper food-dots"></div>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-box">
            <h2>Royal Taste Hotel</h2>
            <p>Experience luxury dining with fresh food and premium taste.</p>
        </div>

        <div class="footer-box">
            <h3>Quick Links</h3>
            <a href="index.jsp">Home</a>
            <a href="main-course.jsp">Main Course</a>
            <a href="starters.jsp">Starters</a>
            <a href="dessert.jsp">Dessert</a>
            <a href="fresh-juice.jsp">Fresh Juice</a>
            <a href="reservation.jsp">Reservation</a>
        </div>

        <div class="footer-box">
            <h3>Contact</h3>
            <p>Email: royal@taste.com</p>
            <p>Phone: +91 7339060316</p>
            <p>Location: Coimbatore, India</p>
        </div>

        <div class="footer-box">
            <h3>Follow Us</h3>
            <div class="social-icons">
                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                <a href="#"><i class="fa-brands fa-twitter"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
            </div>
        </div>
    </div>
</footer>


<script src="scroll-load.js?v=6000"></script>

<script src="order.js"></script>
<script>
let searchPage = 1;
let searchItems = [];
let searchPerPage = 6;

function searchAllFoodsFromDB() {

    let keyword = document.getElementById("foodSearch").value.trim();

    let mainBox = document.getElementById("mainCourseBox");
    let searchBox = document.getElementById("searchResultBox");

    let mainDots = document.querySelector(".food-dots");
    let searchDots = document.querySelector(".search-food-dots");

    if (keyword === "") {
        searchBox.style.display = "none";
        searchBox.innerHTML = "";

        searchDots.classList.remove("show-search-dots");
        mainDots.classList.remove("hide-main-dots");

        mainBox.style.display = "grid";
        return;
    }

    mainBox.style.display = "none";
    mainDots.classList.add("hide-main-dots");

    searchBox.style.display = "grid";
    searchDots.classList.add("show-search-dots");

    fetch("searchFood?keyword=" + encodeURIComponent(keyword))
        .then(res => res.text())
        .then(data => {
            searchBox.innerHTML = data;
            searchItems = Array.from(searchBox.querySelectorAll(".food-card"));
            searchPage = 1;
            renderSearchDots();
            showSearchPage(1);
        });
}

function showSearchPage(page) {
    let totalPages = Math.ceil(searchItems.length / searchPerPage);
    if (totalPages < 2) totalPages = 2;

    if (page < 1 || page > totalPages) return;

    searchPage = page;

    let start = (page - 1) * searchPerPage;
    let end = start + searchPerPage;

    searchItems.forEach((item, index) => {
        item.style.display = index >= start && index < end ? "" : "none";
    });

    updateSearchDots();
}

function renderSearchDots() {
    let searchDots = document.querySelector(".search-food-dots");
    let totalPages = Math.ceil(searchItems.length / searchPerPage);
    if (totalPages < 2) totalPages = 2;

    searchDots.innerHTML = "";

    for (let i = 1; i <= totalPages; i++) {
        let dot = document.createElement("span");
        dot.className = "scroll-dot";
        dot.onclick = function() {
            showSearchPage(i);
        };
        searchDots.appendChild(dot);
    }
}

function updateSearchDots() {
    document.querySelectorAll(".search-food-dots .scroll-dot")
        .forEach((dot, index) => {
            dot.classList.toggle("active-dot", index + 1 === searchPage);
        });
}
</script>

</body>
</html>