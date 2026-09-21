<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String owner = (String) session.getAttribute("owner");
String admin = (String) session.getAttribute("admin");
String staff = (String) session.getAttribute("staff");
String manager = (String) session.getAttribute("manager");

Integer branchId = (Integer) session.getAttribute("branchId");
String branchName = "";
String branchLocation = "";

if (branchId != null) {
    try {
        Connection bcon = DBConnection.getConnection();

        PreparedStatement bps = bcon.prepareStatement(
            "SELECT branch_name, location FROM branches WHERE id=?"
        );

        bps.setInt(1, branchId);

        ResultSet brs = bps.executeQuery();

        if (brs.next()) {
            branchName = brs.getString("branch_name");
            branchLocation = brs.getString("location");
        }

        brs.close();
        bps.close();
        bcon.close();

    } catch (Exception e) {
        branchName = "";
        branchLocation = "";
    }
}

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
    <title>Restaurant Reservations</title>
    <link rel="stylesheet" href="style.css">
</head>

<body class="<%= isOwnerAdmin ? "owner-reservation-page" : "staff-reservation-page" %>">

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

<h1 class="owner-title">Restaurant Reservations</h1>

<div class="owner-export-buttons no-print">

    <button type="button"
            onclick="downloadReservationsExcel()"
            class="accept-btn">

        ⬇ Excel Sheet

    </button>

    <button type="button"
            onclick="downloadReservationsPDF()"
            class="print-btn owner-print-btn">

        📄 PDF

    </button>

</div>


<div class="reservation-control-box">

    <h2>Branch Reservation Control</h2>

    <%
    try {
        Connection rcon = DBConnection.getConnection();
        PreparedStatement rps;

        if (isOwnerAdmin) {
            rps = rcon.prepareStatement(
                "SELECT b.id, b.branch_name, b.location, " +
                "COALESCE(rs.status, 'Open') AS reservation_status " +
                "FROM branches b " +
                "LEFT JOIN reservation_settings rs ON b.id=rs.branch_id " +
                "WHERE b.status='Active' " +
                "ORDER BY b.id ASC"
            );
        } else {
            rps = rcon.prepareStatement(
                "SELECT b.id, b.branch_name, b.location, " +
                "COALESCE(rs.status, 'Open') AS reservation_status " +
                "FROM branches b " +
                "LEFT JOIN reservation_settings rs ON b.id=rs.branch_id " +
                "WHERE b.id=? AND b.status='Active'"
            );

            rps.setInt(1, staffBranchId);
        }

        ResultSet rrs = rps.executeQuery();

        while (rrs.next()) {
            String branchReservationStatus =
                    rrs.getString("reservation_status");
    %>

    <div class="branch-reservation-control">

        <h3>
            <%= rrs.getString("branch_name") %>
            -
            <%= rrs.getString("location") %>
        </h3>

        <p>Status: <b><%= branchReservationStatus %></b></p>

        <form action="<%= request.getContextPath() %>/updateReservationSetting"
              method="post">

            <input type="hidden"
                   name="branchId"
                   value="<%= rrs.getInt("id") %>">

            <% if ("Open".equalsIgnoreCase(branchReservationStatus)) { %>

            <input type="hidden" name="status" value="Closed">

            <button type="submit" class="reject-btn">
                Close This Branch
            </button>

            <% } else { %>

            <input type="hidden" name="status" value="Open">

            <button type="submit" class="accept-btn">
                Open This Branch
            </button>

            <% } %>

        </form>

    </div>

    <%
        }

        rrs.close();
        rps.close();
        rcon.close();

    } catch(Exception e) {
    %>

    <p>Reservation control error</p>

    <%
    }
    %>

</div>

<form action="<%= request.getContextPath() %>/addReservationTable"
      method="post"
      class="food-admin-form staff-form-box">

    <h2>Add Table Type</h2>

    <% if (isOwnerAdmin) { %>

    <select name="branchId" required>
        <option value="">Select Branch</option>

        <%
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT id, branch_name, location " +
                "FROM branches WHERE status='Active' ORDER BY id ASC"
            );
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
        %>

        <option value="<%= rs.getInt("id") %>">
            <%= rs.getString("branch_name") %> - <%= rs.getString("location") %>
        </option>

        <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch(Exception e) {
        %>

        <option value="">Branch Error</option>

        <%
        }
        %>
    </select>

    <% } else { %>

    <input type="hidden" name="branchId" value="<%= staffBranchId %>">

    <div class="selected-branch-box">
    <h3><%= branchName %></h3>
    <p><%= branchLocation %></p>
</div>

    <% } %>

    <input type="text"
           name="tableName"
           placeholder="Couple Table / Friends Table / Family Table"
           required>

    <input type="number"
           name="capacity"
           placeholder="Capacity"
           min="1"
           required>

    <button type="submit">Add Table Type</button>

</form>

<div class="food-admin-form staff-form-box">

    <h2>Manage Table Types</h2>

    <table class="bill-table reservation-table" id="tableTypeTable">

        <thead>
        <tr>
            <th>ID</th>
            <th>Branch</th>
            <th>Table Type</th>
            <th>Capacity</th>
            <th>Delete</th>
        </tr>
        </thead>

        <tbody>

        <%
        try {
            Connection tcon = DBConnection.getConnection();
            PreparedStatement tps;

            if (isOwnerAdmin) {
                tps = tcon.prepareStatement(
                    "SELECT rt.id, rt.table_name, rt.capacity, " +
                    "b.branch_name, b.location " +
                    "FROM reservation_tables rt " +
                    "LEFT JOIN branches b ON rt.branch_id=b.id " +
                    "ORDER BY rt.id ASC"
                );
            } else {
                tps = tcon.prepareStatement(
                    "SELECT rt.id, rt.table_name, rt.capacity, " +
                    "b.branch_name, b.location " +
                    "FROM reservation_tables rt " +
                    "LEFT JOIN branches b ON rt.branch_id=b.id " +
                    "WHERE rt.branch_id=? " +
                    "ORDER BY rt.id ASC"
                );

                tps.setInt(1, staffBranchId);
            }

            ResultSet trs = tps.executeQuery();
            boolean hasTableType = false;

            while (trs.next()) {
                hasTableType = true;
        %>

        <tr>
            <td><%= trs.getRow() %></td>

            <td>
                <%= trs.getString("branch_name") %><br>
                <small><%= trs.getString("location") %></small>
            </td>

            <td><%= trs.getString("table_name") %></td>

            <td><%= trs.getInt("capacity") %></td>

            <td>
                <form action="<%= request.getContextPath() %>/deleteReservationTable"
                      method="post"
                      onsubmit="return confirm('Delete this table type?');">

                    <input type="hidden"
                           name="id"
                           value="<%= trs.getInt("id") %>">

                    <button type="submit" class="reject-btn">
                        Delete
                    </button>

                </form>
            </td>
        </tr>

        <%
            }

            if (!hasTableType) {
        %>

        <tr>
            <td colspan="5">No table types found</td>
        </tr>

        <%
            }

            trs.close();
            tps.close();
            tcon.close();

        } catch(Exception e) {
        %>

        <tr>
            <td colspan="5">Table loading error</td>
        </tr>

        <%
        }
        %>

        </tbody>

    </table>
    
    <div id="tableTypePages"
     class="table-pagination table-type-pagination">
</div>

    

</div>

<form action="<%= request.getContextPath() %>/addAdminReservation"
      method="post"
      class="food-admin-form staff-form-box">

    <h2>Add Reservation</h2>

    <% if (isOwnerAdmin) { %>

    <select name="branchId"
            id="adminBranchId"
            required
            onchange="loadAdminTables()">
        <option value="">Select Branch</option>

        <%
        try {
            Connection bcon = DBConnection.getConnection();
            PreparedStatement bps = bcon.prepareStatement(
                "SELECT id, branch_name, location " +
                "FROM branches WHERE status='Active' ORDER BY id ASC"
            );
            ResultSet brs = bps.executeQuery();

            while (brs.next()) {
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

    <select name="tableNo" id="adminTableNo" required>
        <option value="">Select Branch First</option>
    </select>

    <% } else { %>

    <input type="hidden"
           name="branchId"
           id="adminBranchId"
           value="<%= staffBranchId %>">

    <div class="selected-branch-box">
    <h3><%= branchName %></h3>
    <p><%= branchLocation %></p>
</div>

    <select name="tableNo" id="adminTableNo" required>
        <option value="">Loading Tables...</option>
    </select>

    <% } %>

    <input type="text" name="customerName" placeholder="Customer Name" required>
    <input type="text" name="phone" placeholder="Phone Number" required>
    <input type="date" name="reservationDate" required>
    <input type="time" name="reservationTime" required>
    <input type="number" name="guests" placeholder="Guests" min="1" required>
    <textarea name="message" placeholder="Message"></textarea>

    <button type="submit">Add Reservation</button>

</form>

<div class="order-search-box">
    <input type="text"
           id="reservationSearch"
           placeholder="Search reservation..."
           onkeyup="searchReservation()">
</div>

<table class="bill-table reservation-table" id="reservationTable">

<thead>
<tr>
    <th>ID</th>
    <th>Branch</th>
    <th>Table</th>
    <th>Name</th>
    <th>Phone</th>
    <th>Date</th>
    <th>Time</th>
    <th>Guests</th>
    <th>Message</th>
    <th>Status</th>
    <th>Action</th>
</tr>
</thead>

<tbody>

<%
try {
    Connection con = DBConnection.getConnection();
    PreparedStatement ps;

    if (isOwnerAdmin) {
        ps = con.prepareStatement(
            "SELECT r.*, b.branch_name, b.location, rt.table_name, rt.capacity " +
            "FROM reservations r " +
            "LEFT JOIN branches b ON r.branch_id=b.id " +
            "LEFT JOIN reservation_tables rt ON r.table_no=rt.id " +
            "ORDER BY r.id ASC"
        );
    } else {
        ps = con.prepareStatement(
            "SELECT r.*, b.branch_name, b.location, rt.table_name, rt.capacity " +
            "FROM reservations r " +
            "LEFT JOIN branches b ON r.branch_id=b.id " +
            "LEFT JOIN reservation_tables rt ON r.table_no=rt.id " +
            "WHERE r.branch_id=? " +
            "ORDER BY r.id ASC"
        );

        ps.setInt(1, staffBranchId);
    }

    ResultSet rs = ps.executeQuery();
    boolean hasReservation = false;

    while (rs.next()) {
        hasReservation = true;

        int reservationId = rs.getInt("id");
        String status = rs.getString("status");

        if (status == null || status.trim().equals("")) {
            status = "Pending";
        }

        String statusClass = "inactive";

        if ("Accepted".equalsIgnoreCase(status)) {
            statusClass = "active";
        } else if ("Rejected".equalsIgnoreCase(status)) {
            statusClass = "rejected";
        }

        String tableName = rs.getString("table_name");
        String capacity = rs.getString("capacity");
%>

<tr class="reservation-row">

    <td><%= rs.getRow() %></td>

    <td>
        <%= rs.getString("branch_name") %><br>
        <small><%= rs.getString("location") %></small>
    </td>

    <td>
        <%= tableName == null ? "No Table" : tableName %><br>
        <small><%= capacity == null ? "" : capacity + " Persons" %></small>
    </td>

    <td><%= rs.getString("customer_name") %></td>
    <td><%= rs.getString("phone") %></td>
    <td><%= rs.getDate("reservation_date") %></td>
    <td><%= rs.getTime("reservation_time") %></td>
    <td><%= rs.getInt("guests") %></td>
    <td><%= rs.getString("message") %></td>

    <td>
        <span class="status <%= statusClass %>">
            <%= status %>
        </span>
    </td>

    <td>
        <div class="reservation-action-box">

            <% if ("Pending".equalsIgnoreCase(status)) { %>

            <form action="<%= request.getContextPath() %>/updateReservationStatus"
                  method="post">
                <input type="hidden" name="id" value="<%= reservationId %>">
                <input type="hidden" name="status" value="Accepted">
                <button type="submit" class="accept-btn">Accept</button>
            </form>

            <form action="<%= request.getContextPath() %>/updateReservationStatus"
                  method="post">
                <input type="hidden" name="id" value="<%= reservationId %>">
                <input type="hidden" name="status" value="Rejected">
                <button type="submit" class="reject-btn">Reject</button>
            </form>

            <% } else { %>

            <span class="status <%= statusClass %>">
                <%= status %>
            </span>

            <% } %>

        </div>
    </td>

</tr>

<%
    }

    if (!hasReservation) {
%>

<tr>
    <td colspan="11">No reservations found</td>
</tr>

<%
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
%>

<tr>
    <td colspan="11">
        <h2>Error loading reservations</h2>
        <p><%= e.getMessage() %></p>
    </td>
</tr>

<%
}
%>

</tbody>
</table>

<div id="reservationPages" class="table-pagination"></div>

</section>
<script>
function searchReservation() {
    let input = document.getElementById("reservationSearch").value.toLowerCase();
    let rows = document.querySelectorAll(".reservation-row");

    rows.forEach(function(row) {
        let text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? "" : "none";
    });
}

function loadAdminTables() {
    let branchId = document.getElementById("adminBranchId").value;
    let tableBox = document.getElementById("adminTableNo");

    tableBox.innerHTML = "<option value=''>Loading...</option>";

    if (branchId === "") {
        tableBox.innerHTML = "<option value=''>Select Branch First</option>";
        return;
    }

    fetch("loadReservationTables?branchId=" + branchId)
        .then(function(response) {
            return response.text();
        })
        .then(function(data) {
            tableBox.innerHTML = data;
        })
        .catch(function() {
            tableBox.innerHTML = "<option value=''>Table Load Error</option>";
        });
}

window.addEventListener("load", function() {
    var staffMode = <%= isStaff ? "true" : "false" %>;

    if (staffMode) {
        loadAdminTables();
    }
});

function downloadReservationsExcel() {

    let rows =
        document.querySelectorAll(
            "#reservationTable tbody tr"
        );

    let csv =
        "ID,Branch,Table,Name,Phone,Date,Time,Guests,Message,Status\n";

    rows.forEach(function(row) {

        let cols =
            row.querySelectorAll("td");

        if (cols.length >= 10) {

            csv +=

                '"' + cols[0].innerText.trim() + '",' +

                '"' + cols[1].innerText.trim().replace(/\n/g, " - ") + '",' +

                '"' + cols[2].innerText.trim().replace(/\n/g, " - ") + '",' +

                '"' + cols[3].innerText.trim() + '",' +

                '"' + cols[4].innerText.trim() + '",' +

                '"' + cols[5].innerText.trim() + '",' +

                '"' + cols[6].innerText.trim() + '",' +

                '"' + cols[7].innerText.trim() + '",' +

                '"' + cols[8].innerText.trim() + '",' +

                '"' + cols[9].innerText.trim() + '"\n';
        }
    });

    let blob = new Blob(
        ["\ufeff" + csv],
        {
            type: "text/csv;charset=utf-8;"
        }
    );

    let link =
        document.createElement("a");

    link.href =
        URL.createObjectURL(blob);

    link.download =
        "restaurant_reservations.csv";

    document.body.appendChild(link);

    link.click();

    document.body.removeChild(link);
}

function downloadReservationsPDF() {

    window.print();
}

</script>


<script src="pagination.js?v=10"></script>

<script>
window.addEventListener("load", function() {

    paginateRows("tableTypeTable", "tableTypePages", 5);

    paginateRows("reservationTable", "reservationPages", 5);

});
</script>


</body>
</html>