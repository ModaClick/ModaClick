<%-- 
    Document   : clientesFormulario
    Created on : 12/09/2024, 11:27:53 PM
    Author     : casa
--%>
<%@ page import="clases.TipoGenero" %>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Cliente</title>
</head>
<body>
    <h1>Formulario de Cliente</h1>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        Persona cliente = "edit".equals(action) ? new Persona(id) : new Persona();
    %>
    <form action="clientesActualizar.jsp" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        
        <% if ("edit".equals(action)) { %>
        <input type="hidden" name="oldId" value="<%= cliente.getIdentificacion() %>">
        <% } %>

        <label for="identificacion">Identificación:</label>
        <input type="text" id="identificacion" name="identificacion" value="<%= cliente.getIdentificacion() %>" <%= "edit".equals(action) ? "readonly" : "" %>><br>

        <label for="nombre">Nombre:</label>
        <input type="text" id="nombre" name="nombre" value="<%= cliente.getNombre() %>"><br>

        <label for="telefono">Teléfono:</label>
        <input type="text" id="telefono" name="telefono" value="<%= cliente.getTelefono() %>"><br>

        <label>Género:</label>
        <%= new TipoGenero(cliente.getGenero()).getRadioButtons() %><br>

        <label for="correoElectronico">Correo Electrónico:</label>
        <input type="email" id="correoElectronico" name="correoElectronico" value="<%= cliente.getCorreoElectronico() %>"><br>

        <input type="hidden" name="tipo" value="C"> <!-- Tipo está predeterminado como Cliente -->

        <input type="submit" value="<%= "edit".equals(action) ? "Modificar" : "Adicionar" %>">
    </form>
    <a href="principal.jsp?CONTENIDO=clientes.jsp">Volver a la lista de clientes</a>
</body>
</html>
