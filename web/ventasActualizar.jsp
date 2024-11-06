<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");
    Venta venta = new Venta();

    switch (accion) {
        case "Adicionar":
            // Obtener el ID del cliente
            String idCliente = request.getParameter("cliente").substring(0, request.getParameter("cliente").indexOf("-")).trim();
            
            // Obtener la cadena de artículos vendidos
            String cadenaArticulos = request.getParameter("articulosVendidos");
            
            // Inicializar la cadena para medios de pago
            String cadenaMediosPago = "";

            // Procesar los medios de pago
            List<MedioDePago> datosMediosPago = MedioDePago.getListaEnObjetos(null, null);
            for (int i = 0; i < datosMediosPago.size(); i++) {
                MedioDePago medioPago = datosMediosPago.get(i);
                // Verificar si el valor del medio de pago está presente
                if (request.getParameter("valor" + medioPago.getId()) != null) {
                    int valor = Integer.parseInt(request.getParameter("valor" + medioPago.getId()));
                    if (valor > 0) {
                        // Formatear la cadena de medios de pago
                        if (!cadenaMediosPago.equals("")) {
                            cadenaMediosPago += "||";
                        }
                        cadenaMediosPago += medioPago.getId() + "|" + valor;
                    }
                }
            }

            // Imprimir para depuración (puedes eliminar estas líneas una vez confirmado el formato)
            out.print("Identificacion: " + idCliente + "<br>");
            out.print("Cadena de Productos: " + cadenaArticulos + "<br>");
            out.print("Cadena de Medios de Pago: " + cadenaMediosPago + "<br>");
            
            // Asignar el cliente a la venta
            venta.setIdCliente(idCliente);
            
            // Grabar la venta utilizando el procedimiento almacenado
            venta.grabarConProcedimientoAlmacenado(cadenaArticulos, cadenaMediosPago);
            break;

        case "Eliminar":
            // Obtener y eliminar la venta por ID
            venta.setIdVenta(request.getParameter("idVenta"));
            venta.eliminar();
            break;
    }
%>

<!-- Redireccionar de nuevo a la página de ventas -->
<script type="text/javascript">
    document.location="principal.jsp?CONTENIDO=ventas.jsp";
</script>
