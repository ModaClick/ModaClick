<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<%@page import="clases.VentaDetalle"%>
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
        response.setHeader("Content-Disposition", "inline; filename=\"reporteVentas" + extensionArchivo + "\"");
    }

    // Filtros para la búsqueda
    String filtro = "";
    String chkFecha = request.getParameter("chkFecha");
    String fechaInicio = "";
    String fechaFin = "";

    if (chkFecha != null) {
<<<<<<< HEAD
        chkFecha = "checked";
        fechaInicio = request.getParameter("fechaInicio");
        fechaFin = request.getParameter("fechaFin");
        filtro = "(DATE(v.fechaVenta) between '" + fechaInicio + "' AND '" + fechaFin + "')";
    }
=======
    chkFecha = "checked";
    fechaInicio = request.getParameter("fechaInicio");
    fechaFin = request.getParameter("fechaFin");
        filtro = "(DATE(v.fechaVenta) between '" + fechaInicio + "' AND '" + fechaFin + "')";
}

>>>>>>> 7107026975515d79007e051943af17425710c6d8

    String chkNombreArticulo = request.getParameter("chkNombreArticulo");
    String nombreArticulo = "";
    if (chkNombreArticulo != null) {
        chkNombreArticulo = "checked";
        nombreArticulo = request.getParameter("nombreArticulo");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "nombreArticulo like '%" + nombreArticulo + "%'";
    } else {
        chkNombreArticulo = "";
    }

    String chkIdCategoria = request.getParameter("chkIdCategoria");
    String idCategoria = "";
    if (chkIdCategoria != null) {
        chkIdCategoria = "checked";
        idCategoria = request.getParameter("idCategoria");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "idCategoria=" + idCategoria;
    } else {
        chkIdCategoria = "";
    }

    // Obtener la lista de ventas con el filtro aplicado
    List<Venta> listaVentas = Venta.getListaEnObjetos(filtro, null);

    // Construir la tabla de resultados
    String lista = "";
    int valorTotal = 0;

    for (Venta venta : listaVentas) {
        List<VentaDetalle> detalles = venta.getDetalles();

        for (VentaDetalle detalle : detalles) {
            Inventario inventario = new Inventario(detalle.getIdArticuloInventario());
            Categoria categoria = new Categoria(inventario.getIdCategoria());
<<<<<<< HEAD

            int subtotal = Integer.parseInt(detalle.getCantidad()) * Integer.parseInt(detalle.getValorUnitVenta());
            valorTotal += subtotal;

=======
            
            int subtotal = Integer.parseInt(detalle.getCantidad()) * Integer.parseInt(detalle.getValorUnitVenta());
            valorTotal += subtotal;
            
>>>>>>> 7107026975515d79007e051943af17425710c6d8
            lista += "<tr>";
            lista += "<td>" + venta.getFechaVenta() + "</td>"; // Fecha de la venta
            lista += "<td>" + inventario.getNombreArticulo() + "</td>";
            lista += "<td>" + categoria.getNombre() + "</td>";
            lista += "<td align='right'>" + detalle.getCantidad() + "</td>";
<<<<<<< HEAD
            lista += "<td align='right'>" + detalle.getValorUnitVenta() + "</td>"; // Costo unitario de la venta
=======
            lista += "<td align='right'>" + detalle.getValorUnitVenta()+ "</td>"; // Costo unitario de la venta
>>>>>>> 7107026975515d79007e051943af17425710c6d8
            lista += "<td>" + inventario.getDescripcion() + "</td>";
            lista += "<td align='right'>" + subtotal + "</td>";
            lista += "</tr>";
        }
    }
%>

<<<<<<< HEAD
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Ventas</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Estilo de encabezado centrado */
        .table-container h2 {
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
    </style>
</head>
<body class="bg-light">

<div class="container-fluid">
    <div class="table-container">
        <h2>REPORTE DE VENTAS</h2>

        <!-- Formulario de búsqueda de ventas por fecha y otros filtros -->
        <form method="post">
            <div class="form-row">
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkFecha" <%=chkFecha%>> Fecha de Venta
                            </div>
                        </div>
                        Desde <input type="date" name="fechaInicio" value="<%=fechaInicio%>" class="form-control">
                        Hasta <input type="date" name="fechaFin" value="<%=fechaFin%>" class="form-control">
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo
                            </div>
                        </div>
                        <input type="text" name="nombreArticulo" value="<%=nombreArticulo%>" class="form-control">
                    </div>
                </div>
                <div class="col">
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" name="chkIdCategoria" <%=chkIdCategoria%>> Categoría
                            </div>
                        </div>
                        <select name="idCategoria" class="form-control"><%=Categoria.getListaEnOptions(idCategoria)%></select>
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="col">
                    <input type="submit" name="buscar" value="Buscar" class="btn btn-primary">
                </div>
            </div>
        </form>

        <!-- Opciones de exportación -->
        <p>
            <a href="Reportes/reporteVentas.jsp?formato=excel" target="_blank"><img src="presentacion/excel.png" width="50" height="50"></a>
            <a href="Reportes/reporteVentas.jsp?formato=word" target="_blank"><img src="presentacion/word.png" width="50" height="50"></a>
        </p>

        <!-- Tabla del reporte de ventas -->
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>Fecha de Venta</th>
                    <th>Artículo</th>
                    <th>Categoría</th>
                    <th>Cantidad</th>
                    <th>Valor Unitario (Venta)</th>
                    <th>Descripción</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <%=lista%>
                <tr>
                    <th colspan="6">Valor Total</th>
                    <th align="right"><%=valorTotal%></th>
                </tr>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
=======
<h3>Reporte de Ventas</h3>

<!-- Formulario de búsqueda de ventas por fecha y otros filtros -->
<form method="post">
    <table>
         <tr>
                <td><input type="checkbox" name="chkFecha" <%=chkFecha%>> Fecha de Pedido</td>
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
    <a href="Reportes/reporteVentas.jsp?formato=excel" target="_blank"><img src="presentacion/excel.png" width="50" height="50"></a>
    <a href="Reportes/reporteVentas.jsp?formato=word" target="_blank"><img src="presentacion/word.png" width="50" height="50"></a>
</p>

<!-- Tabla del reporte de ventas -->
<table border="1">
    <tr>
        <th>Fecha de Venta</th>
        <th>Artículo</th>
        <th>Categoría</th>
        <th>Cantidad</th>
        <th>Valor Unitario (Venta)</th>
        <th>Descripción</th>
        <th>Subtotal</th>
    </tr>
    <%=lista%>
    <tr>
        <th colspan="6">Valor Total</th>
        <th align="right"><%=valorTotal%></th>
    </tr>
</table>
>>>>>>> 7107026975515d79007e051943af17425710c6d8
