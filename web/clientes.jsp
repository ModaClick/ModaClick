
<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Clientes</title>
    <!-- Incluye jQuery y jQuery UI para el autocompletado -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
</head>
<body>

<div class="form-container">
    <h3>Búsqueda de Clientes</h3>
    <form method="post">
        <!-- Campo de identificación con autocompletado -->
        <div class="form-group">
            <label for="identificacion">Identificación</label>
            <input type="text" name="identificacion" id="identificacion" value="<%= request.getParameter("identificacion") != null ? request.getParameter("identificacion") : "" %>">
        </div>
        <div class="form-group">
            <label for="nombre">Nombre</label>
            <input type="text" name="nombre" id="nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>">
        </div>
        <div class="form-group">
            <label for="genero">Género</label>
            <select name="genero" id="genero">
                <option value="" <%= "".equals(request.getParameter("genero")) ? "selected" : "" %>>Todos</option>
                <option value="M" <%= "M".equals(request.getParameter("genero")) ? "selected" : "" %>>Masculino</option>
                <option value="F" <%= "F".equals(request.getParameter("genero")) ? "selected" : "" %>>Femenino</option>
            </select>
        </div>
        <div class="form-group">
            <input type="submit" value="Buscar">
        </div>
    </form>
</div>
<table border="1">
    <thead>
        <h1>Cliente</h1>
            <a href="clientesFormulario.jsp?action=add">Adicionar Nuevo Cliente</a>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Teléfono</th>
            <th>Género</th>
            <th>Correo Electrónico</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <% 
            String filtro = "tipo = 'C'";  // Solo clientes

            // Filtrar por identificación
            String identificacion = request.getParameter("identificacion");
            if (identificacion != null && !identificacion.isEmpty()) {
                filtro += " AND identificacion = '" + identificacion + "'";
            }

            // Filtrar por nombre
            String nombre = request.getParameter("nombre");
            if (nombre != null && !nombre.isEmpty()) {
                filtro += " AND nombre LIKE '%" + nombre + "%'";
            }

            // Filtrar por género
            String genero = request.getParameter("genero");
            if (genero != null && !genero.isEmpty()) {
                filtro += " AND genero = '" + genero + "'";
            }

            // Obtener solo la lista de clientes filtrados
            List<Persona> clientes = Persona.getListaEnObjetos(filtro, "nombre");

            // Recorrer la lista de clientes y mostrar los datos en la tabla
            for (Persona cliente : clientes) { 
        %>
        <tr>
            <td><%= cliente.getIdentificacion() %></td>
            <td><%= cliente.getNombre() %></td>
            <td><%= cliente.getTelefono() %></td>
            <td><%= cliente.getGenero() %></td>
            <td><%= cliente.getCorreoElectronico() %></td>
            <td>
                <a href="clientesFormulario.jsp?action=edit&id=<%= cliente.getIdentificacion() %>">Modificar</a>
                <a href="clientesActualizar.jsp?action=delete&id=<%= cliente.getIdentificacion() %>">Eliminar</a>
                <a href="comprasPendientes.jsp?id=<%= cliente.getIdentificacion() %>">Pagos Pendientes</a>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>

<script>
    // Crear un arreglo con las identificaciones de los clientes
    var identificaciones = [
        <% for (Persona cliente : clientes) { %>
            "<%= cliente.getIdentificacion() %>",
        <% } %>
    ];

    // Configurar el autocompletado en el campo de identificación
    $("#identificacion").autocomplete({
        source: identificaciones,
        minLength: 2
    });
</script>

</body>
</html>
