<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.Inventario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Configuración para exportar a Excel o Word
    if (request.getParameter("formato") != null) {
        String tipoDeContenido = "";
        String extensionArchivo = "";
        switch (request.getParameter("formato")) {
            case "excel":
                tipoDeContenido = "application/vnd.ms-excel";
                extensionArchivo = ".xls";
                break;
            case "word":
                tipoDeContenido = "application/vnd.msword";
                extensionArchivo = ".doc";
                break;
        }
        response.setContentType(tipoDeContenido);
        response.setHeader("Content-Disposition", "inline; filename=\"reportePedidos" + extensionArchivo + "\"");
    }

    // Filtros para la búsqueda
    String filtro = "";
    String chkFecha = request.getParameter("chkFecha");
    String fechaInicio = "";
    String fechaFin = "";

    if (chkFecha != null) {
        chkFecha = "checked";
        fechaInicio = request.getParameter("fechaInicio");
        fechaFin = request.getParameter("fechaFin");
        filtro = "(fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "')";
    }

    String chkNombreArticulo = request.getParameter("chkNombreArticulo");
    String nombreArticulo = "";
    if (chkNombreArticulo != null) {
        chkNombreArticulo = "checked";
        nombreArticulo = request.getParameter("nombreArticulo");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "Inventario.nombreArticulo LIKE '%" + nombreArticulo + "%'";
    }

    // Filtro por nombre del cliente
    String chkNombreCliente = request.getParameter("chkNombreCliente");
    String nombreCliente = "";
    if (chkNombreCliente != null) {
        chkNombreCliente = "checked";
        nombreCliente = request.getParameter("nombreCliente");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "Persona.nombre LIKE '%" + nombreCliente + "%'";
    }

    // Obtener la lista de pedidos con el filtro aplicado
    List<Pedido> pedidos = Pedido.getListaEnObjetos(filtro, "fecha DESC");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Pedidos</title>
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
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <center><h2 class="report-title">REPORTE DE PEDIDOS</h2></center>

        <!-- Formulario de filtros -->
        <form method="post">
            <div class="form-row">
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkFecha" <%=chkFecha%>> Fecha de Pedido
                            </div>
                        </div>
                        Desde <input type="date" name="fechaInicio" value="<%=fechaInicio%>" class="form-control">
                        Hasta <input type="date" name="fechaFin" value="<%=fechaFin%>" class="form-control">
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo
                            </div>
                        </div>
                        <input type="text" name="nombreArticulo" value="<%=nombreArticulo%>" class="form-control">
                    </div>
                </div>
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkNombreCliente" <%=chkNombreCliente%>> Nombre Cliente
                            </div>
                        </div>
                        <input type="text" name="nombreCliente" value="<%=nombreCliente%>" class="form-control">
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="col">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </div>
            </div>
        </form>

        <!-- Opciones de exportación -->
        <p>
            <a href="Reportes/reportePedidos.jsp?formato=excel" target="_blank"><img src="presentacion/excel.png" width="50" height="50"></a>
            <a href="Reportes/reportePedidos.jsp?formato=word" target="_blank"><img src="presentacion/word.png" width="50" height="50"></a>
        </p>

        <div class="table-container">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cliente</th>
                        <th>Periodo</th>
                        <th>Cantidad</th>
                        <th>Valor Unitario</th>
                        <th>Abonado</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        double totalValorUnitario = 0, totalAbonado = 0, totalSubtotal = 0;

                        for (Pedido pedido : pedidos) {
                            List<PedidoDetalle> detalles = PedidoDetalle.getDetallesPorPedido(pedido.getId());
                            for (PedidoDetalle detalle : detalles) {
                                Inventario inventario = new Inventario(detalle.getIdArticulo());

                                double valorUnitario = Double.parseDouble(detalle.getValorUnitVenta());
                                double cantidad = Double.parseDouble(detalle.getCantidad());
                                double subtotal = valorUnitario * cantidad;
                                double abonado = pedido.obtenerTotalAbonado();

                                totalValorUnitario += valorUnitario;
                                totalAbonado += abonado;
                                totalSubtotal += subtotal;
                    %>
                    <tr>
                        <td><%= inventario.getNombreArticulo() %></td>
                        <td><%= pedido.getNombreCliente() %></td>
                        <td><%= pedido.getFecha() %></td>
                        <td><%= detalle.getCantidad() %></td>
                        <td><%= valorUnitario %></td>
                        <td><%= abonado %></td>
                        <td><%= subtotal %></td>
                    </tr>
                    <% 
                            }
                        }
                    %>
                    <tr>
                        <td colspan="4">Total</td>
                        <td><%= totalValorUnitario %></td>
                        <td><%= totalAbonado %></td>
                        <td><%= totalSubtotal %></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
