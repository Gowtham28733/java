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

    <title>Food Reviews</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<header class="owner-header">

    <div class="logo">

        <img src="images/logo.png">

       <span><%= panelTitle %></span>

    </div>

    <nav>

        <a href="<%= dashboardLink %>">
            Dashboard
        </a>

        <a href="<%= logoutLink %>"
           class="logout-btn">

            Logout

        </a>

    </nav>

</header>

<section class="admin-orders-page">

<h1 class="owner-title">
    Customer Reviews
</h1>

<div class="food-admin-grid">

<%
try{

    Connection con =
            DBConnection.getConnection();

    PreparedStatement ps;

    if(owner != null){

        ps = con.prepareStatement(

            "SELECT r.*, f.name AS food_name, " +

            "f.image, b.branch_name, b.location " +

            "FROM food_ratings r " +

            "JOIN foods f ON r.food_id=f.id " +

            "LEFT JOIN branches b ON f.branch_id=b.id " +

            "ORDER BY r.id DESC"
        );

    } else {

        ps = con.prepareStatement(

            "SELECT r.*, f.name AS food_name, " +

            "f.image, b.branch_name, b.location " +

            "FROM food_ratings r " +

            "JOIN foods f ON r.food_id=f.id " +

            "LEFT JOIN branches b ON f.branch_id=b.id " +

            "WHERE f.branch_id=? " +

            "ORDER BY r.id DESC"
        );

        ps.setInt(1, staffBranchId);
    }

    ResultSet rs =
            ps.executeQuery();

    boolean hasReviews = false;

    while(rs.next()){

        hasReviews = true;
%>

<div class="food-admin-card">

    <img src="<%= rs.getString("image") %>">

    <h2>
        <%= rs.getString("food_name") %>
    </h2>

    <div class="food-rating-view">

        ⭐
        <%= rs.getInt("rating") %>
        / 5

    </div>

    <p class="food-review-text">

        <%= rs.getString("review") %>

    </p>

    <div class="food-branch-tag">

        <%= rs.getString("branch_name") %>
        -
        <%= rs.getString("location") %>

    </div>

    <div class="review-date">

        <%= rs.getTimestamp("created_at") %>

    </div>

</div>

<%
    }

    if(!hasReviews){
%>

<h2 style="text-align:center;">
    No Reviews Found
</h2>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){
%>

<h2>
    Error:
    <%= e.getMessage() %>
</h2>

<%
}
%>

</div>
<div id="reviewPages" class="table-pagination"></div>
</section>
<script src="pagination.js"></script>

<script>
window.addEventListener("load", function() {
    paginateCards(".food-admin-card", "reviewPages", 5);
});
</script>
</body>
</html>