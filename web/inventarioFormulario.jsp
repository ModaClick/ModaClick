<%@page import="clases.Inventario"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");
    String id = request.getParameter("id");
    Inventario inventario = new Inventario();
    inventario.setIdArticulo("sin generar");
    if ("Modificar".equals(accion)) {
        inventario = new Inventario(id);
    }
%>

<h3><%=accion.toUpperCase()%> INVENTARIO</h3>
<form name="formulario" method="post" action="principal.jsp?CONTENIDO=inventarioActualizar.jsp" enctype="multipart/form-data">
    <table border="0">
        <tr>
            <th>Id</th>
            <td><%=inventario.getIdArticulo()%></td>
        </tr>
        <tr>
            <th>Nombre Artículo</th>
            <td><input type="text" name="nombreArticulo" value="<%=inventario.getNombreArticulo()%>" maxlength="30" size="30" required></td>
        </tr>
        <tr>
            <th>Descripción</th>
            <td><textarea name="descripcion" rows="5" cols="30"><%=inventario.getDescripcion()%></textarea></td>
        </tr>
        <tr>
            <th>Costo Unitario Compra</th>
            <td>
                <input type="number" name="costoUnitarioCompra" value="<%=inventario.getCostoUnitarioCompra()%>" step="0.01" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Valor Unitario Venta</th>
            <td>
                <input type="number" name="valorUnitarioVenta" value="<%=inventario.getValorUnitarioVenta()%>" step="0.01" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Stock</th>
            <td>
                <input type="number" name="stock" value="<%=inventario.getStock()%>" step="1" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Stock Mínimo</th>
            <td>
                <input type="number" name="stockMinimo" value="<%=inventario.getStockMinimo()%>" step="1" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Stock Máximo</th>
            <td>
                <input type="number" name="stockMaximo" value="<%=inventario.getStockMaximo()%>" step="1" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Tipo Tela</th>
            <td><input type="text" name="tipoTela" value="<%=inventario.getTipoTela()%>" maxlength="30"></td>
        </tr>
        <tr>
            <th>Color Artículo</th>
            <td><input type="text" name="colorArticulo" value="<%=inventario.getColorArticulo()%>" maxlength="30"></td>
        </tr>
        <tr>
            <th>Talla</th>
            <td><input type="text" name="talla" value="<%=inventario.getTalla()%>" maxlength="10"></td>
        </tr>
        <tr>
            <th>Foto</th>
            <td>
                <input type="file" name="foto" accept="image/*"  onchange="mostrarFoto();" >
            </td>
        </tr>
        <tr>
            <th>Categoría</th>
            <td>
                <select name="idCategoria">
                    <%=Categoria.getListaEnOptions(inventario.getIdCategoria())%>
                </select>
            </td>
        </tr>
        <tr>
            <th>Impuestos</th>
            <td>
                <label><input type="checkbox" name="impuesto" value="IVA"> IVA</label>
                <label><input type="checkbox" name="impuesto" value="ICE"> ICE</label>
                <label><input type="checkbox" name="impuesto" value="ARANCELES"> ARANCELES</label>
            </td>
        </tr>
    </table>
    <p>
        <input type="hidden" name="id" value="<%=inventario.getIdArticulo()%>">
        <input type="submit" name="accion" value="<%=accion%>">
    </p>
</form>

<td>
    <img src="Presentacion/inventario/<%=inventario.getFoto()%>" id="foto" width="300" height="400">
</td>

<script type="text/javascript">
    function mostrarFoto() {
        var lector = new FileReader();
        lector.readAsDataURL(document.formulario.foto.files[0]);
        lector.onloadend = function () {
            document.getElementById("foto").src = lector.result;
        }
    }
</script>
