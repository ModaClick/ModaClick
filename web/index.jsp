
<%-- 
    Document   : index
    Created on : 25/04/2024, 07:56:05 AM
    Author     : SENA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    String mensaje="";
    if(request.getParameter("error")!=null){
        switch(request.getParameter("error")){
            case "1": mensaje="usuario o contraseña no valida"; break;
            case "2": mensaje="Aceso denegado"; break;
            default: mensaje="Error desconocido";
                
        }
    }
    
 %>
 
 <html>
     <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <title>Software de inventario</title>
         <link rel="stylesheet" href="presentacion.css">
     </head>
     <body>
     <center>
         <h3>Inventario</h3>
         <p id="error"><%=mensaje%></p>
         <form name="formulario" method="post" action="validar.jsp">
             <table border="0">
                 <tr><td>Usuario</td><td><input type="text" name="identificacion" required></td></tr>
                 <tr><td>Contraseña</td><td><input type="password" name="clave" required></td></tr>
             </table>
             <p>
                 <input type="submit" value="Iniciar">
             </p>
         </form>
     </center>
     </body>
 </html>

