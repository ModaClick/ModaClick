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

<html>
<head>
    <title>Detalles del Pedido</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        h3 {
            text-align: center;
            font-size: 24px;
            color: #333;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #00a2d1;
            color: white;
            text-transform: uppercase;
        }
        .detalle-pedido td:nth-child(2) {
            background-color: #f2f2f2; /* Color gris claro para la segunda columna */
            color: black;
        }
        tr:nth-child(even) {
            background-color: #ddd;
            color: black;
        }
        tr:hover {
            background-color: #ddd;
        }
        .total-row {
            background-color: #00a2d1;
            color: white;
            font-weight: bold;
        }
        .center {
            margin-left: auto;
            margin-right: auto;
        }
        .pedido-info th {
            background-color: #00a2d1;
            color: white;
            padding: 8px;
        }
        .pedido-info td {
            background-color: #ddd; /* Aplicamos el gris claro a la segunda columna */
            color: black;
        }
    </style>
</head>
<body>

<h3>Detalles de pedidos</h3>
<table class="pedido-info">
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

<table class="center">
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
    <tr class="total-row">
        <td colspan="3">Total Pedido</td>
        <td><%= totalPedido %></td>
    </tr>
</table>

</body>
</html>
