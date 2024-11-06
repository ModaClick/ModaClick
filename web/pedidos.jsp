<%@page import="clases.TipoEnvio"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.Venta"%>
<%@page import="clases.VentaDetalle"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Persona"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int elementosXPagina = 5;
    int pagina = 1;
    if (request.getParameter("pagina") != null) {
        pagina = Integer.parseInt(request.getParameter("pagina"));
    }
    int registroInicial = (pagina - 1) * elementosXPagina;
    int registroFinal = registroInicial + elementosXPagina;

    // Obtener la lista de clientes y proveedores con id y nombre para autocompletado
    List<Persona> personas = Persona.getListaEnObjetos("tipo IN ('C')", null);
    StringBuilder listaPersonasJS = new StringBuilder();
    listaPersonasJS.append("[");
    for (int i = 0; i < personas.size(); i++) {
        if (i > 0) {
            listaPersonasJS.append(", ");
        }
        listaPersonasJS.append("{")
                .append("\"label\": \"").append(personas.get(i).getIdentificacion()).append(" - ").append(personas.get(i).getNombre()).append("\", ")
                .append("\"value\": \"").append(personas.get(i).getIdentificacion()).append("\"")
                .append("}");
    }
    listaPersonasJS.append("]");

    // Variables para filtros
    String filtro = "";

    // Filtro por fecha
    String chkFecha = request.getParameter("chkFecha");
    String fechaInicio = "";
    String fechaFin = "";
    if (chkFecha != null) {
        chkFecha = "checked";
        fechaInicio = request.getParameter("fechaInicio");
        fechaFin = request.getParameter("fechaFin");
        filtro = "(fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "')";
    } else {
        chkFecha = "";
    }

    // Filtro por código de pedido
    String chkCodigoPedido = request.getParameter("chkCodigoPedido");
    String codigoInicio = "";
    String codigoFin = "";
    if (chkCodigoPedido != null) {
        chkCodigoPedido = "checked";
        codigoInicio = request.getParameter("codigoInicio");
        codigoFin = request.getParameter("codigoFin");
        if (!filtro.equals("")) {
            filtro += " AND ";
        }
        filtro += "(id BETWEEN " + codigoInicio + " AND " + codigoFin + ")";
    } else {
        chkCodigoPedido = "";
    }

    // Filtro por cliente/proveedor (solo por ID del cliente o proveedor)
    String chkNombrePersona = request.getParameter("chkNombrePersona");
    String idPersona = "";
    if (chkNombrePersona != null) {
        chkNombrePersona = "checked";
        idPersona = request.getParameter("idPersona");
        if (!filtro.equals("")) {
            filtro += " AND ";
        }
        filtro += "idCliente = '" + idPersona + "'";
    } else {
        chkNombrePersona = "";
    }

    // Filtro por tipo de envío
    String chkTipoEnvio = request.getParameter("chkTipoEnvio");
    String tipoEnvio = "";
    if (chkTipoEnvio != null) {
        chkTipoEnvio = "checked";
        tipoEnvio = request.getParameter("tipoEnvio");
        if (!filtro.equals("")) {
            filtro += " AND ";
        }
        filtro += "idTipoEnvio = '" + tipoEnvio + "'";
    } else {
        chkTipoEnvio = "";
    }

    String tipoEnvioOptions = TipoEnvio.getListaEnOptionEnvios(tipoEnvio);

    // Filtro por estado
    String chkEstado = request.getParameter("chkEstado");
    String estado = "";
    if (chkEstado != null) {
        chkEstado = "checked";
        estado = request.getParameter("estado");
        if (!filtro.equals("")) {
            filtro += " AND ";
        }
        filtro += "estado = '" + estado + "'";
    } else {
        chkEstado = "";
    }

    List<Pedido> datos = Pedido.getListaEnObjetos(filtro, "id desc");
    double totalRegistros = datos.size();
    datos = Pedido.getListaEnObjetos(filtro, "id desc limit " + registroInicial + "," + elementosXPagina);
    String lista = "";
    for (Pedido pedido : datos) {
        String colorEstado = pedido.getEstado().equalsIgnoreCase("Entregado") ? "green" : "red";
        String fechaFormateada = pedido.getFecha().substring(0, 10); // Obtener solo el año, mes y día
        lista += "<tr bgColor='" + colorEstado + "'>";
        lista += "<td align='right'>" + pedido.getId() + "</td>";
        lista += "<td>" + pedido.getIdVentaDetalle() + "</td>";
        lista += "<td>" + fechaFormateada + "</td>";
        lista += "<td>" + pedido.getNombreCliente() + "</td>";
        lista += "<td>" + pedido.getTipoEnvio() + "</td>";
        lista += "<td>" + pedido.getEstado() + "</td>";
        lista += "<td>" + pedido.calcularValorTotal() + "</td>";
        lista += "<td>";
        lista += "<img src='presentacion/modificar.png' title='Modificar' onClick='modificar(" + pedido.getId() + ")' width='40' height='40'>"; // Opción de Modificar
        lista += "<img src='presentacion/eliminar.png' title='Eliminar' onClick='eliminar(" + pedido.getId() + ")' width='40' height='40'>";  // Opción de Eliminar
        lista += "<img src='presentacion/detalle.png' title='Ver detalles' onClick='verDetalles(" + pedido.getId() + ")' width='40' height='40'>";
        lista += "<img src='presentacion/pdf.png' title='Ver Pedido' onClick='verPedido(" + pedido.getId() + ")' width='40' height='40'>";
        lista += "<img src='presentacion/ventas.png' title='Ventas' onClick='Generarventas(" + pedido.getId() + ")' width='40' height='40'>";
        lista += "<img src='presentacion/pagos.png' title='Pagos' onClick='pagos(" + pedido.getIdVentaDetalle() + ")' width='40' height='40'>";
        lista += "</td>";
        lista += "</tr>";
    }
    int numeroDePaginas = (int) Math.ceil((double)totalRegistros / elementosXPagina);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Pedidos</title>
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

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <h3>LISTA DE PEDIDOS</h3>
        <div class="form-container mb-3">
            <form name="formulario" method="post">
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkFecha" <%= chkFecha %>> Fecha
                                </div>
                            </div>
                            desde <input type="date" name="fechaInicio" value="<%= fechaInicio %>" class="form-control">
                            hasta <input type="date" name="fechaFin" value="<%= fechaFin %>" class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkCodigoPedido" <%= chkCodigoPedido %>> Código de Pedido
                                </div>
                            </div>
                            desde <input type="number" name="codigoInicio" value="<%= codigoInicio %>" class="form-control">
                            hasta <input type="number" name="codigoFin" value="<%= codigoFin %>" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkNombrePersona" <%= chkNombrePersona %>> Nombre del Cliente
                                </div>
                            </div>
                            <input type="text" name="nombrePersona" id="nombrePersona" size="50" value="<%= idPersona %>" class="form-control">
                            <input type="hidden" name="idPersona" id="idPersona" value="<%= idPersona %>"> <!-- Campo oculto para almacenar solo el ID -->
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkTipoEnvio" <%= chkTipoEnvio %>> Tipo de Envío
                                </div>
                            </div>
                            <select name="tipoEnvio" <%= (chkTipoEnvio != null) ? "" : "disabled" %>> <!-- Habilitar solo si el checkbox está marcado -->
                                <option value="">Seleccione...</option>
                                <%= tipoEnvioOptions %> <!-- Cargar opciones dinámicamente -->
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkEstado" <%= chkEstado %>> Estado
                                </div>
                            </div>
                            <select name="estado">
                                <option value="">Seleccione...</option>
                                <option value="Entregado" <%= estado.equals("Entregado") ? "selected" : "" %>>Entregado</option>
                                <option value="Por entregar" <%= estado.equals("Por entregar") ? "selected" : "" %>>Por entregar</option>
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Buscar</button>
                    </div>
                </div>
            </form>
        </div>
                             <center>
            Página <%= pagina %> de <%= numeroDePaginas %>,
            mostrando registros del <%= registroInicial + 1 %> al <%= Math.min(registroFinal, totalRegistros) %> de un total de <%= totalRegistros %>
        </center>
        <div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Código Pedido</th>
                        <th>Código Venta</th>
                        <th>Fecha</th>
                        <th>Nombre Cliente</th>
                        <th>Tipo Envío</th>
                        <th>Estado</th>
                        <th>Valor Total</th>
                        <th>
                            <a href="principal.jsp?CONTENIDO=pedidosFormulario.jsp&accion=Adicionar" title="Adicionar">
                                <img src="presentacion/adicionar.png" class="icono" alt="Adicionar">
                            </a>
                            <img src="presentacion/excel.png" title="Generar reporte en excel" onclick="exportar('excel')" class="icono">
                            <img src="presentacion/word.png" title="Generar reporte en word" onclick='exportar("word")' class="icono">
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%= lista %>
                </tbody>
            </table>
        </div>

       

        <div style="text-align: center;">
            <img src="presentacion/primero.png" onclick="cambiarPagina('primero')"/>
            <img src="presentacion/anterior.png" onclick="cambiarPagina('anterior')"/>
            <input type="text" name="pagina" value="<%= pagina %>" size="2" onchange="cambiarPagina('especifico')"/>
            <img src="presentacion/siguiente.png" onclick="cambiarPagina('siguiente')"/>
            <img src="presentacion/ultimo.png" onclick="cambiarPagina('ultimo')"/>
        </div>
    </div>
</div>

<script>
    var personas = <%= listaPersonasJS.toString() %>;

    $("#nombrePersona").autocomplete({
        source: personas,
        select: function (event, ui) {
            $("#nombrePersona").val(ui.item.label);
            $("#idPersona").val(ui.item.value);
            return false;
        },
        minLength: 2
    });

    function cambiarPagina(pagina){
        paginaActual = parseInt(document.formulario.pagina.value);
        switch(pagina){
            case "primero": pagina = 1; break;
            case "anterior": pagina = paginaActual - 1; break;
            case "siguiente": pagina = paginaActual + 1; break;
            case "ultimo": pagina = <%= numeroDePaginas %>; break;
            case "especifico": pagina = paginaActual; break;
        }
        document.formulario.pagina.value = pagina;
        document.formulario.submit();
    }

    function eliminar(id) {
        var respuesta = confirm("¿Realmente desea eliminar este pedido con el Código " + id + "?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=pedidosActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }

    function verDetalles(id) {
        document.location = "principal.jsp?CONTENIDO=pedidosDetalles.jsp&id=" + id;
    }

    function Generarventas(id) {
        document.location = "principal.jsp?CONTENIDO=ventasFormularioP.jsp&accion=Adicionar&id=" + id;
    }

    function verPedido(id) {
        window.open("pedidosGenerarPDF.jsp?id=" + id);
    }

    function pagos(idVentaDetalle) {
        window.open("pagosVentas.jsp?idVenta=" + idVentaDetalle, "_blank"); // Abrir en una nueva ventana
    }

    function modificar(id) {
        document.location = "principal.jsp?CONTENIDO=pedidosFormulario.jsp&accion=Modificar&id=" + id;
    }

    function exportar(formato) {
        event.preventDefault();
        window.open("pedidosExportar.jsp?formato=" + formato + "&filtro=<%= filtro %>", "_blank");
    }
</script>

</body>
</html>
