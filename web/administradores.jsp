<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Administradores</title>
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
        .action-btn {
            padding: 5px;
            font-size: 14px;
            color: white;
            border-radius: 4px;
            margin: 2px;
        }
        .btn-primary { background-color: #00cc00; }
        .btn-modify { background-color: #ffc107; }
        .btn-delete { background-color: #dc3545; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="table-container">
        <h3>ADMINISTRADORES</h3>
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
                            <a href="admiFormulario.jsp?action=add" class="action-btn btn-primary" title="Adicionar">
                                <img src="presentacion/adicionar.png" width="20" alt="Adicionar">
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Obtener la lista de administradores
                        List<Persona> administradores = Persona.getListaEnObjetos("tipo='A'", "nombre");
                        
                        // Recorrer la lista de administradores y mostrar los datos en la tabla
                        for (Persona administrador : administradores) { 
                    %>
                    <tr>
                        <td><%= administrador.getIdentificacion() %></td>
                        <td><%= administrador.getNombre() %></td>
                        <td><%= administrador.getTelefono() %></td>
                        <td><%= administrador.getGenero() %></td>
                        <td><%= administrador.getCorreoElectronico() %></td>
                        <td>
                            <a href="admiFormulario.jsp?action=edit&id=<%= administrador.getIdentificacion() %>" class="action-btn btn-modify" title="Modificar">
                                <img src="presentacion/modificar.png" width="16" alt="Modificar">
                            </a>
                            <a href="javascript:void(0)" onclick="confirmarEliminacion('<%= administrador.getIdentificacion() %>')" class="action-btn btn-delete" title="Eliminar">
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
        var resultado = confirm("¿Realmente desea eliminar el administrador " + id + " del sistema?");
        if (resultado) {
            document.location = "admiActualizar.jsp?action=delete&id=" + id;   
        }   
    }
</script>
</body>
</html>
