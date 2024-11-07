<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Proveedores</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Estilo de encabezado centrado */
        .table-container h2 {
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
        .btn-action {
            font-size: 14px;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            display: inline-flex;
            align-items: center;
            margin: 0 2px;
        }
        

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <h2>PROVEEDORES</h2>
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
                            <input type="text" name="identificacion" id="identificacion" value="<%= request.getParameter("identificacion") != null ? request.getParameter("identificacion") : "" %>" class="form-control" placeholder="Identificación">
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
                            <input type="text" name="nombre" id="nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" class="form-control" placeholder="Nombre del proveedor">
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

        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Teléfono</th>
                    <th>Género</th>
                    <th>Correo Electrónico</th>
                    <th>
                        <a href="proveedoresFormulario.jsp?action=add" class="btn btn-action btn-add" title="Adicionar">
                            <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
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
                        <a href="proveedoresFormulario.jsp?action=edit&id=<%= proveedor.getIdentificacion() %>" class="btn-action btn-edit" title="Modificar">
                            <img src="presentacion/modificar.png" width='30' height='30' title='Modificar'>
                        </a>
                        <a href="proveedoresActualizar.jsp?action=delete&id=<%= proveedor.getIdentificacion() %>" class="btn-action btn-delete" title="Eliminar">
                            <img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'>
                        </a>
                        <a href="comprasPendientes.jsp?accion=add&id=<%= proveedor.getIdentificacion()%>" class="btn-action btn-add" title="Pagos Pendientes">
                            <img src="presentacion/pagos.png" width='30' height='30' alt="Pagos Pendientes">
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
