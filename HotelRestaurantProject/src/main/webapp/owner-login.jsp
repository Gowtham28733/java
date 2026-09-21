<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Owner Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<section class="login-page">

    <form action="<%= request.getContextPath() %>/ownerLogin" method="post" class="login-card">
        <h1>Owner Login</h1>

        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>

    </form>

</section>

</body>
</html>