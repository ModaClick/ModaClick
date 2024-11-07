<%@page import="java.sql.ResultSet"%>
<%@page import="clases.Persona"%>
<%@page import="clases.DevolucionVenta, clases.DevolucionVentaDetalles, clases.VentaDetalle" %>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%
    // Inicialización de la variable 'cliente' en caso de que no esté definida
    String cliente = request.getParameter("cliente");
    if (cliente == null) {
        cliente = "";
    }

    // Lógica para manejar la eliminación si se envían los parámetros id y acción
    String id = request.getParameter("id");
    String accion = request.getParameter("accion");

    if ("eliminar".equals(accion) && id != null) {
        try {
            int idDevolucion = Integer.parseInt(id);

            // Llamar al método para eliminar la devolución
            boolean resultado = DevolucionVenta.eliminarDevolucion(idDevolucion);

            // Redirigir a la página principal después de la eliminación
            if (resultado) {
                response.sendRedirect("DevolucionesVentas.jsp");
            } else {
                out.println("<p>Error al eliminar la devolución.</p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p>Error: el ID no es válido.</p>");
        }
    }

    // Inicialización de los parámetros de los filtros
    String filtro = "";

    // Filtro de fecha de venta (usando DATE() para ignorar la hora)
    String chkFechaVenta = request.getParameter("chkFechaVenta");
    String inicio = request.getParameter("inicio");
    String fin = request.getParameter("fin");

    // Aplicar el filtro por rango de fechas de venta (ignorando la hora)
    if (chkFechaVenta != null && inicio != null && !inicio.isEmpty() && fin != null && !fin.isEmpty()) {
        filtro += " AND d.fecha BETWEEN '" + inicio + "' AND '" + fin + "'";
    }

    // Filtro por número de venta
    String chkVenta = request.getParameter("chkVenta");
    String numeroVenta = request.getParameter("numeroVenta");
    if (chkVenta != null && !numeroVenta.isEmpty()) {
        filtro += " AND v.idVenta LIKE '%" + numeroVenta + "%'";
    }

    // Filtro por cliente (usando el campo oculto para la identificación del cliente)
    String chkCliente = request.getParameter("chkCliente");
    String clienteId = request.getParameter("clienteId"); // ID del cliente (oculto)
    if (chkCliente != null && clienteId != null && !clienteId.isEmpty()) {
        filtro += " AND p.identificacion = '" + clienteId + "'";  // Ajustar la columna correcta
    }

    // Paginación
    int elementosXPagina = 5;
    int pagina = 1;
    if (request.getParameter("pagina") != null) {
        pagina = Integer.parseInt(request.getParameter("pagina"));
    }
    int registroInicial = (pagina - 1) * elementosXPagina;

    // Obtener la lista de devoluciones con los filtros aplicados y paginación
    List<DevolucionVenta> devoluciones = DevolucionVenta.getDevolucionesVentaPaginadas(
            filtro, registroInicial, elementosXPagina
    );
    int totalRegistros = DevolucionVenta.getTotalDevoluciones(filtro);
    int numeroDePaginas = (totalRegistros > 0) ? (int) Math.ceil(totalRegistros / (double) elementosXPagina) : 1;
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>DEVOLUCIONES VENTA</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            /* Estilo de encabezado centrado */
            h2 {
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

            /* Estilos para el motor de búsqueda */
            .form-row {
                margin-bottom: 0px; /* Espacio entre filas */
            }

            /* Ajustar los márgenes entre los checkbox y el texto */
            .input-group-prepend {
                margin-right: 10px; /* Espacio adicional entre el checkbox y el texto */
            }

            button.btn {
                margin-left: 10px; /* Espacio a la izquierda del botón de búsqueda */
            }

            /* Estilo para el grupo de entrada */
            .input-group {
                margin-right: 15px; /* Espacio a la derecha del grupo */
            }

            /* Espacio entre el texto del input-group-text y el checkbox */
            .input-group-text {
                margin-right: 2px; /* Espacio a la derecha del input-group-text */
                min-width: 100px; /* Ancho mínimo para el input-group-text */
            }

            /* Ancho de los campos de entrada */
            .form-control {
                width: 200px; /* Ancho de los campos de texto */
                margin-left: 10px; /* Espacio a la izquierda del campo */
            }
        </style>
    </head>
 <body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
            <center><h2>DEVOLUCIONES VENTA</h2></center>
            <div class="table-container">
                <div class="form-container mb-3">
                    <form name="formulario" method="post">
                        <div class="form-row">
                            <div class="col">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="chkFechaVenta" <%= chkFechaVenta != null ? "checked" : ""%>> Fecha
                                        </div>
                                    </div>
                                    Desde <input type="date" name="inicio" value="<%= inicio != null ? inicio : ""%>" class="form-control"> 
                                    Hasta <input type="date" name="fin" value="<%= fin != null ? fin : ""%>" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="col">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="chkVenta" <%= chkVenta != null ? "checked" : ""%>> N° Venta
                                        </div>
                                    </div>
                                    <input type="text" name="numeroVenta" value="<%= numeroVenta != null ? numeroVenta : ""%>" class="form-control" placeholder="Número de venta">
                                </div>
                            </div>
                            <div class="col">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="chkCliente" <%= chkCliente != null ? "checked" : ""%>> Cliente
                                        </div>
                                    </div>
                                    <input type="text" name="cliente" id="cliente" value="<%= cliente%>" class="form-control" placeholder="Nombre del cliente">
                                    <input type="hidden" name="clienteId" id="clienteId" value="">
                                </div>
                            </div>
                            <div class="col">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Buscar</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
<div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead class="thead-dark">
                        <tr>
                            <th>Fecha</th>
                            <th>Número de venta</th>
                            <th>Cliente</th>
                            <th>Código</th>
                            <th>Valor Total Devolución</th>
                            <th>
                                <div class="add-compra-btn">
                                    <a href="principal.jsp?CONTENIDO=DevolucionesVentaFormulario.jsp" title="Adicionar">
                                        <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
                                    </a>
                                    <div class="export-btn">
                                        <a href="ExportarDevolucionesVentas.jsp?formato=pdf" title="Generar reporte en PDF">
                                            <img src="presentacion/pdf.png" width='30' height='30' title='pdf'>
                                        </a>
                                        <a href="ExportarDevolucionesVentas.jsp?formato=word" title="Generar reporte en Word">
                                            <img src="presentacion/word.png" width='30' height='30' title='Word'>
                                        </a>
                                    </div>
                                </div>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (DevolucionVenta devolucion : devoluciones) {
                                double valorTotalDevolucion = 0;
                                List<DevolucionVentaDetalles> detallesDevolucion = DevolucionVentaDetalles.getDetallesPorDevolucion(devolucion.getId());

                                for (DevolucionVentaDetalles detalle : detallesDevolucion) {
                                    VentaDetalle ventaDetalle = new VentaDetalle(String.valueOf(detalle.getIdVentaDetalle()));
                                    double valorUnitario = Double.parseDouble(ventaDetalle.getValorUnitVenta());
                                    int cantidadDevuelta = detalle.getCantidad();

                                    // Consultar los impuestos asociados al artículo
                                    String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                            + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                            + "WHERE ImpuestoInventario.idArticulo = '" + ventaDetalle.getIdArticuloInventario() + "'";
                                    ResultSet rsImpuestos = clasesGenericas.ConectorBD.consultar(consultaImpuestos);

                                    double totalImpuestos = 0.0;
                                    while (rsImpuestos != null && rsImpuestos.next()) {
                                        int porcentajeImpuesto = rsImpuestos.getInt("porcentaje");
                                        totalImpuestos += porcentajeImpuesto / 100.0;
                                    }
                                    if (rsImpuestos != null) {
                                        rsImpuestos.close();
                                    }

                                    // Cálculo del valor devuelto con impuestos
                                    double valorDevuelto = cantidadDevuelta * valorUnitario;
                                    double totalConImpuesto = valorDevuelto + (valorDevuelto * totalImpuestos);

                                    valorTotalDevolucion += totalConImpuesto;
                                }
                        %>
                        <tr>
                            <td><%= devolucion.getFecha()%></td>
                            <td><%= devolucion.getVenta().getIdVenta()%></td>
                            <td><%= devolucion.getVenta().getNombresCliente()%></td>
                            <td><%= devolucion.getId()%></td>
                            <td>$<%= String.format("%.2f", valorTotalDevolucion)%></td>
                            <td>
                                <a href="DevolucionesVentasDetalles.jsp?id=<%= devolucion.getId()%>">
                                    <img src="presentacion/detalle.png" width='30' height='30' title='Detalle'>
                                </a>
                                <a href="javascript:confirmarEliminacion(<%= devolucion.getId()%>)">
                                    <img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'>
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="pagination-container">
                <%
                    String baseUrl = "principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp";
                    boolean primeraPagina = (pagina == 1);
                    boolean ultimaPagina = (pagina == numeroDePaginas);
                %>
                <a href="<%= baseUrl%>&pagina=1"><img src="presentacion/primero.png" class="<%= primeraPagina ? "disabled" : ""%>"></a>
                <a href="<%= baseUrl%>&pagina=<%= (pagina - 1)%>"><img src="presentacion/anterior.png" class="<%= primeraPagina ? "disabled" : ""%>"></a>
                <input type="text" name="pagina" value="<%=pagina%>" size="2" onchange="cambiarPagina('especifico')">
                <a href="<%= baseUrl%>&pagina=<%= (pagina + 1)%>"><img src="presentacion/siguiente.png" class="<%= ultimaPagina ? "disabled" : ""%>"></a>
                <a href="<%= baseUrl%>&pagina=<%= numeroDePaginas%>"><img src="presentacion/ultimo.png" class="<%= ultimaPagina ? "disabled" : ""%>"></a>
            </div>
        </div>

        <script>
            var clientes = <%= Persona.getListaEnArregloJs("tipo='C'", null)%>;

            $("#cliente").autocomplete({
                source: clientes,
                select: function (event, ui) {
                    var valorSeleccionado = ui.item.value;
                    var partes = valorSeleccionado.split(" - "); // separar la identificación del nombre
                    $("#clienteId").val(partes[0]); // asignar la identificación al campo oculto
                    $("#cliente").val(partes[1]); // mostrar solo el nombre en el campo de texto
                    return false; // evitar que jQuery UI autocomplete reemplace el valor manualmente
                }
            });

            function cambiarPagina(pagina) {
                paginaActual = parseInt(document.formulario.pagina.value);
                switch (pagina) {
                    case "primero":
                        pagina = 1;
                        break;
                    case "anterior":
                        pagina = paginaActual - 1;
                        break;
                    case "especifico":
                        pagina = paginaActual;
                        break;
                    case "siguiente":
                        pagina = paginaActual + 1;
                        break;
                    case "ultimo":
                        pagina = <%=numeroDePaginas%>;
                        break;
                }
                document.formulario.pagina.value = pagina;
                document.formulario.submit();
            }

            function confirmarEliminacion(id) {
                if (confirm("¿Está seguro que desea eliminar esta devolución?")) {
                    // Redirigir al mismo JSP con el ID de la devolución para eliminarla
                    window.location.href = "principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp?id=" + id + "&accion=eliminar";
                }
            }

        </script>
    </body>
</html>
