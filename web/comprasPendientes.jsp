<%@ page import="clases.Persona" %>
<%@ page import="clases.Compra" %>
<%@ page import="clases.MedioPagoPorCompra" %>
<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.CompraDetalle" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Compras Pendientes por Pagar</title>
</head>
<body>

    <!-- Encabezado con el logo y el título -->
    <header>
        <img src="Icono/logo.jpg" alt="Logo" style="width:40px;height:40px;">
        <h1>Compras Pendientes por Pagar</h1>
    </header>

    <!-- Información del proveedor -->
    <div>
        <%
            String idProveedor = request.getParameter("id");
            Persona proveedor = new Persona(idProveedor);

            if (proveedor != null && proveedor.getIdentificacion() != null) {
        %>
        <p><strong>Identificación:</strong> <%= proveedor.getIdentificacion() %></p>
        <p><strong>Proveedor:</strong> <%= proveedor.getNombre() %></p>
        <p><strong>Correo Electrónico:</strong> <%= proveedor.getCorreoElectronico() %></p>
        <%
            } else {
                out.println("<p>No se encontró información del proveedor.</p>");
            }
        %>
    </div>

    <!-- Tabla de compras pendientes -->
    <table border="1">
        <thead>
            <tr>
                <th>Fecha Compra</th>
                <th>Número de Compra</th>
                <th>Proveedor</th>
                <th>Medio de Pago</th>
                <th>Total a Pagar</th>
                <th>Abonado</th>
                <th>Saldo Pendiente</th>
            </tr>
        </thead>
        <tbody>
            <%
                int totalPagar = 0;
                int totalAbonado = 0;
                int totalSaldo = 0;

                List<Compra> comprasPendientes = Compra.getListaEnObjetos("idProveedor='" + idProveedor + "'", null);
                for (Compra compraPendiente : comprasPendientes) {
                    List<MedioPagoPorCompra> mediosDePago = MedioPagoPorCompra.getListaEnObjetos("idCompraDetalle='" + compraPendiente.getIdCompra() + "'", null);

                    List<CompraDetalle> detallesCompra = CompraDetalle.getListaEnObjetos("idCompraDetalle='" + compraPendiente.getIdCompra() + "'", null);
                    int totalCompra = 0;
                    int abonosTotales = 0; // Suma de los valores abonados

                    for (CompraDetalle detalle : detallesCompra) {
                        totalCompra += detalle.getSubTotal();  // Sumar el subtotal de cada detalle
                    }

                    // Calcular los abonos por medio de pago
                    for (MedioPagoPorCompra medioPagoPorCompra : mediosDePago) {
                        abonosTotales += Integer.parseInt(medioPagoPorCompra.getValor());
                    }

                    // Calcular el saldo pendiente
                    int saldoPendiente = totalCompra - abonosTotales;

                    totalPagar += totalCompra;
                    totalAbonado += abonosTotales;
                    totalSaldo += saldoPendiente;
            %>
            <tr>
                <td><%= compraPendiente.getFechaCompra() %></td>
                <td><%= compraPendiente.getIdCompra() %></td>
                <td><%= proveedor.getNombre() %></td>

                <!-- Mostrar los medios de pago y sus valores -->
                <td>
                    <ul>
                        <%
                            for (MedioPagoPorCompra medioPagoPorCompra : mediosDePago) {
                                String nombreMedio = medioPagoPorCompra.getMedioDePago().getTipoPago();
                                String valorPago = medioPagoPorCompra.getValor();
                        %>
                        <li><%= nombreMedio %> <%= valorPago %></li>
                        <% } %>
                    </ul>
                </td>

                <!-- Mostrar el total calculado de la compra -->
                <td><%= totalCompra %></td>
                <td><%= abonosTotales %></td>
                <td><%= saldoPendiente %></td>
                <td>
                    <a href="pagosCompras.jsp?idCompra=<%= compraPendiente.getIdCompra() %>" title="Realizar pago">
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
    <a href="principal.jsp?CONTENIDO=proveedores.jsp">Volver a la lista de proveedores</a>        
</body>
</html>
