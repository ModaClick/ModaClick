<%@page import="clases.MedioDePago"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="clases.Compra"%>
<%@page import="clases.Inventario" %>
<%@page import="clases.CompraDetalle" %>
<%@page import="clases.ImpuestoInventario" %>
<%@page import="java.util.List" %>

<%
    // Obtener el id de la compra desde el request
    String idCompra = request.getParameter("idCompra");
    // Crear una instancia de Compra para obtener sus detalles
    Compra compra = new Compra(idCompra);

    // Obtener detalles de la compra
    List<CompraDetalle> detallesCompra = compra.getDetalles(); 
    String fechaCompra = compra.getFechaCompra();
    String proveedor = compra.getNombresCompletosProveedor();
    String idProveedor = compra.getIdProveedor();

    int totalFactura = compra.getTotal();
    int abonado = compra.getAbonado();
    int saldo = compra.getSaldo();
    
    // Obtener medios de pago
    List<MedioPagoPorCompra> mediosDePago = compra.getMediosDePago();
    String listaMediosDePago = "";
    for (MedioPagoPorCompra medioDePago : mediosDePago) {
        MedioDePago medio = new MedioDePago(medioDePago.getIdPagos());
        listaMediosDePago += "<tr>";
        listaMediosDePago += "<td>" + medio.getTipoPago() + "</td>";
        listaMediosDePago += "<td align='right'>" + medioDePago.getValor() + "</td>";
        listaMediosDePago += "</tr>";
    }
%>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        color: #333;
    }
    h2 {
        text-align: center;
        font-size: 28px;
        margin-top: 20px;
        font-family: 'Comic Sans MS', cursive, sans-serif;
        background-color: #FFFFFF;
        padding: 10px;
        border-radius: 5px;
    }
    table {
        width: 95%;
        margin: 20px auto;
        border-collapse: collapse;
        box-shadow: 0px 0px 5px rgba(0,0,0,0.3);
    }
    th, td {
        border: 1px solid #CCC;
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #343a40;
        color: #FFFFFF;
        font-weight: bold;
    }
    .info-table th {
        background-color: #5A5A5A;
        color: #FFFFFF;
    }
    .info-table td {
        background-color: #F7F7F7;
    }
</style>

<h2>DETALLES DE COMPRA</h2>

<!-- Información de la factura y proveedor -->
<table>
    <tr>
        <th>Factura N°:</th>
        <td><%=idCompra%></td>
        <th>Fecha:</th>
        <td><%=fechaCompra%></td>
    </tr>
    <tr>
        <th>Proveedor:</th>
        <td><%=proveedor%></td>
        <th>Identificación:</th>
        <td><%=idProveedor%></td>
    </tr>
</table>

<br>

<!-- Detalles de los artículos -->
<table>
    <tr>
        <th>Artículo</th>
        <th>Costo Unitario</th>
        <th>Tipo Tela</th>
        <th>Color Artículo</th>
        <th>Talla</th>
        <th>Cantidad</th>
        <th>Impuestos</th>
        <th>Subtotal</th>
    </tr>

<%
    for (CompraDetalle detalle : detallesCompra) {
        String idArticuloInventario = detalle.getIdArticuloInventario();
        int cantidad = Integer.parseInt(detalle.getCantidad());
        int costoUnitario = Integer.parseInt(detalle.getCostoUnitCompra());
        int subtotal = cantidad * costoUnitario;

        // Crear una instancia de Inventario para obtener los detalles del artículo
        Inventario articuloInventario = new Inventario(idArticuloInventario);

        // Obtener los detalles del artículo desde la clase Inventario
        String nombreArticulo = articuloInventario.getNombreArticulo();
        String tipoTela = articuloInventario.getTipoTela();
        String colorArticulo = articuloInventario.getColorArticulo();
        String talla = articuloInventario.getTalla();

        // Utilizar el método getNombreYPorcentajeImpuesto desde CompraDetalle para obtener los impuestos
        String impuestosTexto = detalle.getNombreYPorcentajeImpuesto();
%>
    <tr>
        <td><%=nombreArticulo%></td>
        <td><%=costoUnitario%></td>
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
<table>
    <tr>
        <th>Medio de Pago</th>
        <th>Valor</th>
    </tr>
    <%=listaMediosDePago%> <!-- Aquí se muestran los medios de pago -->
</table>

<br>

<!-- Totales y saldos -->
<table>
    <tr>
        <th>Total Abonado</th>
        <td align="right"><%=abonado%></td>
    </tr>
    <tr>
        <th>Saldo Pendiente</th>
        <td align="right"><%=saldo%></td>
    </tr>
</table>
