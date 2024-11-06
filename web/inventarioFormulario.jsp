<%@page import="java.util.List"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.Categoria"%>
<%@page import="clases.Impuesto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Estilo del contenedor del formulario */
    .form-container {
        max-width: 900px; /* Ancho máximo del formulario */
        margin: 50px auto; /* Centrar el formulario y agregar margen superior */
        padding: 30px; /* Espaciado interno */
        background: linear-gradient(to bottom left, #cccccc, #ccffff); /* Degradado suave entre azul claro y gris */
        border-radius: 8px; /* Bordes redondeados */
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3); /* Sombra del formulario */
        opacity: 0.95; /* Ligeramente transparente */
    }

    /* Estilo del encabezado del formulario */
    h3 {
        text-align: center; /* Centrar el texto */
        color: #333333; /* Color del texto */
        font-size: 24px; /* Tamaño de fuente */
        font-weight: bold; /* Negrita */
        margin-bottom: 20px; /* Margen inferior */
    }

    /* Estilo de los botones */
    .btn-submit {
        background-color: #007BFF; /* Color del botón */
        color: white; /* Color del texto */
        border: none; /* Sin borde */
        border-radius: 30px; /* Bordes redondeados */
        padding: 10px 20px; /* Espaciado interno */
        font-size: 16px; /* Tamaño de fuente */
        cursor: pointer; /* Cambia el cursor al pasar sobre el botón */
        transition: background-color 0.3s ease; /* Transición de color */
        width: 100%; /* Botón de ancho completo */
    }

    .btn-submit:hover {
        background-color: #0056b3; /* Color del botón al pasar el mouse */
    }

    /* Estilo de los campos de entrada */
    .form-control {
        border-radius: 5px; /* Bordes redondeados */
        border: 1px solid #ced4da; /* Color del borde */
        padding: 10px; /* Aumentar el espaciado interno */
        font-size: 16px; /* Tamaño de fuente */
        height: 45px; /* Aumentar altura de los campos de entrada */
        width: 100%; /* Asegurar que ocupe el 100% del contenedor */
        box-sizing: border-box; /* Incluye padding y borde en el ancho total */
    }

    /* Ajustes específicos para el campo de selección */
    select.form-control {
        height: 50px; /* Aumentar la altura del campo de selección */
        padding: 10px; /* Aumentar el padding interno */
    }

    /* Estilo de las etiquetas */
    label {
        font-weight: bold; /* Negrita */
    }

    /* Espacio entre los elementos del formulario */
    .form-group {
        margin-bottom: 1.8rem; /* Mayor espacio entre campos */
    }

    .img-preview {
        width: 300px;
        height: 400px;
        object-fit: cover; /* Mantener la proporción de la imagen */
    }
</style>

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

<div class="form-container">
    <h3><%= accion.toUpperCase() %> INVENTARIO</h3>
    <form name="formulario" method="POST" action="principal.jsp?CONTENIDO=inventarioActualizar.jsp" enctype="multipart/form-data">
        <div class="row">
            <div class="col-md-8">
                <div class="form-group">
                    <label for="id">Id</label>
                    <input type="text" id="id" class="form-control" value="<%= inventario.getIdArticulo() %>" readonly>
                </div>
                <div class="form-group">
                    <label for="nombreArticulo">Nombre Artículo</label>
                    <input type="text" name="nombreArticulo" id="nombreArticulo" class="form-control" value="<%= inventario.getNombreArticulo() %>" maxlength="30" required>
                </div>
                <div class="form-group">
                    <label for="descripcion">Descripción</label>
                    <textarea name="descripcion" id="descripcion" class="form-control" rows="5"><%= inventario.getDescripcion() %></textarea>
                </div>
                <div class="form-group">
                    <label for="costoUnitCompra">Costo Unitario Compra</label>
                    <input type="number" name="costoUnitCompra" id="costoUnitCompra" class="form-control" value="<%= inventario.getCostoUnitCompra() %>" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="valorUnitVenta">Valor Unitario Venta</label>
                    <input type="number" name="valorUnitVenta" id="valorUnitVenta" class="form-control" value="<%= inventario.getValorUnitVenta() %>" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="stock">Stock</label>
                    <input type="number" name="stock" id="stock" class="form-control" value="<%= inventario.getStock() %>" step="1" min="0" required>
                </div>
                <div class="form-group">
                    <label for="stockMinimo">Stock Mínimo</label>
                    <input type="number" name="stockMinimo" id="stockMinimo" class="form-control" value="<%= inventario.getStockMinimo() %>" step="1" min="0" required>
                </div>
                <div class="form-group">
                    <label for="stockMaximo">Stock Máximo</label>
                    <input type="number" name="stockMaximo" id="stockMaximo" class="form-control" value="<%= inventario.getStockMaximo() %>" step="1" min="0" required>
                </div>
                <div class="form-group">
                    <label for="tipoTela">Tipo Tela</label>
                    <input type="text" name="tipoTela" id="tipoTela" class="form-control" value="<%= inventario.getTipoTela() %>" maxlength="30">
                </div>
                <div class="form-group">
                    <label for="colorArticulo">Color Artículo</label>
                    <input type="text" name="colorArticulo" id="colorArticulo" class="form-control" value="<%= inventario.getColorArticulo() %>" maxlength="30">
                </div>
                <div class="form-group">
                    <label for="talla">Talla</label>
                    <input type="text" name="talla" id="talla" class="form-control" value="<%= inventario.getTalla() %>" maxlength="10">
                </div>
                <div class="form-group">
                    <label for="foto">Foto</label>
                    <input type="file" name="foto" id="foto" class="form-control" accept="image/*" onchange="mostrarFoto();">
                </div>
                <div class="form-group">
                    <label>Categoría</label>
                    <select name="idCategoria" class="form-control">
                        <%= Categoria.getListaEnOptions(inventario.getIdCategoria()) %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Impuestos</label><br>
                    <%= Impuesto.getOpciones(impuestosSeleccionados) %> <!-- Aquí generas la lista de checkboxes dinámicamente con preselección -->
                </div>
                <input type="hidden" name="id" value="<%= inventario.getIdArticulo() %>">
                <div class="text-center">
                    <input type="submit" name="accion" value="<%= accion %>" class="btn-submit">
                </div>
            </div>
            <div class="col-md-4">
                <div class="text-center mt-3">
                    <img src="presentacion/<%= inventario.getFoto() %>" id="img-preview" class="img-preview" alt="Vista previa de la imagen" onerror="this.src='presentacion/default.png';"> <!-- Imagen predeterminada en caso de error -->
                </div>
            </div>
        </div>
    </form>
</div>
<script type="text/javascript">
    function mostrarFoto() {
        var lector = new FileReader();
        lector.readAsDataURL(document.formulario.foto.files[0]);
        lector.onloadend = function () {
            document.getElementById("img-preview").src = lector.result;
        }
    }
</script>
