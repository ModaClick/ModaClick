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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Dosis:wght@200..800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="recursos/jquery-ui-1.13.3.custom/jquery-ui.css">
    <script src="recursos/jquery-3.7.1.min.js"></script>
    <script src="recursos/jquery-ui-1.13.3.custom/jquery-ui.min.js"></script>
    <script src="recursos/amcharts5/index.js"></script>
    <script src="recursos/amcharts5/xy.js"></script>
    <script src="recursos/amcharts5/themes/Animated.js"></script>
    
    <link rel="stylesheet" href="recursos/bootstrap-3.0.3-dist.zip">
    <!-- Estilos de Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        * {
            font-family: "Dosis", sans-serif; /* Aplicar la fuente Dosis a todo el cuerpo */
           
        }

        #chartdiv {
            width: 100%;
            height: 500px;
        }

        @media (max-width: 768px) {
            #menu {
                width: 100%; /* Hacer que el menú ocupe todo el ancho en pantallas pequeñas */
            }
        }
        /* Estilos del menú */
        #menu {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 300px;
            background: white; /* Fondo blanco */
            transform: translateX(-100%);
            transition: transform 0.3s ease;
            z-index: 1000;
            padding-top: 40px;
            color: black; /* Texto negro */
            overflow-y: auto;
            border-right: 1px solid black; /* Borde derecho negro */
        }
        #menu.show {
            transform: translateX(0);
        }
        .menu-icon {
            position: fixed;
            top: 15px;
            left: 15px;
            font-size: 30px;
            color: black; /* Icono del menú en negro */
            cursor: pointer;
            z-index: 1001;
        }
        .menu-content a {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            text-decoration: none;
            color: black; /* Texto del menú en negro */
            font-size: 1.2em;
            transition: background 0.3s ease;
        }
        .menu-content a i {
            margin-right: 10px;
            color: black; /* Iconos en negro */
        }
        .menu-content a:hover {
            background: rgba(0, 0, 0, 0.1); /* Hover con fondo gris claro */
        }
        
        /* Estilos para submenús desplegables */
        .menu ul {
            padding-left: 0;
            list-style: none;
        }
        .menu li {
            list-style: none;
        }
        .menu li.submenu > a {
            font-weight: bold;
            color: black;
        }
        .menu li.submenu ul {
            display: none;
            padding-left: 20px;
        }
        .menu li.submenu:hover ul {
            display: block;
        }
        .menu li.submenu ul li a {
            color: black; /* Texto en negro para submenús */
            padding: 8px 15px;
            display: block;
            text-align: left;
        }
        .menu li.submenu ul li a:hover {
            background: rgba(0, 0, 0, 0.1);
        }

        /* Iconos específicos */
        .icon-home::before { content: "\f015"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-category::before { content: "\f03a"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-inventory::before { content: "\f291"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-payment::before { content: "\f09d"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-shipping::before { content: "\f0d1"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-admin::before { content: "\f007"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-supplier::before { content: "\f0d1"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-client::before { content: "\f0c0"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-sales::before { content: "\f53d"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-purchases::before { content: "\f217"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-orders::before { content: "\f0ae"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-returns::before { content: "\f2e3"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-reports::before { content: "\f201"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
        .icon-indicators::before { content: "\f201"; font-family: "Font Awesome 5 Free"; font-weight: 900; margin-right: 10px; color: black; }
    </style>
</head>
<body>
    <header>
        <!-- Ícono del menú hamburguesa -->
        <div class="menu-icon" onclick="menuHamburguesa();">&#9776;</div>
        
        <!-- Menú lateral con contenido dinámico -->
        <div id="menu" class="menu-content">
            <!-- Contenido dinámico del menú -->
            <%=USUARIO.getTipoEnObjeto().getMenu()%>
        </div>
        
        <!-- Contenido de la página -->
        <div id="contenido">
           <jsp:include page='<%=request.getParameter("CONTENIDO")%>' flush="true" />   
        </div>
    </header>
    
    <!-- Script para mostrar/ocultar el menú -->
    <script>
        function menuHamburguesa() {
            var menu = document.getElementById('menu');
            menu.classList.toggle('show');
        }
    </script>
</body>
</html>
