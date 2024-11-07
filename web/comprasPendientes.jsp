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
            background-color: #45a049;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="table-container">
            <h3>Compras Pendientes por Pagar</h3>

            <%
                String idProveedor = request.getParameter("id");
                Persona proveedor = new Persona(idProveedor);
            %>

            <div class="info-section">
                <%
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

            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Fecha Compra</th>
                        <th>Número de Compra</th>
                        <th>Proveedor</th>
                        <th>Medio de Pago</th>
                        <th>Total a Pagar</th>
                        <th>Abonado</th>
                        <th>Saldo Pendiente</th>
                        <th>Acciones</th>
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
                                <img src="presentacion/pagos.png" alt="Realizar pago">
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
            <div class="button-section">
                <a href="principal.jsp?CONTENIDO=proveedores.jsp">Regresar a la lista de proveedores</a>
            </div>
        </div>
    </div>
</body>
</html>
