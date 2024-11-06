<%@ page import="java.util.List" %>
<%@ page import="clases.Impuesto" %>
<%@ page import="clasesGenericas.ConectorBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Impuestos</title>
    <script type="text/javascript">
        function confirmarEliminacion(idImpuesto) {
            var confirmacion = confirm("¿Está seguro de que desea eliminar este impuesto?");
            if (confirmacion) {
                window.location.href = "impuestoActualizar.jsp?action=Eliminar&id=" + idImpuesto;
            }
        }
    </script>
</head>
<body>
    <h2>Impuestos</h2>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Porcentaje</th>
            <th>Descripción</th>
            <th>
                <a href="impuestoFormulario.jsp?action=adicionar">
                    <img src="presentacion/adicionar.png" width='30' height='30' title='Adicionar'>
                </a>
            </th>
        </tr>
        <%
            try {
                List<Impuesto> listaImpuestos = Impuesto.getListaEnObjetos(null, "nombre"); 
                
                for (Impuesto imp : listaImpuestos) {
        %>
        <tr>
            <td><%= imp.getId() %></td>
            <td><%= imp.getNombre() %></td>
            <td><%= imp.getPorcentaje() %>%</td>
            <td><%= imp.getDescripcion() %></td>
            <td>
                <a href="javascript:confirmarEliminacion('<%= imp.getId() %>')">
                <img src="presentacion/eliminar.png" width='30' height='30' title='Eliminar'></a>
                <a href="impuestoFormulario.jsp?action=update&id=<%= imp.getId() %>">
                <img src="presentacion/modificar.png" width='30' height='30' title='Modificar'></a>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>
</body>
</html>
