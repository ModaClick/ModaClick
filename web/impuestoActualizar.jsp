<%@ page import="clases.Impuesto" %>
<%
    String action = request.getParameter("action");
    String idImpuesto = request.getParameter("id"); 
    String nombre = request.getParameter("nombre");
    String porcentaje = request.getParameter("porcentaje");
    String descripcion = request.getParameter("descripcion");

    Impuesto impuesto = new Impuesto();
    
    try {
        if ("adicionar".equals(action)) {
            impuesto.setNombre(nombre);
            impuesto.setPorcentaje(Integer.parseInt(porcentaje));
            impuesto.setDescripcion(descripcion);
            impuesto.grabar(); 
        } else if ("update".equals(action) && idImpuesto != null) {
            impuesto.setId(idImpuesto);
            impuesto.setNombre(nombre);
            impuesto.setPorcentaje(Integer.parseInt(porcentaje));
            impuesto.setDescripcion(descripcion);
            impuesto.modificar(); 
        } else if ("Eliminar".equals(action) && idImpuesto != null) {
            impuesto.setId(idImpuesto);
            impuesto.eliminar(); 
        }

        response.sendRedirect("principal.jsp?CONTENIDO=impuesto.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
