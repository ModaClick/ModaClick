<%-- 
    Document   : medioDepago
    Created on : 9/09/2024, 02:55:30 PM
    Author     : casa
--%>

<%@page import="java.util.List"%>
<%@page import="clases.MedioDePago"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String lista = "";
  List<MedioDePago> datos = MedioDePago.getListaEnObjetos(null, null);
  for (int i = 0; i < datos.size(); i++) {
        MedioDePago medioPago = datos.get(i);
        lista += "<tr>";
        lista += "<td>" + medioPago.getId() + "</td>";
        lista += "<td>" + medioPago.getTipoPago() + "</td>";
        lista += "<td>" + medioPago.getDescripcionMetodoPago() + "</td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=medioDePagoFormulario.jsp&accion=Modificar&id=" + medioPago.getId() + 
                "' title='Modificar'><img src='Presentacion/Imagenes/modificar.png'></a> ";
        lista += "<img src='Presentacion/Imagenes/eliminar.png' title='Eliminar' onClick='eliminar(" + medioPago.getId() + ")'>";
        lista += "</td>";
        lista += "</tr>";
  }
%>
<h3>LISTAS DE MEDIOS DE PAGO</h3>
<table border="1">
    <tr>
        <th>ID</th><th>Tipo de Pago</th><th>Descripción</th>
        <th><a href="principal.jsp?CONTENIDO=medioDePagoFormulario.jsp&accion=Adicionar" title="Adicionar"> 
                <img src="Presentacion/Imagenes/agregar.png"></a></th>
    </tr>
    <%=lista%>
</table>
<script>
    function eliminar(id) {
        var resultado = confirm("Realmente desea eliminar este medio de pago " + id + " del sistema?");
        if (resultado) {
            document.location = "principal.jsp?CONTENIDO=medioDePagoActualizar.jsp&accion=Eliminar&id=" + id;   
        }   
    }
</script>


