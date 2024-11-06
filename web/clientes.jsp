<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Clientes</title>
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
        <h3>CLIENTES</h3>
        <div class="form-container mb-3">
            <h4>Búsqueda de Clientes</h4>
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
                            <a href="clientesFormulario.jsp?action=add" title="Adicionar" class="action-btn btn-add">
                                <img src="presentacion/adicionar.png" class="icono" alt="Adicionar">
                            </a>
                        </th>
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
                            <a href="clientesFormulario.jsp?action=edit&id=<%= cliente.getIdentificacion() %>" class="action-btn btn-modify" title="Modificar">
                                <img src="presentacion/modificar.png" width="16" alt="Modificar">
                            </a>
                            <a href="javascript:void(0)" onclick="confirmarEliminacion('<%= cliente.getIdentificacion() %>')" class="action-btn btn-delete" title="Eliminar">
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
        var resultado = confirm("¿Realmente desea eliminar el cliente " + id + " del sistema?");
        if (resultado) {
            document.location = "clientesActualizar.jsp?action=delete&id=" + id;   
        }   
    }
</script>
</body>
</html>
