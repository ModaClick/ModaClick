<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Persona"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="clases.MedioDePago"%>
<%@page import="clases.CompraDetalle"%>
<%@page import="clases.Compra"%>
<%@page import="clases.ImpuestoInventario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    String idCompra = request.getParameter("idCompra");
    String idArticulo = request.getParameter("idArticulo");

    Compra compra = new Compra(idCompra);
    String lineaModificar = "";
    String lista = "";
    int totalArticulos = 0;
    int saldos = compra.getSaldo();

    // Obtener detalles de la compra si es una modificación
    if (accion.equals("Modificar")) {
        lineaModificar = "<tr><th>Fecha</th><td>" + compra.getFechaCompra() + "</td></tr>";
        lineaModificar += "<tr><th>Número Compra</th><td>" + compra.getIdCompra() + "</td></tr>";
        List<CompraDetalle> detalles = compra.getDetalles();
        for (CompraDetalle detalle : detalles) {
            totalArticulos += detalle.getSubTotal();
            lista += "<tr>";
            lista += "<td>" + detalle.getIdArticuloInventario() + "</td>";   // Muestra el ID del artículo
            lista += "<td align='right'>" + detalle.getCostoUnitCompra() + "</td>";   // Muestra el costo unitario del artículo
            lista += "<td align='right'>" + detalle.getCantidad() + "</td>";  // Muestra la cantidad comprada
            lista += "<td align='right'>" + detalle.getNombreYPorcentajeImpuesto() + "</td>";  // Muestra el impuesto asociado
            lista += "<td align='right'>" + detalle.getSubTotal() + "</td>";  // Muestra el subtotal
            lista += "<td><img src='presentacion/eliminar.png' title='Eliminar'></td>";  // Icono de eliminar
            lista += "</tr>";
        }
    }

    // Obtener lista de medios de pago asociados a la compra usando idCompraDetalle
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
        listaMediosDePago += "<td><input type='number' name='valor" + medioDePago.getId() + "' value='" + valor + "' oninput='actualizarTotales()'></td>";
        listaMediosDePago += "</tr>";
    }
%>

<div class="form-container">
    <h3><%= accion.toUpperCase() %> COMPRA</h3>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=comprasActualizar.jsp">
        <table border="0">
            <%= lineaModificar %>
            <tr>
                <th>Proveedor</th>
                <td><input type="text" name="proveedor" id="proveedor" value="<%= compra.getIdProveedor() %>" size="50"></td>
            </tr>
        </table>

        <input type="hidden" name="articulosComprados" value="<%= lista %>">
        <table border="1" id="tablaArticulos">
            <tr>
                <th>Artículo</th><th>Costo unitario</th><th>Cantidad</th><th>Impuestos</th><th>Subtotal</th><th></th>
                <th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();"></th>
            </tr>
            <%= lista %>
            <tr><th colspan="5">TOTAL</th><td align="right" id="totalCompra"><%= totalArticulos %></td></tr>
        </table>

        <p>MEDIOS DE PAGO<br>
        <table border="1" id="tablaMediosDePago">
            <%= listaMediosDePago %>
            <tr>
                <th>Total</th>
                <td align="right" id="totalMediosDePago"><%= totalArticulos %></td>
            </tr>
            <tr>
                <th>Saldo</th>
                <td align="right" id="saldo"><%= saldos %></td>
            </tr>
        </table>
        <p>
            <input type="hidden" name="idCompra" value="<%= idCompra %>">
            <input type="submit" name="accion" value="<%= accion %>">
    </form>

    <!-- Formulario emergente -->
    <div id="formulario" title="Adicionar artículo a la compra">
        <form name="formularioArticulo">
            <table border="0">
                <tr><th>Artículo</th><td><input type="text" name="idArticulo" id="idArticulo" oninput="cargarDatosArticulo(this.value);"></td></tr>
                <tr><th>Costo unitario</th><td id="costoUnitario" align="right">0</td></tr>
                <tr><th>Impuestos</th><td><ul id="listaImpuestos"></ul></td></tr>
                <tr><th>Cantidad</th><td><input type="number" name="cantidad" id="cantidad" value="1" min="1" oninput="calcularSubTotal()"></td></tr>
                <tr><th>Subtotal</th><td id="subTotal" align="right">0</td></tr>
            </table>
            <input type="button" value="Agregar" onclick="actualizarTabla();">
            <input type="button" value="Cancelar" onclick="cerrarFormulario();">
        </form>
    </div>
</div>

<script type="text/javascript">
    var impuestos = <%= ImpuestoInventario.getListaEnArregloJS() %>;
    var articulos = <%= Inventario.getListaCompletaEnArregloJS(null, null) %>;

    var vectorArticulos = [];
    for (var i = 0; i < articulos.length; i++) {
        vectorArticulos[i] = articulos[i][1] + " (" + articulos[i][0] + ")"; // Nombre (ID Artículo)
    }

    $("#idArticulo").autocomplete({
        source: vectorArticulos,
        select: function (event, ui) {
            var nombreArticulo = ui.item.label.split(" (")[0].trim(); // Obtener solo el nombre del artículo
            var posicion = buscarProducto(nombreArticulo, 1); // Busca el artículo por el nombre
            cargarDatosArticulo(articulos[posicion][0]);  // Llama a la función para cargar los datos del artículo
        }
    });

    var personas = <%= Persona.getListaEnArregloJs("tipo='P'", null) %>;
    $("#proveedor").autocomplete({
        source: personas
    });

    $(function () {
        $("#formulario").dialog({
            autoOpen: false,
            modal: true,
            width: 400,  // Ajusta el ancho del diálogo
            height: 400, // Ajusta la altura del diálogo
            show: {effect: "blind", duration: 1000},
            hide: {effect: "explode", duration: 1000}
        });
    });

    function abrirFormulario() {
        $("#formulario").dialog('open');
    }

    function cerrarFormulario() {
        // Limpiar los campos del formulario
        document.formularioArticulo.idArticulo.value = "";  // Limpiar el campo idArticulo
        document.getElementById("costoUnitario").innerHTML = "0";  // Restablecer el costo unitario a 0
        document.formularioArticulo.cantidad.value = "1";  // Restablecer la cantidad a 1
        document.getElementById("subTotal").innerHTML = "0";  // Restablecer el subtotal a 0

        // Limpiar la lista de impuestos
        document.getElementById("listaImpuestos").innerHTML = "<li>No hay impuestos</li>";  // Restablecer el campo de impuestos

        // Cerrar el formulario emergente
        $('#formulario').dialog('close');
    }

    function cargarImpuestos(idArticulo) {
        console.log("Cargando impuestos para el artículo: " + idArticulo);
        var listaImpuestos = document.getElementById("listaImpuestos");
        listaImpuestos.innerHTML = "";

        var impuestosEncontrados = false;
        // Recorrer los impuestos y mostrarlos con nombre y porcentaje
        for (var i = 0; i < impuestos.length; i++) {
            if (idArticulo === impuestos[i][0]) {
                // Concatenar nombre del impuesto y porcentaje
                var nombreImpuesto = impuestos[i][2];
                var porcentajeImpuesto = impuestos[i][3];
                listaImpuestos.innerHTML += "<li>" + nombreImpuesto + " " + porcentajeImpuesto + "%</li>";
                impuestosEncontrados = true;
            }
        }

        // Si no se encontraron impuestos, mostrar mensaje
        if (!impuestosEncontrados) {
            listaImpuestos.innerHTML = "<li>No hay impuestos</li>";
        }
    }

    function cargarDatosArticulo(idArticulo) {
        var posicion = buscarProducto(idArticulo, 0);
        if (posicion !== -1) {
            var costoUnitario = articulos[posicion][2];
            document.getElementById("costoUnitario").innerHTML = costoUnitario ? costoUnitario : "0";

            cargarImpuestos(idArticulo);
            calcularSubTotal();
        }
    }

    function buscarProducto(valor, indice) {
        for (var i = 0; i < articulos.length; i++) {
            if (articulos[i][indice] === valor) {
                return i; // Retorna la posición si coincide
            }
        }
        return -1; // Retorna -1 si no encuentra el artículo
    }

    function calcularSubTotal() {
        var costoUnitario = parseFloat(document.getElementById("costoUnitario").innerHTML);
        var cantidad = parseInt(document.formularioArticulo.cantidad.value);
        var subTotal = costoUnitario * cantidad;
        document.getElementById("subTotal").innerHTML = subTotal;
    }

    function actualizarTabla() {
        objeto = document.formulario.articulosComprados;
        if (objeto.value != '') objeto.value += "||";

        var articulo = document.formularioArticulo.idArticulo.value;
        var nombreArticulo = articulo.substring(0, articulo.indexOf("(")).trim();

        var posicion = buscarProducto(nombreArticulo, 1);
        var idArticulo = articulos[posicion][0];
        var impuestosAplicados = 0;  // Inicializar con 0 para sumar los porcentajes

        // Sumar todos los porcentajes de impuestos
        for (var i = 0; i < impuestos.length; i++) {
            if (idArticulo === impuestos[i][0]) {
                impuestosAplicados += parseInt(impuestos[i][3]);  // Sumar los porcentajes como números
            }
        }

        var cantidad = document.formularioArticulo.cantidad.value;

        // Solo enviar el ID del artículo, cantidad y la suma de los impuestos
        objeto.value += idArticulo + "|" + cantidad + "|" + impuestosAplicados;

        cargarTabla();
        cerrarFormulario();
    }

    function cargarTabla() {
        document.getElementById("tablaArticulos").innerHTML = '<tr><th>Artículo</th><th>Costo unitario</th><th>Cantidad</th><th>Impuestos</th><th>Subtotal</th><th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();" style="cursor:pointer;"></th></tr>';
        
        var filas = document.formulario.articulosComprados.value.split("||");
        var totalCompra = 0;

        for (var i = 0; i < filas.length; i++) {
            var fila = filas[i].split("|");
            var idArticulo = fila[0];
            var posicion = buscarProducto(idArticulo, 0);
            var costoUnitario = articulos[posicion][2];

            // Inicializar variable de impuestos
            var impuestosTexto = "";
            for (var j = 0; j < impuestos.length; j++) {
                if (impuestos[j][0] == idArticulo) {
                    impuestosTexto += impuestos[j][2] + " " + impuestos[j][3] + "%<br>";
                }
            }

            var cantidad = fila[1];
            var subtotal = costoUnitario * parseInt(cantidad);
            totalCompra += subtotal;

            document.getElementById("tablaArticulos").innerHTML += "<tr><td>" + articulos[posicion][1] + "</td><td align='right'>" + costoUnitario + "</td><td align='right'>" + cantidad + "</td><td align='right'>" + impuestosTexto + "</td><td align='right'>" + subtotal + "</td><td><img src='presentacion/eliminar.png' title='Eliminar' onclick='eliminarProducto(" + i + ")'></td></tr>";
        }

        document.getElementById("tablaArticulos").innerHTML += "<tr><th colspan='4'>TOTAL</th><td align='right' id='totalCompra'>" + totalCompra + "</td></tr>";
        actualizarTotales();
    }

    function eliminarProducto(fila) {
        // Reiniciar la variable de artículos comprados
        var articulosComprados = "";
        
        // Obtener la lista de productos comprados
        var filas = document.formulario.articulosComprados.value.split("||");
        
        // Recorrer las filas para construir la lista nuevamente sin el producto eliminado
        for (var i = 0; i < filas.length; i++) {
            if (i != fila) {
                if (articulosComprados !== "") articulosComprados += "||"; // Concatenar si ya hay productos
                articulosComprados += filas[i];
            }
        }

        // Actualizar el campo oculto con la nueva lista de productos
        document.formulario.articulosComprados.value = articulosComprados;
        
        // Recargar la tabla
        cargarTabla();
    }

    function actualizarTotales() {
        var totalMediosPago = <%= compra.getTotal() %>;        
        var camposValor = document.querySelectorAll("#tablaMediosDePago input[type='number']");

        // Sumar los valores de cada medio de pago
        camposValor.forEach(function (campo) {
            totalMediosPago += parseFloat(campo.value || 0); // Si no hay valor, se toma como 0
        });

        // Calcular el saldo restante (total compra - total medios de pago)
        var saldoRestante = parseFloat(document.getElementById("totalCompra").innerHTML) - totalMediosPago;

        // Actualizar los elementos HTML para mostrar el total de medios de pago y el saldo restante
        document.getElementById("totalMediosDePago").innerHTML = totalMediosPago;
        document.getElementById("saldo").innerHTML = saldoRestante;
    }
</script>
