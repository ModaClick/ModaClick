<%@page import="clases.TipoGenero"%>
<%@page import="clases.Persona"%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Estilo del contenedor del formulario */
    .form-container {
        max-width: 500px; /* Ancho máximo del formulario */
        margin: 50px auto; /* Centrar el formulario y agregar margen superior */
        padding: 20px; /* Espaciado interno */
        background: linear-gradient(to bottom left, #cccccc, #ccffff); /* Degradado suave entre azul claro y gris */
        border-radius: 8px; /* Bordes redondeados */
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Sombra del formulario */
    }

    /* Estilo del encabezado del formulario */
    h1 {
        text-align: center; /* Centrar el texto */
        color: #333333; /* Color del texto */
        font-size: 24px; /* Tamaño de fuente */
        font-weight: bold; /* Negrita */
        margin-bottom: 20px; /* Margen inferior */
    }

    /* Estilo de los botones */
    .btn-submit {
        background-color: #007BFF; /* Color del botón */
        color: white; /* Color del texto */
        border: none; /* Sin borde */
        border-radius: 30px; /* Bordes redondeados */
        padding: 10px 20px; /* Espaciado interno */
        font-size: 16px; /* Tamaño de fuente */
        cursor: pointer; /* Cambia el cursor al pasar sobre el botón */
        transition: background-color 0.3s ease; /* Transición de color */
        width: 100%; /* Botón de ancho completo */
    }

    .btn-submit:hover {
        background-color: #0056b3; /* Color del botón al pasar el mouse */
    }

    /* Estilo de los campos de entrada */
    .form-control {
        border-radius: 5px; /* Bordes redondeados */
        border: 1px solid #ced4da; /* Color del borde */
        padding: 10px; /* Espaciado interno */
        font-size: 16px; /* Tamaño de fuente */
    }

    /* Estilo de las etiquetas */
    label {
        font-weight: bold; /* Negrita */
    }

    /* Espacio entre los elementos del formulario */
    .form-group {
        margin-bottom: 1.8rem; /* Mayor espacio entre campos */
    }
</style>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Administrador</title>
</head>
<body>
<div class="form-container">
    <h1>Formulario de Administrador</h1>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        Persona administrador = "edit".equals(action) ? new Persona(id) : new Persona();
    %>
    <form action="admiActualizar.jsp" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        
        <% if ("edit".equals(action)) { %>
        <input type="hidden" name="oldId" value="<%= administrador.getIdentificacion() %>">
        <% } %>

        <div class="form-group">
            <label for="identificacion">Identificación:</label>
            <input type="text" id="identificacion" name="identificacion" value="<%= administrador.getIdentificacion() %>" <%= "edit".equals(action) ? "readonly" : "" %> class="form-control" required>
        </div>

        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre" value="<%= administrador.getNombre() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="telefono">Teléfono:</label>
            <input type="text" id="telefono" name="telefono" value="<%= administrador.getTelefono() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Género:</label>
            <%= new TipoGenero(administrador.getGenero()).getRadioButtons() %><br>
        </div>

        <div class="form-group">
            <label for="correoElectronico">Correo Electrónico:</label>
            <input type="email" id="correoElectronico" name="correoElectronico" value="<%= administrador.getCorreoElectronico() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="clave">Clave:</label>
            <input type="password" id="clave" name="clave" placeholder="Ingrese nueva clave (deje en blanco para no cambiar)" class="form-control">
        </div>

        <input type="hidden" name="tipo" value="A"> <!-- Tipo está predeterminado como Administrador -->

        <div class="text-center">
            <input type="submit" value="<%= "edit".equals(action) ? "Modificar" : "Adicionar" %>" class="btn-submit">
        </div>
    </form>
    <a href="administradores.jsp" class="btn btn-secondary mt-3">Volver a la lista de administradores</a>
</div>
</body>
</html>
