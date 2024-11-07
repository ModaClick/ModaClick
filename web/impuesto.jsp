<%@ page import="java.util.List" %>
<%@ page import="clases.Impuesto" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Impuestos</title>
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

        /* Evitar el desbordamiento en la tabla */
        .table-responsive {
            overflow-x: auto;
        }
    </style>
    <script type="text/javascript">
        function confirmarEliminacion(idImpuesto) {
            var confirmacion = confirm("¿Está seguro de que desea eliminar este impuesto?");
            if (confirmacion) {
                window.location.href = "impuestoActualizar.jsp?action=Eliminar&id=" + idImpuesto;
            }
        }
    </script>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <h2>IMPUESTOS</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Porcentaje</th>
                        <th>Descripción</th>
                        <th>
                            <a href="impuestoFormulario.jsp?action=adicionar">
                                <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            List<Impuesto> listaImpuestos = Impuesto.getListaEnObjetos(null, "nombre"); 
                            
                            for (Impuesto imp : listaImpuestos) {
                    %>
                    <tr>
                        <td><%= imp.getIdImpuesto() %></td>
                        <td><%= imp.getNombre() %></td>
                        <td><%= imp.getPorcentaje() %>%</td>
                        <td><%= imp.getDescripcion() %></td>
                        <td>
                            <a href="javascript:confirmarEliminacion('<%= imp.getIdImpuesto() %>')">
                                <img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'>
                            </a>
                            <a href="impuestoFormulario.jsp?action=update&id=<%= imp.getIdImpuesto() %>">
                                <img src="presentacion/modificar.png" width='30' height='30' title='Modificar'>
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

