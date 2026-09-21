<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Staff Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<section class="login-page">

    <form action="<%= request.getContextPath() %>/staffLogin"
          method="post"
          class="login-card">

        <h1>Staff Login</h1>

        <input type="text" name="username" placeholder="Staff Username" required>

        <input type="password" name="password" placeholder="Staff Password" required>

        <button type="submit">Login</button>

    </form>

</section>

</body>
</html>