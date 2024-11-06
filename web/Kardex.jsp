<%@page import="java.util.List" %>
<%@page import="clases.Inventario, clases.Compra, clases.CompraDetalle, clases.Venta, clases.VentaDetalle, clases.Impuesto" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
    table {
        width: 100%;
        border-collapse: collapse;
    }

    /* Encabezado de las columnas de la tabla */
    th {
        background-color: #343a40;
        color: white;
        font-weight: bold;
        text-align: center;
        padding: 10px;
    }

    /* Celdas de la tabla */
    td {
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

<%
    // Obtener el ID del artículo desde el parámetro de la URL
    String idArticulo = request.getParameter("idArticulo");

    if (idArticulo == null || idArticulo.isEmpty()) {
        out.println("No se ha proporcionado el id del artículo.");
    } else {
        // Instanciar el objeto de Inventario para obtener la información del artículo
        Inventario inventario = new Inventario(idArticulo);

        // Obtener las compras del artículo
        List<CompraDetalle> detallesCompras = CompraDetalle.getListaEnObjetos("idArticuloInventario=" + idArticulo, null);

        // Obtener las ventas del artículo
        List<VentaDetalle> detallesVentas = VentaDetalle.getListaEnObjetos("idArticuloInventario=" + idArticulo, null);

        // Obtener los impuestos del artículo
        List<Impuesto> impuestos = inventario.obtenerImpuestos();

        // Variables para el saldo
        int saldoCantidad = 0;
        double saldoTotal = 0;
        double saldoPromedio = 0;

        // Variable para construir la tabla del Kardex
        String lista = "";

        // Agregar las compras (Entradas) al Kardex
        for (CompraDetalle detalleCompra : detallesCompras) {
            Compra compra = new Compra(detalleCompra.getIdCompraDetalle());
            String fechaCompra = compra.getFechaCompra();

            int cantidadEntrada = Integer.parseInt(detalleCompra.getCantidad());
            double valorUnitarioEntrada = Double.parseDouble(detalleCompra.getCostoUnitCompra());
            double valorTotalEntrada = cantidadEntrada * valorUnitarioEntrada;

            // Actualizar el saldo
            saldoCantidad += cantidadEntrada;
            saldoTotal += valorTotalEntrada;
            saldoPromedio = saldoCantidad > 0 ? saldoTotal / saldoCantidad : 0;

            // Agregar fila al Kardex
            lista += "<tr>";
            lista += "<td>" + fechaCompra + "</td>";
            lista += "<td>Compra con No. " + detalleCompra.getIdCompraDetalle() + "</td>";
            lista += "<td class='center'>" + cantidadEntrada + "</td>";
            lista += "<td class='center'>" + valorUnitarioEntrada + "</td>";
            lista += "<td class='center'>" + valorTotalEntrada + "</td>";
            lista += "<td></td><td></td><td></td>"; // Espacios vacíos para salidas (ventas)
            lista += "<td class='center'>" + saldoCantidad + "</td>";
            lista += "<td class='center'>" + saldoPromedio + "</td>";
            lista += "<td class='center'>" + saldoTotal + "</td>";
            lista += "</tr>";
        }

        // Agregar las ventas (Salidas) al Kardex
        for (VentaDetalle detalleVenta : detallesVentas) {
            Venta venta = new Venta(detalleVenta.getIdVentaDetalle());
            String fechaVenta = venta.getFechaVenta();

            int cantidadSalida = Integer.parseInt(detalleVenta.getCantidad());
            double valorUnitarioSalida = Double.parseDouble(detalleVenta.getValorUnitVenta());
            double valorTotalSalida = cantidadSalida * valorUnitarioSalida;

            // Actualizar el saldo
            saldoCantidad -= cantidadSalida;
            saldoTotal -= valorTotalSalida;
            saldoPromedio = saldoCantidad > 0 ? saldoTotal / saldoCantidad : 0;

            // Agregar fila al Kardex
            lista += "<tr>";
            lista += "<td>" + fechaVenta + "</td>";
            lista += "<td>Venta con No. " + detalleVenta.getIdVentaDetalle() + "</td>";
            lista += "<td></td><td></td><td></td>"; // Espacios vacíos para entradas (compras)
            lista += "<td class='center'>" + cantidadSalida + "</td>";
            lista += "<td class='center'>" + valorUnitarioSalida + "</td>";
            lista += "<td class='center'>" + valorTotalSalida + "</td>";
            lista += "<td class='center'>" + saldoCantidad + "</td>";
            lista += "<td class='center'>" + saldoPromedio + "</td>";
            lista += "<td class='center'>" + saldoTotal + "</td>";
            lista += "</tr>";
        }
%>

<div class="container-fluid">
    <div class="table-container">
        <h3>Inventario Kardex</h3>

        <!-- Información general del artículo -->
        <table class="info-table">
            <tr>
                <th>Producto</th>
                <td><%= inventario.getNombreArticulo() %></td>
                <th>Descripción</th>
                <td><%= inventario.getDescripcion() %></td>
                <th>Talla</th>
                <td><%= inventario.getTalla() %></td>
                <th>Categoría</th>
                <td><%= inventario.getNombreArticulo()%></td>
                <th>Impuesto</th>
                <td>
                    <%
                        // Mostrar todos los impuestos asociados al artículo
                        if (impuestos.isEmpty()) {
                            out.print("Sin impuesto");
                        } else {
                            for (Impuesto impuesto : impuestos) {
                                out.print(impuesto.getNombre() + " (" + impuesto.getPorcentaje() + "%)<br>");
                            }
                        }
                    %>
                </td>
            </tr>
        </table>

        <!-- Tabla del Kardex -->
        <table class="kardex-table">
            <tr>
                <th>Fecha</th>
                <th>Detalle</th>
                <th>Cantidad Entrada</th>
                <th>Valor Unitario Entrada</th>
                <th>Valor Total Entrada</th>
                <th>Cantidad Salida</th>
                <th>Valor Unitario Salida</th>
                <th>Valor Total Salida</th>
                <th>Saldo Cantidad</th>
                <th>Promedio Costo</th>
                <th>Saldo Total</th>
            </tr>
            <%= lista %>
        </table>
    </div>
</div>

<%
    }
%>
