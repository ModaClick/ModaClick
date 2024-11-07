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
<body>

<div class="container-fluid">
    <div class="table-container">
        <h2>ADMINISTRADORES</h2>
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
                           <a href="adminFormulario.jsp?action=add" class="btn btn-action btn-add" title="Adicionar">
                            <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
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
                           <a href="adminFormulario.jsp?action=edit&id=<%= administrador.getIdentificacion() %>" class="btn-action btn-edit" title="Modificar">
                            <img src="presentacion/modificar.png" width='30' height='30' title='Modificar'>
                        </a>
                        <a href="admiActualizar.jsp?action=delete&id=<%= administrador.getIdentificacion() %>" class="btn-action btn-delete" title="Eliminar">
                            <img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'>
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
