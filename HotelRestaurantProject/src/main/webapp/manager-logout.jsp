<%@ page contentType="text/html;charset=UTF-8" %>


<%
session.removeAttribute("manager");
session.removeAttribute("managerId");
session.removeAttribute("branchId");
response.sendRedirect("manager-login.jsp");
%>