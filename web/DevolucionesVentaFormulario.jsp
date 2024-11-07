<%@page import="java.util.List"%>
<%@page import="clases.VentaDetalle"%>
<%@page import="clases.DevolucionVenta, clases.DevolucionVentaDetalles, clases.Venta" %>
<%@page import="java.sql.Date, java.time.LocalDate" %>
<%@page import="clasesGenericas.ConectorBD" %>
<%@page import="java.sql.ResultSet" %>
<%
    // Obtener parámetros de la solicitud
    String id = request.getParameter("id");
    String accion = request.getParameter("accion");

    // Variable para almacenar el resultado de la operación
    boolean resultado = false;

    // Lógica para la eliminación de la devolución
    if ("eliminar".equals(accion)) {
        try {
            int idDevolucion = Integer.parseInt(id);  // Convertir el ID a entero
            resultado = DevolucionVenta.eliminarDevolucion(idDevolucion);
            if (resultado) {
                response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp");
            }
        } catch (NumberFormatException e) {
            // Manejar el error por ID no válido si es necesario
        } catch (Exception e) {
            // Manejar cualquier error inesperado
        }
    } else {
        // Lógica para adicionar o actualizar una devolución
        try {
            String idVenta = request.getParameter("idVenta");
            String idVentaDetalle = request.getParameter("idVentaDetalle");
            String cantidadDevuelta = request.getParameter("cantidadDevuelta");
            String comentarios = request.getParameter("comentarios");

            DevolucionVenta devolucion;
            if (id != null && !id.isEmpty()) {
                devolucion = DevolucionVenta.getDevolucionPorId(Integer.parseInt(id));
            } else {
                devolucion = new DevolucionVenta();
            }

            Venta venta = new Venta(idVenta);
            devolucion.setVenta(venta);
            devolucion.setFecha(Date.valueOf(LocalDate.now()));

            resultado = DevolucionVenta.insertarDevolucion(devolucion);

            if (resultado) {
                int idDevolucionVenta = devolucion.getId();
                DevolucionVentaDetalles detalle = new DevolucionVentaDetalles();
                detalle.setIdVentaDetalle(Integer.parseInt(idVentaDetalle));
                detalle.setCantidad(Integer.parseInt(cantidadDevuelta));
                detalle.setEstadoDevolucion("A");
                detalle.setComentariosAdicionales(comentarios != null ? comentarios : "");

                boolean detalleResultado = DevolucionVentaDetalles.insertarDetalleDevolucion(idDevolucionVenta, detalle);
                if (detalleResultado) {
                    String consultaCantidad = "SELECT cantidad FROM VentaDetalle WHERE idVentaDetalle = '" + idVentaDetalle + "'";
                    ResultSet rsCantidad = ConectorBD.consultar(consultaCantidad);
                    int cantidadOriginal = 0;
                    if (rsCantidad.next()) {
                        cantidadOriginal = rsCantidad.getInt("cantidad");
                    }
                    rsCantidad.close();

                    if (Integer.parseInt(cantidadDevuelta) <= cantidadOriginal) {
                        int nuevaCantidad = cantidadOriginal - Integer.parseInt(cantidadDevuelta);
                        String actualizarCantidad = "UPDATE VentaDetalle SET cantidad = " + nuevaCantidad + " WHERE idVentaDetalle = '" + idVentaDetalle + "'";
                        boolean actualizacionExitosa = ConectorBD.ejecutarQuery(actualizarCantidad);
                        if (actualizacionExitosa) {
                            response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            // Manejar error por valores no válidos
        } catch (Exception e) {
            // Manejar cualquier error inesperado
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Devolución de Venta</title>
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


        h2 {

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
        function cargarDetallesVenta() {
            var idVenta = document.getElementById("idVenta").value;
            if (idVenta) {
                window.location.href = "DevolucionesVentaFormulario.jsp?idVenta=" + idVenta;
            }
        }

        function detectarEnter(event) {
            if (event.key === "Enter") {
                event.preventDefault();
                cargarDetallesVenta();
            }
        }

        function actualizarValores(cantidadMaxima, valorUnitario, totalImpuestos, index) {
            var cantidadDevuelta = document.getElementById("cantidadDevuelta-" + index).value;

            if (parseInt(cantidadDevuelta) > parseInt(cantidadMaxima)) {
                alert("La cantidad devuelta no puede ser mayor que la cantidad vendida.");
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

        <h2><%= (request.getParameter("id") != null) ? "MODIFICAR DEVOLUCION DE VENTAS" : "ADICIONAR DEVOLUCION DE VENTAS"%></h2>

        <h1><%= (request.getParameter("id") != null) ? "Actualizar Devolución de Ventas" : "Adicionar Devolución de Ventas"%></h1>


        <%
            DevolucionVenta devolucion = null;
            Venta venta = null;
            String idVenta = request.getParameter("idVenta");

            if (idVenta != null) {
                venta = new Venta(idVenta);
            }

            if (request.getParameter("id") != null) {
                int idDevolucion = Integer.parseInt(request.getParameter("id"));
                devolucion = DevolucionVenta.getDevolucionPorId(idDevolucion);
            }
        %>

        <form action="DevolucionesVentaActualizar.jsp" method="post">
            <input type="hidden" name="id" value="<%= (devolucion != null) ? devolucion.getId() : ""%>">

            <div class="form-group">
                <label for="idVenta">Número de venta:</label>
                <input type="text" id="idVenta" name="idVenta" 
                       value="<%= (venta != null) ? venta.getIdVenta() : ""%>" 
                       placeholder="Ingrese el ID de la venta" 
                       required 
                       onkeypress="detectarEnter(event)">
                <button type="button" onclick="cargarDetallesVenta()" class="btn btn-secondary">Buscar</button>
            </div>

            <% if (venta != null) {
                    List<VentaDetalle> detallesVenta = venta.getDetalles();
                    if (!detallesVenta.isEmpty()) {
            %>
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Comentarios</th>
                        <th>Cantidad Vendida</th>
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
                        for (VentaDetalle detalleVenta : detallesVenta) {
                            String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                    + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                    + "WHERE ImpuestoInventario.idArticulo = '" + detalleVenta.getIdArticuloInventario() + "'";
                            ResultSet rsImpuestos = ConectorBD.consultar(consultaImpuestos);

                            double totalImpuestos = 0.0;
                            String impuestosDesglosados = "";

                            while (rsImpuestos != null && rsImpuestos.next()) {
                                int porcentajeImpuesto = rsImpuestos.getInt("porcentaje");
                                totalImpuestos += porcentajeImpuesto / 100.0;
                                impuestosDesglosados += porcentajeImpuesto + "%<br>";
                            }
                            if (rsImpuestos != null) {
                                rsImpuestos.close();
                            }

                            String nombreArticulo = "Artículo no encontrado";
                            String consultaArticulo = "SELECT nombreArticulo FROM Inventario WHERE idArticulo = '" + detalleVenta.getIdArticuloInventario() + "'";
                            ResultSet rsArticulo = ConectorBD.consultar(consultaArticulo);
                            if (rsArticulo != null && rsArticulo.next()) {
                                nombreArticulo = rsArticulo.getString("nombreArticulo");
                                rsArticulo.close();
                            }
                    %>
                    <tr id="fila-<%= index%>">
                        <td><%= nombreArticulo%></td>
                        <input type="hidden" name="idVentaDetalle" value="<%= detalleVenta.getIdVentaDetalle()%>">
                        <td><input type="text" name="comentarios" placeholder="Comentarios" class="form-control"></td>
                        <td><%= detalleVenta.getCantidad()%></td>
                        <td><input type="number" id="cantidadDevuelta-<%= index%>" name="cantidadDevuelta" 
                                   value="0" min="0" max="<%= detalleVenta.getCantidad()%>" required 
                                   oninput="actualizarValores(<%= detalleVenta.getCantidad()%>, <%= detalleVenta.getValorUnitVenta()%>, <%= totalImpuestos%>, <%= index%>)" class="form-control"></td>
                        <td><%= impuestosDesglosados%></td>
                        <td>$<%= detalleVenta.getValorUnitVenta()%></td>
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
                    }
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
        <button class="btn btn-secondary" onclick="window.location.href = 'principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp'">Regresar</button>
    </div>
</body>
</html>
