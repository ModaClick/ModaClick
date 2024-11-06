<%@page import="clases.Persona" %>
<%@page import="clases.Compra" %>
<%@page import="clases.CompraDetalle" %>
<%@page import="clases.MedioPagoPorCompra" %>
<%@page import="clases.MedioDePago" %>
<%@page import="java.util.List" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Pagos de Compras</title>
    <link rel="stylesheet" type="text/css" href="recursos/dist/css/bootstrap.css">
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

        /* Estilos de botones de acción */
        .btn-action {
            font-size: 14px;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            display: inline-flex;
            align-items: center;
            margin: 0 2px;
        }
        .btn-add {
            background-color: #28a745;
        }
        .btn-edit {
            background-color: #ffc107;
        }
        .btn-delete {
            background-color: #dc3545;
        }

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <h3>PAGOS DE COMPRAS</h3>

        <%
            String idCompra = request.getParameter("idCompra");
            Compra compra = new Compra(idCompra);
            Persona proveedor = new Persona(compra.getIdProveedor());

            // Calcular el total de la compra
            List<CompraDetalle> detallesCompra = CompraDetalle.getListaEnObjetos("idCompraDetalle='" + idCompra + "'", null);
            int totalCompra = 0;

            for (CompraDetalle detalle : detallesCompra) {
                totalCompra += detalle.getSubTotal();  // Sumar el subtotal de cada detalle
            }

            // Calcular el total abonado
            List<MedioPagoPorCompra> mediosDePago = MedioPagoPorCompra.getListaEnObjetos("idCompraDetalle='" + idCompra + "'", null);
            int totalAbonado = 0;

            for (MedioPagoPorCompra medioPago : mediosDePago) {
                totalAbonado += Integer.parseInt(medioPago.getValor());  // Sumar los valores abonados
            }

            // Calcular el saldo pendiente
            int saldoPendiente = totalCompra - totalAbonado;

            if (compra != null && proveedor != null) {
        %>

        <!-- Información de la compra y proveedor -->
        <div class="datos-compra">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Proveedor</th>
                        <th>Identificación</th>
                        <th>Número Compra</th>
                        <th>Valor Total</th>
                        <th>Saldo Pendiente</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><%= proveedor.getNombre() %></td>
                        <td><%= proveedor.getIdentificacion() %></td>
                        <td><%= compra.getIdCompra() %></td>
                        <td><%= totalCompra %></td> <!-- Total de la compra -->
                        <td><%= saldoPendiente %></td> <!-- Saldo pendiente -->
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Medio de Pago</th>
                        <th>Valor</th>
                        <th>
                            <%
                                String idMedioPago = (mediosDePago.size() > 0) ? mediosDePago.get(0).getIdPagos() : "";
                                if (!idMedioPago.isEmpty()) {
                            %>
                            <a href="adicionarPagoCompra.jsp?idCompra=<%= idCompra %>&idMedioPago=<%= idMedioPago %>&action=add" title="Adicionar Pago">
                                <img src="presentacion/adicionar.png" alt="Adicionar">
                            </a>
                            <%
                                } else {
                            %>
                            <span>No hay medios de pago disponibles para adicionar.</span>
                            <%
                                }
                            %>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (MedioPagoPorCompra pago : mediosDePago) {
                    %>
                    <tr>
                        <td><%= pago.getFecha() %></td>
                        <td><%= pago.getNombreMedioDePago() %></td>
                        <td><%= pago.getValor() %></td>
                        <td class="iconos">
                            <a href="adicionarPagoCompra.jsp?idPago=<%= pago.getIdMedioPagoCompra() %>&idCompra=<%= idCompra %>" title="Editar">
                                <img src="presentacion/modificar.png" alt="Editar">
                            </a>
                            <a href="procesarPagoC.jsp?action=delete&idPago=<%= pago.getIdMedioPagoCompra() %>&idCompra=<%= idCompra %>" title="Eliminar" onclick="return confirm('¿Estás seguro de eliminar este pago?')">
                                <img src="presentacion/eliminar.png" alt="Eliminar">
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <%
            } else {
                out.println("<p>No se encontró información del proveedor o la compra.</p>");
            }
        %>
    </div>

     <a href="principal.jsp?CONTENIDO=compras.jsp" class="btn btn-primary" style="margin: 20px auto; display: block; width: 200px;">Regresar a compras</a>
</div>
</body>
</html>
