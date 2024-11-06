<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");
    Compra compra = new Compra();

    switch (accion) {
        case "Adicionar":
            // Obtener el ID del proveedor
            String idProveedor = request.getParameter("proveedor").substring(0, request.getParameter("proveedor").indexOf("-")).trim();
            
            // Obtener la cadena de artículos comprados
            String cadenaArticulos = request.getParameter("articulosComprados");
            
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
            out.print("Identificacion: " + idProveedor + "<br>");
            out.print("Cadena de Artículos: " + cadenaArticulos + "<br>");
            out.print("Cadena de Medios de Pago: " + cadenaMediosPago + "<br>");
            
            // Asignar el proveedor a la compra
            compra.setIdProveedor(idProveedor);
            
            // Grabar la compra utilizando el procedimiento almacenado
            compra.grabarConProcedimientoAlmacenado(cadenaArticulos, cadenaMediosPago);
            break;

        case "Eliminar":
            // Obtener y eliminar la compra por ID
            compra.setIdCompra(request.getParameter("idCompra"));
            compra.eliminar();
            break;
    }
%>

<!-- Redireccionar de nuevo a la página de compras -->
<script type="text/javascript">
    document.location="principal.jsp?CONTENIDO=compras.jsp";
</script>
