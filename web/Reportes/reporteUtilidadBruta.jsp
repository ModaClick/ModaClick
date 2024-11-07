<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<%@page import="clases.VentaDetalle"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Reporte Utilidad Bruta por Ventas</title>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <script type="text/javascript">
        // Obtenemos el arreglo de artículos desde el backend
        var articulos = <%=Inventario.getListaCompletaEnArregloJS(null, null)%>;

        // Activamos el autocompletado en el campo de búsqueda de nombre de artículo
        $(function() {
            $("#nombreArticulo").autocomplete({
                source: articulos.map(function(item) {
                    return item[1]; // Usamos el nombre del artículo para el autocompletado
                }),
                select: function(event, ui) {
                    // Buscamos el artículo seleccionado por su nombre
                    var articuloSeleccionado = articulos.find(function(item) {
                        return item[1] === ui.item.value;
                    });
                    console.log("Artículo seleccionado:", articuloSeleccionado);
                }
            });
        });
    </script>
</head>
<body class="bg-light">

<%
    // Filtros por rango de meses de venta y otros
    String filtro = "";
    String chkMes = request.getParameter("chkMes");
    String mesDesde = "";
    String mesHasta = "";

    if (chkMes != null) {
        chkMes = "checked";
        mesDesde = request.getParameter("mesDesde");
        mesHasta = request.getParameter("mesHasta");
        filtro = "MONTH(fechaVenta) BETWEEN '" + mesDesde + "' AND '" + mesHasta + "'"; // Filtrar solo por mes
    } else {
        chkMes = "";
    }

    String chkNombreArticulo = request.getParameter("chkNombreArticulo");
    String nombreArticulo = "";
    if (chkNombreArticulo != null) {
        chkNombreArticulo = "checked";
        nombreArticulo = request.getParameter("nombreArticulo");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "nombreArticulo LIKE '%" + nombreArticulo + "%'";
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
    
        if (request.getParameter("formato") != null) {
        String tipoDeContenido = "";
        String extensionArchivo = "";
        switch (request.getParameter("formato")) {
            case "excel":
                tipoDeContenido = "application/vnd.ms-excel";
                extensionArchivo = ".xls";
                break;

            case "word":
                tipoDeContenido = "aplication/vnd.msword";
                extensionArchivo = ".doc";
                break;
        }
        response.setContentType(tipoDeContenido);
        response.setHeader("Content-Disposition", "inline; filename=\"reporteUtilidadBruta." + extensionArchivo + "\"");
    }

    // Obtener la lista de ventas con el filtro aplicado
    List<Venta> listaVentas = Venta.getListaEnObjetos(filtro, null);

    // Construir la tabla de resultados
    String lista = "";
    int totalUtilidadBruta = 0;
    int totalSubtotalVentas = 0;
    int totalCostoMercanciaVendida = 0; // Nueva variable para total de costo de mercancía vendida

    for (Venta venta : listaVentas) {
        List<VentaDetalle> detalles = venta.getDetalles();

        for (VentaDetalle detalle : detalles) {
            Inventario inventario = new Inventario(detalle.getIdArticuloInventario());
            Categoria categoria = new Categoria(inventario.getIdCategoria());

            // Valores correctos para el cálculo convertidos a int
            int cantidadVendida = Integer.parseInt(detalle.getCantidad());
            int valorUnitarioVenta = Integer.parseInt(inventario.getValorUnitVenta());
            int costoUnitarioCompra = Integer.parseInt(inventario.getCostoUnitCompra()); // Obtener el costo de adquisición

            // Cálculo del costo de mercancía vendida
            int costoMercanciaVendida = costoUnitarioCompra * cantidadVendida;

            // Cálculo del subtotal (ingresos por ventas)
            int subtotal = valorUnitarioVenta * cantidadVendida;

            // Cálculo de la utilidad bruta
            int utilidadBruta = subtotal - costoMercanciaVendida;

            // Sumar a los totales
            totalUtilidadBruta += utilidadBruta;
            totalSubtotalVentas += subtotal;
            totalCostoMercanciaVendida += costoMercanciaVendida;

            // Agregar a la lista
            lista += "<tr>";
            lista += "<td>" + venta.getFechaVenta().substring(5, 7) + "</td>"; // Mostrar solo el mes de la venta
            lista += "<td>" + inventario.getNombreArticulo() + "</td>";
            lista += "<td>" + categoria.getNombre() + "</td>";
            lista += "<td align='right'>" + costoMercanciaVendida + "</td>";
            lista += "<td align='right'>" + utilidadBruta + "</td>";
            lista += "<td align='right'>" + cantidadVendida + "</td>";
            lista += "<td align='right'>" + subtotal + "</td>";
            lista += "</tr>";
        }
    }
%>

<div class="table-container">
    <h2>REPORTE UTILIDAD BRUTA POR VENTAS</h2>

    <!-- Formulario de búsqueda de ventas por rango de meses y otros filtros -->
    <form method="post">
        <div class="form-row">
            <div class="col">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <input type="checkbox" name="chkMes" <%=chkMes%>> Mes
                        </div>
                    </div>
                    Desde 
                    <select name="mesDesde" class="form-control">
                        <option value="01" <%=mesDesde.equals("01") ? "selected" : ""%>>01-Enero</option>
                        <option value="02" <%=mesDesde.equals("02") ? "selected" : ""%>>02-Febrero</option>
                        <option value="03" <%=mesDesde.equals("03") ? "selected" : ""%>>03-Marzo</option>
                        <option value="04" <%=mesDesde.equals("04") ? "selected" : ""%>>04-Abril</option>
                        <option value="05" <%=mesDesde.equals("05") ? "selected" : ""%>>05-Mayo</option>
                        <option value="06" <%=mesDesde.equals("06") ? "selected" : ""%>>06-Junio</option>
                        <option value="07" <%=mesDesde.equals("07") ? "selected" : ""%>>07-Julio</option>
                        <option value="08" <%=mesDesde.equals("08") ? "selected" : ""%>>08-Agosto</option>
                        <option value="09" <%=mesDesde.equals("09") ? "selected" : ""%>>09-Septiembre</option>
                        <option value="10" <%=mesDesde.equals("10") ? "selected" : ""%>>10-Octubre</option>
                        <option value="11" <%=mesDesde.equals("11") ? "selected" : ""%>>11-Noviembre</option>
                        <option value="12" <%=mesDesde.equals("12") ? "selected" : ""%>>12-Diciembre</option>
                    </select>

                    Hasta 
                    <select name="mesHasta" class="form-control">
                        <option value="01" <%=mesHasta.equals("01") ? "selected" : ""%>>01-Enero</option>
                        <option value="02" <%=mesHasta.equals("02") ? "selected" : ""%>>02-Febrero</option>
                        <option value="03" <%=mesHasta.equals("03") ? "selected" : ""%>>03-Marzo</option>
                        <option value="04" <%=mesHasta.equals("04") ? "selected" : ""%>>04-Abril</option>
                        <option value="05" <%=mesHasta.equals("05") ? "selected" : ""%>>05-Mayo</option>
                        <option value="06" <%=mesHasta.equals("06") ? "selected" : ""%>>06-Junio</option>
                        <option value="07" <%=mesHasta.equals("07") ? "selected" : ""%>>07-Julio</option>
                        <option value="08" <%=mesHasta.equals("08") ? "selected" : ""%>>08-Agosto</option>
                        <option value="09" <%=mesHasta.equals("09") ? "selected" : ""%>>09-Septiembre</option>
                        <option value="10" <%=mesHasta.equals("10") ? "selected" : ""%>>10-Octubre</option>
                        <option value="11" <%=mesHasta.equals("11") ? "selected" : ""%>>11-Noviembre</option>
                        <option value="12" <%=mesHasta.equals("12") ? "selected" : ""%>>12-Diciembre</option>
                    </select>
                </div>
            </div>
            <div class="col">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Artículo
                        </div>
                    </div>
                    <input type="text" id="nombreArticulo" name="nombreArticulo" value="<%=nombreArticulo%>" class="form-control" placeholder="Nombre del artículo">
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
        <p>
            <input type="submit" name="buscar" value="Buscar" class="btn btn-primary">
        </p>
    </form>

    <!-- Opciones de exportación -->
    <p>
        <a href="Reportes/reporteUtilidadBruta.jsp?formato=excel" target="_blank"><img src="presentacion/excel.png" width="50" height="50"></a>
        <a href="Reportes/reporteUtilidadBruta.jsp?formato=word" target="_blank"><img src="presentacion/word.png" width="50" height="50"></a>
    </p>

    <!-- Tabla del reporte de utilidad bruta por ventas -->
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Mes</th>
                <th>Artículo</th>
                <th>Categoría Artículo</th>
                <th>Costo de Mercancía Vendida</th>
                <th>Utilidad Bruta</th>
                <th>Cantidad Vendida</th>
                <th>Subtotal Ventas</th>
            </tr>
        </thead>
        <tbody>
            <%=lista%>
            <tr>
                <th colspan="3">Total</th>
                <td align="right"><%=totalCostoMercanciaVendida%></td>
                <td align="right"><%=totalUtilidadBruta%></td>
                <td align="right"></td>
                <td align="right"><%=totalSubtotalVentas%></td>
            </tr>
        </tbody>
    </table>
</div>

</body>
</html>
