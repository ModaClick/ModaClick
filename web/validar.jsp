<%@page import="clases.Persona"%>
<%
    
String identificacion=request.getParameter("identificacion");
String clave=request.getParameter("clave");
Persona usuario=Persona.validar(identificacion, clave);
if (usuario!=null){
    HttpSession sesion=request.getSession();
    sesion.setAttribute("usuario", usuario);
    response.sendRedirect("principal.jsp?CONTENIDO=inicio.jsp");
} else {
    response.sendRedirect("index.jsp?error=1");
}

%>
