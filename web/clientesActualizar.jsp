<%-- 
    Document   : clientesActualizar
    Created on : 12/09/2024, 11:52:48 PM
    Author     : casa
--%>
<%@ page import="clases.Persona" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Cliente</title>
</head>
<body>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        boolean success = false;

        if ("add".equals(action)) {
            // Crear un nuevo cliente
            Persona cliente = new Persona();
            cliente.setIdentificacion(request.getParameter("identificacion"));
            cliente.setNombre(request.getParameter("nombre"));
            cliente.setTelefono(request.getParameter("telefono"));
            cliente.setGenero(request.getParameter("genero"));
            cliente.setCorreoElectronico(request.getParameter("correoElectronico"));
            cliente.setTipo("C"); // Cliente por defecto
            success = cliente.grabar();
        } else if ("edit".equals(action)) {
            // Editar un cliente existente
            String oldId = request.getParameter("oldId");
            Persona cliente = new Persona(oldId);
            cliente.setIdentificacion(request.getParameter("identificacion"));
            cliente.setNombre(request.getParameter("nombre"));
            cliente.setTelefono(request.getParameter("telefono"));
            cliente.setGenero(request.getParameter("genero"));
            cliente.setCorreoElectronico(request.getParameter("correoElectronico"));
            success = cliente.modificar(oldId);
        } else if ("delete".equals(action)) {
            // Eliminar un cliente
            Persona cliente = new Persona(id);
            success = cliente.eliminar();
        }

        // Redirigir si la acción fue exitosa
        if (success) {
            response.sendRedirect("principal.jsp?CONTENIDO=clientes.jsp");
        } else {
            out.println("Error al realizar la acción.");
        }
    %>
</body>
</html>
