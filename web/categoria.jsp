<%-- 
    Document   : categorias
    Created on : 30/04/2024, 09:01:00 AM
    Author     : SENA
--%>

<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String lista = "";
    List<Categoria> datos = Categoria.getListaEnObjetos(null, null);
    for (int i = 0; i < datos.size(); i++) {
        Categoria categoria = datos.get(i);
        lista += "<tr>";
        lista += "<td>" + categoria.getIdCategoria()+ "</td>";
        lista += "<td>" + categoria.getNombre() + "</td>";
        lista += "<td>" + categoria.getDescripcion() + "</td>";
        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Modificar&id=" + categoria.getIdCategoria()+ "'><img src='Presentacion/imagenes/modificar.jpg' style='width: 20px; height: 20px;'></a>";
        lista += "<label onClick='confirmarEliminacion(" + categoria.getIdCategoria()+ ");'> <img src='Presentacion/imagenes/eliminar.png' style='width: 20px; height: 20px;'></label>";
        //lista += "<img src='Presentacion/imagenes/eliminar.png' style='width: 20px; height: 20px;' title='Eliminar' onClick='eliminar(" + categoria.getId()+ ")'>";
        lista += "</td>";
        lista += "</tr>";
    }
%>
<h3>LISTA DE CATEGORIAS</h3>
<table border="1">
    <tr>
        <th>ID</th><th>Nombre</th><th>Descripción</th>
        <th><a href='principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Adicionar'> 
                 <img src="Presentacion/imagenes/adicionar.jpg" style="width: 20px; height: 20px;">
            </a>
        </th>
    </tr>
    <%=lista%>
</table>

<script type="text/javascript">
    function prueba(){
        alert("Prueba");
    }
    function confirmarEliminacion(id) {
        respuesta = confirm("Realmente desea eliminar el registro?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=categoriasActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }
</script>