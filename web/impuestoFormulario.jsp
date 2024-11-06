<%@ page import="clases.Impuesto" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulario de Impuestos</title>
    <style>
        .percentage-container {
            position: relative;
            display: inline-block; 
            width: 100%;
        }

        .percentage-symbol {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: bold;
            pointer-events: none; 
        }

        .form-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-group {
            margin-bottom: 15px;
            position: relative;
        }

        label {
            display: block;
            font-weight: bold;
        }

        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        input[type="number"] {
            padding-right: 30px; 
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
<body>
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
        <h2><%= "adicionar".equals(action) ? "Agregar Impuesto" : "Modificar Impuesto" %></h2>
        
        <form id="impuestoForm" action="impuestoActualizar.jsp" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            
            <div class="form-group">
                <label for="id">ID:</label>
                <% if ("adicionar".equals(action)) { %>
                    <span>Sin generar</span>
                <% } else { %>
                    <input type="text" id="id" name="id" value="<%= idImpuesto %>" readonly>
                <% } %>
            </div>

            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" value="<%= nombre %>" required>
            </div>
            
            <div class="form-group">
                <label for="porcentaje">Porcentaje:</label>
                <div class="percentage-container">
                    <input type="number" id="porcentaje" name="porcentaje" value="<%= porcentaje %>" min="0" step="1" placeholder="0" required>
                    <span class="percentage-symbol">%</span>
                </div>
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción:</label>
                <textarea id="descripcion" name="descripcion" required><%= descripcion %></textarea>
            </div>
            
            <button type="submit"><%= "adicionar".equals(action) ? "Agregar" : "Actualizar" %></button>
        </form>
    </div>

    <br>
    <a href="impuesto.jsp">
        <img src="presentacion/regresar.png" width='30' height='30' title='Regresar'>
    </a>
</body>
</html>
