<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="clases.Venta"%>
<%@page import="clases.Persona"%>
<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Ventas</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
        table.table {
            width: 100%;
            border-collapse: collapse;
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
        .btn-modify {
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

        /* Evitar el desbordamiento en la tabla */
        .table-responsive {
            overflow-x: auto;
        }
    </style>
</head>
<body class="bg-light">

<%
    int elementosXPagina = 5;
    int pagina = 1;
    if (request.getParameter("pagina") != null) {
        pagina = Integer.parseInt(request.getParameter("pagina"));
    }
    int registroInicial = (pagina - 1) * elementosXPagina;
    int registroFinal = registroInicial + elementosXPagina;

    // Inicialización de filtro
    String filtro = "";

    // Filtro por fecha de venta
    String chkFechaVenta = request.getParameter("chkFechaVenta");
    String inicio = "";
    String fin = "";
    if (chkFechaVenta != null) {
        chkFechaVenta = "checked";
        inicio = request.getParameter("inicio");
        fin = request.getParameter("fin");
        filtro = "(fechaVenta between '" + inicio + "' and '" + fin + "')";
    } else chkFechaVenta = "";

    // Filtro por número de venta
    String chkVenta = request.getParameter("chkVenta");
    String idVentaDetalle = ""; 
    if (chkVenta != null) {
        chkVenta = "checked";
        idVentaDetalle = request.getParameter("idVentaDetalle");
        if (!filtro.equals("")) filtro += " and ";
        filtro += "idVenta like '%" + idVentaDetalle + "%'";
    } else chkVenta = "";

    // Filtro por cliente
    String chkCliente = request.getParameter("chkCliente");
    String cliente = "";
    if (chkCliente != null) {
        chkCliente = "checked";
        cliente = request.getParameter("cliente");
        if (!filtro.equals("")) filtro += " and ";
        filtro += "concat(identificacion,' - ',nombre) like '%" + cliente + "%'";
    } else chkCliente = "";

    // Filtro por medio de pago
    String chkMedioDePago = request.getParameter("chkMedioDePago");
    String idMedioDePago = "";
    if (chkMedioDePago != null) {
        chkMedioDePago = "checked";
        idMedioDePago = request.getParameter("idMedioDePago");
    } else chkMedioDePago = "";

    String lista = "";
    int totalLista = 0;
    int totalAbonado = 0;
    int totalSaldo = 0;

    // Obtener lista de ventas con filtro y paginación
    List<Venta> datos = Venta.getListaEnObjetos(filtro, "idVenta desc");
    int totalRegistros = datos.size();
    datos = Venta.getListaEnObjetos(filtro, "idVenta desc limit " + registroInicial + "," + elementosXPagina);

    // Generar lista de ventas
    for (int i = 0; i < datos.size(); i++) {
        Venta venta = datos.get(i);
        List<MedioPagoPorVenta> datosMedioDePago = venta.getMediosDePago();
        boolean presentarRegistro = false;
        String listaMediosDePago = "<table>";
        for (int j = 0; j < datosMedioDePago.size(); j++) {
            MedioPagoPorVenta medioPagoVenta = datosMedioDePago.get(j);
            if (idMedioDePago.equals("") || idMedioDePago.equals(medioPagoVenta.getIdMedioPagoFactura())) presentarRegistro = true;
            listaMediosDePago += "<tr>";
            listaMediosDePago += "<td>" + medioPagoVenta.getNombreMedioDePago() + "</td>";
            listaMediosDePago += "<td align='right'>" + medioPagoVenta.getValor() + "</td>";
            listaMediosDePago += "</tr>";
        }
        listaMediosDePago += "</table>";
        if (presentarRegistro) {
            totalLista += venta.getTotal();
            totalAbonado += venta.getAbonado();
            totalSaldo += venta.getSaldo();
            lista += "<tr>";
            lista += "<td>" + venta.getFechaVenta() + "</td>";
            lista += "<td>" + venta.getIdVenta() + "</td>";
            lista += "<td>" + venta.getCliente() + "</td>";
            lista += "<td>" + listaMediosDePago + "</td>";
            lista += "<td align='right'>" + venta.getTotal() + "</td>";
            lista += "<td align='right'>" + venta.getAbonado() + "</td>";
            lista += "<td align='right'>" + venta.getSaldo() + "</td>";
            lista += "<td>";
            lista += "<img src='presentacion/eliminar.png' title='Eliminar' onClick='eliminar(" + venta.getIdVenta() + ")'>"; 
            lista += "<img src='presentacion/detalle.png' title='Ver detalles' onClick='verDetalles(" + venta.getIdVenta() + ")'>"; 
            lista += "<img src='presentacion/pdf.png' title='Ver factura' onClick='verFactura(" + venta.getIdVenta() + ")'>"; 
            lista += "<img src='presentacion/pagos.png' title='Ver pagos pendientes' onClick='verPagos(" + venta.getIdVenta() + ")'>"; 
            
            lista += "</td>";
            lista += "</tr>";
        }
    }
    int numeroDePaginas = (int) Math.ceil((double)totalRegistros / elementosXPagina);
%>

<div class="container-fluid">
    <div class="table-container">
        <h3>LISTA DE VENTAS</h3>
        <div class="form-container mb-3">
            <h4>Búsqueda de Ventas</h4>
            <form method="post">
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkFechaVenta" <%=chkFechaVenta%>> Fecha
                                </div>
                            </div>
                            desde <input type="date" name="inicio" value="<%=inicio%>" class="form-control">
                            hasta <input type="date" name="fin" value="<%=fin%>" class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkVenta" <%=chkVenta%>> Venta
                                </div>
                            </div>
                            <input type="text" name="idVentaDetalle" value="<%=idVentaDetalle%>" class="form-control" placeholder="Número de venta">
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkCliente" <%=chkCliente%>> Cliente
                                </div>
                            </div>
                            <input type="text" name="cliente" id="cliente" value="<%=cliente%>" class="form-control" placeholder="Nombre del cliente">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkMedioPago" <%=chkMedioDePago%>> Medio de pago
                                </div>
                            </div>
                            <select name="idMedioDePago" class="form-control"><%=MedioDePago.getListaEnOptions(idMedioDePago)%></select>
                        </div>
                    </div>
                    <div class="col">
                        <button type="submit" class="btn btn-primary">Buscar</button>
                    </div>
                </div>
            </form>
        </div>

        <center>
            Página <%=pagina%> de <%=numeroDePaginas%>,
            mostrando registros del <%=registroInicial + 1%> al <%=Math.min(registroFinal, totalRegistros)%>
            de un total de <%=totalRegistros%>
        </center>

        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Fecha Venta</th>
                        <th>Número Venta</th>
                        <th>Cliente</th>
                        <th>Medio de pago</th>
                        <th>Total</th>
                        <th>Abonado</th>
                        <th>Saldo</th>
                        <th>
                            <a href="principal.jsp?CONTENIDO=ventasFormulario.jsp&accion=Adicionar" title="Adicionar">
                                <img src="presentacion/adicionar.png">
                            </a>
                            <img src="presentacion/excel.png" title="Generar reporte en excel" onclick="exportar('excel')">
                            <img src="presentacion/word.png" title="Generar reporte en word" onclick='exportar("word")'> 
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%= lista %>
                    <tr>
                        <th colspan="4">TOTAL</th>
                        <th align='right'><%=totalLista%></th>
                        <th align='right'><%=totalAbonado%></th>
                        <th align='right'><%=totalSaldo%></th>
                    </tr>
                </tbody>
            </table>
        </div>
<div style="text-align: center;">
        <img src="presentacion/primero.png" onclick="cambiarPagina('primero')"/>
        <img src="presentacion/anterior.png" onclick="cambiarPagina('anterior')"/>
        <input type="text" name="pagina" value="<%=pagina%>" size="2" onchange="cambiarPagina('especifico')"/>
        <img src="presentacion/siguiente.png" onclick="cambiarPagina('siguiente')"/>
        <img src="presentacion/ultimo.png" onclick="cambiarPagina('ultimo')"/>
</div>
    </div>
</div>

<script type="text/javascript">
    var personas = <%=Persona.getListaEnArregloJs("tipo='C'", null)%>
    $("#cliente").autocomplete({
        source: personas
    }); 
    function cambiarPagina(pagina){
        paginaActual=parseInt(document.formulario.pagina.value);
        switch(pagina){
            case "primero": pagina=1; break;
            case "anterior": pagina=paginaActual-1; break;
            case "siguiente": pagina=paginaActual+1; break;
            case "ultimo": pagina=<%=numeroDePaginas%>; break;
            case "especifico": pagina=paginaActual; break;
        }
        document.formulario.pagina.value=pagina;
        document.formulario.submit();
    }
    function eliminar(idVenta){
        respuesta=confirm("Realmente desea eliminar la venta "+idVenta+" con sus detalles y pagos?");
        if(respuesta){
            document.location="principal.jsp?CONTENIDO=ventasActualizar.jsp&accion=Eliminar&idVenta="+idVenta;
        }
    }
    function verDetalles(idVenta){
        document.location="principal.jsp?CONTENIDO=ventasDetalles.jsp&idVenta="+idVenta;
    }
     function verPagos(idVenta){
        document.location="principal.jsp?CONTENIDO=pagosVentas.jsp&idVenta="+idVenta;
    }
    function verFactura(idVenta){
        window.open("ventasGenerarFactura.jsp?idVenta=" + idVenta);
    }
    function exportar(formato){
        window.open("ventasExportar.jsp?formato="+formato+"&filtro=<%=filtro%>");
    }    
</script>
</body>
</html>
