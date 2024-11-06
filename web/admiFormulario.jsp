<%@page import="clases.TipoGenero"%>
<%@ page import="clases.Persona" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Administrador</title>
</head>
<body>
    <h1>Formulario de Administrador</h1>
    <%
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        Persona administrador = "edit".equals(action) ? new Persona(id) : new Persona();
    %>
    <form action="admiActualizar.jsp" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        
        <% if ("edit".equals(action)) { %>
        <input type="hidden" name="oldId" value="<%= administrador.getIdentificacion() %>">
        <% } %>

        <label for="identificacion">Identificación:</label>
        <input type="text" id="identificacion" name="identificacion" value="<%= administrador.getIdentificacion() %>" <%= "edit".equals(action) ? "readonly" : "" %>><br>

        <label for="nombre">Nombre:</label>
        <input type="text" id="nombre" name="nombre" value="<%= administrador.getNombre() %>"><br>

        <label for="telefono">Teléfono:</label>
        <input type="text" id="telefono" name="telefono" value="<%= administrador.getTelefono() %>"><br>

        <label>Género:</label>
        <%= new TipoGenero(administrador.getGenero()).getRadioButtons() %><br>

        <label for="correoElectronico">Correo Electrónico:</label>
        <input type="email" id="correoElectronico" name="correoElectronico" value="<%= administrador.getCorreoElectronico() %>"><br>

        <!-- Campo de clave para modificación -->
        <label for="clave">Clave:</label>
        <input type="password" id="clave" name="clave" placeholder="Ingrese nueva clave (deje en blanco para no cambiar)"><br>

        <input type="hidden" name="tipo" value="A"> <!-- Tipo está predeterminado como Administrador -->

        <input type="submit" value="<%= "edit".equals(action) ? "Modificar" : "Adicionar" %>">
    </form>
    <a href="administradores.jsp">Volver a la lista de administradores</a>
</body>
</html>
