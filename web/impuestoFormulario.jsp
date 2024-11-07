<%@ page import="clases.Impuesto" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Impuestos</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Estilo del contenedor del formulario */
        .form-container {
            max-width: 500px; /* Ancho máximo del formulario */
            margin: 50px auto; /* Centrar el formulario y agregar margen superior */
            padding: 20px; /* Espaciado interno */
            background: linear-gradient(to bottom left, #cccccc, #ccffff); /* Degradado suave entre azul claro y gris */
            border-radius: 8px; /* Bordes redondeados */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Sombra del formulario */
        }

        /* Estilo del encabezado del formulario */
        h2 {
            text-align: center; /* Centrar el texto */
            color: #333333; /* Color del texto */
            font-size: 24px; /* Tamaño de fuente */
            font-weight: bold; /* Negrita */
            margin-bottom: 20px; /* Margen inferior */
        }

        /* Estilo de los botones */
        .btn-submit {
            background-color: #007BFF; /* Color del botón */
            color: white; /* Color del texto */
            border: none; /* Sin borde */
            border-radius: 30px; /* Bordes redondeados */
            padding: 10px 20px; /* Espaciado interno */
            font-size: 16px; /* Tamaño de fuente */
            cursor: pointer; /* Cambia el cursor al pasar sobre el botón */
            transition: background-color 0.3s ease; /* Transición de color */
            width: 100%; /* Botón de ancho completo */
        }

        .btn-submit:hover {
            background-color: #0056b3; /* Color del botón al pasar el mouse */
        }

        /* Estilo de las etiquetas */
        label {
            font-weight: bold; /* Negrita */
        }
    </style>
    <script>
        window.onload = function() {
            const porcentajeInput = document.getElementById('porcentaje');
            const form = document.getElementById('impuestoForm');
            form.addEventListener('submit', function(e) {
                let value = porcentajeInput.value;
                if (value.includes('%')) {
                    porcentajeInput.value = value.replace('%', '');
                }
            });
        };
    </script>
</head>
<body class="bg-light">
    <%
        String action = request.getParameter("action");
        String idImpuesto = request.getParameter("id");
        String nombre = "";
        String porcentaje = "";
        String descripcion = "";

        Impuesto impuesto = new Impuesto();

        if ("update".equals(action) && idImpuesto != null) {
            try {
                impuesto = new Impuesto(idImpuesto); 
                nombre = impuesto.getNombre();
                porcentaje = String.valueOf(impuesto.getPorcentaje());
                descripcion = impuesto.getDescripcion();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        }
    %>

    <div class="form-container">
        <h2><%= "adicionar".equals(action) ? "AGREGAR IMPUESTO" : "MODIFICAR IMPUESTO" %></h2>
        
        <form id="impuestoForm" action="impuestoActualizar.jsp" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            
            <div class="form-group">
                <label for="id">ID:</label>
                <% if ("adicionar".equals(action)) { %>
                    <span>Sin generar</span>
                <% } else { %>
                    <input type="text" id="id" name="id" value="<%= idImpuesto %>" readonly class="form-control">
                <% } %>
            </div>

            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" value="<%= nombre %>" required class="form-control">
            </div>
            
            <div class="form-group">
                <label for="porcentaje">Porcentaje:</label>
                <input type="number" id="porcentaje" name="porcentaje" value="<%= porcentaje %>" min="0" step="1" placeholder="0" required class="form-control">
                <span class="percentage-symbol">%</span>
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción:</label>
                <textarea id="descripcion" name="descripcion" required class="form-control"><%= descripcion %></textarea>
            </div>
            
            <button type="submit" class="btn-submit"><%= "adicionar".equals(action) ? "Agregar" : "Actualizar" %></button>
        </form>
    </div>

    <br>
    <a href="impuesto.jsp">
        <img src="presentacion/regresar.png" width='30' height='30' title='Regresar'>
    </a>
</body>
</html>
