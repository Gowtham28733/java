<%@ page contentType="text/html;charset=UTF-8" %>

<%
String branchId = request.getParameter("branchId");

if (branchId != null && !branchId.trim().equals("")) {
    session.setAttribute("customerBranchId", Integer.parseInt(branchId));
}

response.sendRedirect("main-course.jsp");
%>