<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Clientes</title>
        <link rel="stylesheet" href="estilos.css"> <!-- Asegúrate de tener un archivo de estilos CSS si es necesario -->
        <script>
            function eliminar(id) {
                var resultado = confirm("¿Seguro que deseas eliminar al cliente con ID " + id + "?");
                if (resultado) {
                    document.location = "clientesActualizar.jsp?action=delete&id=" + id;   
                }
            }
        </script>
    </head>
    <body>

        <div class="form-container">
            <h3>Búsqueda de Clientes</h3>
            <form method="post">
                <!-- Checkboxes para seleccionar filtros -->
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="filterIdentificacion" id="filterIdentificacion" <%= request.getParameter("filterIdentificacion") != null ? "checked" : ""%>>
                        Identificación
                    </label>
                    <input type="text" name="identificacion" id="identificacion" value="<%= request.getParameter("identificacion") != null ? request.getParameter("identificacion") : ""%>">
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="filterNombre" id="filterNombre" <%= request.getParameter("filterNombre") != null ? "checked" : ""%>>
                        Nombre
                    </label>
                    <input type="text" name="nombre" id="nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : ""%>">
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="filterGenero" id="filterGenero" <%= request.getParameter("filterGenero") != null ? "checked" : ""%>>
                        Género
                    </label>
                    <select name="genero" id="genero">
                        <option value="" <%= "".equals(request.getParameter("genero")) ? "selected" : ""%>>Todos</option>
                        <option value="M" <%= "M".equals(request.getParameter("genero")) ? "selected" : ""%>>Masculino</option>
                        <option value="F" <%= "F".equals(request.getParameter("genero")) ? "selected" : ""%>>Femenino</option>
                    </select>
                </div>
                <div class="form-group">
                    <input type="submit" value="Buscar">
                </div>
            </form>
        </div>

        <table border="1">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Teléfono</th>
                    <th>Género</th>
                    <th>Correo Electrónico</th>
                    <th>
                        <a href="clientesFormulario.jsp?action=add" title="Adicionar Nuevo Cliente">
                            <img src="presentacion/adicionar.png" alt="Adicionar">
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
<%
    String filtro = "tipo = 'C'";  // Solo clientes
    
    // Construir el filtro basado en los checkboxes seleccionados
    // Filtrar por identificación
    String filterIdentificacion = request.getParameter("filterIdentificacion");
    String identificacion = request.getParameter("identificacion");
        if ("on".equals(filterIdentificacion) && identificacion != null && !identificacion.isEmpty()) {
            filtro += " AND identificacion = '" + identificacion + "'";
        }

        // Filtrar por nombre
    String filterNombre = request.getParameter("filterNombre");
    String nombre = request.getParameter("nombre");
        if ("on".equals(filterNombre) && nombre != null && !nombre.isEmpty()) {
            filtro += " AND nombre LIKE '%" + nombre + "%'";
        }

        // Filtrar por género
    String filterGenero = request.getParameter("filterGenero");
    String genero = request.getParameter("genero");
        if ("on".equals(filterGenero) && genero != null && !genero.isEmpty()) {
            filtro += " AND genero = '" + genero + "'";
        }

        // Obtener solo la lista de clientes filtrados
        List<Persona> clientes = Persona.getListaEnObjetos(filtro, "nombre");

        // Recorrer la lista de clientes y mostrar los datos en la tabla
        for (Persona cliente : clientes) {
%>

<tr>
        <td><%= cliente.getIdentificacion()%></td>
        <td><%= cliente.getNombre()%></td>
        <td><%= cliente.getTelefono()%></td>
        <td><%= cliente.getGenero()%></td>
        <td><%= cliente.getCorreoElectronico()%></td>
        <td>
        <a href="clientesFormulario.jsp?action=edit&id=<%= cliente.getIdentificacion()%>" title="Modificar">
            <img src="presentacion/modificar.png" alt="Modificar">
        </a>
        <img src="presentacion/eliminar.png" alt="Eliminar" title="Eliminar" onClick="eliminar('<%= cliente.getIdentificacion()%>')">
        <a href="facturasPendientes.jsp?id=<%= cliente.getIdentificacion()%>" title="Pagos Pendientes">
            <img src="presentacion/pago.png" alt="Pagos Pendientes">
        </a>
    </td>
</tr>
<% } %>
            </tbody>
        </table>

        <script>
            // Crear un arreglo con las identificaciones de los clientes
            var identificaciones = [
            <% for (Persona cliente : clientes) {%>
                "<%= cliente.getIdentificacion()%>",
            <% }%>
            ];

            // Configurar el autocompletado en el campo de identificación
            $("#identificacion").autocomplete({
                source: identificaciones,
                minLength: 2
            });

        </script>

    </body>
</html>
