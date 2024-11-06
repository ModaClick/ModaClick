<%@ page import="clases.Persona" %>
<%@ page import="clases.Venta" %>
<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.VentaDetalle" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ventas pendientes por pagar</title>
</head>
<body>

    <!-- Encabezado con el logo y el título -->
    <header>
        <img src="Icono/logo.jpg" alt="Logo" style="width:40px;height:40px;">
        <h1>Ventas pendientes por pagar</h1>
    </header>

    <!-- Información del cliente -->
    <div>
        <%
            String idCliente = request.getParameter("id");
            Persona cliente = new Persona(idCliente);

            if (cliente != null && cliente.getIdentificacion() != null) {
        %>
        <p><strong>Identificación:</strong> <%= cliente.getIdentificacion() %></p>
        <p><strong>Cliente:</strong> <%= cliente.getNombre() %></p>
        <p><strong>Correo Electrónico:</strong> <%= cliente.getCorreoElectronico() %></p>
        <%
            } else {
                out.println("<p>No se encontró información del cliente.</p>");
            }
        %>
    </div>

    <!-- Tabla de ventas pendientes -->
    <table border="1">
        <thead>
            <tr>
                <th>Fecha Venta</th>
                <th>Número Factura</th>
                <th>Cliente</th>
                <th>Medio de Pago</th>
                <th>Total a pagar</th>
                <th>Abonado</th>
                <th>Saldo pendiente</th>
            </tr>
        </thead>
        <tbody>
            <%
                int totalPagar = 0;
                int totalAbonado = 0;
                int totalSaldo = 0;

                List<Venta> ventasPendientes = Venta.getListaEnObjetos("idCliente='" + idCliente + "'", null);
                for (Venta ventaPendiente : ventasPendientes) {
                    List<MedioPagoPorVenta> mediosDePago = MedioPagoPorVenta.getListaEnObjetos("idVentaDetalle='" + ventaPendiente.getIdVenta() + "'", null);

                    List<VentaDetalle> detallesVenta = VentaDetalle.getListaEnObjetos("idVentaDetalle='" + ventaPendiente.getIdVenta() + "'", null);
                    int totalVenta = 0;
                    int abonosTotales = 0; // Suma de los valores abonados

                    for (VentaDetalle detalle : detallesVenta) {
                        totalVenta += detalle.getSubTotal();  // Sumar el subtotal de cada detalle
                    }

                    // Calcular los abonos por medio de pago
                    for (MedioPagoPorVenta medioPagoPorVenta : mediosDePago) {
                        abonosTotales += Integer.parseInt(medioPagoPorVenta.getValor());
                    }

                    // Calcular el saldo pendiente
                    int saldoPendiente = totalVenta - abonosTotales;

                    totalPagar += totalVenta;
                    totalAbonado += abonosTotales;
                    totalSaldo += saldoPendiente;
            %>
            <tr>
                <td><%= ventaPendiente.getFechaVenta() %></td>
                <td><%= ventaPendiente.getIdVenta() %></td>
                <td><%= ventaPendiente.getNombresCliente() %></td>

                <!-- Mostrar los medios de pago y sus valores -->
                <td>
                    <ul>
                        <%
                            for (MedioPagoPorVenta medioPagoPorVenta : mediosDePago) {
                                String nombreMedio = medioPagoPorVenta.getMedioDePago().getTipoPago();
                                String valorPago = medioPagoPorVenta.getValor();
                        %>
                        <li><%= nombreMedio %> <%= valorPago %></li>
                            <% } %>
                    </ul>
                </td>

                <!-- Mostrar el total calculado de la venta -->
                <td><%= totalVenta %></td>
                <td><%= abonosTotales %></td>
                <td><%= saldoPendiente %></td>
                <td>
                    <a href="pagosVentas.jsp?idVenta=<%= ventaPendiente.getIdVenta() %>" title="Realizar pago">
                        <img src="presentacion/abono.png" alt="Realizar pago">
                    </a>
                </td>
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4"><strong>TOTAL</strong></td>
                <td><%= totalPagar %></td>
                <td><%= totalAbonado %></td>
                <td><%= totalSaldo %></td>
                <td></td> <!-- No hay acción en la fila de total -->
            </tr>
        </tfoot>
    </table> 
    <a href="principal.jsp?CONTENIDO=clientes.jsp">Volver a la lista de clientes</a>        
</body>
</html>
