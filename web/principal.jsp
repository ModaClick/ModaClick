<%-- 
    Document   : principal.jsp
    Created on : 25/04/2024, 11:16:54 AM
    Author     : SENA
--%>
<%@page import="clases.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    Persona USUARIO = null;
    if (sesion.getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp?error=2");
    } else {
        USUARIO = (Persona) sesion.getAttribute("usuario");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sistema de ventas</title>
    <link rel="stylesheet" type="text/css" href="Menu.css">
    <link rel="stylesheet" href="recursos/jquery-ui-1.13.3.custom/jquery-ui.css">
    <script src="recursos/jquery-3.7.1.min.js"></script>
    <script src="recursos/jquery-ui-1.13.3.custom/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <script src="recursos/amcharts5/index.js"></script>
    <script src="recursos/amcharts5/xy.js"></script>
    <script src="recursos/amcharts5/themes/Animated.js"></script>
</head>
<body>
    <div class="menu-container">
        <div class="menu">
            <div id="menu"><%=USUARIO.getTipoEnObjeto().getMenu()%></div>
        </div>
        <div class="content">
            <!-- Contenido dinámico -->
            <div id="contenido">
                <jsp:include page='<%=request.getParameter("CONTENIDO")%>' flush="true" />
            </div>
        </div>
    </div>
</body>
</html>

