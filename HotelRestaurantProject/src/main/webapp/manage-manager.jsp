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

<title>Manage Managers</title>

<link rel="stylesheet" href="style.css">

</head>

<body>

<header class="owner-header">

    <div class="logo">
        <img src="images/logo.png" alt="">
        <span>Royal Taste Owner</span>
    </div>

    <nav>

        <a href="owner-dashboard.jsp">Dashboard</a>

        <a href="manage-branches.jsp">Branches</a>

        <a href="manage-food.jsp">Food</a>

        <a href="manage-staff.jsp">Staff</a>

        <a href="manage-manager.jsp">Managers</a>

        <a href="logout.jsp"
           class="logout-btn">

            Logout

        </a>

    </nav>

</header>

<section class="admin-orders-page">

<h1 class="owner-title">

    Manage Managers

</h1>

<form action="<%= request.getContextPath() %>/addManager"
      method="post"
      class="food-admin-form staff-form-box">

    <h2>Add New Manager</h2>

    <select name="branchId" required>

        <option value="">
            Select Branch
        </option>

        <%
        try {

            Connection branchCon =
                    DBConnection.getConnection();

            PreparedStatement branchPs =
                    branchCon.prepareStatement(

                            "SELECT * FROM branches " +
                            "WHERE status='Active' " +
                            "ORDER BY branch_name ASC"

                    );

            ResultSet branchRs =
                    branchPs.executeQuery();

            while (branchRs.next()) {
        %>

        <option value="<%= branchRs.getInt("id") %>">

            <%= branchRs.getString("branch_name") %>
            -
            <%= branchRs.getString("location") %>

        </option>

        <%
            }

            branchRs.close();
            branchPs.close();
            branchCon.close();

        } catch (Exception e) {
        %>

        <option value="">
            Branch Error
        </option>

        <%
        }
        %>

    </select>

    <input type="text"
           name="name"
           placeholder="Manager Name"
           pattern="[A-Za-z ]+"
           oninput="this.value=this.value.replace(/[^A-Za-z ]/g,'')"
           required>

    <input type="text"
           name="username"
           placeholder="Manager Username"
           required>

    <input type="password"
           name="password"
           placeholder="Manager Password"
           required>

    <input type="text"
           name="phone"
           placeholder="Phone Number"
           maxlength="10"
           minlength="10"
           pattern="[0-9]{10}"
           oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
           required>

    <button type="submit">

        Add Manager

    </button>

</form>

<div class="staff-table-scroll">

<table class="bill-table food-admin-table staff-table"
       id="managerTable">

<thead>

<tr>

    <th>ID</th>

    <th>Branch</th>

    <th>Name</th>

    <th>Username</th>

    <th>Phone Number</th>

    <th>New Password</th>

    <th>Update</th>

    <th>Status</th>

    <th>Action</th>

    <th>Delete</th>

</tr>

</thead>

<tbody>

<%
try {

    Connection con =
            DBConnection.getConnection();

    PreparedStatement ps =
            con.prepareStatement(

                    "SELECT m.*, " +
                    "b.branch_name, " +
                    "b.location " +

                    "FROM managers m " +

                    "LEFT JOIN branches b " +
                    "ON m.branch_id=b.id " +

                    "ORDER BY m.id ASC"

            );

    ResultSet rs =
            ps.executeQuery();

    boolean hasManager = false;

    while (rs.next()) {

        hasManager = true;

        int managerId =
                rs.getInt("id");

        String formId =
                "managerForm_" + managerId;

        String status =
                rs.getString("status");

        if (status == null ||
            status.trim().equals("")) {

            status = "Active";
        }

        String phone =
                rs.getString("phone");

        if (phone == null) {
            phone = "";
        }
%>

<tr>

<td class="auto-serial"></td>

<td>

    <%= rs.getString("branch_name") %>

    <br>

    <small>

        <%= rs.getString("location") %>

    </small>

</td>

<td>

    <%= rs.getString("name") %>

</td>

<td>

    <%= rs.getString("username") %>

</td>

<td>

    <input form="<%= formId %>"
           type="text"
           name="phone"
           value="<%= phone %>"
           maxlength="10"
           minlength="10"
           pattern="[0-9]{10}"
           oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
           required>

</td>

<td>

    <input form="<%= formId %>"
           type="password"
           name="password"
           placeholder="New Password">

</td>

<td>

<form id="<%= formId %>"
      action="<%= request.getContextPath() %>/updateManager"
      method="post">

    <input type="hidden"
           name="id"
           value="<%= managerId %>">

    <button type="submit"
            class="accept-btn">

        Update

    </button>

</form>

</td>

<td>

<span class="status <%= "Active".equalsIgnoreCase(status) ? "active" : "inactive" %>">

    <%= status %>

</span>

</td>

<td>

<%
if ("Active".equalsIgnoreCase(status)) {
%>

<form action="<%= request.getContextPath() %>/updateManager"
      method="post">

    <input type="hidden"
           name="id"
           value="<%= managerId %>">

    <input type="hidden"
           name="status"
           value="Inactive">

    <button type="submit"
            class="staff-inactive-btn">

        Inactive

    </button>

</form>

<%
} else {
%>

<form action="<%= request.getContextPath() %>/updateManager"
      method="post">

    <input type="hidden"
           name="id"
           value="<%= managerId %>">

    <input type="hidden"
           name="status"
           value="Active">

    <button type="submit"
            class="staff-active-btn">

        Active

    </button>

</form>

<%
}
%>

</td>

<td>

<form action="<%= request.getContextPath() %>/deleteManager"
      method="post">

    <input type="hidden"
           name="id"
           value="<%= managerId %>">

    <button type="submit"
            class="reject-btn"
            onclick="return confirm('Delete manager?')">

        Delete

    </button>

</form>

</td>

</tr>

<%
    }

    if (!hasManager) {
%>

<tr>

<td colspan="10">

    No manager found

</td>

</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
%>

<tr>

<td colspan="10">

    Error:
    <%= e.getMessage() %>

</td>

</tr>

<%
}
%>

</tbody>

</table>

</div>

<div id="managerPages"
     class="table-pagination"></div>

</section>

<script src="pagination.js?v=9999"></script>

<script>

window.addEventListener("load", function () {

    paginateRows(
        "managerTable",
        "managerPages",
        5
    );

});

</script>

</body>
</html>