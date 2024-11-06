<%@page import="clases.MedioDePago"%>
<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="clases.Venta"%>
<%@ page import="clases.Inventario" %>
<%@ page import="clases.VentaDetalle" %>
<%@ page import="clases.ImpuestoInventario" %>
<%@ page import="java.util.List" %>

<%
    // Obtener el id de la venta desde el request
    String idVenta = request.getParameter("idVenta");
    // Crear una instancia de Venta para obtener sus detalles
    Venta venta = new Venta(idVenta);

    // Obtener detalles de la venta
    List<VentaDetalle> detallesVenta = venta.getDetalles(); 
    String fechaVenta = venta.getFechaVenta();
    String cliente = venta.getNombresCompletosCliente();
    String idCliente = venta.getIdCliente();

    int totalFactura = venta.getTotal();
    int abonado = venta.getAbonado();
    int saldo = venta.getSaldo();
    
    // Obtener medios de pago
    List<MedioPagoPorVenta> mediosDePago = venta.getMediosDePago();
    String listaMediosDePago = "";
    for (MedioPagoPorVenta medioDePago : mediosDePago) {
        MedioDePago medio = new MedioDePago(medioDePago.getIdPagos());
        listaMediosDePago += "<tr>";
        listaMediosDePago += "<td>" + medio.getTipoPago() + "</td>";
        listaMediosDePago += "<td align='right'>" + medioDePago.getValor() + "</td>";
        listaMediosDePago += "</tr>";
    }
%>

<h2>Venta Detalles</h2>

<!-- Información de la factura y cliente -->
<table border="1" width="100%">
    <tr>
        <th>Factura N°:</th>
        <td><%=idVenta%></td>
        <th>Fecha:</th>
        <td><%=fechaVenta%></td>
    </tr>
    <tr>
        <th>Cliente:</th>
        <td><%=cliente%></td>
        <th>Identificación:</th>
        <td><%=idCliente%></td>
    </tr>
</table>

<br>

<!-- Detalles de los artículos -->
<table border="1" width="100%">
    <tr>
        <th>Artículo</th>
        <th>Valor Unitario</th>
        <th>Tipo Tela</th>
        <th>Color Artículo</th>
        <th>Talla</th>
        <th>Cantidad</th>
        <th>Impuestos</th>
        <th>Subtotal</th>
    </tr>

<%
    for (VentaDetalle detalle : detallesVenta) {
        String idArticuloInventario = detalle.getIdArticuloInventario();
        int cantidad = Integer.parseInt(detalle.getCantidad());
        int valorUnitario = Integer.parseInt(detalle.getValorUnitVenta());
        int subtotal = cantidad * valorUnitario;

        // Crear una instancia de Inventario para obtener los detalles del artículo
        Inventario articuloInventario = new Inventario(idArticuloInventario);

        // Obtener los detalles del artículo desde la clase Inventario
        String nombreArticulo = articuloInventario.getNombreArticulo();
        String tipoTela = articuloInventario.getTipoTela();
        String colorArticulo = articuloInventario.getColorArticulo();
        String talla = articuloInventario.getTalla();

        // Utilizar el método getNombreYPorcentajeImpuesto desde VentaDetalle para obtener los impuestos
        String impuestosTexto = detalle.getNombreYPorcentajeImpuesto();
%>
    <tr>
        <td><%=nombreArticulo%></td>
        <td><%=valorUnitario%></td>
        <td><%=tipoTela%></td>
        <td><%=colorArticulo%></td>
        <td><%=talla%></td>
        <td><%=cantidad%></td>
        <td><%=impuestosTexto%></td> <!-- Mostrar todos los impuestos concatenados -->
        <td><%=subtotal%></td> <!-- Mostrar subtotal directamente -->
    </tr>
<%
    } // Fin del ciclo for
%>
    <tr>
        <th colspan="7" align="right">TOTAL</th>
        <td><%=totalFactura%></td>
    </tr>
</table>

<br>

<!-- Medios de Pago -->
<h3>MEDIOS DE PAGO</h3>
<table border="1" width="100%">
    <tr>
        <th>Medio de Pago</th>
        <th>Valor</th>
    </tr>
    <%=listaMediosDePago%> <!-- Aquí se muestran los medios de pago -->
</table>

<br>

<!-- Totales y saldos -->
<table border="1" width="100%">
    <tr>
        <th>Total Abonado</th>
        <td align="right"><%=abonado%></td>
    </tr>
    <tr>
        <th>Saldo Pendiente</th>
        <td align="right"><%=saldo%></td>
    </tr>
</table>
