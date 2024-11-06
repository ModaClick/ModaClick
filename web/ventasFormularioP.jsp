<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Persona"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Impuesto"%>
<%@page import="clases.TipoEnvio"%>
<%@page import="clases.MedioDePago"%>
<%@page import="clases.MedioPagoPorVenta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    String idPedido = request.getParameter("id");
    Pedido pedido = null;
    String listaArticulos = "";
    int totalArticulos = 0;
    String clienteValor = "";

    if (idPedido != null) {
        pedido = new Pedido(idPedido);
        clienteValor = pedido.getIdCliente();

        List<PedidoDetalle> detalles = PedidoDetalle.getDetallesPorPedido(idPedido);
        for (PedidoDetalle detalle : detalles) {
            int subtotal = Integer.parseInt(detalle.getValorUnitVenta()) * Integer.parseInt(detalle.getCantidad());
            totalArticulos += subtotal;

            Inventario articulo = new Inventario(detalle.getIdArticulo());
            String tipoTela = articulo.getTipoTela();
            String colorArticulo = articulo.getColorArticulo();
            String talla = articulo.getTalla();

            List<Impuesto> impuestos = articulo.obtenerImpuestos();
            StringBuilder impuestosTexto = new StringBuilder();

            for (Impuesto impuesto : impuestos) {
                impuestosTexto.append(impuesto.getNombre())
                        .append(" ")
                        .append(impuesto.getPorcentaje())
                        .append("%<br>");
            }

            if (impuestosTexto.length() == 0) {
                impuestosTexto.append("Sin impuestos");
            }

            listaArticulos += "<tr>";
            listaArticulos += "<td>" + detalle.getIdArticulo() + "</td>";
            listaArticulos += "<td align='right'>" + detalle.getValorUnitVenta() + "</td>";
            listaArticulos += "<td align='right'>" + detalle.getCantidad() + "</td>";
            listaArticulos += "<td align='right'>" + subtotal + "</td>";
            listaArticulos += "<td align='right'>" + talla + "</td>";
            listaArticulos += "<td align='right'>" + impuestosTexto.toString() + "</td>";
            listaArticulos += "<td align='right'>" + tipoTela + "</td>";
            listaArticulos += "<td align='right'>" + colorArticulo + "</td>";
            listaArticulos += "</tr>";
        }
    }

    String listaMediosDePago = "";
    List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
    for (MedioDePago medioDePago : mediosDePago) {
        String valor = "0";
        if (pedido != null) {
            List<MedioPagoPorVenta> mediosDePagoPedido = MedioPagoPorVenta.getListaEnObjetos(
                    "idVentaDetalle='" + idPedido + "' and idMedioPago=" + medioDePago.getId(), null);
            if (!mediosDePagoPedido.isEmpty()) {
                valor = mediosDePagoPedido.get(0).getValor();
            }
        }
        listaMediosDePago += "<tr>";
        listaMediosDePago += "<td>" + medioDePago.getTipoPago() + "</td>";
        listaMediosDePago += "<td><input type='number' name='valor" + medioDePago.getId() + "' value='" + valor + "' oninput='actualizarTotales()'></td>";
        listaMediosDePago += "</tr>";
    }
%>

<div class="form-container">
    <h3><%= accion.toUpperCase() %> VENTA</h3>
    <form name="formulario" method="post" action="RegistrarVentaConPedido.jsp" onsubmit="return actualizarCadenas();">
        <table border="0">
            <tr>
                <th>Cliente</th>
                <td>
                    <input type="text" name="cliente" id="cliente" 
                           value="<%= clienteValor %>" 
                           size="50" placeholder="Escriba aquí para buscar un cliente...">
                </td>
            </tr>
        </table>

        <table border="1" id="tablaArticulos">
            <tr>
                <th>Artículo</th>
                <th>Valor unitario</th>
                <th>Cantidad</th>
                <th>Subtotal</th>
                <th>Talla</th>
                <th>Impuestos</th>
                <th>TipoTela</th>
                <th>ColorArticulo</th>
            </tr>
            <%= listaArticulos %>
            <tr>
                <th colspan="3">TOTAL</th>
                <td align="right" id="totalArticulos"><%= totalArticulos %></td>
            </tr>
        </table>

        <p>MEDIOS DE PAGO<br>
        <table border="1" id="tablaMediosDePago">
            <%= listaMediosDePago %>
            <tr>
                <th>Total</th>
                <td align="right" id="totalMediosDePago">0</td>
            </tr>
            <tr>
                <th>Saldo</th>
                <td align="right" id="saldo"><%= totalArticulos %></td>
            </tr>
        </table>
        
        <input type="hidden" name="articulosVendidos" id="articulosVendidos">
        <input type="hidden" name="mediosDePagoUtilizados" id="mediosDePagoUtilizados">
        <input type="hidden" name="idPedido" value="<%= idPedido %>">
        <input type="submit" name="accion" value="<%= accion %>">
    </form>
</div>

<script type="text/javascript">
    function actualizarTotales() {
        var totalMediosPago = 0;
        var camposValor = document.querySelectorAll("#tablaMediosDePago input[type='number']");

        camposValor.forEach(function (campo) {
            totalMediosPago += parseFloat(campo.value || 0);
        });

        var saldo = parseFloat(document.getElementById("totalArticulos").innerHTML) - totalMediosPago;

        document.getElementById("totalMediosDePago").innerHTML = totalMediosPago;
        document.getElementById("saldo").innerHTML = saldo;
    }

    function actualizarCadenas() {
        // Generar cadena de artículos
        var cadenaArticulos = "";
        var tabla = document.getElementById("tablaArticulos");

        for (var i = 1; i < tabla.rows.length - 1; i++) {
            var idArticulo = tabla.rows[i].cells[0].innerHTML;
            var cantidad = tabla.rows[i].cells[2].innerHTML;
            cadenaArticulos += idArticulo + "|" + cantidad + "||";
        }
        document.getElementById("articulosVendidos").value = cadenaArticulos;

        // Generar cadena de medios de pago
        var cadenaMediosPago = "";
        var tablaMedios = document.querySelectorAll("#tablaMediosDePago input[type='number']");
        tablaMedios.forEach(function (input) {
            if (input.value > 0) { // Solo agregar si el valor es mayor a cero
                var idMedioPago = input.name.replace('valor', '');
                cadenaMediosPago += idMedioPago + "|" + input.value + "||";
            }
        });
        
        // Verificación en consola
        console.log("Cadena de Medios de Pago Generada: ", cadenaMediosPago); // <--- Verificar aquí
        document.getElementById("mediosDePagoUtilizados").value = cadenaMediosPago;

        // Confirmar envío del formulario solo si se completa el proceso
        return true;
    }
</script>
