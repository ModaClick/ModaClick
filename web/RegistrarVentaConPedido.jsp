<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    Venta venta = new Venta();

    // Verificar el valor de la acción
    if (accion != null && ("Adicionar".equalsIgnoreCase(accion) || "Modificar".equalsIgnoreCase(accion))) {

        String idCliente = request.getParameter("cliente").trim();
        String idPedido = request.getParameter("idPedido").trim();
        String cadenaArticulos = request.getParameter("articulosVendidos");
        String cadenaMediosPago = request.getParameter("mediosDePagoUtilizados");

        // Depuración para verificar los datos recibidos
        out.print("Datos recibidos:<br>");
        out.print("Cliente: " + idCliente + "<br>");
        out.print("ID Pedido: " + idPedido + "<br>");
        out.print("Cadena de Artículos (raw): " + cadenaArticulos + "<br>");
        out.print("Cadena de Medios de Pago (raw): " + cadenaMediosPago + "<br>");

        // Verificar que el ID de Pedido y el ID de Cliente estén presentes
        if (idPedido == null || idPedido.isEmpty()) {
            out.print("Error: El ID del pedido no puede estar vacío.");
            return;
        }
        if (idCliente == null || idCliente.isEmpty()) {
            out.print("Error: El ID del cliente no puede estar vacío.");
            return;
        }

        // Verificar si `cadenaArticulos` y `cadenaMediosPago` están vacíos
        if (cadenaArticulos == null || cadenaArticulos.isEmpty()) {
            out.print("Error: La cadena de artículos está vacía.<br>");
            return;
        }
        if (cadenaMediosPago == null || cadenaMediosPago.isEmpty()) {
            out.print("Error: La cadena de medios de pago está vacía.<br>");
            return;
        }

        // Procesar la cadena de artículos
        String[] articulos = cadenaArticulos.split("\\|\\|");
        StringBuilder cadenaArticulosFormateada = new StringBuilder();
        for (String articulo : articulos) {
            String[] datosArticulo = articulo.split("\\|");
            if (datosArticulo.length == 2) {
                cadenaArticulosFormateada.append(datosArticulo[0])  // idArticulo
                                          .append("|")
                                          .append(datosArticulo[1])  // cantidad
                                          .append("||");
            } else {
                out.print("Formato incorrecto en cadena de artículos: " + articulo + "<br>");
            }
        }
        if (cadenaArticulosFormateada.length() > 0) {
            cadenaArticulosFormateada.setLength(cadenaArticulosFormateada.length() - 2); // Remueve el último '||'
        }

        // Procesar la cadena de medios de pago
        String[] mediosPago = cadenaMediosPago.split("\\|\\|");
        StringBuilder cadenaMediosPagoFormateada = new StringBuilder();
        for (String medio : mediosPago) {
            String[] datosMedio = medio.split("\\|");
            if (datosMedio.length == 2) {
                cadenaMediosPagoFormateada.append(datosMedio[0])  // idMedioPago
                                           .append("|")
                                           .append(datosMedio[1])  // valor
                                           .append("||");
            } else {
                out.print("Formato incorrecto en cadena de medios de pago: " + medio + "<br>");
            }
        }
        if (cadenaMediosPagoFormateada.length() > 0) {
            cadenaMediosPagoFormateada.setLength(cadenaMediosPagoFormateada.length() - 2); // Remueve el último '||'
        }

        // Depuración para confirmar las cadenas procesadas
        out.print("Cadena de Artículos procesada: " + cadenaArticulosFormateada.toString() + "<br>");
        out.print("Cadena de Medios de Pago procesada: " + cadenaMediosPagoFormateada.toString() + "<br>");

        if ("Adicionar".equalsIgnoreCase(accion)) {
            // Registrar la venta utilizando el procedimiento almacenado
            boolean resultado = venta.registrarVentaConPedido(idPedido, idCliente, cadenaArticulosFormateada.toString(), cadenaMediosPagoFormateada.toString());

            if (!resultado) {
                out.print("Error al registrar la venta. Por favor, verifica los datos e intenta nuevamente.");
            } else {
                out.print("Venta registrada correctamente.");
            }
        } else if ("Modificar".equalsIgnoreCase(accion)) {
            out.print("La funcionalidad de modificación aún no está implementada.");
        }
    }

    
%>

<script type="text/javascript">
    setTimeout(function() {
        document.location = "principal.jsp?CONTENIDO=pedidos.jsp";
    }, 0000); // Redirigir después de 2 segundos
</script>
