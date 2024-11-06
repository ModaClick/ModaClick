<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Categoria"%>
<%@page import="clases.Impuesto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<head>
    <link rel="stylesheet" href="presentacion/estilosformulario.css">
</head>
<%
    String accion = request.getParameter("accion");
    String id = request.getParameter("id");
    Inventario inventario = new Inventario();
    List<Integer> impuestosSeleccionados = null; // Lista para los impuestos asociados

    if ("Modificar".equals(accion)) {
        inventario = new Inventario(id);
        // Obtener los impuestos ya asociados al artículo
        impuestosSeleccionados = inventario.obtenerIdImpuestosAsociados(); // Deberías tener un método para obtener los id de los impuestos asociados
    }

%>

<h3><%=accion.toUpperCase()%> INVENTARIO</h3>

<center><form name="formulario" method="POST" action="principal.jsp?CONTENIDO=inventarioActualizar.jsp" enctype="multipart/form-data">
    <h3><%=accion.toUpperCase()%> INVENTARIO</h3>
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
                <input type="number" name="costoUnitarioCompra" value="<%=inventario.getCostoUnitCompra()%>" step="0.01" min="0" required>
            </td>
        </tr>
        <tr>
            <th>Valor Unitario Venta</th>
            <td>
                <input type="number" name="valorUnitarioVenta" value="<%=inventario.getValorUnitVenta()%>" step="0.01" min="0" required>
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
                <input type="file" name="foto" accept="image/*" onchange="mostrarFoto();">
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
                <%= Impuesto.getOpciones(impuestosSeleccionados) %> <!-- Aquí generas la lista de checkboxes dinámicamente con preselección -->
            </td>
        </tr>
    </table>
    <p>
        <input type="hidden" name="id" value="<%=inventario.getIdArticulo()%>">
        <input type="submit" name="accion" value="<%=accion%>">
    </form></center>

<td>
    <img src="presentacion/inventario/<%=inventario.getFoto()%>" id="foto" width="300" height="400">
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
