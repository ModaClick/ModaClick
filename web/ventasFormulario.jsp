<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Persona"%>
<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="clases.MedioDePago"%>
<%@page import="clases.VentaDetalle"%>
<%@page import="clases.Venta"%>
<%@page import="clases.ImpuestoInventario"%>
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
    h3 {
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
    String idVenta = request.getParameter("idVenta");
    String idArticulo = request.getParameter("idArticulo");

    Venta venta = new Venta(idVenta);
    String lineaModificar = "";
    String lista = "";
    int totalarticulos = 0;
    int saldos = venta.getSaldo();

    // Obtener detalles de la venta si es una modificación
    if (accion.equals("Modificar")) {
        List<VentaDetalle> detalles = venta.getDetalles();
        for (VentaDetalle detalle : detalles) {
            totalarticulos += detalle.getSubTotal();
            lista += "<tr>";
            lista += "<td>" + detalle.getIdArticuloInventario() + "</td>";   // Muestra el ID del artículo
            lista += "<td align='right'>" + detalle.getValorUnitVenta() + "</td>";   // Muestra el valor unitario del artículo            
            lista += "<td align='right'>" + detalle.getCantidad() + "</td>";  // Muestra la cantidad vendida
            lista += "<td align='right'>" + detalle.getNombreYPorcentajeImpuesto() + "</td>";  // Muestra el impuesto asociado
            lista += "<td align='right'>" + detalle.getSubTotal() + "</td>";  // Muestra el subtotal
            lista += "<td><img src='presentacion/eliminar.png' title='Eliminar'></td>";  // Icono de eliminar
            lista += "</tr>";
        }
    }

    // Obtener lista de medios de pago asociados a la venta usando idVentaDetalle
    String listaMediosDePago = "";
    List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
    for (MedioDePago medioDePago : mediosDePago) {
        String valor = "0";
        List<MedioPagoPorVenta> mediosDePagoVenta = MedioPagoPorVenta.getListaEnObjetos(
                "idVentaDetalle='" + venta.getIdVenta() + "' and idMedioPago=" + medioDePago.getId(), null);
        if (!mediosDePagoVenta.isEmpty()) {
            valor = mediosDePagoVenta.get(0).getValor();
        }
        listaMediosDePago += "<tr>";
        listaMediosDePago += "<td>" + medioDePago.getTipoPago() + "</td>";
        listaMediosDePago += "<td><input type='number' name='valor" + medioDePago.getId() + "' value='" + valor + "' oninput='actualizarTotales()' class='form-control'></td>";
        listaMediosDePago += "</tr>";
    }
%>

<div class="form-container">
    <h3><%= accion.toUpperCase() %> VENTA</h3>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=ventasActualizar.jsp">
        <div class="form-group">
            <label>Cliente:</label>
            <input type="text" name="cliente" id="cliente" value="<%= venta.getIdCliente() %>" class="form-control" size="50">
        </div>

        <input type="text" name="articulosVendidos" value="<%= lista %>" size="150" hidden>
        <div class="table-container">
            <table class="table table-striped table-hover" id="tablaArticulos">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Valor unitario</th>
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
                        <th colspan="6">TOTAL</th>
                        <td align="right" id="totalVenta"><%= totalarticulos %></td>
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
                        <td align="right" id="totalMediosDePago"><%= totalarticulos %></td>
                    </tr>
                    <tr>
                        <th>Saldo</th>
                        <td align="right" id="saldo"><%= saldos %></td>
                    </tr>
                </tbody>
            </table>
        </div>
        </p>
        <input type="hidden" name="idVenta" value="<%= idVenta %>">
        <div class="text-center">
            <input type="submit" name="accion" value="<%= accion %>" class="btn-submit">
        </div>
    </form>

    <!-- Formulario emergente -->
 <div id="formulario" title="Adicionar artículo a la venta" style="display:none;">
        <form name="formularioArticulo">
            <table class="table">
                <tr><th>Artículo</th><td><input type="text" name="idArticulo" id="idArticulo" oninput="cargarDatosArticulo(this.value);" class="form-control"></td></tr>
                

                 <tr><th>Valor unitario</th><td id="valorUnitario" align="right">0</td></tr>
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
        var nombreArticulo = ui.item.label.split(" (")[0].trim(); // Obtener solo el nombre del artículo.
        var posicion = buscarProducto(nombreArticulo, 1); // Busca el artículo por el nombre.
        cargarDatosArticulo(articulos[posicion][0]);  // Llama a la función para cargar los datos del artículo.
    }
});


    
    
    var personas = <%= Persona.getListaEnArregloJs("tipo='C'", null)%>;
    $("#cliente").autocomplete({
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
        document.getElementById("valorUnitario").innerHTML = "0";  // Restablecer el valor unitario a 0
        document.formularioArticulo.cantidad.value = "1";  // Restablecer la cantidad a 1
        document.getElementById("subTotal").innerHTML = "0";  // Restablecer el subtotal a 0
        document.getElementById("tipoTela").innerHTML = "No especificado";  // Restablecer el tipo de tela
        document.getElementById("colorArticulo").innerHTML = "No especificado";  // Restablecer el color
        document.getElementById("talla").innerHTML = "No especificado";  // Restablecer la talla

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
            var valorUnitario = articulos[posicion][2];
            var tipoTela = articulos[posicion][3];
            var colorArticulo = articulos[posicion][4];
            var talla = articulos[posicion][5];

            document.getElementById("valorUnitario").innerHTML = valorUnitario ? valorUnitario : "0";
            document.getElementById("tipoTela").innerHTML = tipoTela ? tipoTela : "No especificado";
            document.getElementById("colorArticulo").innerHTML = colorArticulo ? colorArticulo : "No especificado";
            document.getElementById("talla").innerHTML = talla ? talla : "No especificado";

            cargarImpuestos(idArticulo);
            calcularSubTotal();
        }
    }


function buscarProducto(valor, indice) {
    for (var i = 0; i < articulos.length; i++) {
        if (articulos[i][indice] === valor) {
            return i; // Retorna la posición si coincide.
        }
    }
    return -1; // Retorna -1 si no encuentra el artículo.
}



    function calcularSubTotal() {
        var valorUnitario = parseFloat(document.getElementById("valorUnitario").innerHTML);
        var cantidad = parseInt(document.formularioArticulo.cantidad.value);
        var subTotal = valorUnitario * cantidad;
        document.getElementById("subTotal").innerHTML = subTotal;
    }

    function limpiarFormulario() {
        document.getElementById("valorUnitario").innerHTML = "0";
        document.getElementById("tipoTela").innerHTML = "No especificado";
        document.getElementById("colorArticulo").innerHTML = "No especificado";
        document.getElementById("talla").innerHTML = "No especificado";
    }
function actualizarTabla() {
    objeto = document.formulario.articulosVendidos;
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



$("#idArticulo").change(function() {
    nombreArticulo = this.value.substring(0, this.value.indexOf("(")).trim();   
    posicion = buscarProducto(nombreArticulo, 1);
    valorUnitario = articulos[posicion][2];
    document.getElementById("valorUnitario").innerHTML = valorUnitario;   
    impuesto = impuestos[posicion][3]; // Capturar el impuesto
    document.getElementById("impuesto").innerHTML = impuesto; // Mostrar el impuesto    
    calcularSubTotal();
});
$("#idArticulo").on('change', function () {
    var nombreArticulo = $(this).val();
    var posicion = buscarProducto(nombreArticulo, 1);
    if (posicion !== -1) {
        cargarDatosArticulo(articulos[posicion][0]);
    }
});
   function cargarTabla() {
    document.getElementById("tablaArticulos").innerHTML = '<tr><th>Artículo</th><th>Valor unitario</th><th>Tipo tela</th><th>Color artículo</th><th>Talla</th><th>Impuestos</th><th>Cantidad</th><th>Subtotal</th><th><img src="presentacion/adicionar.png" title="Adicionar" onclick="abrirFormulario();" style="cursor:pointer;"></th></tr>';
    
    var filas = document.formulario.articulosVendidos.value.split("||");
    var totalCompra = 0;

    for (var i = 0; i < filas.length; i++) {
        var fila = filas[i].split("|");
        var idArticulo = fila[0];
        var posicion = buscarProducto(idArticulo, 0);
        var valorUnitario = articulos[posicion][2];
        var tipoTela = articulos[posicion][3];
        var colorArticulo = articulos[posicion][4];
        var talla = articulos[posicion][5];
        
        // Inicializar variable de impuestos
        var impuestosTexto = "";
        for (var j = 0; j < impuestos.length; j++) {
            if (impuestos[j][0] == idArticulo) {
                impuestosTexto += impuestos[j][2] + " " + impuestos[j][3] + "%<br>";
            }
        }

        var cantidad = fila[1];
        var subtotal = valorUnitario * parseInt(cantidad);
        totalCompra += subtotal;

        document.getElementById("tablaArticulos").innerHTML += "<tr><td>" + articulos[posicion][1] + "</td><td align='right'>" + valorUnitario + "</td><td align='right'>" + tipoTela + "</td><td align='right'>" + colorArticulo + "</td><td align='right'>" + talla + "</td><td align='right'>" + impuestosTexto + "</td><td align='right'>" + cantidad + "</td><td align='right'>" + subtotal + "</td><td><img src='presentacion/eliminar.png' title='Eliminar' onclick='eliminarProducto(" + i + ")'></td></tr>";
    }

    document.getElementById("tablaArticulos").innerHTML += "<tr><th colspan='7'>TOTAL</th><td align='right' id='totalVenta'>" + totalCompra + "</td></tr>";
    actualizarTotales();
}

function eliminarProducto(fila) {
    // Reiniciar la variable de artículos vendidos
    var articulosVendidos = "";
    
    // Obtener la lista de productos vendidos
    var filas = document.formulario.articulosVendidos.value.split("||");
    
    // Recorrer las filas para construir la lista nuevamente sin el producto eliminado
    for (var i = 0; i < filas.length; i++) {
        if (i != fila) {
            if (articulosVendidos !== "") articulosVendidos += "||"; // Concatenar si ya hay productos
            articulosVendidos += filas[i];
        }
    }

    // Actualizar el campo oculto con la nueva lista de productos
    document.formulario.articulosVendidos.value = articulosVendidos;
    
    // Recargar la tabla
    cargarTabla();
}
function actualizarTotales() {
    var totalMediosPago = <%= venta.getTotal() %>;        
    var camposValor = document.querySelectorAll("#tablaMediosDePago input[type='number']");

    // Sumar los valores de cada medio de pago
    camposValor.forEach(function (campo) {
        totalMediosPago += parseFloat(campo.value || 0); // Si no hay valor, se toma como 0
    });

    // Calcular el saldo restante (total venta - total medios de pago)
    var mediosdelsaldo = parseFloat(document.getElementById("totalVenta").innerHTML) - totalMediosPago;

    // Actualizar los elementos HTML para mostrar el total de medios de pago y el saldo restante
    document.getElementById("totalMediosDePago").innerHTML = totalMediosPago;
    document.getElementById("saldo").innerHTML = mediosdelsaldo;
}
</script>
