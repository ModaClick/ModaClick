<%@page import="java.util.List"%>
<%@page import="clases.Pedido"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    Pedido pedido = new Pedido();

    // Verificar el valor de la acción
    if (accion != null && ("Adicionar".equalsIgnoreCase(accion) || "Modificar".equalsIgnoreCase(accion))) {

        // Obtener los datos del formulario
        String idCliente = request.getParameter("cliente").trim();
        String fecha = request.getParameter("fecha");
        String idTipoEnvio = request.getParameter("tipoEnvio");
        String estado = request.getParameter("estado");
        String cadenaArticulos = request.getParameter("articulosVendidos");

        // Verificar el valor de estado antes de pasarlo al procedimiento
        if (estado == null || estado.isEmpty()) {
            estado = "Por entregar"; // Establecer un valor predeterminado si está vacío
        }

        // Verificar la fecha y asignar la actual si está vacía
        if (fecha == null || fecha.isEmpty()) {
            fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        }

        // Asignar los valores al objeto pedido
        pedido.setIdCliente(idCliente);
        pedido.setFecha(fecha);
        pedido.setIdTipoEnvio(idTipoEnvio);
        pedido.setEstado(estado);

        // Convertir la cadena de artículos al formato adecuado 'idArticulo|cantidad||'
        String[] articulos = cadenaArticulos.split(";");
        StringBuilder cadenaFormateada = new StringBuilder();
        for (String articulo : articulos) {
            String[] datosArticulo = articulo.split(",");
            if (datosArticulo.length == 2) {
                cadenaFormateada.append(datosArticulo[0])  // idArticulo
                                .append("|")
                                .append(datosArticulo[1])  // cantidad
                                .append("||");
            }
        }

        // Remover el último '||' de la cadena formateada
        if (cadenaFormateada.length() > 0) {
            cadenaFormateada.setLength(cadenaFormateada.length() - 2);
        }

        if ("Adicionar".equalsIgnoreCase(accion)) {
            // Registrar el pedido utilizando el procedimiento almacenado
            boolean resultado = pedido.grabarConProcedimiento(cadenaFormateada.toString());

            if (!resultado) {
                out.print("Error al registrar el pedido. Por favor, verifica los datos e intenta nuevamente.");
            } else {
                out.print("Pedido registrado correctamente.");
            }
        } else if ("Modificar".equalsIgnoreCase(accion)) {
            // Obtener el ID del pedido para modificar
            String idPedido = request.getParameter("idPedido").trim();
            pedido.setId(idPedido);

            // Modificar el pedido utilizando el procedimiento almacenado
            boolean resultado = pedido.modificarConProcedimiento(cadenaFormateada.toString());

            if (!resultado) {
                out.print("Error al modificar el pedido. Por favor, verifica los datos e intenta nuevamente.");
            } else {
                out.print("Pedido modificado correctamente.");
            }
        }

        // Imprimir para depuración (elimina después de probar)
        out.print("Valor de estado: " + estado + "<br>");
        out.print("Cliente: " + idCliente + "<br>");
        out.print("Fecha: " + fecha + "<br>");
        out.print("Tipo de Envío: " + idTipoEnvio + "<br>");
        out.print("Cadena de Artículos: " + cadenaFormateada.toString() + "<br>");
    }

    if ("Eliminar".equalsIgnoreCase(accion)) {
        // Obtener el ID del pedido a eliminar
        String idPedido = request.getParameter("id").trim();

        // Validar que el ID no sea nulo ni vacío
        if (idPedido != null && !idPedido.isEmpty()) {
            pedido.setId(idPedido);
            boolean eliminado = pedido.eliminar(); // Llamar al método eliminar

            if (!eliminado) {
                out.print("Error al eliminar el pedido. Por favor, verifica el ID e intenta nuevamente.");
            } else {
                out.print("Pedido eliminado correctamente.");
            }
        } else {
            out.print("El ID del pedido es inválido para la eliminación.");
        }
    }
%>

<!-- Redireccionar de nuevo a la página de pedidos -->
<script type="text/javascript">
    setTimeout(function() {
        document.location = "principal.jsp?CONTENIDO=pedidos.jsp";
    }, 2000); // Redirigir después de 2 segundos
</script>
