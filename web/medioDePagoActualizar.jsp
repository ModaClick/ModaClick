<%-- 
    Document   : medioDePagoActualizar
    Created on : 9/09/2024, 03:03:50 PM
    Author     : casa
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="clases.MedioDePago"%>
<%
    String accion = request.getParameter("accion");
    String tipoPago = request.getParameter("tipoPago");
    String descripcionMetodoPago = request.getParameter("descripcionMetodoPago");
    
    MedioDePago medioDePago = new MedioDePago();
    medioDePago.setTipoPago(tipoPago);
    medioDePago.setDescripcionMetodoPago(descripcionMetodoPago);
    
    switch (accion) {
        case "Adicionar":
            medioDePago.grabar();
            break;
        case "Modificar":
            medioDePago.setId(request.getParameter("id"));
            medioDePago.modificar();
            break;
        case "Eliminar":
            medioDePago.setId(request.getParameter("id"));
            medioDePago.eliminar();
            break;
    }
%>
<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=mediosDePago.jsp";
</script>
