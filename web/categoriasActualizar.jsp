<%-- 
    Document   : categoriasActualizar
    Created on : 1/05/2024, 05:22:30 PM
    Author     : PC
--%>

<%@page import="clases.Categoria"%>
<%
    String accion=request.getParameter("accion");
    String nombre=request.getParameter("nombre");
    String descripcion=request.getParameter("descripcion");
    Categoria categoria=new Categoria();
    categoria.setNombre(nombre);
    categoria.setDescripcion(descripcion);
    switch(accion){
        case "Adicionar":
            categoria.grabar();
            break;
        case "Modificar":
            categoria.setIdCategoria(request.getParameter("id"));
            categoria.modificar();
            break;
        case "Eliminar":
            categoria.setIdCategoria(request.getParameter("id"));
            categoria.eliminar();
            break;
    }
    
 %>
 <script type="text/javascript">
     document.location="principal.jsp?CONTENIDO=categoria.jsp";
     </script>