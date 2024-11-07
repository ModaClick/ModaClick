<%@ page import="clases.MedioPagoPorCompra" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String action = request.getParameter("action");

    if (action != null && action.equals("delete")) {
        // Obtener el idPago y el idCompra desde la URL
        String idPago = request.getParameter("idPago");
        String idCompra = request.getParameter("idCompra");

        if (idPago != null && !idPago.isEmpty()) {
            // Crear el objeto y eliminar el pago
            MedioPagoPorCompra pago = new MedioPagoPorCompra(idPago);
            if (pago.eliminar()) {
                out.println("<p>Pago eliminado correctamente.</p>");
            } else {
                out.println("<p>Error al eliminar el pago.</p>");
            }
            // Redirigir de vuelta a la página de pagos
            response.sendRedirect("http://localhost:8081/ModaClick/pagosCompras.jsp?idCompra=" + idCompra);
        }
    } else {
        // Código existente para agregar o modificar pagos
        String idCompra = request.getParameter("idCompra");
        String fechaPago = request.getParameter("fechaPago");
        String medioPago = request.getParameter("medioPago");
        String valorPago = request.getParameter("valorPago");
        String idPago = request.getParameter("idPago");

        // Validar que los parámetros necesarios no sean nulos o vacíos
        if (idCompra == null || fechaPago == null || medioPago == null || valorPago == null || 
            idCompra.isEmpty() || fechaPago.isEmpty() || medioPago.isEmpty() || valorPago.isEmpty()) {
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
                // Inicializar el objeto MedioPagoPorCompra
                MedioPagoPorCompra pago;

                if (idPago != null && !idPago.isEmpty()) {
                    // Modificación del pago existente
                    pago = new MedioPagoPorCompra(idPago);
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
                    pago = new MedioPagoPorCompra();
                    pago.setIdCompraDetalle(idCompra);
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

                // Redirigir de vuelta a la página de pagos de compras
                response.sendRedirect("http://localhost:8081/ModaClick/pagosCompras.jsp?idCompra=" + idCompra);
            }
        }
    }
%>
