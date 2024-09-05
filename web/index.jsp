
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String mensaje = "";
    if (request.getParameter("error") != null) {
        switch (request.getParameter("error")) {
            case "1":
                mensaje = "Usuario o contraseña incorrecto";
                break;
            case "2":
                mensaje = "Acceso denegado";
                break;
            default:
                mensaje = "Error desconocido";
        }
    }
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Software de Ventas</title>
    <link rel="stylesheet" type="text/css" href="Login.css">
</head>
<body>
    <center>
        <h3>MODACLICK :) </h3>
        <br>
        <p id="error"><%= mensaje %></p>
        <form name="formulario" method="post" action="validar.jsp">
            <div class="input-container">
                <input type="text" name="identificacion" required="" placeholder="Usuario">
                <i class='bx bxs-user'></i>
            </div>
            <div class="input-container">
                <input type="password" name="clave" required="" placeholder="Contraseña">
                <i class='bx bxs-lock-alt'></i>
            </div>
            <br>
            <input type="submit" value="Iniciar sesion">
        </form>
    </center>
</body>
</html>