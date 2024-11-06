<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="clases.DevolucionCompra, clases.Compra, clases.CompraDetalle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Devolución de Compra</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .form-container {
            max-width: 1000px; /* Ancho máximo del formulario */
            margin: 50px auto; /* Centrar el formulario y agregar margen superior */
            padding: 20px; /* Espaciado interno */
             background: linear-gradient(to bottom left, #cccccc, #ccffff);/* Color de fondo */
            border-radius: 8px; /* Bordes redondeados */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Sombra del formulario */
        }
        h1 {
            text-align: center; /* Centrar el texto */
            color: #333; /* Color del texto */
            margin-bottom: 20px; /* Margen inferior */
        }
        /* Estilo de la tabla */
        table.table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
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
        .total-section {
            text-align: right;
            margin-top: 20px;
        }
        .button-section {
            text-align: center;
            margin-top: 20px;
        }
        .button-section button {
            background-color: #007BFF; /* Color del botón */
            color: white; /* Color del texto */
            border: none; /* Sin borde */
            padding: 10px 20px; /* Espaciado interno */
            cursor: pointer; /* Cambia el cursor al pasar sobre el botón */
            border-radius: 5px; /* Bordes redondeados */
            transition: background-color 0.3s ease; /* Transición de color */
        }
        .button-section button:hover {
            background-color: #0056b3; /* Color del botón al pasar el mouse */
        }
        /* Estilo de los campos de entrada */
        .form-control {
            border-radius: 5px; /* Bordes redondeados */
            border: 1px solid #ced4da; /* Color del borde */
            padding: 10px; /* Espaciado interno */
            font-size: 16px; /* Tamaño de fuente */
        }
        /* Estilo de las etiquetas */
        label {
            font-weight: bold; /* Negrita */
        }
    </style>
    <script>
        function cargarDetallesCompra() {
            var idCompra = document.getElementById("idCompra").value;
            if (idCompra) {
                window.location.href = "DevolucionesCompraFormulario.jsp?idCompra=" + idCompra;
            }
        }

        function detectarEnter(event) {
            if (event.key === "Enter") {
                event.preventDefault();
                cargarDetallesCompra();
            }
        }

        function actualizarValores(cantidadMaxima, valorUnitario, totalImpuestos, index) {
            var cantidadDevuelta = document.getElementById("cantidadDevuelta-" + index).value;

            if (parseInt(cantidadDevuelta) > parseInt(cantidadMaxima)) {
                alert("La cantidad devuelta no puede ser mayor que la cantidad comprada.");
                document.getElementById("cantidadDevuelta-" + index).value = cantidadMaxima;
                cantidadDevuelta = cantidadMaxima;
            }

            var valorDevuelto = cantidadDevuelta * valorUnitario;
            var subtotal = valorDevuelto;
            var total = valorDevuelto + (valorDevuelto * totalImpuestos);

            document.getElementById("valorDevuelto-" + index).value = valorDevuelto.toFixed(2);
            document.getElementById("subtotal-" + index).innerHTML = "$" + subtotal.toFixed(2);
            document.getElementById("total-" + index).innerHTML = "$" + total.toFixed(2);

            actualizarValorTotal();
        }

        function actualizarValorTotal() {
            var totalGeneral = 0;
            var totales = document.querySelectorAll(".total");

            totales.forEach(function (element) {
                totalGeneral += parseFloat(element.innerText.replace("$", "")) || 0;
            });

            document.getElementById("valorTotal").innerHTML = "$" + totalGeneral.toFixed(2);
        }
    </script>
</head>
<body>
    <div class="form-container">
        <h1><%= (request.getParameter("id") != null) ? "Actualizar Devolución de Compra" : "Adicionar Devolución de Compra"%></h1>

        <%
            DevolucionCompra devolucion = null;
            Compra compra = null;
            String idCompra = request.getParameter("idCompra");

            if (idCompra != null) {
                compra = new Compra(idCompra);
            }

            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                int idDevolucion = Integer.parseInt(request.getParameter("id"));
                devolucion = DevolucionCompra.getDevolucionPorId(idDevolucion);
            }
        %>

        <form action="DevolucionesCompraActualizar.jsp" method="post">
            <input type="hidden" name="id" value="<%= (devolucion != null) ? devolucion.getId() : ""%>">

            <div class="form-group">
                <label for="idCompra">Número de compra:</label>
                <input type="text" id="idCompra" name="idCompra" 
                       value="<%= (compra != null) ? compra.getIdCompra() : ""%>" 
                       placeholder="Ingrese el ID de la compra" 
                       required 
                       onkeypress="detectarEnter(event)">
                <button type="button" onclick="cargarDetallesCompra()" class="btn btn-secondary">Buscar</button>
            </div>

            <% if (compra != null) {
                    List<CompraDetalle> detallesCompra = compra.getDetalles();
                    if (!detallesCompra.isEmpty()) {
            %>
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Cantidad</th>
                        <th>Comentarios</th>
                        <th>Cantidad Devuelta</th>
                        <th>Impuestos</th>
                        <th>Valor Unitario</th>
                        <th>Valor Devuelto</th>
                        <th>Subtotal</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int index = 0;
                        for (CompraDetalle detalleCompra : detallesCompra) {
                            String nombreArticulo = "Artículo no encontrado";
                            String cantidad = detalleCompra.getCantidad(); 
                            String consultaArticulo = "SELECT nombreArticulo FROM Inventario WHERE idArticulo = '" + detalleCompra.getIdArticuloInventario() + "'";
                            ResultSet rsArticulo = ConectorBD.consultar(consultaArticulo);
                            if (rsArticulo != null && rsArticulo.next()) {
                                nombreArticulo = rsArticulo.getString("nombreArticulo");
                                rsArticulo.close();
                            }

                            String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                    + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                    + "WHERE ImpuestoInventario.idArticulo = '" + detalleCompra.getIdArticuloInventario() + "'";
                            ResultSet rsImpuestos = ConectorBD.consultar(consultaImpuestos);

                            double totalImpuestos = 0.0;
                            String impuestosDesglosados = "";

                            while (rsImpuestos != null && rsImpuestos.next()) {
                                int porcentaje = rsImpuestos.getInt("porcentaje");
                                totalImpuestos += porcentaje / 100.0;
                                impuestosDesglosados += porcentaje + "%<br>";
                            }
                            if (rsImpuestos != null) {
                                rsImpuestos.close();
                            }
                    %>
                    <tr>
                        <td><%= nombreArticulo%></td>
                        <td><%= cantidad%></td>
                        <input type="hidden" name="idCompraDetalle" value="<%= detalleCompra.getIdCompraDetalle()%>">
                        <td><input type="text" name="comentarios" placeholder="Comentarios" class="form-control"></td>
                        <td><input type="number" id="cantidadDevuelta-<%= index%>" name="cantidadDevuelta" 
                                 value="0" min="0" max="<%= cantidad %>" required 
                                   oninput="actualizarValores(<%= cantidad%>, <%= detalleCompra.getCostoUnitCompra()%>, <%= totalImpuestos%>, <%= index%>)" class="form-control"></td>
                        <td><%= impuestosDesglosados%></td>
                        <td>$<%= detalleCompra.getCostoUnitCompra()%></td>
                        <td><input type="text" id="valorDevuelto-<%= index%>" name="valorDevuelto" class="valorDevuelto" value="0.00" readonly></td>
                        <td id="subtotal-<%= index%>">$0.00</td>
                        <td id="total-<%= index%>" class="total">$0.00</td>
                    </tr>
                    <%
                            index++;
                        }
                    %>
                </tbody>
            </table>
            <%
                    } else {
                        out.println("<p>No se encontraron detalles para esta compra.</p>");
                    }
                } else {
                    out.println("<p>Ingrese el número de la compra para cargar los detalles de la compra.</p>");
                }
            %>

            <div class="total-section">
                <p><strong>Valor Total:</strong> <span id="valorTotal">$0.00</span></p>
            </div>

            <div class="button-section">
                <button type="submit" class="btn btn-primary"><%= (devolucion != null) ? "Actualizar" : "Adicionar"%></button>
            </div>
        </form>
    </div>
    <div class="button-section">
        <button class="btn btn-secondary" onclick="window.location.href = 'principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp'">Regresar</button>
    </div>
</body>
</html>