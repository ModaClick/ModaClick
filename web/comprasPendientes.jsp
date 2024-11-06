<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page import="clases.MedioPagoPorCompra"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Compra Pendiente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .no-data {
            text-align: center;
            font-size: 18px;
            color: #888;
        }
        .action-icon {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        .action-icon:hover {
            opacity: 0.8;
        }
        .completed {
            color: green;
            font-weight: bold;
        }
        .btn-regresar {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }
        .btn-regresar:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Detalle de Compra</h2>

    <table>
        <thead>
            <tr>
                <th>Fecha compra</th>
                <th>Número de compra</th>
                <th>Proveedor</th>
                <th>Medio de pago</th>
                <th>Total a pagar</th>
                <th>Abonado</th>
                <th>Saldo pendiente</th>
                <th>Acción</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Ajuste para capturar el parámetro 'id' en lugar de 'idCompra'
                String idCompraStr = request.getParameter("id");

                if (idCompraStr != null && !idCompraStr.isEmpty()) {
                    try {
                        int idCompra = Integer.parseInt(idCompraStr);
                        Compra compra = Compra.getCompraPorId(idCompra);

                        if (compra != null) {
                            int totalCompra = compra.calcularTotal();
                            int abonadoCompra = compra.calcularAbonado();
                            int saldoPendiente = compra.calcularSaldoPendiente();

                            if (saldoPendiente > 0) {
            %>
            <tr>
                <td><%= compra.getFechaCompra() %></td>
                <td><%= compra.getIdCompra() %></td>
                <td><%= compra.getIdProveedor() %></td>
                <td>
                    <%
                        List<MedioPagoPorCompra> mediosPago = MedioPagoPorCompra.getMediosPagoPorCompra(compra.getIdCompra());
                        if (!mediosPago.isEmpty()) {
                            for (MedioPagoPorCompra medio : mediosPago) {
                                out.print(medio.getTipoPago() + " $" + medio.getValor() + "<br>");
                            }
                        } else {
                            out.print("No hay medios de pago registrados.");
                        }
                    %>
                </td>
                <td>$<%= totalCompra %></td>
                <td>$<%= abonadoCompra %></td>
                <td>$<%= saldoPendiente %></td>
                <td>
                    <a href="pendientespagosproveedores.jsp?idCompra=<%= compra.getIdCompra() %>">
                        <img src="icons/moneda.png" alt="Pagar" class="action-icon">
                    </a>
                </td>
            </tr>
            <%
                            } else {
            %>
            <tr>
                <td colspan="8" class="no-data completed">Pago completado para la compra número <%= compra.getIdCompra() %>.</td>
            </tr>
            <%
                            }
                        } else {
            %>
            <tr>
                <td colspan="8" class="no-data">No se encontró la compra con el ID especificado.</td>
            </tr>
            <%
                        }
                    } catch (NumberFormatException e) {
            %>
            <tr>
                <td colspan="8" class="no-data">ID de compra no válido.</td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="8" class="no-data">No se proporcionó ningún ID de compra.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <!-- Botón para regresar -->
    <a href="http://localhost:8081/ModaClick/principal.jsp?CONTENIDO=compras.jsp" class="btn-regresar">Regresar</a>
</div>

</body>
</html>
