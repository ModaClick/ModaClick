<%-- 
    Document   : enviosActualizar
    Created on : 10/09/2024, 07:59:49 AM
    Author     : User
--%>

<%@page import="clases.TipoEnvio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String accion=request.getParameter("accion");
  String nombre=request.getParameter("nombre");
  String descripcion = request.getParameter("descripcion");
  TipoEnvio envio = new TipoEnvio();
  envio.setNombre(nombre);
  envio.setDescripcion(descripcion);
  switch(accion){
      case "Adicionar":
          envio.grabar();
          break;
      case "Modificar":
          envio.setId(request.getParameter("id"));
          envio.modificar();
          break;
      case "Eliminar":
      envio.setId(request.getParameter("id"));
      envio.eliminar();
      break;
  }  
%>
<script type="text/javascript">
    document.location="principal.jsp?CONTENIDO=tiposEnvio.jsp";
</script>