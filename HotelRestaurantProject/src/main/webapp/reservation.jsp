<%@ page import="java.sql.*" %>
<%@ page import="com.myapp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
Integer customerBranchId =
        (Integer) session.getAttribute("customerBranchId");

String customerBranchName = "";
String customerBranchLocation = "";

if (customerBranchId == null) {

    response.sendRedirect("index.jsp");
    return;
}

try {

    Connection branchCon =
        DBConnection.getConnection();

    PreparedStatement branchPs =
        branchCon.prepareStatement(
            "SELECT branch_name, location " +
            "FROM branches " +
            "WHERE id=?"
        );

    branchPs.setInt(1, customerBranchId);

    ResultSet branchRs =
        branchPs.executeQuery();

    if (branchRs.next()) {

        customerBranchName =
            branchRs.getString("branch_name");

        customerBranchLocation =
            branchRs.getString("location");
    }

    branchRs.close();
    branchPs.close();
    branchCon.close();

} catch (Exception e) {

    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Reservation</title>

<link rel="stylesheet" href="style.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<header>

    <div class="logo">

        <img src="images/logo.png"
             alt="Royal Taste Logo">

        <span>Royal Taste</span>

    </div>

    <nav>

        <a href="index.jsp">Home</a>

        <a href="main-course.jsp">Main Course</a>

        <a href="starters.jsp">Starters</a>

        <a href="dessert.jsp">Dessert</a>

        <a href="cold-drinks.jsp">Cold Drinks</a>

        <a href="fresh-juice.jsp">Fresh Juice</a>

        <a href="reservation.jsp"
           class="reserve-btn">
           Reservation
        </a>

    </nav>

</header>

<section class="reservation-section">

<div class="reservation-closed-box"
     id="reservationClosedBox"
     style="display:none;">

    <h1>
        Reservation is not available
    </h1>

    <p>
        This branch reservation is closed.
    </p>

</div>

<form action="<%= request.getContextPath() %>/reservation"
      method="post"
      class="reservation-form"
      id="reservationForm">

    <h2>Book Your Table</h2>

    <input type="hidden"
           name="branchId"
           id="branchId"
           value="<%= customerBranchId %>">

    <div class="selected-branch-box">

        <h3>
            <%= customerBranchName %>
        </h3>

        <p>
            <%= customerBranchLocation %>
        </p>

    </div>

    <input type="text"
           name="name"
           placeholder="Your Name"
           required>

    <input type="email"
           name="email"
           placeholder="Email Address"
           required>

    <input type="text"
           name="phone"
           placeholder="Phone Number"
           required>

    <select name="tableNo"
            id="tableNo"
            required>
        <option value="">Loading Tables...</option>
    </select>

    <input type="date"
           name="bookingDate"
           required>

    <input type="time"
           name="bookingTime"
           required>

    <input type="number"
           name="guests"
           placeholder="Number of Guests"
           min="1"
           required>

    <textarea name="message"
              placeholder="Special Message"></textarea>

    <button type="submit"
            id="reservationSubmitBtn">

        Book Reservation

    </button>

</form>

</section>

<script>
function checkReservationAndLoadTables() {

    let branchId = document.getElementById("branchId").value;
    let closedBox = document.getElementById("reservationClosedBox");
    let reservationForm = document.getElementById("reservationForm");

    closedBox.style.display = "none";
    reservationForm.style.display = "block";

    fetch("checkReservationStatus?branchId=" + branchId)
        .then(function(response) {
            return response.text();
        })
        .then(function(status) {

            if (status.trim().toLowerCase() === "closed") {
                closedBox.style.display = "block";
                reservationForm.style.display = "none";
                return;
            }

            closedBox.style.display = "none";
            reservationForm.style.display = "block";

            loadTablesByBranch();
        })
        .catch(function() {
            closedBox.style.display = "none";
            reservationForm.style.display = "block";
        });
}

function loadTablesByBranch() {

    let branchId = document.getElementById("branchId").value;
    let tableBox = document.getElementById("tableNo");

    tableBox.innerHTML = "<option value=''>Loading Tables...</option>";

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

window.onload = function () {
    checkReservationAndLoadTables();
};
</script>

</body>
</html>