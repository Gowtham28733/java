<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>No Access</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste Staff</span>
    </div>

    <nav>
        <a href="staff-dashboard.jsp">Dashboard</a>
        <a href="staff-logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="owner-dashboard-page">
    <div class="owner-dashboard-section">
        <div class="owner-card">
            <h2>No Access</h2>
            <p>Admin has not allowed this page for your staff account.</p>
            <a href="staff-dashboard.jsp">Back Dashboard</a>
        </div>
    </div>
</section>

</body>
</html>