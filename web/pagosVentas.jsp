<%@ page import="clases.Persona" %>
<%@ page import="clases.Venta" %>
<%@ page import="clases.VentaDetalle" %>
<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="clases.MedioDePago" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Pagos ventas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        td {
            border: 1px solid #dddddd;
        }
        .datos-cliente {
            margin-top: 20px;
        }
        .datos-cliente table {
            width: 100%;
        }
        .encabezado {
            font-size: 18px;
            font-weight: bold;
            background-color: #eaeaea;
        }
        h1 {
            text-align: center;
        }
        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <!-- Encabezado con el logo y el título -->
    <header>
        <img src="Icono/logo.jpg" alt="Logo" style="width:60px;height:60px;float:left;">
        <h1 style="display: inline-block; margin-left: 10px;">Pagos ventas</h1>
    </header>

    <%
        String idVenta = request.getParameter("idVenta");

        // Verificar si idVenta es null o está vacío
        if (idVenta == null || idVenta.isEmpty()) {
            out.println("<p class='error-message'>El ID de venta no existe.</p>");
        } else {
            Venta venta = new Venta(idVenta);
            Persona cliente = new Persona(venta.getIdCliente());

            // Calcular el total de la venta
            List<VentaDetalle> detallesVenta = VentaDetalle.getListaEnObjetos("idVentaDetalle='" + idVenta + "'", null);
            int totalVenta = 0;

            for (VentaDetalle detalle : detallesVenta) {
                totalVenta += detalle.getSubTotal();  // Sumar el subtotal de cada detalle
            }

            // Calcular el total abonado
            List<MedioPagoPorVenta> mediosDePago = MedioPagoPorVenta.getListaEnObjetos("idVentaDetalle='" + idVenta + "'", null);
            int totalAbonado = 0;

            for (MedioPagoPorVenta medioPago : mediosDePago) {
                totalAbonado += Integer.parseInt(medioPago.getValor());  // Sumar los valores abonados
            }

            // Calcular el saldo pendiente
            int saldoPendiente = totalVenta - totalAbonado;

            // Verificar si no existen medios de pago y mostrar mensaje
            if (venta == null || cliente == null || detallesVenta.isEmpty()) {
                out.println("<p class='error-message'>El ID de venta no existe o no se encontraron detalles de la venta.</p>");
            } else {
    %>

    <!-- Información de la venta y el cliente -->
    <div class="datos-cliente">
        <table>
            <thead>
                <tr class="encabezado">
                    <th>Cliente</th>
                    <th>Identificación</th>
                    <th>Número Factura</th>
                    <th>Valor Total</th>
                    <th>Saldo Pendiente</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= cliente.getNombre() %></td>
                    <td><%= cliente.getIdentificacion() %></td>
                    <td><%= venta.getIdVenta() %></td>
                    <td><%= totalVenta %></td> <!-- Total de la venta -->
                    <td><%= saldoPendiente %></td> <!-- Saldo pendiente -->
                </tr>
            </tbody>
        </table>
    </div>

    <table>
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Medio de Pago</th>
                <th>Valor</th>
                <th>
                    <a href="adicionarPago.jsp?idVenta=<%= idVenta %>&idMedioPago=<%= !mediosDePago.isEmpty() ? mediosDePago.get(0).getIdPagos() : "" %>&action=add" title="Adicionar Pago">
                        <img src="presentacion/adicionar.png" alt="Adicionar">
                    </a>
                </th>
            </tr>
        </thead>
        <tbody>
            <%
                if (mediosDePago.isEmpty()) {
                    out.println("<tr><td colspan='4' class='error-message'>No se encontraron medios de pago para esta venta.</td></tr>");
                } else {
                    for (MedioPagoPorVenta pago : mediosDePago) {
            %>
            <tr>
                <td><%= pago.getFecha() %></td>
                <td><%= pago.getNombreMedioDePago() %></td>
                <td><%= pago.getValor() %></td>
                <td class="iconos">
                    <a href="adicionarPago.jsp?idPago=<%= pago.getIdMedioPagoFactura() %>&idVenta=<%= idVenta %>" title="Editar">
                        <img src="presentacion/modificar.png" alt="Editar">
                    </a>
                    <a href="procesarPago.jsp?action=delete&idPago=<%= pago.getIdMedioPagoFactura() %>&idVenta=<%= idVenta %>" title="Eliminar" onclick="return confirm('¿Estás seguro de eliminar este pago?')">
                        <img src="presentacion/eliminar.png" alt="Eliminar">
                    </a>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>

    <%
            } // Cierra el bloque ELSE del idVenta válido
        }
    %>

    <a href="principal.jsp?CONTENIDO=inicio.jsp">Volver al menú</a>
</body>
</html>
