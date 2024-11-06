<%-- 
    Document   : tiposDeEnvio
    Created on : 10/09/2024, 07:40:31 AM
    Author     : User
--%>

<%@page import="java.util.List"%>
<%@page import="clases.TipoEnvio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Inventario</title>
    <link rel="stylesheet" href="presentacion/tablas.css">
</head>
<body>
<%
    String lista = "";
    List<TipoEnvio> datos = TipoEnvio.getListaEnObjetos(null, null);
    for (int i = 0; i < datos.size(); i++) {
        TipoEnvio envio = datos.get(i);
        lista += "<td>" + envio.getId() + "</td>";
        lista += "<td>" + envio.getNombre() + "</td>";
        lista += "<td>" + envio.getDescripcion() + "</td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=enviosFormulario.jsp&accion=Modificar&id=" + envio.getId() + "' title='Modificar'><img src='presentacion/modificar.png'></a> ";
        lista += "<img src='presentacion/eliminar.png' title='Eliminar' onClick='confirmarEliminacion(" + envio.getId() + ")'>";
        lista += "</td>";
        lista += "</tr>";
    }
%>

<div class="tabla-container">
    <table class="tabla-categorias">
        <thead>
            
            <th colspan="4">
            <center><h3>TIPOS DE ENVÍO</h3></center></th>
            
        <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Descripción</th>
             
            <th>
                <a href="principal.jsp?CONTENIDO=enviosFormulario.jsp&accion=Adicionar" title="Adicionar">
                    <img src="presentacion/adicionar.png" alt="Adicionar">
                </a>
            </th>
        </tr>
       
    </thead>
    <tbody>
        <%=lista%>
    </tbody>
    </table>
</div>

<script type="text/javascript">
    function confirmarEliminacion(id) {
        var respuesta = confirm("¿Seguro que quieres eliminar el tipo de envío " + id + " del sistema?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=enviosActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }
</script>
</body>
</html>
