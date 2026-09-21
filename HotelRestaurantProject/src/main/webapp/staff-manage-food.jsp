<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String staff = (String) session.getAttribute("staff");

if (staff == null) {
    response.sendRedirect("staff-login.jsp");
    return;
}

Integer accessFood = (Integer) session.getAttribute("access_food");
Integer accessServices = (Integer) session.getAttribute("access_services");
Integer accessOrders = (Integer) session.getAttribute("access_orders");
Integer accessReservations = (Integer) session.getAttribute("access_reservations");
Integer accessPayment = (Integer) session.getAttribute("access_payment");

if (accessFood == null || accessFood != 1) {
    response.sendRedirect("staff-no-access.jsp");
    return;
}

if (accessServices == null) accessServices = 0;
if (accessOrders == null) accessOrders = 0;
if (accessReservations == null) accessReservations = 0;
if (accessPayment == null) accessPayment = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Manage Food</title>
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
        <a href="staff-manage-food.jsp">Manage Food</a>

        <% if (accessServices == 1) { %>
            <a href="staff-services.jsp">Services</a>
        <% } %>

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

    <h1 class="owner-title">Staff Food Management</h1>

    <form action="<%= request.getContextPath() %>/addFood"
          method="post"
          enctype="multipart/form-data"
          class="food-admin-form">

        <h2>Add New Food</h2>

        <input type="text" name="name" placeholder="Food Name" required>
        <input type="text" name="description" placeholder="Food Description" required>
        <input type="number" name="price" placeholder="Food Price" required>
        <input type="file" name="imageFile" accept="image/*" required>

        <select name="category" id="categorySelect" onchange="checkCategory()" required>
            <option value="">Select Category</option>
            <option value="Main Course">Main Course</option>
            <option value="Starters">Starters</option>
            <option value="Dessert">Dessert</option>
            <option value="Cold Drinks">Cold Drinks</option>
            <option value="Fresh Juice">Fresh Juice</option>
            <option value="new">+ Add New Category</option>
        </select>

        <input type="text"
               name="newCategory"
               id="newCategory"
               placeholder="Enter New Category"
               style="display:none;">

        <button type="submit">Add Food</button>
    </form>

    <table class="bill-table food-admin-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Food</th>
            <th>Description</th>
            <th>Category</th>
            <th>Price</th>
            <th>Update</th>
            <th>Delete</th>
        </tr>
        </thead>

        <tbody>
        <%
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM foods ORDER BY id DESC");
            ResultSet rs = ps.executeQuery();

            boolean hasFood = false;

            while (rs.next()) {
                hasFood = true;
                String category = rs.getString("category");
        %>

        <tr>
            <td><%= rs.getInt("id") %></td>

            <form action="<%= request.getContextPath() %>/updateFood"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <input type="hidden" name="oldImage" value="<%= rs.getString("image") %>">

                <td>
                    <img src="<%= rs.getString("image") %>" class="food-admin-img">
                    <input type="file" name="imageFile" accept="image/*">
                </td>

                <td>
                    <input type="text" name="name" value="<%= rs.getString("name") %>" required>
                </td>

                <td>
                    <input type="text" name="description" value="<%= rs.getString("description") %>" required>
                </td>

                <td>
                    <select name="category" required>
                        <option value="Main Course" <%= "Main Course".equals(category) ? "selected" : "" %>>Main Course</option>
                        <option value="Starters" <%= "Starters".equals(category) ? "selected" : "" %>>Starters</option>
                        <option value="Dessert" <%= "Dessert".equals(category) ? "selected" : "" %>>Dessert</option>
                        <option value="Cold Drinks" <%= "Cold Drinks".equals(category) ? "selected" : "" %>>Cold Drinks</option>
                        <option value="Fresh Juice" <%= "Fresh Juice".equals(category) ? "selected" : "" %>>Fresh Juice</option>

                        <%
                        if (!"Main Course".equals(category)
                                && !"Starters".equals(category)
                                && !"Dessert".equals(category)
                                && !"Cold Drinks".equals(category)
                                && !"Fresh Juice".equals(category)) {
                        %>
                            <option value="<%= category %>" selected><%= category %></option>
                        <%
                        }
                        %>
                    </select>
                </td>

                <td>
                    <input type="number" name="price" value="<%= rs.getDouble("price") %>" required>
                </td>

                <td>
                    <button type="submit" class="accept-btn">Update</button>
                </td>
            </form>

            <td>
                <form action="<%= request.getContextPath() %>/deleteFood" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="reject-btn"
                            onclick="return confirm('Delete this food?')">
                        Delete
                    </button>
                </form>
            </td>
        </tr>

        <%
            }

            if (!hasFood) {
        %>
        <tr>
            <td colspan="8">No food found</td>
        </tr>
        <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="8">Error: <%= e.getMessage() %></td>
        </tr>
        <%
        }
        %>
        </tbody>
    </table>

</section>

<script>
function checkCategory() {
    var categorySelect = document.getElementById("categorySelect");
    var newCategory = document.getElementById("newCategory");

    if (categorySelect.value === "new") {
        newCategory.style.display = "block";
        newCategory.required = true;
        newCategory.focus();
    } else {
        newCategory.style.display = "none";
        newCategory.required = false;
        newCategory.value = "";
    }
}
</script>

</body>
</html>