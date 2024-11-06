<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Persona"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.TipoEnvio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    String idPedido = request.getParameter("id");
    Pedido pedido = null;
    String listaArticulos = "";
    int totalArticulos = 0;

    // Obtener detalles del pedido si es una modificación
    if ("Modificar".equals(accion) && idPedido != null) {
        pedido = new Pedido(idPedido);  // Obtener el pedido con todos sus detalles

        // Obtener los detalles del pedido
        List<PedidoDetalle> detalles = PedidoDetalle.getDetallesPorPedido(idPedido);
        for (PedidoDetalle detalle : detalles) {
            totalArticulos += Integer.parseInt(detalle.getValorUnitVenta()) * Integer.parseInt(detalle.getCantidad());
            listaArticulos += "<tr>";
            listaArticulos += "<td>" + detalle.getIdArticulo() + "</td>"; // ID del artículo
            listaArticulos += "<td align='right'>" + detalle.getValorUnitVenta() + "</td>"; // Valor unitario
            listaArticulos += "<td align='right'>" + detalle.getCantidad() + "</td>"; // Cantidad
            listaArticulos += "<td align='right'>" + (Integer.parseInt(detalle.getValorUnitVenta()) * Integer.parseInt(detalle.getCantidad())) + "</td>"; // Subtotal
            listaArticulos += "<td><img src='presentacion/eliminar.png' title='Eliminar' onclick='eliminarArticulo(this);'></td>"; // Icono de eliminar
            listaArticulos += "</tr>";
        }
    }

    // Obtener la lista de artículos para el autocompletado
    List<Inventario> inventario = Inventario.getListaEnObjetos(null, null);
    StringBuilder listaArticulosJS = new StringBuilder();
    listaArticulosJS.append("[");
    for (int i = 0; i < inventario.size(); i++) {
        if (i > 0) {
            listaArticulosJS.append(", ");
        }
        listaArticulosJS.append("{")
            .append("\"label\": \"").append(inventario.get(i).getNombreArticulo()).append("\", ")
            .append("\"value\": \"").append(inventario.get(i).getIdArticulo()).append("\"")
            .append("}");
    }
    listaArticulosJS.append("]");
    
    // Obtener lista de clientes
    List<Persona> personas = Persona.getListaEnObjetos("tipo='C'", null);
    StringBuilder listaClientesJS = new StringBuilder();
    listaClientesJS.append("[");
    for (int i = 0; i < personas.size(); i++) {
        if (i > 0) {
            listaClientesJS.append(", ");
        }
        Persona cliente = personas.get(i);
        listaClientesJS.append("{")
            .append("\"label\": \"").append(cliente.getIdentificacion()).append(" - ").append(cliente.getNombre()).append("\", ")
            .append("\"value\": \"").append(cliente.getIdentificacion()).append("\"")
            .append("}");
    }
    listaClientesJS.append("]");
%>

<div class="form-container">
    <h3><%= accion.toUpperCase() %> PEDIDO</h3>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=pedidosActualizar.jsp" onsubmit="actualizarCadenaArticulos();">
        <table border="0">
            <tr>
                <th>Cliente</th>
                <td>
                    <input type="text" name="cliente" id="cliente" 
                           value="<%= (pedido != null && pedido.getIdCliente() != null) ? pedido.getIdCliente() : "" %>" 
                           size="50" placeholder="Escriba aquí para buscar un cliente...">
                </td>
            </tr>
            <tr>
                <th>Fecha</th>
                <td><input type="date" name="fecha" value="<%= (pedido != null) ? pedido.getFecha() : "" %>"></td>
            </tr>
            <tr>
                <th>Tipo Envío</th>
                <td>
                    <select name="tipoEnvio">
                        <option value="">Seleccione...</option>
                        <%= TipoEnvio.getListaEnOptionEnvios((pedido != null) ? pedido.getIdTipoEnvio() : "") %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Estado</th>
                <td>
                    <select name="estado">
                        <option value="Entregado" <%= (pedido != null && "Entregado".equals(pedido.getEstado())) ? "selected" : "" %>>Entregado</option>
                        <option value="Por entregar" <%= (pedido != null && "Por entregar".equals(pedido.getEstado())) ? "selected" : "" %>>Por entregar</option>
                    </select>
                </td>
            </tr>
        </table>

        <table border="1" id="tablaArticulos">
            <tr>
                <th>Artículo</th>
                <th>Valor Unitario</th>
                <th>Cantidad</th>
                <th>Subtotal</th>
                <th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();" style="cursor:pointer;"></th>
            </tr>
            <%= listaArticulos %>
            <tr>
                <th colspan="3">TOTAL</th>
                <td align="right" id="totalArticulos"><%= totalArticulos %></td>
            </tr>
        </table>

        <!-- Campo oculto para la cadena de artículos -->
        <input type="hidden" name="articulosVendidos" id="articulosVendidos">
        
        <input type="hidden" name="idPedido" value="<%= idPedido %>">
        <input type="submit" name="accion" value="<%= accion %>">
    </form>

    <!-- Formulario emergente para añadir artículos (inicialmente oculto) -->
    <div id="formulario" title="Adicionar artículo al pedido" style="display:none;">
        <form name="formularioArticulo">
            <table border="0">
                <tr>
                    <th>Artículo</th>
                    <td>
                        <select name="idArticulo" id="idArticulo" onchange="cargarDatosArticulo(this.value);">
                            <option value="">Seleccione un artículo...</option>
                            <%
                                List<Inventario> articulos = Inventario.getListaEnObjetos(null, null);
                                for (Inventario articulo : articulos) {
                                    out.println("<option value='" + articulo.getIdArticulo() + "'>" + articulo.getNombreArticulo() + "</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>Valor Unitario</th>
                    <td id="valorUnitario" align="right">0</td>
                </tr>
                <tr>
                    <th>Cantidad</th>
                    <td><input type="number" name="cantidad" id="cantidad" value="1" min="1" oninput="calcularSubTotal();"></td>
                </tr>
                <tr>
                    <th>Subtotal</th>
                    <td id="subTotal" align="right">0</td>
                </tr>
            </table>
            <div style="text-align: center;">
                <input type="button" value="Agregar" onclick="actualizarTabla();">
                <input type="button" value="Cancelar" onclick="cerrarFormulario();">
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    var articulos = <%= Inventario.getListaCompletaEnArregloJS(null, null) %>;
    
    function cargarDatosArticulo(idArticulo) {
        var articuloSeleccionado = articulos.find(function(art) {
            return art[0] == idArticulo;
        });

        if (articuloSeleccionado) {
            var valorUnitario = articuloSeleccionado[2];
            document.getElementById("valorUnitario").innerHTML = valorUnitario || "0";
            calcularSubTotal();
        } else {
            document.getElementById("valorUnitario").innerHTML = "0";
            document.getElementById("subTotal").innerHTML = "0";
        }
    }

    function calcularSubTotal() {
        var valorUnitario = parseFloat(document.getElementById("valorUnitario").innerHTML);
        var cantidad = parseInt(document.getElementById("cantidad").value);
        var subTotal = valorUnitario * cantidad;
        document.getElementById("subTotal").innerHTML = subTotal;
    }

    function actualizarTabla() {
        var idArticulo = $("#idArticulo").val();
        var valorUnitario = document.getElementById("valorUnitario").innerHTML;
        var cantidad = document.getElementById("cantidad").value;
        var subTotal = document.getElementById("subTotal").innerHTML;

        var tabla = document.getElementById("tablaArticulos");
        var nuevaFila = tabla.insertRow(tabla.rows.length - 1);
        nuevaFila.innerHTML = "<td>" + idArticulo + "</td>" +
                              "<td align='right'>" + valorUnitario + "</td>" +
                              "<td align='right'>" + cantidad + "</td>" +
                              "<td align='right'>" + subTotal + "</td>" +
                              "<td><img src='presentacion/eliminar.png' title='Eliminar' onclick='eliminarArticulo(this);'></td>";

        actualizarTotales();
        actualizarCadenaArticulos();
        cerrarFormulario();
    }

    function actualizarTotales() {
        var total = 0;
        var tabla = document.getElementById("tablaArticulos");
        for (var i = 1; i < tabla.rows.length - 1; i++) {
            total += parseFloat(tabla.rows[i].cells[3].innerHTML);
        }
        document.getElementById("totalArticulos").innerHTML = total;
    }

    function actualizarCadenaArticulos() {
        var cadenaArticulos = "";
        var tabla = document.getElementById("tablaArticulos");

        for (var i = 1; i < tabla.rows.length - 1; i++) {
            var idArticulo = tabla.rows[i].cells[0].innerHTML;
            var cantidad = tabla.rows[i].cells[2].innerHTML;

            if (cadenaArticulos !== "") {
                cadenaArticulos += ";";
            }
            cadenaArticulos += idArticulo + "," + cantidad;
        }

        document.getElementById("articulosVendidos").value = cadenaArticulos;
    }

    function eliminarArticulo(el) {
        var row = el.parentNode.parentNode;
        row.parentNode.removeChild(row);
        actualizarTotales();
        actualizarCadenaArticulos();
    }

    function abrirFormulario() {
        // Mostrar el formulario usando jQuery
        $("#formulario").dialog({
            autoOpen: false,
            modal: true,
            width: 400,
            height: 400,
            show: { effect: "blind", duration: 1000 },
            hide: { effect: "explode", duration: 1000 }
        });
        $("#formulario").dialog('open');
    }

    function cerrarFormulario() {
        // Limpiar los campos del formulario
        document.formularioArticulo.idArticulo.value = "";
        document.getElementById("valorUnitario").innerHTML = "0";
        document.getElementById("subTotal").innerHTML = "0";
        document.getElementById("cantidad").value = "1";

        // Cerrar el formulario
        $('#formulario').dialog('close');
    }

    $(function () {
        var clientes = <%= listaClientesJS.toString() %>;

        $("#cliente").autocomplete({
            source: clientes,
            select: function(event, ui) {
                $("#cliente").val(ui.item.value);
                return false;
            },
            minLength: 2
        });
    });
</script>


<style>
    #formulario {
        width: 350px;
        height: auto;
    }

    #formulario table th {
        width: 120px;
        text-align: left;
        padding-right: 10px;
    }

    #formulario table td {
        width: 200px;
        text-align: left;
    }

    #formulario td, #formulario th {
        padding: 5px;
    }

    #formulario select, #formulario input {
        width: 100%;
    }

    #formulario .form-buttons {
        text-align: center;
        margin-top: 10px;
    }
</style>


