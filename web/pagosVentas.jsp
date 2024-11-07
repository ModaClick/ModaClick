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
    <title>Pagos Ventas</title>
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

        .info-section p {
            font-size: 1.1em;
            color: #4682b4;
        }

        .total-section {
            text-align: right;
            margin-top: 20px;
            font-size: 1.2em;
            color: #008080;
        }

        .total-section strong {
            color: #006064;
        }

        .button-section {
            text-align: center;
            margin-top: 20px;
        }

        .button-section a {
            background-color: #333333;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
        }

        .button-section a:hover {
            background-color: #4CAF50;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="table-container">
            <h3>Pagos Ventas</h3>

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
            <div class="info-section">
                <table class="table table-striped table-hover">
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

            <div class="table-container">
                <h3>Medios de Pago</h3>
                <table class="table table-striped table-hover">
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
            </div>

           <div class="button-section">
            <a href="principal.jsp?CONTENIDO=facturasPendientes.jsp">Regresar a ventas pendientes</a>
        </div>

            <%
                    } // Cierra el bloque ELSE del idVenta válido
                }
            %>
    </div>
</body>
</html>
