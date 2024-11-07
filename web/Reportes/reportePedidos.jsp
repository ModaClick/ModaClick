<<<<<<< HEAD
<%@page import="java.util.List"%>
=======
>>>>>>> 7107026975515d79007e051943af17425710c6d8
<%@page import="clases.Categoria"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.Inventario"%>
<<<<<<< HEAD
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Configuraci√≥n para exportar a Excel o Word
=======
<%@page import="java.util.List"%>

<style>
    /* Estilos CSS para el contenedor del reporte */
    .report-container {
        background-color: #f0f8ff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .report-title {
        font-size: 28px;
        font-weight: bold;
        color: #333;
        text-align: center;
        margin-bottom: 20px;
    }
    .table-container {
        width: 100%;
        overflow-x: auto;
    }
    /* Estilos para la tabla */
    table {
        width: 100%;
        border-collapse: collapse;
        font-family: Arial, sans-serif;
        background-color: #ffffff;
    }
    th, td {
        padding: 12px 15px;
        text-align: center;
        border: 1px solid #e0e0e0;
    }
    th {
        background-color: #d3eafc;
        color: #333;
        font-weight: bold;
        border-top: 2px solid #b0d4f1;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    tr:nth-child(odd) {
        background-color: #f1f7fd;
    }
    tr:last-child {
        font-weight: bold;
        background-color: #e0f2ff;
    }
    tr:hover {
        background-color: #d3eafc;
    }
</style>

<%
    // ConfiguraciÛn para exportar a Excel o Word
>>>>>>> 7107026975515d79007e051943af17425710c6d8
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

<<<<<<< HEAD
    // Filtros para la b√∫squeda
=======
    // Filtros para la b˙squeda
>>>>>>> 7107026975515d79007e051943af17425710c6d8
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

<<<<<<< HEAD
    // Filtro por nombre del cliente
=======
    // Filtro por nombre del cliente en lugar de categorÌa
>>>>>>> 7107026975515d79007e051943af17425710c6d8
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

<<<<<<< HEAD
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

        /* Expansi√≥n de contenedor de la tabla en toda la p√°gina */
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
                                <input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Art√≠culo
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

        <!-- Opciones de exportaci√≥n -->
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
=======
<div class="report-container">
    <h2 class="report-title">Reporte de pedidos</h2>

    <!-- Formulario de filtros -->
    <form method="post">
        <table>
            <tr>
                <td><input type="checkbox" name="chkFecha" <%=chkFecha%>> Fecha de Pedido</td>
                <td>
                    Desde <input type="date" name="fechaInicio" value="<%=fechaInicio%>">
                    Hasta <input type="date" name="fechaFin" value="<%=fechaFin%>">
                </td>
            </tr>
            <tr>
                <td><input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre ArtÌculo</td>
                <td><input type="text" name="nombreArticulo" value="<%=nombreArticulo%>"></td>
            </tr>
            <tr>
                <td><input type="checkbox" name="chkNombreCliente" <%=chkNombreCliente%>> Nombre Cliente</td>
                <td><input type="text" name="nombreCliente" value="<%=nombreCliente%>"></td>
            </tr>
        </table>
        <p><input type="submit" name="buscar" value="Buscar"></p>
    </form>

    <!-- Opciones de exportaciÛn -->
    <p>
        <a href="Reportes/reportePedidos.jsp?formato=excel" target="_blank"><img src="Presentacion/imagenes/excel.jpg" width="50" height="50"></a>
        <a href="Reportes/reportePedidos.jsp?formato=word" target="_blank"><img src="Presentacion/imagenes/word.jpg" width="50" height="50"></a>
    </p>

    <div class="table-container">
        <table>
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
                    <td><%= pedido.getNombreCliente() %></td> <!-- Muestra el nombre del cliente -->
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
 †††</div>
</div>
>>>>>>> 7107026975515d79007e051943af17425710c6d8
