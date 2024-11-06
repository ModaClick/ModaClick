<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.MedioPagoPorVenta" %>
<%@ page import="clases.Venta" %>
<%@ page import="java.util.List" %>
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
            // Obtener el parámetro idVenta desde la URL o el request
            String idVenta = request.getParameter("idVenta");
            String idPago = request.getParameter("idPago");

            // Inicializar el objeto de la clase MedioPagoPorVenta
            MedioPagoPorVenta pago = null;
            Venta venta = null;

            // Si es una modificación, cargar los datos del pago existente
            if (idPago != null) {
                pago = new MedioPagoPorVenta(idPago);
                venta = pago.getVenta(); // Obtener la venta asociada
                idVenta = venta.getIdVenta(); // Obtener el idVenta asociado a la venta
            }

            // Variables para prellenar el formulario en caso de edición
            String fecha = (pago != null) ? pago.getFecha() : "";
            String idMedioPago = (pago != null) ? pago.getIdPagos() : "";
            String valor = (pago != null) ? pago.getValor() : "";
        %>

        <form action="<%= idPago != null ? "modificarPago.jsp" : "procesarPago.jsp" %>" method="post">
            <!-- Mostrar el ID de la venta (idVentaDetalle) -->
            <label for="idVenta">ID Venta:</label>
            <input type="text" name="idVentaDetalle" value="<%= idVenta != null ? idVenta : "No se encontró el ID de la venta" %>" readonly>

            <!-- Campo para seleccionar la fecha del pago -->
            <label for="fechaPago">Fecha:</label>
            <input type="date" name="fechaPago" id="fechaPago" value="<%= fecha %>" required>

            <!-- Campo para seleccionar el medio de pago -->
            <label for="medioPago">Medio Pago:</label>
            <select name="medioPago" id="medioPago" required>
                <%
                    List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
                    for (MedioDePago medio : mediosDePago) {
                        String selected = (medio.getId().equals(idMedioPago)) ? "selected" : "";
                %>
                <option value="<%= medio.getId() %>" <%= selected %>><%= medio.getTipoPago() %></option>
                <% } %>
            </select>

            <!-- Campo para ingresar el valor del pago -->
            <label for="valorPago">Valor:</label>
            <input type="number" name="valorPago" id="valorPago" value="<%= valor %>" required>

            <!-- Campo oculto para pasar el id del pago en caso de modificación -->
            <input type="hidden" name="idPago" value="<%= idPago != null ? idPago : "" %>">

            <!-- Botones para agregar o cancelar -->
            <div class="form-buttons">
                <input type="submit" value="<%= idPago != null ? "Modificar" : "Agregar" %>">
                <input type="button" value="Cancelar" onclick="window.history.back();">
            </div>
        </form>
    </div>

</body>
</html>
