<%-- 
    Document   : medioDePagoFormulario
    Created on : 9/09/2024, 02:59:22 PM
    Author     : casa
--%>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Medios de Pago</title>
    <link rel="stylesheet" href="presentacion/estilosformulario.css">
</head>
<body>
<%@page import="clases.MedioDePago"%>
<%
   String accion = request.getParameter("accion");
   String id = "sin generar";
   String tipoPago = "";
   String descripcionMetodoPago = "";
   
    if(accion.equals("Modificar")) {
        id = request.getParameter("id");
        MedioDePago medioP = new MedioDePago(id); // Crear instancia de MedioDePago con el id
        tipoPago = medioP.getTipoPago();  
        descripcionMetodoPago = medioP.getDescripcionMetodoPago();
    }
%>

<div id="banner">
    
    <center><form name="formulario" method="post" action="principal.jsp?CONTENIDO=medioDePagoActualizar.jsp">
            <center><h3><%=accion.toUpperCase() %> MEDIOS DE PAGO</h3></center>
        <table border="0">
            <tr><th>Id</th><td><%=id%></td></tr>
            <tr><th>Tipo de Pago</th><td><input type="text" name="tipoPago" value="<%=tipoPago%>" size="50" maxlength="40" required></td></tr>
            <tr><th>Descripción del Método de Pago</th><td><textarea name="descripcionMetodoPago" cols="50" rows="5" required><%=descripcionMetodoPago%></textarea></td></tr>
        </table>
        
        <input type="hidden" name="id" value="<%=id%>">
        <input type="submit" name="accion" value="<%=accion%>">
        </form></center>
</div>

