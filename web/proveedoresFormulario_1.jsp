<%-- 
    Document   : proveedoresFormulario
    Created on : 16/09/2024, 02:39:58 PM
    Author     : SARA
--%>

<%@ page import="clases.Persona" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= request.getParameter("action").equals("edit") ? "Modificar Proveedor" : "Agregar Proveedor" %></title>
</head>
<body>

<%
    String action = request.getParameter("action");
    Persona proveedor = new Persona();

    if ("edit".equals(action)) {
        String id = request.getParameter("id");
        proveedor = new Persona(id);  // Se carga el proveedor por su ID para modificar
    }
%>

<h1><%= action.equals("edit") ? "Modificar Proveedor" : "Agregar Proveedor" %></h1>

<form method="POST" action="proveedoresActualizar.jsp">
    <input type="hidden" name="action" value="<%= action %>">
    <input type="hidden" name="oldId" value="<%= proveedor.getIdentificacion() %>">

    <label>Identificación:</label>
    <input type="text" name="identificacion" value="<%= proveedor.getIdentificacion() %>" required><br>

    <label>Nombre:</label>
    <input type="text" name="nombre" value="<%= proveedor.getNombre() %>" required><br>

    <label>Teléfono:</label>
    <input type="text" name="telefono" value="<%= proveedor.getTelefono() %>" required><br>

    <label>Género:</label>
    <select name="genero">
        <option value="M" <%= proveedor.getGenero().equals("M") ? "selected" : "" %>>Masculino</option>
        <option value="F" <%= proveedor.getGenero().equals("F") ? "selected" : "" %>>Femenino</option>
    </select><br>

    <label>Correo Electrónico:</label>
    <input type="email" name="correoElectronico" value="<%= proveedor.getCorreoElectronico() %>" required><br>

    <button type="submit">Guardar</button>
</form>

</body>
</html>
