<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Proveedores</title>
    <link rel="stylesheet" href="style-Proyecto.css">
</head>
<body>
    <h1>Proveedores</h1>
    <div class="form-container">
        <h3>Búsqueda de Proveedores</h3>
        <form method="post">
            <!-- Filtros para la búsqueda -->
            <div class="form-group">
                <label>
                    <input type="checkbox" name="filterIdentificacion" id="filterIdentificacion" <%= request.getParameter("filterIdentificacion") != null ? "checked" : "" %>>
                    Identificación
                </label>
                <input type="text" name="identificacion" id="identificacion" value="<%= request.getParameter("identificacion") != null ? request.getParameter("identificacion") : "" %>">
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox" name="filterNombre" id="filterNombre" <%= request.getParameter("filterNombre") != null ? "checked" : "" %>>
                    Nombre
                </label>
                <input type="text" name="nombre" id="nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>">
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox" name="filterGenero" id="filterGenero" <%= request.getParameter("filterGenero") != null ? "checked" : "" %>>
                    Género
                </label>
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
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Teléfono</th>
                <th>Género</th>
                <th>Correo Electrónico</th>
                <th> <a href="proveedoresFormulario.jsp?action=add"><img src="presentacion/adicionar.png" width='30' height='30' title='adicionar'></a></th>
            </tr>
        </thead>
        <tbody>
            <% 
                String filtro = "tipo = 'P'"; 

              
                String filterIdentificacion = request.getParameter("filterIdentificacion");
                String identificacion = request.getParameter("identificacion");
                if ("on".equals(filterIdentificacion) && identificacion != null && !identificacion.isEmpty()) {
                    filtro += " AND identificacion = '" + identificacion + "'";
                }

                
                String filterNombre = request.getParameter("filterNombre");
                String nombre = request.getParameter("nombre");
                if ("on".equals(filterNombre) && nombre != null && !nombre.isEmpty()) {
                    filtro += " AND nombre LIKE '%" + nombre + "%'";
                }

                
                String filterGenero = request.getParameter("filterGenero");
                String genero = request.getParameter("genero");
                if ("on".equals(filterGenero) && genero != null && !genero.isEmpty()) {
                    filtro += " AND genero = '" + genero + "'";
                }

                
                List<Persona> proveedores = Persona.getListaEnObjetos(filtro, "nombre");

            
                for (Persona proveedor : proveedores) { 
            %>
            <tr>
                <td><%= proveedor.getIdentificacion() %></td>
                <td><%= proveedor.getNombre() %></td>
                <td><%= proveedor.getTelefono() %></td>
                <td><%= proveedor.getGenero() %></td>
                <td><%= proveedor.getCorreoElectronico() %></td>
                <td>
                    <a href="proveedoresFormulario.jsp?action=edit&id=<%= proveedor.getIdentificacion() %>"><img src="presentacion/modificar.png" width='30' height='30' title='Modificar'></a>
                    <a href="proveedoresActualizar.jsp?action=delete&id=<%= proveedor.getIdentificacion() %>"><img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'></a>
                    <a href="comprasPendientes.jsp?id=<%= proveedor.getIdentificacion()%>" title="Pagos Pendientes">
                        <img src="presentacion/pago.png"  width='30' height='30' alt="Pagos Pendientes"></a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
