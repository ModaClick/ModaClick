<%-- 
    Document   : categoriasFormulario
    Created on : 30/04/2024, 11:50:57 AM
    Author     : SENA
--%>

<%@page import="clases.Categoria"%>
<%
    String accion=request.getParameter("accion");
    String id="sin generar";
    String nombre="";
    String descripcion="";
    
    if(accion.equals("Modificar")) {
       id=request.getParameter("id");
       Categoria categoria=new Categoria(id);
       nombre=categoria.getNombre();
       descripcion=categoria.getDescripcion();
    }
%>

<h3><%=accion.toUpperCase() %> CATEGORIA</h3>
<form name="formulario" method="post" action="principal.jsp?CONTENIDO=categoriasActualizar.jsp">
    <table border="0">
    <tr><th>Id</th><td><%=id%></td></tr>
    <tr><th>Nombre</th><td><input type="text" name="nombre" value="<%=nombre%>" size="50" maxlength="50" required=></td></tr>
    <tr><th>Descripcion</th><td><textarea name="descripcion" cols="50" rows="5"><%=descripcion%></textarea></td></tr>
    </table>
    
    <input type="hidden" name="id" value="<%=id%>">
    <input type="submit" name="accion" value="<%=accion%>">
   </form> 