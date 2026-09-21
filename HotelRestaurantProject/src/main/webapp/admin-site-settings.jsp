<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String owner = (String) session.getAttribute("owner");
String admin = (String) session.getAttribute("admin");

if (owner == null && admin == null) {
    response.sendRedirect("owner-login.jsp");
    return;
}

String restaurantName = "Royal Taste";
String logoImage = "images/logo.png";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT restaurant_name, logo_image FROM site_settings WHERE id=1"
    );

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        restaurantName = rs.getString("restaurant_name");
        logoImage = rs.getString("logo_image");
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Site Settings</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<header class="owner-header">
    <div class="logo">
        <img src="<%= logoImage %>" alt="Logo">
        <span><%= restaurantName %> Owner</span>
    </div>

    <nav>
        <a href="owner-dashboard.jsp">Dashboard</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

<h1 class="owner-title">Site Settings</h1>

<form action="<%= request.getContextPath() %>/updateSiteSettings"
      method="post"
      enctype="multipart/form-data"
      class="food-admin-form">

    <h2>Update Restaurant Name & Logo</h2>

    <input type="text"
           name="restaurantName"
           value="<%= restaurantName %>"
           placeholder="Restaurant Name"
           required>

    <div style="text-align:center;">
        <img src="<%= logoImage %>"
             style="width:130px;height:130px;object-fit:contain;border:2px solid #ffcc70;border-radius:18px;padding:8px;">
    </div>

    <input type="hidden"
           name="oldLogo"
           value="<%= logoImage %>">

    <div class="logo-upload-box">
        <label class="custom-logo-upload">
            <i class="fa-solid fa-image"></i>
            Choose Logo Image

            <input type="file"
                   name="logoFile"
                   accept="image/*"
                   hidden>
        </label>
    </div>

    <button type="submit">Update Settings</button>

</form>

</section>

</body>
</html>