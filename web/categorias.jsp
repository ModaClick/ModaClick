<%@page import="java.util.List"%>
<%@page import="clases.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Categorías</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"> <!-- Para íconos de Bootstrap -->
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="card">
        <div class="card-header text-center">
            <h3>Lista de Categorías</h3>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String lista = "";
                            List<Categoria> datos = Categoria.getListaEnObjetos(null, null);
                            for (int i = 0; i < datos.size(); i++) {
                                Categoria categoria = datos.get(i);
                                lista += "<tr>";
                                lista += "<td>" + categoria.getIdCategoria() + "</td>";
                                lista += "<td>" + categoria.getNombre() + "</td>";
                                lista += "<td>" + categoria.getDescripcion() + "</td>";
                                lista += "<td>";
                                lista += "<a href='principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Modificar&id=" + categoria.getIdCategoria() + "' class='btn btn-sm btn-warning'><i class='bi bi-pencil'></i> Modificar</a> ";
                                lista += "<button class='btn btn-sm btn-danger' onclick='confirmarEliminacion(" + categoria.getIdCategoria() + ");'><i class='bi bi-trash'></i> Eliminar</button>";
                                lista += "</td>";
                                lista += "</tr>";
                            }
                        %>
                        <%=lista%>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer text-center">
            <a href="principal.jsp?CONTENIDO=categoriaFormulario.jsp&accion=Adicionar" class="btn btn-primary"><i class="bi bi-plus-lg"></i> Adicionar Categoría</a>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    function confirmarEliminacion(id) {
        let respuesta = confirm("¿Realmente desea eliminar el registro?");
        if (respuesta) {
            document.location = "principal.jsp?CONTENIDO=categoriasActualizar.jsp&accion=Eliminar&id=" + id;
        }
    }
</script>
</body>
</html>
