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
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Staff</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png">
        <span>Royal Taste Owner</span>
    </div>

    <nav>
        <a href="owner-dashboard.jsp">Dashboard</a>
        <a href="manage-branches.jsp">Branches</a>
        <a href="manage-food.jsp">Food</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

<h1 class="owner-title">Manage Branch Staff</h1>

<form action="<%= request.getContextPath() %>/addStaff"
      method="post"
      class="food-admin-form staff-form-box">

    <h2>Add New Staff</h2>

    <select name="branchId" required>
        <option value="">Select Branch</option>

        <%
        try {
            Connection bcon = DBConnection.getConnection();
            PreparedStatement bps = bcon.prepareStatement(
                "SELECT * FROM branches WHERE status='Active' ORDER BY branch_name ASC"
            );
            ResultSet brs = bps.executeQuery();

            while(brs.next()){
        %>

        <option value="<%= brs.getInt("id") %>">
            <%= brs.getString("branch_name") %> - <%= brs.getString("location") %>
        </option>

        <%
            }

            brs.close();
            bps.close();
            bcon.close();

        } catch(Exception e) {
        %>

        <option value="">Branch Error</option>

        <%
        }
        %>
    </select>

    <input type="text"
           name="name"
           placeholder="Staff Name"
           pattern="[A-Za-z ]+"
           oninput="this.value=this.value.replace(/[^A-Za-z ]/g,'')"
           required>
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
    <input type="text"
       name="phone"
       placeholder="Phone Number"
       maxlength="10"
       minlength="10"
       pattern="[0-9]{10}"
       oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
       required>

    <div class="staff-access-box">
        <label class="staff-access-item"><input type="checkbox" name="access_food" value="1"><span>Food Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_orders" value="1"><span>Orders Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_reservations" value="1"><span>Reservations Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_services" value="1"><span>Services Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_payment" value="1"><span>Payment Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_reviews" value="1"><span>Reviews Access</span></label>
        <label class="staff-access-item"><input type="checkbox" name="access_stock" value="1"><span>Stock Access</span></label>
    </div>

    <button type="submit">Add Staff</button>
</form>

<div class="staff-table-scroll">

<table class="bill-table food-admin-table staff-table"  id="staffTable">

<thead>
<tr>
    <th>ID</th>
    <th>Branch</th>
    <th>Name</th>
    <th>User name</th>
    <th>Phone</th>
    <th>Password</th>
    <th>Food</th>
    <th>Orders</th>
    <th>Reservations</th>
    <th>Services</th>
    <th>Payment</th>
    <th>Reviews</th>
    <th>Stock</th>
    <th>Update</th>
    <th>Status</th>
    <th>Action</th>
    <th>Delete</th>
</tr>
</thead>

<tbody>

<%
try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT s.*, b.branch_name, b.location " +
        "FROM staff s " +
        "LEFT JOIN branches b ON s.branch_id = b.id " +
        "ORDER BY s.id ASC"
    );

    ResultSet rs = ps.executeQuery();
    boolean hasStaff = false;

    while(rs.next()) {
        hasStaff = true;

        int staffId = rs.getInt("id");
        String accessFormId = "accessForm_" + staffId;

        String status = rs.getString("status");
        if(status == null || status.trim().equals("")) {
            status = "Active";
        }

        String statusClass = "Active".equalsIgnoreCase(status) ? "active" : "inactive";
%>

<tr>
    <td>
    <%= rs.getRow() %>
</td>

    <td>
        <%= rs.getString("branch_name") %><br>
        <small><%= rs.getString("location") %></small>
    </td>

    <td><%= rs.getString("name") %></td>

    <td><%= rs.getString("username") %></td>

    <td>
    <input type="text"
           form="<%= accessFormId %>"
           name="phone"
           value="<%= rs.getString("phone") == null ? "" : rs.getString("phone") %>"
           maxlength="10"
           minlength="10"
           pattern="[0-9]{10}"
           oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
           required>
</td>

    <td>
        <input type="password"
               form="<%= accessFormId %>"
               name="password"
               placeholder="New Password"
               class="staff-password-input">
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_food" value="1"
        <%= rs.getInt("access_food") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_orders" value="1"
        <%= rs.getInt("access_orders") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_reservations" value="1"
        <%= rs.getInt("access_reservations") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_services" value="1"
        <%= rs.getInt("access_services") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_payment" value="1"
        <%= rs.getInt("access_payment") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_reviews" value="1"
        <%= rs.getInt("access_reviews") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <input form="<%= accessFormId %>" type="checkbox" name="access_stock" value="1"
        <%= rs.getInt("access_stock") == 1 ? "checked" : "" %>>
    </td>

    <td>
        <form id="<%= accessFormId %>"
              action="<%= request.getContextPath() %>/updateStaff"
              method="post">
            <input type="hidden" name="id" value="<%= staffId %>">
            <button type="submit" class="accept-btn">Update</button>
        </form>
    </td>

    <td>
        <span class="status <%= statusClass %>"><%= status %></span>
    </td>

    <td>
        <% if ("Active".equalsIgnoreCase(status)) { %>

        <form action="<%= request.getContextPath() %>/updateStaff" method="post">
            <input type="hidden" name="id" value="<%= staffId %>">
            <input type="hidden" name="status" value="Inactive">
            <button type="submit" class="staff-inactive-btn">Inactive</button>
        </form>

        <% } else { %>

        <form action="<%= request.getContextPath() %>/updateStaff" method="post">
            <input type="hidden" name="id" value="<%= staffId %>">
            <input type="hidden" name="status" value="Active">
            <button type="submit" class="staff-active-btn">Active</button>
        </form>

        <% } %>
    </td>

    <td>
        <form action="<%= request.getContextPath() %>/deleteStaff" method="post">
            <input type="hidden" name="id" value="<%= staffId %>">
            <button type="submit"
                    class="reject-btn"
                    onclick="return confirm('Delete staff?')">
                Delete
            </button>
        </form>
    </td>
</tr>

<%
    }

    if(!hasStaff) {
%>

<tr>
    <td colspan="17">No staff found</td>
</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch(Exception e) {
%>

<tr>
    <td colspan="17">Error: <%= e.getMessage() %></td>
</tr>

<%
}
%>

</tbody>
</table>

</div>

<div id="staffPages" class="table-pagination"></div>

<script src="pagination.js?v=9999"></script>

<script>
window.addEventListener("load", function() {
    paginateRows("staffTable", "staffPages", 5);
});
</script>

</body>
</html>