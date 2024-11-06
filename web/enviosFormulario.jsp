<%-- 
    Document   : enviosFormulario
    Created on : 10/09/2024, 07:51:19 AM
    Author     : User
--%>

<%@page import="clases.TipoEnvio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
  String accion = request.getParameter("accion");
  String id ="Sin generar";
  String nombre = "";
  String descripcion = "";
  if(accion.equals("Modificar")){
      id = request.getParameter("id");
      TipoEnvio envio = new TipoEnvio(id);
      nombre = envio.getNombre();
      descripcion = envio.getDescripcion();
  }  
%>
<div class="form-container">
    <h3><%=accion.toUpperCase()%> TIPOS DE ENVÍO</h3>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=enviosActualizar.jsp">
        <table border ="0">
            <tr><th>Código</th><td><%= id %></td></tr>
            <tr><th>Nombre</th><td><input type="text" name="nombre" value="<%= nombre %>" size="50" maxlength="50" required></td></tr>
            <tr><th>Descripción</th><td><textarea name="descripcion" cols="50" rows="5"><%= descripcion %></textarea></td></tr>
        </table>
        <p>
            <input type="hidden" name="id" value="<%=id%>">
            <input type="submit" name="accion" value="<%=accion%>">
        </p>
    </form>
</div>
