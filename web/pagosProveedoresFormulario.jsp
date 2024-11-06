<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="clases.MedioDePago"%>
<%@page import="clases.MedioPagoPorCompra"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagos Proveedor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .btn-container {
            text-align: center;
        }
        button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-agregar {
            background-color: #28a745;
            color: white;
        }
        .btn-cancelar {
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
        }
    </style>
</head>
<body>

<%
    String accion = request.getParameter("accion");
    String idPago = "0";
    String fechaPago = "";
    String idMedioPago = "";
    String valor = "";
    String idCompra = request.getParameter("idCompra");

    if (accion != null && (accion.equals("Modificar") || accion.equals("Eliminar"))) {
        // Obtener el pago por su ID si estamos en modo Modificar o Eliminar
        idPago = request.getParameter("idPago");
        MedioPagoPorCompra pago = MedioPagoPorCompra.getPagoPorId(Integer.parseInt(idPago));

        if (pago != null) {
            fechaPago = pago.getFecha();
            idMedioPago = String.valueOf(pago.getIdMedioPago());
            valor = String.valueOf(pago.getValor());
        }
    }
%>

<div class="form-container">
    <h2><%= accion %> Pago a Proveedor</h2>

    <form action="pagosProveedoresActualizar.jsp" method="post">
        <label for="fecha">Fecha</label>
        <input type="date" id="fecha" name="fecha" value="<%= fechaPago %>" required>

        <label for="medioPago">Medio Pago</label>
        <select id="medioPago" name="medioPago" required>
            <option value="">Seleccione un medio de pago</option>
            <%
                List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, "tipoPago");
                for (MedioDePago medio : mediosDePago) {
                    String selected = medio.getId().equals(idMedioPago) ? "selected" : "";
                    out.println("<option value='" + medio.getId() + "' " + selected + ">" + medio.getTipoPago() + "</option>");
                }
            %>
        </select>

        <label for="valor">Valor</label>
        <input type="number" id="valor" name="valor" value="<%= valor %>" min="1" required>

        <input type="hidden" name="idPago" value="<%= idPago %>">
        <input type="hidden" name="accion" value="<%= accion %>">
        <input type="hidden" name="idCompra" value="<%= idCompra %>">

        <div class="btn-container">
            <button type="submit" class="btn-agregar"><%= accion %></button>
            <a href="pendientespagosproveedores.jsp?idCompra=<%= idCompra %>" class="btn-cancelar">Cancelar</a>
        </div>
    </form>
</div>

</body>
</html>
