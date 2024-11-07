<%@page import="clases.Impuesto"%>
<%@page import="clases.Inventario"%>
<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Inventario</title>
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
        

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }
    </style>
</head>
<body class="bg-light">

<%
      // Variables de filtro y checkbox
    String filtro = "";
    String chkId = request.getParameter("chkId");
    String idInicio = "";
    String idFin = "";
    if (chkId != null) {
        chkId = "checked";
        idInicio = request.getParameter("idInicio");
        idFin = request.getParameter("idFin");
        filtro = "(i.idArticulo between " + idInicio + " and " + idFin + ")";
    } else {
        chkId = "";
    }

    String chkNombreArticulo = request.getParameter("chkNombreArticulo");
    String nombreArticulo = "";
    if (chkNombreArticulo != null) {
        chkNombreArticulo = "checked";
        nombreArticulo = request.getParameter("nombreArticulo");
        if (!filtro.equals("")) filtro += " and ";
        filtro += "nombreArticulo like '%" + nombreArticulo + "%'";
    } else {
        chkNombreArticulo = "";
    }

    String chkIdCategoria = request.getParameter("chkIdCategoria");
    String idCategoria = "";
    if (chkIdCategoria != null) {
        chkIdCategoria = "checked";
        idCategoria = request.getParameter("idCategoria");
        if (!filtro.equals("")) filtro += " and ";
        filtro += "idCategoria=" + idCategoria;
    } else {
        chkIdCategoria = "";
    }

    String chkTalla = request.getParameter("chkTalla");
    String talla = "";
    if (chkTalla != null) {
        chkTalla = "checked";
        talla = request.getParameter("talla");
        if (!filtro.equals("")) filtro += " and ";
        filtro += "talla='" + talla + "'";
    } else {
        chkTalla = "";
    }

    // Lista de inventario que cumple con el filtro
    String lista = "";
    List<Inventario> datos = Inventario.getListaEnObjetos(filtro, null);
    int totalStock = 0;
    int totalStockMinimo = 0;
    int totalStockMaximo = 0;

    for (Inventario inventario : datos) {
        Categoria categoria = new Categoria(inventario.getIdCategoria());
        // Obtener los impuestos relacionados con el artículo
        List<Impuesto> impuestos = inventario.obtenerImpuestos();
        
        // Sumar stock para totales
        totalStock += Integer.parseInt(inventario.getStock());
        totalStockMinimo += Integer.parseInt(inventario.getStockMinimo());
        totalStockMaximo += Integer.parseInt(inventario.getStockMaximo());

        lista += "<tr>";
        lista += "<td align='right'>" + inventario.getIdArticulo() + "</td>";
        lista += "<td>" + inventario.getNombreArticulo() + "</td>";
        lista += "<td>" + inventario.getDescripcion() + "</td>";
        lista += "<td>" + inventario.getCostoUnitCompra() + "</td>";
        lista += "<td>" + inventario.getValorUnitVenta() + "</td>";
        lista += "<td>" + inventario.getStock() + "</td>";
        lista += "<td>" + inventario.getStockMinimo() + "</td>";
        lista += "<td>" + inventario.getStockMaximo() + "</td>";
        lista += "<td>" + inventario.getColorArticulo() + "</td>";
        lista += "<td>" + inventario.getTipoTela() + "</td>";
        lista += "<td>" + categoria.getNombre() + "</td>";
        lista += "<td>" + inventario.getTalla() + "</td>";

        // Aquí mostramos los impuestos del artículo
        lista += "<td>";
        if (impuestos != null && !impuestos.isEmpty()) {
            for (Impuesto impuesto : impuestos) {
                lista += impuesto.getNombre() + " (" + impuesto.getPorcentaje() + "%)<br>";
            }
        } else {
            lista += "Sin impuestos";
        }
        lista += "</td>";
        lista += "<td><img src='presentacion/" + inventario.getFoto() + "' width='30' height='30'></td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=inventarioFormulario.jsp&accion=Modificar&id=" + inventario.getIdArticulo() +
                "' title='Modificar'><img src='presentacion/modificar.png' style='width: 20px; height: 20px;'></a>";
        lista += "<img src='presentacion/eliminar.png' style='width: 20px; height: 20px;' title='Eliminar' onClick='eliminar(" + inventario.getIdArticulo() + ")'> ";
        lista += "<a href='principal.jsp?CONTENIDO=Kardex.jsp&idArticulo=" + inventario.getIdArticulo() +
         "' title='Ver Kardex'><img src='presentacion/kardex.png' style='width: 20px; height: 20px;'></a>";
        lista += "</td>";
        lista += "</tr>";
    }
%>

<div class="container-fluid">
    <div class="table-container">
        <h2>INVENTARIO</h2>
        <div class="form-container mb-3">
            <h4>Búsqueda de Inventario</h4>
            <form method="post">
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkId" <%=chkId%>> Id
                                </div>
                            </div>
                            desde <input type="number" name="idInicio" value="<%=idInicio%>" class="form-control">
                            hasta <input type="number" name="idFin" value="<%=idFin%>" class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo
                                </div>
                            </div>
                            <input type="text" name="nombreArticulo" value="<%=nombreArticulo%>" class="form-control" placeholder="Nombre del artículo">
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkIdCategoria" <%=chkIdCategoria%>> Categoria
                                </div>
                            </div>
                            <select name="idCategoria" class="form-control"><%=Categoria.getListaEnOptions(idCategoria)%></select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <input type="checkbox" name="chkTalla" <%=chkTalla%>> Talla
                                </div>
                            </div>
                            <input type="text" name="talla" value="<%=talla%>" class="form-control" placeholder="Talla">
                        </div>
                    </div>
                    <div class="col">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Buscar</button>
                    </div>
                </div>
            </form>
        </div>

        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Costo Unitario Compra</th>
                    <th>Valor Unitario Venta</th>
                    <th>Stock</th>
                    <th>Stock Mínimo</th>
                    <th>Stock Máximo</th>
                    <th>Color Artículo</th>
                    <th>Tipo Tela</th>
                    <th>Categoría</th>
                    <th>Talla</th>
                    <th>Impuesto</th>
                    <th>Foto</th>
                    <th>
                        <a href="principal.jsp?CONTENIDO=inventarioFormulario.jsp&accion=Adicionar" title="Adicionar" class="btn btn-action btn-add">
                            <img src="presentacion/adicionar.png" class="icono" alt="Adicionar">
                        </a>
                    </th>                
                </tr>
            </thead>
            <tbody>
                <%= lista %>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="5">TOTAL</th>
                    <th align='right'><%=totalStock%></th>
                    <th align='right'><%=totalStockMinimo%></th>
                    <th align='right'><%=totalStockMaximo%></th>
                </tr>
            </tfoot>
        </table>
    </div>
</div>

<script type="text/javascript">
    function eliminar(id) {
        var respuesta = confirm("Realmente desea eliminar el registro");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=inventarioActualizar.jsp&accion=Eliminar&id=" + id;      
        }    
    }
</script>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
