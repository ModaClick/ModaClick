<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Persona"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="clases.MedioDePago"%>
<%@page import="clases.CompraDetalle"%>
<%@page import="clases.Compra"%>
<%@page import="clases.ImpuestoInventario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Estilos para el contenedor del formulario */
    .form-container {
        max-width: 900px;
        margin: 50px auto;
        padding: 30px;
        background: linear-gradient(to bottom left, #cccccc, #ccffff);
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        opacity: 0.95;
    }
    h2 {
        text-align: center;
        color: #333333;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
    }
    .btn-submit {
        background-color: #007BFF;
        color: white;
        border: none;
        border-radius: 30px;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        width: 100%;
    }
    .btn-submit:hover {
        background-color: #0056b3;
    }
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
    .table thead th {
        background-color: #343a40;
        color: white;
        font-weight: bold;
        text-align: center;
    }
    .table tbody td {
        text-align: center;
        vertical-align: middle;
        padding: 10px;
    }
    .form-group {
        margin-bottom: 1.8rem;
    }
</style>

<%
    String accion = request.getParameter("accion");
    String idCompra = request.getParameter("idCompra");
    Compra compra = new Compra(idCompra);
    String lista = "";
    int totalArticulos = 0;
    int saldos = compra.getSaldo();

    // Obtener detalles de la compra si es una modificación
    if (accion.equals("Modificar")) {
        List<CompraDetalle> detalles = compra.getDetalles();
        for (CompraDetalle detalle : detalles) {
            totalArticulos += detalle.getSubTotal();
            lista += "<tr>";
            lista += "<td>" + detalle.getIdArticuloInventario() + "</td>";
            lista += "<td align='right'>" + detalle.getCostoUnitCompra() + "</td>";
            lista += "<td align='right'>" + detalle.getCantidad() + "</td>";
            lista += "<td align='right'>" + detalle.getNombreYPorcentajeImpuesto() + "</td>";
            lista += "<td align='right'>" + detalle.getSubTotal() + "</td>";
            lista += "<td><img src='presentacion/eliminar.png' title='Eliminar'></td>";
            lista += "</tr>";
        }
    }

    // Obtener lista de medios de pago asociados a la compra
    String listaMediosDePago = "";
    List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
    for (MedioDePago medioDePago : mediosDePago) {
        String valor = "0";
        List<MedioPagoPorCompra> mediosDePagoCompra = MedioPagoPorCompra.getListaEnObjetos(
                "idCompraDetalle='" + compra.getIdCompra() + "' and idMedioPago=" + medioDePago.getId(), null);
        if (!mediosDePagoCompra.isEmpty()) {
            valor = mediosDePagoCompra.get(0).getValor();
        }
        listaMediosDePago += "<tr>";
        listaMediosDePago += "<td>" + medioDePago.getTipoPago() + "</td>";
        listaMediosDePago += "<td><input type='number' name='valor" + medioDePago.getId() + "' value='" + valor + "' oninput='actualizarTotales()' class='form-control'></td>";
        listaMediosDePago += "</tr>";
    }
%>

<div class="form-container">
    <h2><%= accion.toUpperCase() %> COMPRA</h2>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=comprasActualizar.jsp">
        <div class="form-group">
            <label>Proveedor:</label>
            <input type="text" name="proveedor" id="proveedor" value="<%= compra.getIdProveedor() %>" class="form-control" size="50">
        </div>

        <input type="hidden" name="articulosComprados" value="<%= lista %>">
        <div class="table-container">
            <table class="table table-striped table-hover" id="tablaArticulos">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Costo unitario</th>
                        <th>Tipo tela</th>
                        <th>Color artículo</th>
                        <th>Talla</th>
                        <th>Impuestos</th>
                        <th>Cantidad</th>
                        <th>Subtotal</th>
                        <th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();" style="cursor:pointer;"></th>
                    </tr>
                </thead>
                <tbody>
                    <%= lista %>
                    <tr>
                        <th colspan="7">TOTAL</th>
                        <td align="right" id="totalCompra"><%= totalArticulos %></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p>MEDIOS DE PAGO<br>
        <div class="table-container">
            <table class="table table-striped table-hover" id="tablaMediosDePago">
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
                        <td align="right" id="totalMediosDePago"><%= totalArticulos %></td>
                    </tr>
                    <tr>
                        <th>Saldo</th>
                        <td align="right" id="saldo"><%= saldos %></td>
                    </tr>
                </tbody>
            </table>
        </div>
        </p>
        <input type="hidden" name="idCompra" value="<%= idCompra %>">
        <div class="text-center">
            <input type="submit" name="accion" value="<%= accion %>" class="btn-submit">
        </div>
    </form>

    <!-- Formulario emergente -->
    <div id="formulario" title="Adicionar artículo a la compra" style="display:none;">
        <form name="formularioArticulo">
            <table class="table">
                <tr><th>Artículo</th><td><input type="text" name="idArticulo" id="idArticulo" oninput="cargarDatosArticulo(this.value);" class="form-control"></td></tr>
                <tr><th>Costo unitario</th><td id="costoUnitario" align="right">0</td></tr>
                <tr><th>Tipo tela</th><td id="tipoTela">No especificado</td></tr>
                <tr><th>Color artículo</th><td id="colorArticulo">No especificado</td></tr>
                <tr><th>Talla</th><td id="talla">No especificado</td></tr>
                <tr><th>Impuestos</th><td><ul id="listaImpuestos"></ul></td></tr>
                <tr><th>Cantidad</th><td><input type="number" name="cantidad" id="cantidad" value="1" min="1" oninput="calcularSubTotal()" class="form-control"></td></tr>
                <tr><th>Subtotal</th><td id="subTotal" align="right">0</td></tr>
            </table>
            <input type="button" value="Agregar" onclick="actualizarTabla();" class="btn btn-primary">
            <input type="button" value="Cancelar" onclick="cerrarFormulario();" class="btn btn-secondary">
        </form>
    </div>
</div>
<script type="text/javascript">
    var impuestos = <%= ImpuestoInventario.getListaEnArregloJS()%>;
    var articulos = <%= Inventario.getListaCompletaEnArregloJS(null, null)%>;

    var vectorArticulos = [];
    for (var i = 0; i < articulos.length; i++) {
        vectorArticulos[i] = articulos[i][1] + " (" + articulos[i][0] + ")"; // Nombre (Tipo de tela)
    }

    $("#idArticulo").autocomplete({
        source: vectorArticulos,
        select: function (event, ui) {
            var nombreArticulo = ui.item.label.split(" (")[0].trim();
            var posicion = buscarProducto(nombreArticulo, 1);
            cargarDatosArticulo(articulos[posicion][0]);
        }
    });

    var personas = <%= Persona.getListaEnArregloJs("tipo='P'", null)%>;
    $("#proveedor").autocomplete({
        source: personas
    });

    $(function () {
        $("#formulario").dialog({
            autoOpen: false,
            modal: true,
            width: 400,
            height: 400,
            show: {effect: "blind", duration: 1000},
            hide: {effect: "explode", duration: 1000}
        });
    });

    function abrirFormulario() {
        $("#formulario").dialog('open');
    }

    function cerrarFormulario() {
        document.formularioArticulo.idArticulo.value = "";
        document.getElementById("costoUnitario").innerHTML = "0";
        document.formularioArticulo.cantidad.value = "1";
        document.getElementById("subTotal").innerHTML = "0";
        document.getElementById("tipoTela").innerHTML = "No especificado";
        document.getElementById("colorArticulo").innerHTML = "No especificado";
        document.getElementById("talla").innerHTML = "No especificado";
        document.getElementById("listaImpuestos").innerHTML = "<li>No hay impuestos</li>";
        $('#formulario').dialog('close');
    }

    function cargarImpuestos(idArticulo) {
        console.log("Cargando impuestos para el artículo: " + idArticulo);
        var listaImpuestos = document.getElementById("listaImpuestos");
        listaImpuestos.innerHTML = "";

        var impuestosEncontrados = false;
        for (var i = 0; i < impuestos.length; i++) {
            if (idArticulo === impuestos[i][0]) {
                var nombreImpuesto = impuestos[i][2];
                var porcentajeImpuesto = impuestos[i][3];
                listaImpuestos.innerHTML += "<li>" + nombreImpuesto + " " + porcentajeImpuesto + "%</li>";
                impuestosEncontrados = true;
            }
        }

        if (!impuestosEncontrados) {
            listaImpuestos.innerHTML = "<li>No hay impuestos</li>";
        }
    }

   
    function buscarProducto(valor, indice) {
        for (var i = 0; i < articulos.length; i++) {
            if (articulos[i][indice] === valor) {
                return i;
            }
        }
        return -1;
    }

    function calcularSubTotal() {
        var costoUnitario = parseFloat(document.getElementById("costoUnitario").innerHTML);
        var cantidad = parseInt(document.formularioArticulo.cantidad.value);
        var subTotal = costoUnitario * cantidad;
        document.getElementById("subTotal").innerHTML = subTotal;
    }

    function actualizarTabla() {
        var articulosComprados = document.formulario.articulosComprados;
        if (articulosComprados.value != '') articulosComprados.value += "||";

        var articulo = document.formularioArticulo.idArticulo.value;
        var nombreArticulo = articulo.substring(0, articulo.indexOf("(")).trim();

        var posicion = buscarProducto(nombreArticulo, 1);
        var idArticulo = articulos[posicion][0];
        var impuestosAplicados = 0;

        for (var i = 0; i < impuestos.length; i++) {
            if (idArticulo === impuestos[i][0]) {
                impuestosAplicados += parseInt(impuestos[i][3]);
            }
        }

        var cantidad = document.formularioArticulo.cantidad.value;
        articulosComprados.value += idArticulo + "|" + cantidad + "|" + impuestosAplicados;

        cargarTabla();
        cerrarFormulario();
    }
function cargarDatosArticulo(idArticulo) {
    var posicion = buscarProducto(idArticulo, 0);
    if (posicion !== -1) {
        document.getElementById("costoUnitario").innerHTML = articulos[posicion][3]; // Ahora usa el índice 3 para costoUnitCompra
        document.getElementById("tipoTela").innerHTML = articulos[posicion][4];
        document.getElementById("colorArticulo").innerHTML = articulos[posicion][5];
        document.getElementById("talla").innerHTML = articulos[posicion][6];
        cargarImpuestos(idArticulo);
        calcularSubTotal();
    }
}

function cargarTabla() {
    document.getElementById("tablaArticulos").innerHTML = '<tr><th>Artículo</th><th>Costo unitario</th><th>Tipo tela</th><th>Color artículo</th><th>Talla</th><th>Impuestos</th><th>Cantidad</th><th>Subtotal</th><th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();" style="cursor:pointer;"></th></tr>';
    
    var filas = document.formulario.articulosComprados.value.split("||");
    var totalCompra = 0;

    for (var i = 0; i < filas.length; i++) {
        var fila = filas[i].split("|");
        var idArticulo = fila[0];
        var posicion = buscarProducto(idArticulo, 0);
        var costoUnitario = articulos[posicion][3]; // Ahora usa el índice 3 para costoUnitCompra
        var tipoTela = articulos[posicion][4];
        var colorArticulo = articulos[posicion][5];
        var talla = articulos[posicion][6];

        var impuestosTexto = "";
        for (var j = 0; j < impuestos.length; j++) {
            if (impuestos[j][0] == idArticulo) {
                impuestosTexto += impuestos[j][2] + " " + impuestos[j][3] + "%<br>";
            }
        }

        var cantidad = fila[1];
        var subtotal = costoUnitario * parseInt(cantidad);
        totalCompra += subtotal;

        document.getElementById("tablaArticulos").innerHTML += "<tr><td>" + articulos[posicion][1] + "</td><td align='right'>" + costoUnitario + "</td><td align='right'>" + tipoTela + "</td><td align='right'>" + colorArticulo + "</td><td align='right'>" + talla + "</td><td align='right'>" + impuestosTexto + "</td><td align='right'>" + cantidad + "</td><td align='right'>" + subtotal + "</td><td><img src='presentacion/eliminar.png' title='Eliminar' onclick='eliminarProducto(" + i + ")'></td></tr>";
    }

    document.getElementById("tablaArticulos").innerHTML += "<tr><th colspan='7'>TOTAL</th><td align='right' id='totalCompra'>" + totalCompra + "</td></tr>";
    actualizarTotales();
}

    function eliminarProducto(fila) {
        var articulosComprados = "";
        var filas = document.formulario.articulosComprados.value.split("||");
        
        for (var i = 0; i < filas.length; i++) {
            if (i != fila) {
                if (articulosComprados !== "") articulosComprados += "||";
                articulosComprados += filas[i];
            }
        }

        document.formulario.articulosComprados.value = articulosComprados;
        cargarTabla();
    }

    function actualizarTotales() {
        var totalMediosPago = <%= compra.getTotal() %>;
        var camposValor = document.querySelectorAll("#tablaMediosDePago input[type='number']");

        camposValor.forEach(function (campo) {
            totalMediosPago += parseFloat(campo.value || 0);
        });

        var saldo = parseFloat(document.getElementById("totalCompra").innerHTML) - totalMediosPago;
        document.getElementById("totalMediosDePago").innerHTML = totalMediosPago;
        document.getElementById("saldo").innerHTML = saldo;
    }
</script>
