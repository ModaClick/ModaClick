<%-- 
    Document   : validar
    Created on : 25/04/2024, 08:02:19 AM
    Author     : SENA
--%>

<%@page import="clases.Persona"%>
<%
 String identificacion=request.getParameter("identificacion");
 String clave=request.getParameter("clave");
 Persona usuario=Persona.validar(identificacion, clave);
 System.out.println("Identificaci�n recibida: " + identificacion);
    System.out.println("Clave recibida: " + clave);
 if(usuario!=null){
     HttpSession sesion=request.getSession();
     sesion.setAttribute("usuario", usuario);
     response.sendRedirect("principal.jsp?CONTENIDO=inicio.jsp");
 }else{
     response.sendRedirect("index.jsp?error=1");
 }
%>
    
 