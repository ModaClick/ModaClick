<%@page import="java.util.List"%>
<%@page import="clases.TipoEnvio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Tipos de Envío</title>
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
        .btn-edit {
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
    </style>
</head>
<body class="bg-light">

<%
    String lista = "";
    List<TipoEnvio> datos = TipoEnvio.getListaEnObjetos(null, null);
    for (TipoEnvio envio : datos) {
        lista += "<tr>";
        lista += "<td>" + envio.getId() + "</td>";
        lista += "<td>" + envio.getNombre() + "</td>";
        lista += "<td>" + envio.getDescripcion() + "</td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=enviosFormulario.jsp&accion=Modificar&id=" + envio.getId() + 
                "' title='Modificar' class='btn btn-action btn-edit'><img src='presentacion/modificar.png' class='icono' width='16'></a> ";
        lista += "<a href='javascript:void(0)' onclick='confirmarEliminacion(" + envio.getId() + ")' title='Eliminar' class='btn btn-action btn-delete'><img src='presentacion/eliminar.png' class='icono' width='16'></a>";
        lista += "</td>";
        lista += "</tr>";
    }
%>

<div class="container-fluid">
    <div class="table-container">
        <h3>TIPOS DE ENVÍO</h3>
        <form name="formulario" method="post" class="mb-3">
            <div class="form-row">
                <!-- Campos de filtro aquí -->
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>
                            <a href="principal.jsp?CONTENIDO=enviosFormulario.jsp&accion=Adicionar" title="Adicionar" class="btn btn-action btn-add">
                                <img src="presentacion/adicionar.png" class="icono" alt="Adicionar">
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%= lista %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
    function confirmarEliminacion(id) {
        var respuesta = confirm("¿Seguro que quieres eliminar el tipo de envío " + id + " del sistema?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=enviosActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }
</script>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
