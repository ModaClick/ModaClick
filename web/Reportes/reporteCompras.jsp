<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page import="clases.CompraDetalle"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Configuración para exportar a Excel o Word
    if (request.getParameter("formato") != null) {
        String tipoDeContenido = "";
        String extensionArchivo = "";
        switch (request.getParameter("formato")) {
            case "excel":
                tipoDeContenido = "application/vnd.ms-excel";
                extensionArchivo = ".xls";
                break;
            case "word":
                tipoDeContenido = "application/vnd.msword";
                extensionArchivo = ".doc";
                break;
        }
        response.setContentType(tipoDeContenido);
        response.setHeader("Content-Disposition", "inline; filename=\"reporteCompras" + extensionArchivo + "\"");
    }

    // Filtros por fecha de compra y otros
    String filtro = "";
    String chkFecha = request.getParameter("chkFecha");
    String fechaInicio = "";
    String fechaFin = "";

    if (chkFecha != null) {
        chkFecha = "checked";
        fechaInicio = request.getParameter("fechaInicio");
        fechaFin = request.getParameter("fechaFin");
        filtro = "(DATE(c.fechaCompra) between '" + fechaInicio + "' AND '" + fechaFin + "')";
    }

    String chkNombreArticulo = request.getParameter("chkNombreArticulo");
    String nombreArticulo = "";
    if (chkNombreArticulo != null) {
        chkNombreArticulo = "checked";
        nombreArticulo = request.getParameter("nombreArticulo");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "nombreArticulo like '%" + nombreArticulo + "%'";
    }

    String chkIdCategoria = request.getParameter("chkIdCategoria");
    String idCategoria = "";
    if (chkIdCategoria != null) {
        chkIdCategoria = "checked";
        idCategoria = request.getParameter("idCategoria");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "idCategoria=" + idCategoria;
    }

    // Obtener la lista de compras con el filtro aplicado
    List<Compra> listaCompras = Compra.getListaEnObjetos(filtro, null);

    // Construir la tabla de resultados
    String lista = "";
    int valorTotal = 0;

    for (Compra compra : listaCompras) {
        List<CompraDetalle> detalles = compra.getDetalles();

        for (CompraDetalle detalle : detalles) {
            Inventario inventario = new Inventario(detalle.getIdArticuloInventario());
            Categoria categoria = new Categoria(inventario.getIdCategoria());

            // Calcular el subtotal
            int subtotal = detalle.getSubTotal();
            valorTotal += subtotal;

            // Agregar fila a la tabla
            lista += "<tr>";
            lista += "<td>" + compra.getFechaCompra() + "</td>"; // Fecha de la compra
            lista += "<td>" + inventario.getNombreArticulo() + "</td>";
            lista += "<td>" + categoria.getNombre() + "</td>";
            lista += "<td align='right'>" + detalle.getCantidad() + "</td>";
            lista += "<td align='right'>" + detalle.getCostoUnitCompra() + "</td>"; // Obtener el costo unitario
            lista += "<td>" + inventario.getDescripcion() + "</td>";
            lista += "<td align='right'>" + subtotal + "</td>";
            lista += "</tr>";
        }
    }
%>

<h3>Reporte de Compras</h3>

<!-- Formulario de búsqueda de compras por fecha y otros filtros -->
<form method="post">
    <table>
        <tr>
            <td><input type="checkbox" name="chkFecha" <%=chkFecha%>> Fecha de Compra</td>
            <td>
                Desde <input type="date" name="fechaInicio" value="<%=fechaInicio%>">
                Hasta <input type="date" name="fechaFin" value="<%=fechaFin%>">
            </td>
        </tr>
        <tr>
            <td><input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo</td>
            <td><input type="text" name="nombreArticulo" value="<%=nombreArticulo%>"></td>
        </tr>
        <tr>
            <td><input type="checkbox" name="chkIdCategoria" <%=chkIdCategoria%>> Categoría</td>
            <td><select name="idCategoria"><%=Categoria.getListaEnOptions(idCategoria)%></select></td>
        </tr>
    </table>
    <p>
        <input type="submit" name="buscar" value="Buscar">
    </p>
</form>

<!-- Opciones de exportación -->
<p>
    <a href="Reportes/reporteCompras.jsp?formato=excel" target="_blank"><img src="presentacion/excel.png" width="50" height="50"></a>
    <a href="Reportes/reporteCompras.jsp?formato=word" target="_blank"><img src="presentacion/word.png" width="50" height="50"></a>
</p>

<!-- Tabla del reporte de compras -->
<table border="1">
    <tr>
        <th>Fecha de Compra</th>
        <th>Artículo</th>
        <th>Categoría</th>
        <th>Cantidad</th>
        <th>Valor Unitario (Compra)</th>
        <th>Descripción</th>
        <th>Subtotal</th>
    </tr>
    <%=lista%>
    <tr>
        <th colspan="6">Valor Total</th>
        <th align="right"><%=valorTotal%></th>
    </tr>
</table>
