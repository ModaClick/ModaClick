<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Categorías</title>
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
        .btn-add {
            background-color: #28a745;
        }
        .btn-modify {
            background-color: #ffc107;
        }
        .btn-delete {
            background-color: #dc3545;
        }

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
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
    <h3>CATEGORÍAS</h3>
     
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th> <a href="principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Adicionar" class="btn btn-action btn-add">
                <img src="presentacion/adicionar.png" class="icono" alt="Adicionar"> 
                        </a> </th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Categoria> datos = Categoria.getListaEnObjetos(null, null);
                    for (Categoria categoria : datos) { 
                %>
                <tr>
                    <td><%= categoria.getIdCategoria() %></td>
                    <td><%= categoria.getNombre() %></td>
                    <td><%= categoria.getDescripcion() %></td>
                    <td>
                     
                        <a href="principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Modificar&id=<%= categoria.getIdCategoria() %>" class="btn btn-action btn-edit">
                            <img src="presentacion/modificar.png" class="icono" alt="Modificar"> 
                        </a>
                        <button onclick="confirmarEliminacion(<%= categoria.getIdCategoria() %>)" class="btn btn-action btn-delete">
                            <img src="presentacion/eliminar.png" class="icono" alt="Eliminar"> 
                        </button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</div>

<script type="text/javascript">
    function confirmarEliminacion(id) {
        let respuesta = confirm("¿Realmente desea eliminar el registro?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=categoriasActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }
</script>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
