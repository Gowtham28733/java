<%@ page contentType="text/html;charset=UTF-8" %>

<%
session.removeAttribute("staff");
session.removeAttribute("staffId");
session.removeAttribute("access_payment");
session.removeAttribute("access_food");
session.removeAttribute("access_orders");
session.removeAttribute("access_reservations");
session.removeAttribute("access_services");

response.sendRedirect("staff-login.jsp");
%>