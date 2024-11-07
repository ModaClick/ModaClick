<%@page import="java.sql.ResultSet"%>
<%@page import="clasesGenericas.ConectorBD"%>
<%@page import="clases.Persona"%>
<%@page import="clases.DevolucionCompra, clases.DevolucionDetallesCompra, clases.CompraDetalle" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List" %>

<!DOCTYPE html>
<%
    // Inicialización de la variable 'proveedor' en caso de que no esté definida
    String proveedor = request.getParameter("proveedor");
    if (proveedor == null) {
        proveedor = "";
    }

    // Lógica para manejar la eliminación si se envían los parámetros id y acción
    String id = request.getParameter("id");
    String accion = request.getParameter("accion");

    if ("eliminar".equals(accion) && id != null) {
        try {
            int idDevolucion = Integer.parseInt(id);
            boolean resultado = DevolucionCompra.eliminarDevolucion(idDevolucion);
            if (resultado) {
                response.sendRedirect("DevolucionesCompras.jsp");
            } else {
                out.println("<p>Error al eliminar la devolución.</p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p>Error: el ID no es válido.</p>");
        }
    }

    // Inicialización de los parámetros de los filtros
    String filtro = "";

    // Filtro de fecha de compra
    String chkFechaCompra = request.getParameter("chkFechaCompra");
    String inicio = request.getParameter("inicio");
    String fin = request.getParameter("fin");

    if (chkFechaCompra != null && inicio != null && !inicio.isEmpty() && fin != null && !fin.isEmpty()) {
        filtro += " AND d.fecha BETWEEN '" + inicio + "' AND '" + fin + "'";
    }

    // Filtro por número de compra
    String chkCompra = request.getParameter("chkCompra");
    String numeroCompra = request.getParameter("numeroCompra");
    if (chkCompra != null && numeroCompra != null && !numeroCompra.isEmpty()) {
        filtro += " AND c.idCompra LIKE '%" + numeroCompra + "%'";
    }

    // Filtro por proveedor
    String chkProveedor = request.getParameter("chkProveedor");
    String proveedorId = request.getParameter("proveedorId"); // ID del proveedor (oculto)
    if (chkProveedor != null && proveedorId != null && !proveedorId.isEmpty()) {
        filtro += " AND p.identificacion = '" + proveedorId + "'";
    }

    // Paginación
    int elementosXPagina = 5;
    int pagina = 1;
    if (request.getParameter("pagina") != null) {
        pagina = Integer.parseInt(request.getParameter("pagina"));
    }
    int registroInicial = (pagina - 1) * elementosXPagina;

    // Obtener la lista de devoluciones con los filtros aplicados y paginación
    List<DevolucionCompra> devoluciones = DevolucionCompra.getDevolucionesCompraPaginadas(filtro, registroInicial, elementosXPagina);
    int totalRegistros = DevolucionCompra.getTotalDevoluciones(filtro);
    int numeroDePaginas = (totalRegistros > 0) ? (int) Math.ceil(totalRegistros / (double) elementosXPagina) : 1;
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Devoluciones Compra</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            h2 {
                text-align: center;
                color: #333;
                margin: 0;
                padding: 15px 0;
                font-size: 24px;
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
            .input-group-prepend {
                margin-right: 10px;
            }
            button.btn {
                margin-left: 10px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <div class="table-container">
                <center><h2>DEVOLUCIONES COMPRA</h2></center>
                <div class="form-container mb-3">
                    <form name="formulario" method="post">
                        <div class="form-row">
                            <div class="col">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="chkFechaCompra" <%= chkFechaCompra != null ? "checked" : ""%>> Fecha
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
                                            <input type="checkbox" name="chkCompra" <%= chkCompra != null ? "checked" : ""%>> N° Compra
                                        </div>
                                    </div>
                                    <input type="text" name="numeroCompra" value="<%= numeroCompra != null ? numeroCompra : ""%>" class="form-control" placeholder="Número de compra">
                                </div>
                            </div>
                            <div class="col">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="chkProveedor" <%= chkProveedor != null ? "checked" : ""%>> Proveedor
                                        </div>
                                    </div>
                                    <input type="text" name="proveedor" id="proveedor" value="<%= proveedor %>" class="form-control" placeholder="Proveedor">
                                    <input type="hidden" name="proveedorId" id="proveedorId" value="">
                                </div>
                            </div>
                            <div class="col">
                                <button type="submit" class="btn btn-primary">Buscar</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th>Fecha</th>
                                <th>Número de compra</th>
                                <th>Proveedor</th>
                                <th>Código</th>
                                <th>Valor Total Devolución</th>
                                <th>
                                    <div class="add-compra-btn">
                                        <a href="principal.jsp?CONTENIDO=DevolucionesCompraFormulario.jsp" title="Adicionar">
                                            <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
                                        </a>
                                        <div class="export-btn">
                                            <a href="ExportarDevoluciones.jsp?formato=pdf" title="Generar reporte en PDF">
                                                <img src="presentacion/pdf.png" width='30' height='30' title='pdf'>
                                            </a>
                                            <a href="ExportarDevoluciones.jsp?formato=word" title="Generar reporte en Word">
                                                <img src="presentacion/word.png" width='30' height='30' title='Word'>
                                            </a>
                                        </div>
                                    </div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (DevolucionCompra devolucion : devoluciones) {
                                    double valorTotalDevolucion = 0;
                                    List<DevolucionDetallesCompra> detallesDevolucion = DevolucionDetallesCompra.getDetallesPorDevolucion(devolucion.getId());

                                    for (DevolucionDetallesCompra detalle : detallesDevolucion) {
                                        CompraDetalle compraDetalle = new CompraDetalle(String.valueOf(detalle.getIdCompraDetalle()));
                                        double valorUnitario = Double.parseDouble(compraDetalle.getCostoUnitCompra());
                                        int cantidadDevuelta = detalle.getCantidad();

                                        String sqlImpuestos = "SELECT porcentaje FROM Impuesto "
                                                + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                                + "WHERE ImpuestoInventario.idArticulo = " + compraDetalle.getIdArticuloInventario();

                                        ResultSet rsImpuestos = ConectorBD.consultar(sqlImpuestos);
                                        double porcentajeTotalImpuesto = 0;

                                        while (rsImpuestos.next()) {
                                            int porcentajeImpuesto = rsImpuestos.getInt("porcentaje");
                                            porcentajeTotalImpuesto += porcentajeImpuesto / 100.0;
                                        }

                                        double valorDevuelto = cantidadDevuelta * valorUnitario;
                                        double totalConImpuesto = valorDevuelto + (valorDevuelto * porcentajeTotalImpuesto);
                                        valorTotalDevolucion += totalConImpuesto;
                                    }
                            %>
                            <tr>
                                <td><%= devolucion.getFecha() %></td>
                                <td><%= devolucion.getCompra().getIdCompra() %></td>
                                <td><%= devolucion.getCompra().getNombresProveedor() %></td>
                                <td><%= devolucion.getId() %></td>
                                <td>$<%= String.format("%.2f", valorTotalDevolucion) %></td>
                                <td>
                                    <a href="DevolucionesComprasDetalles.jsp?id=<%= devolucion.getId() %>">
                                        <img src="presentacion/detalle.png" width='30' height='30' title='Detalle'>
                                    </a>
                                    <a href="javascript:confirmarEliminacion(<%= devolucion.getId() %>)">
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
                        String baseUrl = "principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp";
                        boolean primeraPagina = (pagina == 1);
                        boolean ultimaPagina = (pagina == numeroDePaginas);
                    %>
                    <a href="<%= baseUrl %>&pagina=1"><img src="presentacion/primero.png" class="<%= primeraPagina ? "disabled" : "" %>"></a>
                    <a href="<%= baseUrl %>&pagina=<%= (pagina - 1) %>"><img src="presentacion/anterior.png" class="<%= primeraPagina ? "disabled" : "" %>"></a>
                    <input type="text" name="pagina" value="<%= pagina %>" size="2" onchange="cambiarPagina('especifico')">
                    <a href="<%= baseUrl %>&pagina=<%= (pagina + 1) %>"><img src="presentacion/siguiente.png" class="<%= ultimaPagina ? "disabled" : "" %>"></a>
                    <a href="<%= baseUrl %>&pagina=<%= numeroDePaginas %>"><img src="presentacion/ultimo.png" class="<%= ultimaPagina ? "disabled" : "" %>"></a>
                </div>
            </div>
        </div>

        <script>
            var proveedores = <%= Persona.getListaEnArregloJs("tipo='P'", null) %>;

            $("#proveedor").autocomplete({
                source: proveedores,
                select: function(event, ui) {
                    var valorSeleccionado = ui.item.value;
                    var partes = valorSeleccionado.split(" - "); 
                    $("#proveedorId").val(partes[0]);
                    $("#proveedor").val(partes[1]);
                    return false; 
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
                        pagina = <%= numeroDePaginas %>;
                        break;
                }
                document.formulario.pagina.value = pagina;
                document.formulario.submit();
            }

            function confirmarEliminacion(id) {
                if (confirm("¿Está seguro que desea eliminar esta devolución?")) {
                    window.location.href = "principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp?id=" + id + "&accion=eliminar";
                }
            }
        </script>
    </body>
</html>
