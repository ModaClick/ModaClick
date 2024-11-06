<%-- 
    Document   : principal.jsp
    Created on : 25/04/2024, 11:16:54 AM
    Author     : CASA
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
    <link rel="stylesheet" type="text/css" href="presentacion/main.css">
    
    <!-- Aquí incluimos el estilo para el fondo de pantalla -->
    <style>
        body {
            background-image: url('presentacion/fondo5.jpg');
            background-size: cover; /* Ajusta para cubrir toda la pantalla */
            background-position: center center; /* Centra la imagen */
            background-repeat: no-repeat; /* Evita que la imagen se repita */
            background-attachment: fixed; /* Mantiene el fondo fijo */
            height: 100vh; /* Asegura que cubra toda la ventana del navegador */
            margin: 0;
            padding: 0;            
        }
    </style>
</head>
<body>
    <header>
        <div id="banner"></div>
        <div id="menu">
            <div class="menu-icon" onclick="menuHamburguesa();">&#9776;</div>
            <div class="menu-content">
                 <%=USUARIO.getTipoEnObjeto().getMenu()%>
            </div>
            </div>
            <div id="contenido">
               <jsp:include page='<%=request.getParameter("CONTENIDO")%>' flush="true" />   
        </div>
    </header>
        <script>
            function menuHamburguesa(){
                var menuContent = document.querySelector('.menu-content');
                menuContent.classList.toggle('show');
            }
        </script>
</body>
</html>

