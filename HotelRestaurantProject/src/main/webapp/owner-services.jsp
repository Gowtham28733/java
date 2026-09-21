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
    <title>Manage Services</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<header class="owner-header">
    <div class="logo">
        <img src="images/logo.png" alt="Royal Taste Logo">
        <span><%= panelTitle %></span>
    </div>

    <nav>
        <a href="<%= dashboardLink %>">Dashboard</a>
        <a href="<%= logoutLink %>" class="logout-btn">Logout</a>
    </nav>
</header>

<section class="admin-orders-page">

    <h1 class="owner-title">Manage Restaurant Services</h1>

    <form action="<%= request.getContextPath() %>/addService"
          method="post"
          enctype="multipart/form-data"
          class="food-admin-form">

        <h2>Add New Service</h2>

        <input type="text"
               name="title"
               placeholder="Service Title"
               required>

        <input type="text"
               name="description"
               placeholder="Service Description"
               required>

        <input type="text"
               name="buttonText"
               placeholder="Button Text"
               required>

        

        <input type="file"
               name="imageFile"
               accept="image/*"
               required>
               
        <input type="text"
               name="buttonLink"
               placeholder="Button Link Example: reservation.jsp"
               required>

        <button type="submit">Add Service</button>

    </form>

    <table class="bill-table food-admin-table" id="serviceTable">

        <thead>
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Title</th>
            <th>Description</th>
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

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM restaurant_services ORDER BY id ASC"
            );

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

                <input type="hidden"
                       name="id"
                       value="<%= rs.getInt("id") %>">

                <input type="hidden"
                       name="oldImage"
                       value="<%= rs.getString("image") %>">

                <td>
                    <img src="<%= rs.getString("image") %>"
                         class="food-admin-img"
                         alt="Service Image">

                    <input type="file"
                           name="imageFile"
                           accept="image/*">
                </td>

                <td>
                    <input type="text"
                           name="title"
                           value="<%= rs.getString("title") %>"
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
                           name="buttonText"
                           value="<%= rs.getString("button_text") %>"
                           required>
                </td>

                <td>
                    <input type="text"
                           name="buttonLink"
                           value="<%= rs.getString("button_link") %>"
                           required>
                </td>

                <td>
                    <button type="submit" class="accept-btn">
                        Update
                    </button>
                </td>

            </form>

            <td>
                <form action="<%= request.getContextPath() %>/deleteService"
                      method="post">

                    <input type="hidden"
                           name="id"
                           value="<%= rs.getInt("id") %>">

                    <button type="submit"
                            class="reject-btn"
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
    <div id="servicePages" class="table-pagination"></div>

</section>
<script src="pagination.js?v=9999"></script>
<script>
window.addEventListener("load", function() {
    paginateRows("serviceTable", "servicePages", 5);
});
</script>
</body>
</html>