<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String action = request.getParameter("action");

    if (action != null && action.equals("delete")) {
        // Obtener el idPago y el idVenta desde la URL
        String idPago = request.getParameter("idPago");
        String idVenta = request.getParameter("idVenta");

        if (idPago != null && !idPago.isEmpty()) {
            // Crear el objeto y eliminar el pago
            MedioPagoPorVenta pago = new MedioPagoPorVenta(idPago);
            if (pago.eliminar()) {
                out.println("<p>Pago eliminado correctamente.</p>");
            } else {
                out.println("<p>Error al eliminar el pago.</p>");
            }
            // Redirigir de vuelta a la página de pagos
            response.sendRedirect("pagosVentas.jsp?idVenta=" + idVenta);
        }
    } else {
        // Código existente para agregar o modificar pagos
        String idVenta = request.getParameter("idVenta");
        String fechaPago = request.getParameter("fechaPago");
        String medioPago = request.getParameter("medioPago");
        String valorPago = request.getParameter("valorPago");
        String idPago = request.getParameter("idPago");

        // Validar que los parámetros necesarios no sean nulos o vacíos
        if (idVenta == null || fechaPago == null || medioPago == null || valorPago == null || 
            idVenta.isEmpty() || fechaPago.isEmpty() || medioPago.isEmpty() || valorPago.isEmpty()) {
            out.println("<p>Error: Todos los campos son obligatorios.</p>");
        } else {
            // Formatear la fecha para asegurarnos de que sea compatible con la base de datos
            SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaFormateada = null;
            try {
                fechaFormateada = formatoFecha.parse(fechaPago);
            } catch (Exception e) {
                out.println("<p>Error: Fecha ingresada no válida.</p>");
            }

            if (fechaFormateada != null) {
                // Inicializar el objeto MedioPagoPorVenta
                MedioPagoPorVenta pago;

                if (idPago != null && !idPago.isEmpty()) {
                    // Modificación del pago existente
                    pago = new MedioPagoPorVenta(idPago);
                    pago.setFecha(new SimpleDateFormat("yyyy-MM-dd").format(fechaFormateada));
                    pago.setIdPagos(medioPago);
                    pago.setValor(valorPago);

                    // Modificar el pago en la base de datos
                    if (pago.modificar()) {
                        out.println("<p>Pago modificado correctamente.</p>");
                    } else {
                        out.println("<p>Error al modificar el pago.</p>");
                    }
                } else {
                    // Adición de un nuevo pago
                    pago = new MedioPagoPorVenta();
                    pago.setIdVentaDetalle(idVenta);
                    pago.setFecha(new SimpleDateFormat("yyyy-MM-dd").format(fechaFormateada));
                    pago.setIdPagos(medioPago);
                    pago.setValor(valorPago);

                    // Grabar el nuevo pago en la base de datos
                    if (pago.grabar()) {
                        out.println("<p>Pago agregado correctamente.</p>");
                    } else {
                        out.println("<p>Error al agregar el pago.</p>");
                    }
                }

                // Redirigir de vuelta a la página de pagos de ventas
                response.sendRedirect("pagosVentas.jsp?idVenta=" + idVenta);
            }
        }
    }
%>