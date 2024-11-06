<%@ page import="clases.Persona" %>
<%@ page import="clases.Compra" %>
<%@ page import="clases.CompraDetalle" %>
<%@ page import="clases.MedioPagoPorCompra" %>
<%@ page import="clases.MedioDePago" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Pagos de Compras</title>
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
        .datos-compra {
            margin-top: 20px;
        }
        .datos-compra table {
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
    </style>
</head>
<body>

    <!-- Encabezado con el logo y el título -->
    <header>
        <img src="Icono/logo.jpg" alt="Logo" style="width:60px;height:60px;float:left;">
        <h1 style="display: inline-block; margin-left: 10px;">Pagos de Compras</h1>
    </header>

    <!-- Información de la compra -->
    <div class="datos-compra">
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
        <table>
            <thead>
                <tr class="encabezado">
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
        <%
            } else {
                out.println("<p>No se encontró información del proveedor o la compra.</p>");
            }
        %>
    </div>
    
    <table>
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
        <a href="principal.jsp?CONTENIDO=inicio.jsp">Volver al menu</a>
</body>
</html>
