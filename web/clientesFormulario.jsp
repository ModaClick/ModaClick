<%@page import="clases.TipoGenero" %>
<%@page import="clases.Persona" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Estilo del contenedor del formulario */
    .form-container {
        max-width: 500px; /* Ancho m�ximo del formulario */
        margin: 50px auto; /* Centrar el formulario y agregar margen superior */
        padding: 20px; /* Espaciado interno */
        background: linear-gradient(to bottom left, #cccccc, #ccffff); /* Degradado suave entre azul claro y gris */
        border-radius: 8px; /* Bordes redondeados */
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Sombra del formulario */
    }

    /* Estilo del encabezado del formulario */
    h2 {
        text-align: center; /* Centrar el texto */
        color: #333333; /* Color del texto */
        font-size: 24px; /* Tama�o de fuente */
        font-weight: bold; /* Negrita */
        margin-bottom: 20px; /* Margen inferior */
    }

    /* Estilo de los botones */
    .btn-submit {
        background-color: #007BFF; /* Color del bot�n */
        color: white; /* Color del texto */
        border: none; /* Sin borde */
        border-radius: 30px; /* Bordes redondeados */
        padding: 10px 20px; /* Espaciado interno */
        font-size: 16px; /* Tama�o de fuente */
        cursor: pointer; /* Cambia el cursor al pasar sobre el bot�n */
        transition: background-color 0.3s ease; /* Transici�n de color */
        width: 100%; /* Bot�n de ancho completo */
    }

    .btn-submit:hover {
        background-color: #0056b3; /* Color del bot�n al pasar el mouse */
    }

    /* Estilo de los campos de entrada */
    .form-control {
        border-radius: 5px; /* Bordes redondeados */
        border: 1px solid #ced4da; /* Color del borde */
        padding: 10px; /* Espaciado interno */
        font-size: 16px; /* Tama�o de fuente */
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
    <title>Agregar cliente</title>
</head>
<body>
<div class="form-container">
    <h2>AGREGAR CLIENTE</h2>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        Persona cliente = "edit".equals(action) ? new Persona(id) : new Persona();
    %>
    <form action="clientesActualizar.jsp" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        
        <% if ("edit".equals(action)) { %>
        <input type="hidden" name="oldId" value="<%= cliente.getIdentificacion() %>">
        <% } %>

        <div class="form-group">
            <label for="identificacion">Identificaci�n:</label>
            <input type="text" id="identificacion" name="identificacion" value="<%= cliente.getIdentificacion() %>" <%= "edit".equals(action) ? "readonly" : "" %> class="form-control" required>
        </div>

        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre" value="<%= cliente.getNombre() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="telefono">Tel�fono:</label>
            <input type="text" id="telefono" name="telefono" value="<%= cliente.getTelefono() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label>G�nero:</label>
            <%= new TipoGenero(cliente.getGenero()).getRadioButtons() %><br>
        </div>

        <div class="form-group">
            <label for="correoElectronico">Correo Electr�nico:</label>
            <input type="email" id="correoElectronico" name="correoElectronico" value="<%= cliente.getCorreoElectronico() %>" class="form-control" required>
        </div>

        <input type="hidden" name="tipo" value="C"> <!-- Tipo est� predeterminado como Cliente -->

        <div class="text-center">
            <input type="submit" value="<%= "edit".equals(action) ? "Modificar" : "Adicionar" %>" class="btn-submit">
        </div>
    </form>
    
</div>
</body>
</html>
