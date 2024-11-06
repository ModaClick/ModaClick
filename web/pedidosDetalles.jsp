<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.Inventario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Obtener el ID del pedido desde el parámetro de la URL
    String idPedido = request.getParameter("id");

    // Cargar el pedido utilizando la clase Pedido
    Pedido pedido = new Pedido(idPedido);

    // Obtener los detalles del pedido utilizando la clase PedidoDetalle
    List<PedidoDetalle> detalles = PedidoDetalle.getDetallesPorPedido(idPedido);

    // Datos del pedido
    String nombreCliente = pedido.getNombreCliente();
    String fechaPedido = pedido.getFecha();
    String idCliente = pedido.getIdCliente();
    String tipoEnvio = pedido.getTipoEnvio();
    String estado = pedido.getEstado();

    // Variable para el total
    int totalPedido = 0;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalles del Pedido</title>
    <link rel="stylesheet" type="text/css" href="recursos/dist/css/bootstrap.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        h2 {
            text-align: center;
            font-size: 28px;
            margin-top: 20px;
            font-family: 'Comic Sans MS', cursive, sans-serif;
            background-color: #FFFFFF;
            padding: 10px;
            border-radius: 5px;
        }
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            box-shadow: 0px 0px 5px rgba(0,0,0,0.3);
        }
        th, td {
            border: 1px solid #CCC;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #343a40;
            color: #FFFFFF;
            font-weight: bold;
        }
        .info-table th {
            background-color: #5A5A5A;
            color: #FFFFFF;
        }
        .info-table td {
            background-color: #F7F7F7;
        }
    </style>
</head>
<body>

<h2>Detalles de Pedido</h2>

<!-- Información del pedido -->
<table class="info-table">
    <tr>
        <th>Fecha</th>
        <td><%= fechaPedido %></td>
    </tr>
    <tr>
        <th>Cliente</th>
        <td><%= nombreCliente %></td>
    </tr>
    <tr>
        <th>Identificación</th>
        <td><%= idCliente %></td>
    </tr>
    <tr>
        <th>Estado</th>
        <td><%= estado %></td>
    </tr>
    <tr>
        <th>Tipo de envío</th>
        <td><%= tipoEnvio %></td>
    </tr>
</table>

<!-- Detalles de los artículos -->
<table>
    <tr>
        <th>Artículo</th>
        <th>Cantidad</th>
        <th>Valor Unitario</th>
        <th>Subtotal</th>
    </tr>
    <%
        for (PedidoDetalle detalle : detalles) {
            // Obtener el nombre del artículo a partir de su ID
            Inventario articulo = new Inventario(detalle.getIdArticulo());
            String nombreArticulo = articulo.getNombreArticulo();

            int cantidad = Integer.parseInt(detalle.getCantidad());
            int valorUnitario = Integer.parseInt(detalle.getValorUnitVenta());
            int subtotal = cantidad * valorUnitario;
            totalPedido += subtotal;
    %>
    <tr>
        <td><%= nombreArticulo %></td>
        <td><%= detalle.getCantidad() %></td>
        <td><%= detalle.getValorUnitVenta() %></td>
        <td><%= subtotal %></td>
    </tr>
    <% } %>
    <tr>
        <th colspan="3" align="right">Total Pedido</th>
        <td><%= totalPedido %></td>
    </tr>
</table>

</body>
</html>
