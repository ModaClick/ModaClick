<%@page import="clases.Impuesto"%>
<%@page import="clases.Inventario"%>
<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<link rel="stylesheet" href="presentacion/tablas.css">

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
        filtro = "(idArticulo between " + idInicio + " and " + idFin + ")";
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
        lista += "<td><img src='presentacion/inventario/" + inventario.getFoto() + "' width='30' height='30'></td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=inventarioFormulario.jsp&accion=Modificar&id=" + inventario.getIdArticulo() +
                "' title='Modificar'><img src='presentacion/modificar.png' class='icono'></a>";
        lista += "<img src='presentacion/eliminar.png' class='icono' title='Eliminar' onClick='eliminar(" + inventario.getIdArticulo() + ")'> ";
        lista += "<a href='principal.jsp?CONTENIDO=Kardex.jsp&idArticulo=" + inventario.getIdArticulo() +
         "' title='Ver Kardex'><img src='presentacion/kardex.png' class='icono'></a>";
        lista += "</td>";
        lista += "</tr>";
    }
%>



<form name="formulario" method="post" class="search-form"> 
    <table class="tabla-categorias">
        <thead>
        <th colspan="5">
            <h3 style="text-align:center;">LISTA DE INVENTARIO</h3></th>
        
        <tr>
            <td><input type="checkbox" name="chkId" <%=chkId%>> Id</td>
            <td>desde <input type="number" name="idInicio" placeholder="Ej. 1" value="<%=idInicio%>"></td>
            <td>hasta <input type="number" name="idFin" placeholder="Ej. 10" value="<%=idFin%>"></td>
            <td><input type="checkbox" name="chkIdCategoria" <%=chkIdCategoria%>> Categoria</td>
            <td>
                <select name="idCategoria" class="styled-select">
                    <%=Categoria.getListaEnOptions(idCategoria)%>
                </select>
            </td>
        </tr>
        
        <tr>        
            <td><input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo</td>
            <td><input type="text" name="nombreArticulo" value="<%=nombreArticulo%>"></td>            
            <td><input type="checkbox" name="chkTalla" <%=chkTalla%>> Talla</td>
            <td><input type="text" name="talla" value="<%=talla%>"></td>
        </tr>
        <tr>
            <td colspan="5" style="text-align: center;">
                <input type="submit" class="search-button" name="buscar" value="Buscar">
            </td>
        </tr>
    </table>
</form>

<table class="tabla-categorias"> 
    
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
                <a href="principal.jsp?CONTENIDO=inventarioFormulario.jsp&accion=Adicionar" title="Adicionar">
                    <img src="presentacion/adicionar.png" style="width: 20px; height: 20px;">
                </a>
            </th>
        </tr>
    
</thead>
    <tbody>
        <%=lista%>
        <tr>
            <th colspan="5">TOTAL</th>
            <th align="right"><%=totalStock%></th>
            <th align="right"><%=totalStockMinimo%></th>
            <th align="right"><%=totalStockMaximo%></th>
        </tr>
    </tbody>
</table>

<script type="text/javascript">
    function eliminar(id) {
        var respuesta = confirm("Realmente desea eliminar el registro");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=inventarioActualizar.jsp&accion=Eliminar&id=" + id;      
        }    
    }
</script>
