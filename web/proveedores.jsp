<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Proveedores</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Estilo de encabezado centrado */
        .table-container h3 {
            text-align: center;
            color: #333;
            margin: 0;
            padding: 15px 0;
            font-size: 24px;
        }

        /* Expansión de contenedor de la tabla en toda la página */
        .table-container {
            width: 100%;
            padding: 0;
            margin: 20px 0;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
        }

        /* Estilo de la tabla */
        table.table {
            width: 100%;
            border-collapse: collapse;
        }

        /* Encabezado de las columnas de la tabla */
        .table thead th {
            background-color: #343a40;
            color: white;
            font-weight: bold;
            text-align: center;
        }

        /* Celdas de la tabla */
        .table tbody td {
            text-align: center;
            vertical-align: middle;
            padding: 10px;
        }

        /* Estilos de botones de acción */
        .btn-add {
            font-size: 14px;
            color: white;
            background-color: #28a745;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
        }
        .action-btn {
            padding: 5px;
            font-size: 14px;
            color: white;
            border-radius: 4px;
            margin: 2px;
        }
        .btn-modify { background-color: #ffc107; }
        .btn-delete { background-color: #dc3545; }

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }

        /* Evitar el desbordamiento en la tabla */
        .table-responsive {
            overflow-x: auto;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="table-container">
        <h3>PROVEEDORES</h3>
        <div class="form-container mb-3">
            <h4>Búsqueda de Proveedores</h4>
            <form method="post">
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="filterIdentificacion" id="filterIdentificacion" <%= request.getParameter("filterIdentificacion") != null ? "checked" : "" %>>
                                    Identificación
                                </div>
                            </div>
                            <input type="text" class="form-control" name="identificacion" id="identificacion" placeholder="Ingrese identificación" value="<%= request.getParameter("identificacion") != null ? request.getParameter("identificacion") : "" %>">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="filterNombre" id="filterNombre" <%= request.getParameter("filterNombre") != null ? "checked" : "" %>>
                                    Nombre
                                </div>
                            </div>
                            <input type="text" class="form-control" name="nombre" id="nombre" placeholder="Ingrese nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="filterGenero" id="filterGenero" <%= request.getParameter("filterGenero") != null ? "checked" : "" %>>
                                    Género
                                </div>
                            </div>
                            <select name="genero" id="genero" class="form-control">
                                <option value="" <%= "".equals(request.getParameter("genero")) ? "selected" : "" %>>Todos</option>
                                <option value="M" <%= "M".equals(request.getParameter("genero")) ? "selected" : "" %>>Masculino</option>
                                <option value="F" <%= "F".equals(request.getParameter("genero")) ? "selected" : "" %>>Femenino</option>
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Buscar</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Teléfono</th>
                        <th>Género</th>
                        <th>Correo Electrónico</th>
                        <th>
                            <a href="proveedoresFormulario.jsp?action=add" title="Adicionar" class="action-btn btn-add">
                                <img src="presentacion/adicionar.png" class="icono" alt="Adicionar">
                            </a>
                        </th>
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
                            <a href="proveedoresFormulario.jsp?action=edit&id=<%= proveedor.getIdentificacion() %>" class="action-btn btn-modify" title="Modificar">
                                <img src="presentacion/modificar.png" width="16" alt="Modificar">
                            </a>
                            <a href="javascript:void(0)" onclick="confirmarEliminacion('<%= proveedor.getIdentificacion() %>')" class="action-btn btn-delete" title="Eliminar">
                                <img src="presentacion/eliminar.png" width="16" alt="Eliminar">
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function confirmarEliminacion(id) {
        var resultado = confirm("¿Realmente desea eliminar el proveedor " + id + " del sistema?");
        if (resultado) {
            document.location = "proveedoresActualizar.jsp?action=delete&id=" + id;   
        }   
    }
</script>
</body>
</html>
