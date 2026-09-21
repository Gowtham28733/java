<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String owner = (String) session.getAttribute("owner");

if (owner == null) {
    response.sendRedirect("owner-login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Branches</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span>Royal Taste Owner</span>
    </div>

    <nav>
        <a href="owner-dashboard.jsp">Dashboard</a>
        <a href="manage-food.jsp">Food</a>
        <a href="manage-staff.jsp">Staff</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

    <h1 class="owner-title">Manage Branches</h1>

    <form action="<%= request.getContextPath() %>/addBranch"
          method="post"
          class="food-admin-form">

        <h2>Add New Branch</h2>

        <input type="text"
               name="branchName"
               placeholder="Branch Name"
               required>

        <input type="text"
               name="location"
               placeholder="Location"
               required>

        <input type="text"
               name="phone"
               placeholder="Phone Number">

        <button type="submit">Add Branch</button>
    </form>

    <table class="bill-table food-admin-table" id="branchTable">

        <thead>
        <tr>
            <th>ID</th>
            <th>Branch</th>
            <th>Location</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Change</th>
            <th>Delete</th>
        </tr>
        </thead>

        <tbody>

        <%
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM branches ORDER BY id DESC"
            );

            ResultSet rs = ps.executeQuery();

            boolean hasBranch = false;

            while (rs.next()) {
                hasBranch = true;

                String status = rs.getString("status");

                if (status == null || status.trim().equals("")) {
                    status = "Active";
                }

                String nextStatus = "Active".equalsIgnoreCase(status)
                        ? "Inactive"
                        : "Active";
        %>

        <tr>
          <td>
    <%= rs.getRow() %>
</td>
            <td><%= rs.getString("branch_name") %></td>

            <td><%= rs.getString("location") %></td>

            <td><%= rs.getString("phone") %></td>

            <td>
                <span class="status <%= status.toLowerCase() %>">
                    <%= status %>
                </span>
            </td>

            <td>
                <form action="<%= request.getContextPath() %>/updateBranchStatus"
                      method="post">

                    <input type="hidden"
                           name="id"
                           value="<%= rs.getInt("id") %>">

                    <input type="hidden"
                           name="status"
                           value="<%= nextStatus %>">

                    <% if ("Active".equalsIgnoreCase(status)) { %>

                    <button type="submit"
                            class="deliver-btn">
                        Make Inactive
                    </button>

                    <% } else { %>

                    <button type="submit"
                            class="accept-btn">
                        Make Active
                    </button>

                    <% } %>

                </form>
            </td>

            <td>
                <form action="<%= request.getContextPath() %>/deleteBranch"
                      method="post">

                    <input type="hidden"
                           name="id"
                           value="<%= rs.getInt("id") %>">

                    <button type="submit"
                            class="reject-btn"
                            onclick="return confirm('Delete this branch?')">
                        Delete
                    </button>

                </form>
            </td>
        </tr>

        <%
            }

            if (!hasBranch) {
        %>

        <tr>
            <td colspan="7">No branches found</td>
        </tr>

        <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
        %>

        <tr>
            <td colspan="7">Error: <%= e.getMessage() %></td>
        </tr>

        <%
        }
        %>

        </tbody>
    </table>

   <div id="branchPages" class="table-pagination"></div>

</section>

<script src="pagination.js?v=9999"></script>

<script>
window.addEventListener("load", function() {
    paginateRows("branchTable", "branchPages", 5);
});
</script>


</body>
</html>