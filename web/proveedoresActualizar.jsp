<%-- 
    Document   : proveedoresActualizar
    Created on : 16/09/2024, 02:39:39 PM
    Author     : SARA
--%>

<%@ page import="clases.Persona" %>

<%
    String action = request.getParameter("action");
    boolean success = false;

    if ("add".equals(action)) {
        Persona proveedor = new Persona();
        proveedor.setIdentificacion(request.getParameter("identificacion"));
        proveedor.setNombre(request.getParameter("nombre"));
        proveedor.setTelefono(request.getParameter("telefono"));
        proveedor.setGenero(request.getParameter("genero"));
        proveedor.setCorreoElectronico(request.getParameter("correoElectronico"));
        proveedor.setTipo("P");  

        success = proveedor.grabar();

    } else if ("edit".equals(action)) {
        String oldId = request.getParameter("oldId");
        Persona proveedor = new Persona(oldId);
        proveedor.setIdentificacion(request.getParameter("identificacion"));
        proveedor.setNombre(request.getParameter("nombre"));
        proveedor.setTelefono(request.getParameter("telefono"));
        proveedor.setGenero(request.getParameter("genero"));
        proveedor.setCorreoElectronico(request.getParameter("correoElectronico"));

        // Llama al método modificar1 en lugar de modificar
        success = proveedor.modificar1(oldId);

    } else if ("delete".equals(action)) {
        String id = request.getParameter("id");
        Persona proveedor = new Persona(id);
        success = proveedor.eliminar();
    }

    if (success) {
        response.sendRedirect("principal.jsp?CONTENIDO=proveedores.jsp");
    } else {
        out.println("Error al realizar la acción.");
    }
%>
