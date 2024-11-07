<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="clases.DevolucionCompra, clases.DevolucionDetallesCompra, clases.Compra" %>
<%@ page import="java.sql.Date, java.time.LocalDate" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="clasesGenericas.ConectorBD" %>
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

            // Llamada al método para eliminar la devolución
            resultado = DevolucionCompra.eliminarDevolucion(idDevolucion);

            // Verificar si la eliminación fue exitosa
            if (resultado) {
                response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp");
            } else {
                out.println("<p>Error al eliminar la devolución. <a href='DevolucionesCompras.jsp'>Volver</a></p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p>Error: el ID de devolución no es válido.</p>");
        }
    } else {
        // Lógica para adicionar o actualizar una devolución
        try {
            String idCompra = request.getParameter("idCompra");
            String idCompraDetalle = request.getParameter("idCompraDetalle");
            String cantidadDevuelta = request.getParameter("cantidadDevuelta");
            String comentarios = request.getParameter("comentarios");

            DevolucionCompra devolucion;

            // Si se proporciona un ID, se carga la devolución existente para actualizarla
            if (id != null && !id.isEmpty()) {
                devolucion = DevolucionCompra.getDevolucionPorId(Integer.parseInt(id));
            } else {
                devolucion = new DevolucionCompra();
            }

            // Cargar la compra asociada utilizando su ID
            Compra compra = new Compra(idCompra);
            devolucion.setCompra(compra);
            devolucion.setFecha(Date.valueOf(LocalDate.now()));

            // Insertar o actualizar la devolución
            resultado = DevolucionCompra.insertarDevolucion(devolucion);

            if (resultado) {
                int idDevolucionCompra = devolucion.getId();

                // Crear y configurar el detalle de la devolución
                DevolucionDetallesCompra detalle = new DevolucionDetallesCompra();
                detalle.setIdCompraDetalle(Integer.parseInt(idCompraDetalle));
                detalle.setCantidad(Integer.parseInt(cantidadDevuelta));
                detalle.setEstadoCompra("A"); // Predefinir estado como 'A'
                detalle.setComentariosAdicionales((comentarios != null && !comentarios.isEmpty()) ? comentarios : "");

                // Insertar el detalle de la devolución
                boolean detalleResultado = DevolucionDetallesCompra.insertarDetalleDevolucion(idDevolucionCompra, detalle);

                // Verificar si la inserción del detalle fue exitosa
                if (detalleResultado) {
                    
                    // Actualizar la cantidad en CompraDetalle
                    int cantidadDevueltaInt = Integer.parseInt(cantidadDevuelta);
                    if (cantidadDevueltaInt > 0) {
                        // Consulta para obtener la cantidad actual en CompraDetalle
                        String consultaCantidadActual = "SELECT cantidad FROM CompraDetalle WHERE idCompraDetalle = " + idCompraDetalle;
                        ResultSet rsCantidad = ConectorBD.consultar(consultaCantidadActual);
                        int cantidadActual = 0;

                        if (rsCantidad != null && rsCantidad.next()) {
                            cantidadActual = rsCantidad.getInt("cantidad");
                        }

                        // Validación extra para asegurarse de que se tiene una cantidad válida
                        if (cantidadActual > 0) {
                            // Reducir la cantidad en CompraDetalle
                            int nuevaCantidad = cantidadActual - cantidadDevueltaInt;
                            String updateSQL = "UPDATE CompraDetalle SET cantidad = " + nuevaCantidad + 
                                               " WHERE idCompraDetalle = '" + idCompraDetalle + "'";
                            
                            boolean compraDetalleActualizado = ConectorBD.ejecutarQuery(updateSQL);
                            
                            if (!compraDetalleActualizado) {
                                out.println("<p>Error al actualizar la cantidad en CompraDetalle.</p>");
                            }
                        } else {
                            out.println("<p>No se pudo obtener la cantidad actual correspondiente en CompraDetalle.</p>");
                        }
                    }
                    
                    response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp");
                } else {
                    out.println("<p>Error al agregar los detalles de la devolución. <a href='DevolucionesCompras.jsp'>Volver</a></p>");
                }
            } else {
                out.println("<p>Error al agregar la devolución. <a href='DevolucionesCompras.jsp'>Volver</a></p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p>Error: uno de los valores proporcionados no es válido.</p>");
        }
    }
%>
