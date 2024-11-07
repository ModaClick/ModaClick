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

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Estilo del contenedor del formulario */
    .form-container {
        max-width: 900px; /* Ancho máximo del formulario */
        margin: 50px auto; /* Centrar el formulario y agregar margen superior */
        padding: 30px; /* Espaciado interno */
        background: linear-gradient(to bottom left, #cccccc, #ccffff); /* Degradado suave entre azul claro y gris */
        border-radius: 8px; /* Bordes redondeados */
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3); /* Sombra del formulario */
        opacity: 0.95; /* Ligeramente transparente */
    }

    /* Estilo del encabezado del formulario */
    h2 {
        text-align: center; /* Centrar el texto */
        color: #333333; /* Color del texto */
        font-size: 24px; /* Tamaño de fuente */
        font-weight: bold; /* Negrita */
        margin-bottom: 20px; /* Margen inferior */
    }

    /* Estilo de los botones */
    .btn-submit {
        background-color: #007BFF; /* Color del botón */
        color: white; /* Color del texto */
        border: none; /* Sin borde */
        border-radius: 30px; /* Bordes redondeados */
        padding: 10px 20px; /* Espaciado interno */
        font-size: 16px; /* Tamaño de fuente */
        cursor: pointer; /* Cambia el cursor al pasar sobre el botón */
        transition: background-color 0.3s ease; /* Transición de color */
        width: 100%; /* Botón de ancho completo */
    }

    .btn-submit:hover {
        background-color: #0056b3; /* Color del botón al pasar el mouse */
    }

    /* Estilo de la tabla */
    .table-container {
        width: 100%;
        padding: 0;
        margin: 20px 0;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
    }

    table.table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
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

    /* Espacio entre los elementos del formulario */
    .form-group {
        margin-bottom: 1.8rem; /* Mayor espacio entre campos */
    }
</style>

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
        listaMediosDePago += "<td><input type='number' name='valor" + medioDePago.getId() + "' value='" + valor + "' oninput='actualizarTotales()' class='form-control'></td>";
        listaMediosDePago += "</tr>";
    }
%>

<div class="form-container">
    <h2><%= accion.toUpperCase() %> VENTA</h2>
    <form name="formulario" method="post" action="RegistrarVentaConPedido.jsp" onsubmit="return actualizarCadenas();">
        <table border="0">
            <tr>
                <th>Cliente</th>
                <td>
                    <input type="text" name="cliente" id="cliente" 
                           value="<%= clienteValor %>" 
                           size="50" placeholder="Escriba aquí para buscar un cliente..." class="form-control">
                </td>
            </tr>
        </table>

        <div class="table-container">
            <table class="table table-striped" id="tablaArticulos">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Valor unitario</th>
                        <th>Cantidad</th>
                        <th>Subtotal</th>
                        <th>Talla</th>
                        <th>Impuestos</th>
                        <th>Tipo Tela</th>
                        <th>Color Artículo</th>
                    </tr>
                </thead>
                <tbody>
                    <%= listaArticulos %>
                    <tr>
                        <th colspan="3">TOTAL</th>
                        <td align="right" id="totalArticulos"><%= totalArticulos %></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p>MEDIOS DE PAGO<br>
        <div class="table-container">
            <table class="table table-striped" id="tablaMediosDePago">
                <thead>
                    <tr>
                        <th>Medio de Pago</th>
                        <th>Valor</th>
                    </tr>
                </thead>
                <tbody>
                    <%= listaMediosDePago %>
                    <tr>
                        <th>Total</th>
                        <td align="right" id="totalMediosDePago">0</td>
                    </tr>
                    <tr>
                        <th>Saldo</th>
                        <td align="right" id="saldo"><%= totalArticulos %></td>
                    </tr>
                </tbody>
            </table>
        </div>
        </p>

        <input type="hidden" name="articulosVendidos" id="articulosVendidos">
        <input type="hidden" name="mediosDePagoUtilizados" id="mediosDePagoUtilizados">
        <input type="hidden" name="idPedido" value="<%= idPedido %>">
        <div class="text-center">
            <input type="submit" name="accion" value="<%= accion %>" class="btn-submit">
        </div>
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
