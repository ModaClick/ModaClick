<%@page import="clases.Inventario"%>
<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
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

    String lista = "";
    List<Inventario> datos = Inventario.getListaEnObjetos(filtro, null);
    int totalStock = 0;
    int totalStockMinimo = 0;
    int totalStockMaximo = 0;

    for (Inventario inventario : datos) {
        Categoria categoria=new Categoria(inventario.getIdCategoria());
        totalStock += Integer.parseInt(inventario.getStock());
        totalStockMinimo += Integer.parseInt(inventario.getStockMinimo());
        totalStockMaximo += Integer.parseInt(inventario.getStockMaximo());

        lista += "<tr>";
        lista += "<td align='right'>" + inventario.getIdArticulo() + "</td>";
        lista += "<td>" + inventario.getNombreArticulo() + "</td>";
        lista += "<td>" + inventario.getDescripcion() + "</td>";
        lista += "<td>" + inventario.getCostoUnitarioCompra() + "</td>";
        lista += "<td>" + inventario.getValorUnitarioVenta() + "</td>";
        lista += "<td>" + inventario.getStock() + "</td>";
        lista += "<td>" + inventario.getStockMinimo() + "</td>";
        lista += "<td>" + inventario.getStockMaximo() + "</td>";
        lista += "<td>" + inventario.getColorArticulo() + "</td>";
        lista += "<td>" + inventario.getTipoTela() + "</td>";
        lista += "<td>" + categoria.getNombre() + "</td>";
        lista += "<td>" + inventario.getTalla() + "</td>";
        lista += "<td>" + inventario.getImpuesto() + "</td>";
        lista += "<td><img src='Presentacion/inventario/" + inventario.getFoto() + "' width='30' height='30'></td>";

        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=inventarioFormulario.jsp&accion=Modificar&id=" + inventario.getIdArticulo() +
                "' title='Modificar'><img src='Presentacion/imagenes/modificar.jpg' style='width: 20px; height: 20px;'></a>";
        lista += "<img src='Presentacion/imagenes/eliminar.png' style='width: 20px; height: 20px;' title='Eliminar' onClick='eliminar(" + inventario.getIdArticulo() + ")'> ";
        lista += "</td>";
        lista += "</tr>";
    }
%>

<h3>LISTA DE INVENTARIO</h3>

<form name="formulario" method="post"> 
    <table>
        <tr>
            <td><input type="checkbox" name="chkId" <%=chkId%>> Id</td>
            <td>
                desde <input type="number" name="idInicio" value="<%=idInicio%>">
                hasta <input type="number" name="idFin" value="<%=idFin%>">
            </td>
            <td><input type="checkbox" name="chkNombreArticulo" <%=chkNombreArticulo%>> Nombre Artículo</td>
            <td><input type="text" name="nombreArticulo" value="<%=nombreArticulo%>"></td>
        </tr>
        <tr>
            <td><input type="checkbox" name="chkIdCategoria" <%=chkIdCategoria%>> Categoria</td>
            <td><select name="idCategoria"><%=Categoria.getListaEnOptions(idCategoria)%></select></td>
        </tr>
        
        <tr>
            <td><input type="checkbox" name="chkTalla" <%=chkTalla%>> Talla</td>
            <td><input type="text" name="talla" value="<%=talla%>"></td>
        </tr>
    </table><p>
        <input type="submit" name="buscar" value="Buscar">
</form>
        
<table border="1">
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
                <img src="Presentacion/imagenes/adicionar.jpg" style="width: 20px; height: 20px;">
            </a>
        </th>                
    </tr>
    <%=lista%>
    <tr>
        <th colspan="5">TOTAL</th>
        <th align="right"><%=totalStock%></th>
        <th align="right"><%=totalStockMinimo%></th>
        <th align="right"><%=totalStockMaximo%></th>
    </tr>
</table>

<!--<p>CONVENCIONES</p>
<table class="convention-table">
    <tr><th style="background-color: red;">&nbsp;&nbsp;&nbsp;&nbsp;</th><td>Productos escasos</td></tr>
    <tr><th style="background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;</th><td>Productos en sobreoferta</td></tr>
</table>-->

<script type="text/javascript">
    function eliminar(id) {
        var respuesta = confirm("Realmente desea eliminar el registro");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=inventarioActualizar.jsp&accion=Eliminar&id=" + id;      
        }    
    }
</script>  
