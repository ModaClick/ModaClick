<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="clases.Persona"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagos Proveedor</title>
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
        h1 {
            text-align: center;
            color: #333;
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
        .action-icon {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        .action-icon:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Pagos Proveedor</h1>

    <%
        String idCompraStr = request.getParameter("idCompra");
        if (idCompraStr != null && !idCompraStr.isEmpty()) {
            try {
                int idCompra = Integer.parseInt(idCompraStr);
                Compra compra = Compra.getCompraPorId(idCompra);

                if (compra != null) {
                    String proveedor = compra.getNombreProveedor();
                    int totalCompra = compra.calcularTotal();
                    int saldoPendiente = compra.calcularSaldoPendiente();
                    int abonadoCompra = compra.calcularAbonado();

                    // Mostrar los datos del proveedor y la compra
    %>
    <table>
        <tr>
            <th>Proveedor</th>
            <th>Identificación</th>
            <th>Número de Factura</th>
            <th>Valor Total</th>
            <th>Saldo Pendiente</th>
        </tr>
        <tr>
            <td><%= proveedor %></td>
            <td><%= compra.getIdProveedor() %></td>
            <td><%= compra.getIdCompra() %></td>
            <td>$<%= totalCompra %></td>
            <td>$<%= saldoPendiente %></td>
        </tr>
    </table>

    <h2>Pagos realizados</h2>

    <table>
        <thead>
            <tr>
                <th>Pago #</th>
                <th>Fecha</th>
                <th>Medio de Pago</th>
                <th>Valor</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Obtener los medios de pago asociados a la compra
                List<MedioPagoPorCompra> mediosPago = MedioPagoPorCompra.getMediosPagoPorCompra(compra.getIdCompra());
                if (mediosPago != null && !mediosPago.isEmpty()) {
                    int contador = 1;
                    for (MedioPagoPorCompra medioPago : mediosPago) {
            %>
            <tr>
                <td><%= contador++ %></td>
                <td><%= medioPago.getFecha() %></td>
                <td><%= medioPago.getTipoPago() %></td>
                <td>$<%= medioPago.getValor() %></td>
                <td>
                    <!-- Botones de Modificar y Eliminar -->
                    <a href="pagosProveedoresFormulario.jsp?accion=Modificar&idCompra=<%= compra.getIdCompra() %>&idPago=<%= medioPago.getIdMedioPagoCompra() %>">
                        <button>Modificar</button>
                    </a>
                    <a href="pagosProveedoresFormulario.jsp?accion=Eliminar&idCompra=<%= compra.getIdCompra() %>&idPago=<%= medioPago.getIdMedioPagoCompra() %>">
                        <button>Eliminar</button>
                    </a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5">No hay pagos registrados.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <!-- Botón para adicionar un nuevo pago -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="pagosProveedoresFormulario.jsp?accion=Adicionar&idCompra=<%= compra.getIdCompra() %>">
            <button style="padding: 10px 20px; background-color: #007BFF; color: white; border: none; border-radius: 5px; cursor: pointer;">
                Adicionar Pago
            </button>
        </a>
    </div>

    <%
                } else {
                    out.println("<p>No se encontró la compra con el ID especificado.</p>");
                }
            } catch (NumberFormatException e) {
                out.println("<p>Error: El ID de compra no es válido.</p>");
            }
        } else {
            out.println("<p>Error: No se proporcionó un ID de compra.</p>");
        }
    %>

    <!-- Botón para regresar a la lista de compras -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="http://localhost:8081/ModaClick/principal.jsp?CONTENIDO=compras.jsp">
            <button style="padding: 10px 20px; background-color: #007BFF; color: white; border: none; border-radius: 5px; cursor: pointer;">
                Regresar a la lista de compras
            </button>
        </a>
    </div>
</div>

</body>
</html>
