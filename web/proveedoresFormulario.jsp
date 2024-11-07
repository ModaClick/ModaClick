<%@page import="clases.TipoGenero"%>
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

<%
    String action = request.getParameter("action");
    Persona proveedor = new Persona();

    if ("edit".equals(action)) {
        String id = request.getParameter("id");
        proveedor = new Persona(id);  // Se carga el proveedor por su ID para modificar
    }
%>

<div class="form-container">
    <h2><%= action.equals("edit") ? "MODIFICAR PROVEEDOR" : "AGREGAR PROVEEDOR" %></h2>
    <form method="POST" action="proveedoresActualizar.jsp">
        <input type="hidden" name="action" value="<%= action %>">
        <input type="hidden" name="oldId" value="<%= proveedor.getIdentificacion() %>">

        <div class="form-group">
            <label>Identificaci�n:</label>
            <input type="text" name="identificacion" value="<%= proveedor.getIdentificacion() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Nombre:</label>
            <input type="text" name="nombre" value="<%= proveedor.getNombre() %>" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Tel�fono:</label>
            <input type="text" name="telefono" value="<%= proveedor.getTelefono() %>" class="form-control" required>
        </div>

         <div class="form-group">
            <label>G�nero:</label>
            <%= new TipoGenero(proveedor.getGenero()).getRadioButtons() %><br>
        </div>

        <div class="form-group">
            <label>Correo Electr�nico:</label>
            <input type="email" name="correoElectronico" value="<%= proveedor.getCorreoElectronico() %>" class="form-control" required>
        </div>

        <div class="text-center">
            <input type="submit" value="<%= action.equals("edit") ? "Modificar" : "Agregar" %>" class="btn-submit">
        </div>
    </form>
    
</div>
