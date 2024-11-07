<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="clases.DevolucionVenta, clases.DevolucionVentaDetalles, clases.Venta, clases.VentaDetalle" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalles de Devolución de Venta</title>
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
<body class="bg-light">
    <div class="container">
        <div class="table-container">
            <h3>DETALLES DE DEVOLUCION DE VENTA</h3>

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
                <table class="table table-striped table-hover">
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
    </div>
</body>
</html>
