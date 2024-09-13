<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Administradores</title>
</head>
<body>
    <h1>Administradores</h1>
    <a href="admiFormulario.jsp?action=add">Adicionar Nuevo Administrador</a>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Teléfono</th>
                <th>Género</th>
                <th>Correo Electrónico</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <% 
                // Obtener la lista de administradores
                // Filtro añadido: "tipo='A'"
                List<Persona> administradores = Persona.getListaEnObjetos("tipo='A'", "nombre");
                
                // Recorrer la lista de administradores y mostrar los datos en la tabla
                for (Persona administrador : administradores) { 
            %>
            <tr>
                <td><%= administrador.getIdentificacion() %></td>
                <td><%= administrador.getNombre() %></td>
                <td><%= administrador.getTelefono() %></td>
                <td><%= administrador.getGenero() %></td>
                <td><%= administrador.getCorreoElectronico() %></td>
                <td>
                    <!-- Enlaces para modificar, eliminar y ver compras pendientes -->
                    <a href="admiFormulario.jsp?action=edit&id=<%= administrador.getIdentificacion() %>">Modificar</a>
                    <a href="admiActualizar.jsp?action=delete&id=<%= administrador.getIdentificacion() %>">Eliminar</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
