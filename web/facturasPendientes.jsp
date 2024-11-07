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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Estilo de encabezado centrado */
        h1 {
            text-align: center;
            color: #333;
            margin: 20px 0;
        }

        /* Expansión de contenedor de la tabla en toda la página */
        .table-container {
            margin: 20px auto; /* Centrar el contenedor */
            background-color: #ffffff;
            border-radius: 8px; /* Bordes redondeados */
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15); /* Sombra del contenedor */
            padding: 20px; /* Espaciado interno */
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
            border: 1px solid #dcdcdc;
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

    <!-- Encabezado con el logo y el título -->
    <header>
        <h1>Ventas pendientes por pagar</h1>
    </header>

    <div class="table-container">
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
        <table class="table table-striped table-hover">
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
            <a href="principal.jsp?CONTENIDO=clientes.jsp">Regresar a la lista de clientes</a>
        </div>
        
    </div>

</body>
</html>
