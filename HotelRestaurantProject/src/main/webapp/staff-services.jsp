<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String staff = (String) session.getAttribute("staff");

if (staff == null) {
    response.sendRedirect("staff-login.jsp");
    return;
}

Integer accessServices = (Integer) session.getAttribute("access_services");
Integer accessFood = (Integer) session.getAttribute("access_food");
Integer accessOrders = (Integer) session.getAttribute("access_orders");
Integer accessReservations = (Integer) session.getAttribute("access_reservations");
Integer accessPayment = (Integer) session.getAttribute("access_payment");

if (accessServices == null || accessServices != 1) {
    response.sendRedirect("staff-no-access.jsp");
    return;
}

if (accessFood == null) accessFood = 0;
if (accessOrders == null) accessOrders = 0;
if (accessReservations == null) accessReservations = 0;
if (accessPayment == null) accessPayment = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Services</title>
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

        <% if (accessFood == 1) { %>
            <a href="staff-manage-food.jsp">Manage Food</a>
        <% } %>

        <a href="staff-services.jsp">Services</a>

        <% if (accessOrders == 1) { %>
            <a href="staff-orders.jsp">Orders</a>
        <% } %>

        <% if (accessReservations == 1) { %>
            <a href="staff-reservations.jsp">Reservations</a>
        <% } %>

        <% if (accessPayment == 1) { %>
            <a href="staff-orders.jsp">Payment</a>
        <% } %>

        <a href="staff-logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

    <h1 class="owner-title">Staff Restaurant Services</h1>

    <form action="<%= request.getContextPath() %>/addService"
          method="post"
          enctype="multipart/form-data"
          class="food-admin-form">

        <h2>Add New Service</h2>

        <input type="text" name="title" placeholder="Service Title" required>
        <input type="text" name="description" placeholder="Service Description" required>
        <input type="text" name="icon" placeholder="Icon: fa-solid fa-truck-fast" required>
        <input type="text" name="buttonText" placeholder="Button Text" required>
        <input type="text" name="buttonLink" placeholder="Button Link: main-course.jsp" required>
        <input type="file" name="imageFile" accept="image/*" required>

        <button type="submit">Add Service</button>
    </form>

    <table class="bill-table food-admin-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Title</th>
            <th>Description</th>
            <th>Icon</th>
            <th>Button Text</th>
            <th>Button Link</th>
            <th>Update</th>
            <th>Delete</th>
        </tr>
        </thead>

        <tbody>
        <%
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM restaurant_services ORDER BY id ASC");
            ResultSet rs = ps.executeQuery();

            boolean hasService = false;

            while (rs.next()) {
                hasService = true;
        %>

        <tr>
            <td><%= rs.getInt("id") %></td>

            <form action="<%= request.getContextPath() %>/updateService"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <input type="hidden" name="oldImage" value="<%= rs.getString("image") %>">

                <td>
                    <img src="<%= rs.getString("image") %>" class="food-admin-img">
                    <input type="file" name="imageFile" accept="image/*">
                </td>

                <td>
                    <input type="text" name="title" value="<%= rs.getString("title") %>" required>
                </td>

                <td>
                    <input type="text" name="description" value="<%= rs.getString("description") %>" required>
                </td>

                <td>
                    <input type="text" name="icon" value="<%= rs.getString("icon") %>" required>
                </td>

                <td>
                    <input type="text" name="buttonText" value="<%= rs.getString("button_text") %>" required>
                </td>

                <td>
                    <input type="text" name="buttonLink" value="<%= rs.getString("button_link") %>" required>
                </td>

                <td>
                    <button type="submit" class="accept-btn">Update</button>
                </td>
            </form>

            <td>
                <form action="<%= request.getContextPath() %>/deleteService" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="reject-btn"
                            onclick="return confirm('Delete this service?')">
                        Delete
                    </button>
                </form>
            </td>
        </tr>

        <%
            }

            if (!hasService) {
        %>
        <tr>
            <td colspan="9">No services found</td>
        </tr>
        <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="9">Error: <%= e.getMessage() %></td>
        </tr>
        <%
        }
        %>
        </tbody>
    </table>

</section>

</body>
</html>