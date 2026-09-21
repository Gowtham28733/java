<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String owner = (String) session.getAttribute("owner");
String admin = (String) session.getAttribute("admin");
String staff = (String) session.getAttribute("staff");
String manager = (String) session.getAttribute("manager");


Integer staffBranchId = (Integer) session.getAttribute("branchId");

if (owner == null && admin == null && staff == null && manager == null) {
    response.sendRedirect("staff-login.jsp");
    return;
}

String panelName = (owner != null || admin != null)
        ? "Royal Taste Owner"
        : (manager != null ? "Royal Taste Manager" : "Royal Taste Staff");

String dashboardLink = (owner != null || admin != null)
        ? "owner-dashboard.jsp"
        : (manager != null ? "manager-dashboard.jsp" : "staff-dashboard.jsp");

String logoutLink = (owner != null || admin != null)
        ? "logout.jsp"
        : "staff-logout.jsp";

Integer accessStock = (Integer) session.getAttribute("access_stock");

boolean canManageStock = owner != null || admin != null ||
        (accessStock != null && accessStock == 1);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Food</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span><%= panelName %></span>
    </div>

    <nav>
        <a href="<%= dashboardLink %>">Dashboard</a>
        <a href="<%= logoutLink %>" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

<h1 class="owner-title">Manage Food & Stock</h1>

<form action="<%= request.getContextPath() %>/addFood"
      method="post"
      enctype="multipart/form-data"
      class="food-admin-form">

    <h2>Add New Food</h2>

    <% if (owner != null || admin != null) { %>

<select name="branchId" required>
    <option value="">Select Branch</option>

    <%
    try {
        Connection branchCon = DBConnection.getConnection();

        PreparedStatement branchPs = branchCon.prepareStatement(
            "SELECT * FROM branches WHERE status='Active' ORDER BY id ASC"
        );

        ResultSet branchRs = branchPs.executeQuery();

        while (branchRs.next()) {
    %>

    <option value="<%= branchRs.getInt("id") %>">
        <%= branchRs.getString("branch_name") %> - <%= branchRs.getString("location") %>
    </option>

    <%
        }

        branchRs.close();
        branchPs.close();
        branchCon.close();

    } catch (Exception e) {
    %>

    <option value="">Branch Error</option>

    <%
    }
    %>
</select>

<% } else { %>

<input type="hidden"
       name="branchId"
       value="<%= staffBranchId %>">

<% } %>

    
    <input type="text" name="name" placeholder="Food Name" required>

    <input type="text" name="description" placeholder="Food Short Description" required>

    <input type="text" name="details" placeholder="Food Full Details" required>

    <input type="number" name="price" placeholder="Food Price" required>

    <% if (canManageStock) { %>

    <input type="number"
           name="stockQty"
           placeholder="Food Quantity / Stock"
           min="0"
           required>

    <% } else { %>

    <input type="hidden" name="stockQty" value="0">

    <% } %>

    <select name="foodStatus" required>
        <option value="Active">Active</option>
        <option value="Out of Stock">Out of Stock</option>
    </select>

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

<table class="bill-table food-admin-table" id="foodTable">

<thead>
<tr>
    <th>ID</th>
    <th>Branch</th>
    <th>Image</th>
    <th>Food</th>
    <th>Description</th>
    <th>Details</th>
    <th>Category</th>
    <th>Price</th>
    <th>Stock</th>
    <th>Status</th>
    <th>Update</th>
    <th>Delete</th>
</tr>
</thead>

<tbody>

<%
try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps;

    if (owner != null || admin != null) {
        ps = con.prepareStatement(
            "SELECT f.*, b.branch_name, b.location " +
            "FROM foods f " +
            "JOIN branches b ON f.branch_id = b.id " +
            "ORDER BY f.id ASC"
        );
    } else {
        ps = con.prepareStatement(
            "SELECT f.*, b.branch_name, b.location " +
            "FROM foods f " +
            "JOIN branches b ON f.branch_id = b.id " +
            "WHERE f.branch_id = ? " +
            "ORDER BY f.id ASC"
        );

        ps.setInt(1, staffBranchId);
    }

    ResultSet rs = ps.executeQuery();

    boolean hasFood = false;
    int foodSerial = 1;
    while (rs.next()) {
        hasFood = true;

        String category = rs.getString("category");
        String details = rs.getString("details");
        String foodStatus = rs.getString("food_status");

        if (details == null) {
            details = "";
        }

        if (foodStatus == null || foodStatus.trim().equals("")) {
            foodStatus = "Active";
        }
%>

<tr>
    <td>
    <%= rs.getRow() %>
</td>

    <td>
        <%= rs.getString("branch_name") %><br>
        <small><%= rs.getString("location") %></small>
    </td>

    <form action="<%= request.getContextPath() %>/updateFood"
          method="post"
          enctype="multipart/form-data">

        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
        <input type="hidden" name="oldImage" value="<%= rs.getString("image") %>">
        <input type="hidden" name="branchId" value="<%= rs.getInt("branch_id") %>">

        <td>
            <img src="<%= rs.getString("image") %>"
                 class="food-admin-img"
                 onerror="this.src='images/no-image.png'">

            <input type="file"
                   name="imageFile"
                   accept="image/*">
        </td>

        <td>
            <input type="text"
                   name="name"
                   value="<%= rs.getString("name") %>"
                   required>
        </td>

        <td>
            <input type="text"
                   name="description"
                   value="<%= rs.getString("description") %>"
                   required>
        </td>

        <td>
            <input type="text"
                   name="details"
                   value="<%= details %>"
                   required>
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
            <input type="number"
                   name="price"
                   value="<%= rs.getDouble("price") %>"
                   required>
        </td>

        <td>
            <% if (canManageStock) { %>

            <input type="number"
                   name="stockQty"
                   value="<%= rs.getInt("stock_qty") %>"
                   min="0"
                   required>

            <% } else { %>

            <div class="stock-view-only">
                <%= rs.getInt("stock_qty") %>
            </div>

            <input type="hidden"
                   name="stockQty"
                   value="<%= rs.getInt("stock_qty") %>">

            <% } %>
        </td>

        <td>
            <select name="foodStatus" required>
                <option value="Active"
                    <%= "Active".equalsIgnoreCase(foodStatus) ? "selected" : "" %>>
                    Active
                </option>

                <option value="Out of Stock"
                    <%= "Out of Stock".equalsIgnoreCase(foodStatus) ? "selected" : "" %>>
                    Out of Stock
                </option>
            </select>
        </td>

        <td>
            <button type="submit" class="accept-btn">
                Update
            </button>
        </td>

    </form>

    <td>
        <form action="<%= request.getContextPath() %>/deleteFood" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

            <button type="submit"
                    class="reject-btn"
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
    <td colspan="12">No food found</td>
</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
%>

<tr>
    <td colspan="12">Error: <%= e.getMessage() %></td>
</tr>

<%
}
%>

</tbody>
</table>

<div id="foodPages" class="table-pagination"></div>

</section>

<script src="pagination.js?v=9999"></script>

<script>
function checkCategory() {
    let categorySelect = document.getElementById("categorySelect");
    let newCategory = document.getElementById("newCategory");

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

window.addEventListener("load", function() {
    checkCategory();
    paginateRows("foodTable", "foodPages", 5);
});
</script>


</body>
</html>