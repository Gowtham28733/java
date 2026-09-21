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


String qrImage = "images/my-qr.png";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT qr_image FROM payment_settings WHERE id=1"
    );

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        qrImage = rs.getString("qr_image");
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    qrImage = "images/my-qr.png";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage QR Payment</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header">

    <div class="logo">

        <img src="images/logo.png"
             alt="Royal Taste Logo">

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

    <h1 class="owner-title">Manage QR Payment</h1>

   <form action="<%= request.getContextPath() %>/updateQrPayment"
      method="post"
      enctype="multipart/form-data"
      class="food-admin-form">

        <h2>Current QR</h2>

        <div style="text-align:center;">
            <img src="<%= qrImage %>"
                 style="width:180px; height:180px; object-fit:contain; border:2px solid #ffcc70; border-radius:18px; padding:8px;">
        </div>

        <input type="file" name="qrFile" accept="image/*" required>

        <button type="submit">Update QR Payment</button>

    </form>

</section>

</body>
</html>