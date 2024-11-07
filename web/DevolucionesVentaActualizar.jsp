<%@page import="java.util.List"%>
<%@page import="clases.VentaDetalle"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="clases.DevolucionVenta, clases.DevolucionVentaDetalles, clases.Venta" %>
<%@ page import="java.sql.Date, java.time.LocalDate" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<%@ page import="java.sql.ResultSet" %>
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
            resultado = DevolucionVenta.eliminarDevolucion(idDevolucion);

            // Redirigir si la eliminación fue exitosa
            if (resultado) {
                response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp");
            }
        } catch (NumberFormatException e) {
            // Manejo de error por ID no válido
            // Redirigir o manejar el error
        } catch (Exception e) {
            // Manejo de error inesperado
        }
    } else {
        // Lógica para adicionar o actualizar una devolución
        try {
            String idVenta = request.getParameter("idVenta");
            String idVentaDetalle = request.getParameter("idVentaDetalle");
            String cantidadDevuelta = request.getParameter("cantidadDevuelta");
            String comentarios = request.getParameter("comentarios");

            DevolucionVenta devolucion;

            // Si se proporciona un ID, se carga la devolución existente para actualizarla
            if (id != null && !id.isEmpty()) {
                devolucion = DevolucionVenta.getDevolucionPorId(Integer.parseInt(id));
            } else {
                devolucion = new DevolucionVenta();
            }

            // Cargar la venta asociada utilizando su ID
            Venta venta = new Venta(idVenta);
            devolucion.setVenta(venta);
            devolucion.setFecha(Date.valueOf(LocalDate.now()));

            // Insertar o actualizar la devolución
            resultado = DevolucionVenta.insertarDevolucion(devolucion);

            if (resultado) {
                int idDevolucionVenta = devolucion.getId();

                // Crear y configurar el detalle de la devolución
                DevolucionVentaDetalles detalle = new DevolucionVentaDetalles();
                detalle.setIdVentaDetalle(Integer.parseInt(idVentaDetalle));
                detalle.setCantidad(Integer.parseInt(cantidadDevuelta));
                detalle.setEstadoDevolucion("A"); // Predefinir estado como 'A'
                detalle.setComentariosAdicionales((comentarios != null && !comentarios.isEmpty()) ? comentarios : "");

                // Insertar el detalle de la devolución
                boolean detalleResultado = DevolucionVentaDetalles.insertarDetalleDevolucion(idDevolucionVenta, detalle);

                // Verificar si la inserción del detalle fue exitosa
                if (detalleResultado) {
                    // Obtener la cantidad original de `VentaDetalle`
                    String consultaCantidad = "SELECT cantidad FROM VentaDetalle WHERE idVentaDetalle = '" + idVentaDetalle + "'";
                    ResultSet rsCantidad = ConectorBD.consultar(consultaCantidad);
                    int cantidadOriginal = 0;

                    if (rsCantidad.next()) {
                        cantidadOriginal = rsCantidad.getInt("cantidad");
                    }
                    rsCantidad.close();

                    // Verificar si la cantidad devuelta es menor o igual a la cantidad original
                    if (Integer.parseInt(cantidadDevuelta) <= cantidadOriginal) {
                        int nuevaCantidad = cantidadOriginal - Integer.parseInt(cantidadDevuelta);

                        // Actualizar la cantidad en `VentaDetalle`
                        String actualizarCantidad = "UPDATE VentaDetalle SET cantidad = " + nuevaCantidad +
                                " WHERE idVentaDetalle = '" + idVentaDetalle + "'";
                        boolean actualizacionExitosa = ConectorBD.ejecutarQuery(actualizarCantidad);

                        if (actualizacionExitosa) {
                            response.sendRedirect("principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            // Manejo de error por valores no válidos
        } catch (Exception e) {
            // Manejo de error inesperado
        }
    }
%>
