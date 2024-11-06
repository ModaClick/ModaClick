<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="clases.DevolucionVenta, clases.DevolucionVentaDetalles, clases.Venta, clases.VentaDetalle" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalles de Devolución de Venta</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f8ff;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #5f9ea0;
            margin-bottom: 20px;
        }
        .info-section p {
            font-size: 1.1em;
            color: #4682b4;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            background-color: #fafafa;
        }
        table, th, td {
            border: 1px solid #dcdcdc;
        }
        th {
            background-color: #e0f7fa;
            color: #00695c;
            padding: 12px;
        }
        td {
            padding: 10px;
            text-align: center;
            color: #4d4d4d;
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
        .table-section {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .table-section table {
            border-radius: 5px;
            overflow: hidden;
        }
        .button-section {
            text-align: center;
            margin-top: 20px;
        }
        .button-section button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
        }
        .button-section button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Detalles de Devolución de Venta</h1>

        <%
            String devolucionId = request.getParameter("id");
            DevolucionVenta devolucion = DevolucionVenta.getDevolucionPorId(Integer.parseInt(devolucionId));
            List<DevolucionVentaDetalles> detalles = DevolucionVentaDetalles.getDetallesPorDevolucion(devolucion.getId());
        %>

        <div class="info-section">
            <p><strong>Venta Nº:</strong> <%= devolucion.getVenta().getIdVenta() %></p>
            <p><strong>Fecha:</strong> <%= devolucion.getFecha() %></p>
            <p><strong>Código devolución:</strong> <%= devolucion.getId() %></p>
        </div>

        <div class="table-section">
            <table>
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Comentarios</th>
                        <th>Cantidad</th>
                        <th>Cantidad Devuelta</th>
                        <th>Impuestos</th>
                        <th>Valor Unitario</th>
                        <th>Valor Devuelto</th>
                        <th>Subtotal</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        double totalGeneral = 0;

                        for (DevolucionVentaDetalles detalle : detalles) {
                            VentaDetalle ventaDetalle = new VentaDetalle(String.valueOf(detalle.getIdVentaDetalle()));
                            int cantidadDevuelta = detalle.getCantidad();
                            double valorUnitario = Double.parseDouble(ventaDetalle.getValorUnitVenta());

                            // Obtener el nombre del artículo
                            String nombreArticulo = "Artículo no encontrado";
                            String consultaArticulo = "SELECT nombreArticulo FROM Inventario WHERE idArticulo = '" + ventaDetalle.getIdArticuloInventario() + "'";
                            ResultSet rsArticulo = ConectorBD.consultar(consultaArticulo);
                            if (rsArticulo != null && rsArticulo.next()) {
                                nombreArticulo = rsArticulo.getString("nombreArticulo");
                                rsArticulo.close();
                            }

                            // Consultar los impuestos asociados al artículo
                            String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                                     + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                                     + "WHERE ImpuestoInventario.idArticulo = '" + ventaDetalle.getIdArticuloInventario() + "'";
                            ResultSet rsImpuestos = ConectorBD.consultar(consultaImpuestos);

                            double totalImpuestos = 0.0;
                            String impuestosDesglosados = "";

                            // Sumar y mostrar los impuestos
                            while (rsImpuestos != null && rsImpuestos.next()) {
                                int porcentaje = rsImpuestos.getInt("porcentaje");
                                totalImpuestos += porcentaje / 100.0;
                                impuestosDesglosados += porcentaje + "%<br>";
                            }
                            if (rsImpuestos != null) rsImpuestos.close();

                            // Cálculo del valor devuelto con impuestos
                            double valorDevuelto = cantidadDevuelta * valorUnitario;
                            double subtotal = valorDevuelto;
                            double total = valorDevuelto + (valorDevuelto * totalImpuestos);
                            totalGeneral += total;
                    %>
                    <tr>
                        <td><%= nombreArticulo %></td>
                        <td><%= detalle.getComentariosAdicionales() %></td>
                        <td><%= ventaDetalle.getCantidad() %></td>
                        <td><%= cantidadDevuelta %></td>
                        <td><%= impuestosDesglosados %></td>
                        <td>$<%= valorUnitario %></td>
                        <td>$<%= valorDevuelto %></td>
                        <td>$<%= subtotal %></td>
                        <td>$<%= total %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="total-section">
            <p><strong>Total Devuelto:</strong> $<%= totalGeneral %></p>
        </div>

        <div class="button-section">
            <button onclick="window.location.href='principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp'">Regresar</button>
        </div>
    </div>
</body>
</html>
