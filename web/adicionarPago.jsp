<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="clases.Venta" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= request.getParameter("idPago") != null ? "Modificar Pago" : "Adicionar Pago" %></title>
    <style>
        /* Estilos para el formulario */
        .form-container {
            border: 2px solid #000;
            padding: 20px;
            width: 300px;
            margin: 0 auto;
            background-color: #f9f9f9;
        }

        .form-container h1 {
            text-align: center;
            font-family: Arial, sans-serif;
            font-size: 24px;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 5px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-buttons {
            text-align: center;
        }

        .form-buttons input {
            padding: 10px 20px;
            margin: 5px;
            border: 2px solid #000;
            background-color: #fff;
            cursor: pointer;
        }

        .form-buttons input:hover {
            background-color: #ccc;
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h1><%= request.getParameter("idPago") != null ? "Modificar Pago" : "Adicionar Pago" %></h1>

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
            <label for="fechaPago">Fecha</label>
            <input type="date" name="fechaPago" id="fechaPago" value="<%= fecha %>" required>

            <!-- Campo para seleccionar el medio de pago -->
            <label for="medioPago">Medio Pago</label>
            <select name="medioPago" id="medioPago" required>
                <%
                    for (MedioDePago medio : mediosDePago) {
                        String selected = medio.getId().equals(idMedioPago) ? "selected" : "";
                %>
                <option value="<%= medio.getId() %>" <%= selected %>><%= medio.getTipoPago() %></option>
                <%
                    }
                %>
            </select>

            <!-- Campo para ingresar el valor del pago -->
            <label for="valorPago">Valor</label>
            <input type="number" name="valorPago" id="valorPago" value="<%= valor %>" required>

            <!-- Campo oculto para pasar el id de la venta -->
            <input type="hidden" name="idVenta" value="<%= idVenta %>">

            <!-- Campo oculto para pasar el id del pago si es una modificación -->
            <input type="hidden" name="idPago" value="<%= idPago != null ? idPago : "" %>">

            <!-- Botones para agregar o modificar el pago -->
            <div class="form-buttons">
                <input type="submit" value="<%= idPago != null ? "Modificar" : "Agregar" %>">
                <input type="button" value="Cancelar" onclick="window.history.back();">
            </div>
        </form>
    </div>

</body>
</html>
