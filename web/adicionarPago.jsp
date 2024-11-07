<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="clases.Venta" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= request.getParameter("idPago") != null ? "Modificar Pago" : "Adicionar Pago" %></title>
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
        }

        .btn-submit:hover {
            background-color: #0056b3; /* Color del botón al pasar el mouse */
        }

        /* Estilo de los campos de entrada */
        .form-control {
            border-radius: 5px; /* Bordes redondeados */
            border: 1px solid #ced4da; /* Color del borde */
            padding: 10px; /* Espaciado interno */
            font-size: 16px; /* Tamaño de fuente */
        }

        /* Estilo de las etiquetas */
        label {
            font-weight: bold; /* Negrita */
        }

        /* Ajustes específicos para el campo de selección */
        select.form-control {
            height: 50px; /* Aumentar la altura del campo de selección */
            padding: 10px; /* Aumentar el padding interno */
        }
    </style>
</head>
<body class="bg-light">

    <div class="form-container">
        <h2><%= request.getParameter("idPago") != null ? "MODIFICAR PAGO" : "ADICIONAR PAGO" %></h2>

        <%
            // Obtener los parámetros necesarios
            String idPago = request.getParameter("idPago");
            String idVenta = request.getParameter("idVenta");

            // Inicializar variables para prellenar el formulario
            String fecha = "";
            String idMedioPago = "";
            String valor = "";

            // Si idPago no es nulo, significa que estamos modificando un pago existente
            MedioPagoPorVenta pago = null;
            if (idPago != null && !idPago.isEmpty()) {
                pago = new MedioPagoPorVenta(idPago);
                fecha = pago.getFecha(); // Asegúrate de que el formato sea compatible con HTML
                idMedioPago = pago.getIdPagos();
                valor = pago.getValor();
            }

            // Cargar los medios de pago
            List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
        %>

        <form action="procesarPago.jsp" method="post">
            <!-- Mostrar el ID de la venta -->
            <p><strong>ID de la venta:</strong> <%= idVenta != null ? idVenta : "No se encontró el ID de la venta" %></p>

            <!-- Campo para seleccionar la fecha del pago -->
            <div class="form-group">
                <label for="fechaPago">Fecha</label>
                <input type="date" name="fechaPago" id="fechaPago" class="form-control" value="<%= fecha %>" required>
            </div>

            <!-- Campo para seleccionar el medio de pago -->
            <div class="form-group">
                <label for="medioPago">Medio Pago</label>
                <select name="medioPago" id="medioPago" class="form-control" required>
                    <%
                        for (MedioDePago medio : mediosDePago) {
                            String selected = medio.getId().equals(idMedioPago) ? "selected" : "";
                    %>
                    <option value="<%= medio.getId() %>" <%= selected %>><%= medio.getTipoPago() %></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <!-- Campo para ingresar el valor del pago -->
            <div class="form-group">
                <label for="valorPago">Valor</label>
                <input type="number" name="valorPago" id="valorPago" class="form-control" value="<%= valor %>" required>
            </div>

            <!-- Campo oculto para pasar el id de la venta -->
            <input type="hidden" name="idVenta" value="<%= idVenta %>">

            <!-- Campo oculto para pasar el id del pago si es una modificación -->
            <input type="hidden" name="idPago" value="<%= idPago != null ? idPago : "" %>">

            <!-- Botones para agregar o modificar el pago -->
            <div class="text-center">
                <input type="submit" value="<%= idPago != null ? "Modificar" : "Agregar" %>" class="btn-submit">
                <input type="button" value="Cancelar" class="btn-submit" onclick="window.history.back();">
            </div>
        </form>
    </div>

</body>
</html>
