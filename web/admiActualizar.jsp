<%-- 
    Document   : admiActualizar
    Created on : 13/09/2024, 12:20:36 AM
    Author     : casa
--%>

<%@ page import="clases.Persona" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Administrador</title>
</head>
<body>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        boolean success = false;

        if ("add".equals(action)) {
            Persona administrador = new Persona();
            administrador.setIdentificacion(request.getParameter("identificacion"));
            administrador.setNombre(request.getParameter("nombre"));
            administrador.setTelefono(request.getParameter("telefono"));
            administrador.setGenero(request.getParameter("genero"));
            administrador.setCorreoElectronico(request.getParameter("correoElectronico"));
            administrador.setTipo("A"); // Administrador por defecto

            // Establece la clave solo si se proporciona una nueva
            String clave = request.getParameter("clave");
            if (clave != null && !clave.trim().isEmpty()) {
                administrador.setClave(clave);
            }

            success = administrador.grabar();
        } else if ("edit".equals(action)) {
            String oldId = request.getParameter("oldId");
            Persona administrador = new Persona(oldId);
            administrador.setIdentificacion(request.getParameter("identificacion"));
            administrador.setNombre(request.getParameter("nombre"));
            administrador.setTelefono(request.getParameter("telefono"));
            administrador.setGenero(request.getParameter("genero"));
            administrador.setCorreoElectronico(request.getParameter("correoElectronico"));

            // Establece la clave solo si se proporciona una nueva
            String clave = request.getParameter("clave");
            if (clave != null && !clave.trim().isEmpty()) {
                administrador.setClave(clave);
            }

            success = administrador.modificar(oldId);
        } else if ("delete".equals(action)) {
            Persona administrador = new Persona(id);
            success = administrador.eliminar();
        }

        if (success) {
            response.sendRedirect("administradores.jsp");
        } else {
            out.println("Error al realizar la acción.");
        }
    %>
</body>
</html>
