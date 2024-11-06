<%@ page import="java.util.List" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Administradores</title>
    <link rel="stylesheet" href="presentacion/tablas.css">
</head>
<body>
    <h3>Administradores</h3>
    <a href="admiFormulario.jsp?action=add">Adicionar Nuevo Administrador</a>
    <div class="tabla-container">
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
    </div>
</body>
</html>
