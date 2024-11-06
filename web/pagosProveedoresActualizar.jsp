<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="java.io.IOException"%>

<%
    try {
        // Obtener los parámetros del formulario
        String idPagoStr = request.getParameter("idPago");
        String accion = request.getParameter("accion");
        String fecha = request.getParameter("fecha");
        String medioPago = request.getParameter("medioPago");
        String valorStr = request.getParameter("valor");

        // Verificar si los parámetros necesarios existen
        if (fecha == null || medioPago == null || valorStr == null || accion == null) {
            throw new Exception("Faltan parámetros requeridos.");
        }

        // Depuración: Imprimir los valores recibidos
        System.out.println("Valores recibidos - idPago: " + idPagoStr + ", acción: " + accion + ", fecha: " + fecha + ", medioPago: " + medioPago + ", valor: " + valorStr);

        // Convertir parámetros necesarios a los tipos adecuados
        int valor = Integer.parseInt(valorStr);
        int idMedioPago = Integer.parseInt(medioPago);
        int idCompra = Integer.parseInt(request.getParameter("idCompra"));

        // Crear un objeto MedioPagoPorCompra para manejar la lógica
        MedioPagoPorCompra pago = new MedioPagoPorCompra(idCompra, idMedioPago, valor, fecha, "");

        boolean resultado = false;

        // Procesar según la acción (Agregar o Modificar)
        if (accion != null) {
            if (accion.equals("Agregar")) {
                System.out.println("Intentando grabar un nuevo pago...");
                resultado = pago.grabar();
            } else if (accion.equals("Modificar")) {
                int idPago = Integer.parseInt(idPagoStr);
                System.out.println("Intentando modificar el pago con ID: " + idPago);
                resultado = pago.modificar(idPago);
            }
        }

        // Comprobar si la operación fue exitosa
        if (resultado) {
            response.sendRedirect("pagosPendientes.jsp?idCompra=" + idCompra);
        } else {
            out.println("<p>Error al procesar el pago. Inténtalo de nuevo.</p>");
            out.println("<a href='pagosFormulario.jsp?accion=" + accion + "&idPago=" + idPagoStr + "'>Volver al formulario</a>");
        }

    } catch (NumberFormatException e) {
        out.println("<p>Error al procesar los valores numéricos: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
