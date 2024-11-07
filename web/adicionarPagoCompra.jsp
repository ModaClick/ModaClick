<%@ page import="clases.MedioDePago" %>
<%@ page import="clases.MedioPagoPorCompra" %>
<%@ page import="clases.Compra" %>
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
            max-width: 500px; /* Ancho m�ximo del formulario */
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
            font-size: 24px; /* Tama�o de fuente */
            font-weight: bold; /* Negrita */
            margin-bottom: 20px; /* Margen inferior */
        }

        /* Estilo de los botones */
        .btn-submit {
            background-color: #007BFF; /* Color del bot�n */
            color: white; /* Color del texto */
            border: none; /* Sin borde */
            border-radius: 30px; /* Bordes redondeados */
            padding: 10px 20px; /* Espaciado interno */
            font-size: 16px; /* Tama�o de fuente */
            cursor: pointer; /* Cambia el cursor al pasar sobre el bot�n */
            transition: background-color 0.3s ease; /* Transici�n de color */
        }

        .btn-submit:hover {
            background-color: #0056b3; /* Color del bot�n al pasar el mouse */
        }

        /* Estilo de los campos de entrada */
        .form-control {
            border-radius: 5px; /* Bordes redondeados */
            border: 1px solid #ced4da; /* Color del borde */
            padding: 10px; /* Espaciado interno */
            font-size: 16px; /* Tama�o de fuente */
        }

        /* Estilo de las etiquetas */
        label {
            font-weight: bold; /* Negrita */
        }
        
    /* Ajustes espec�ficos para el campo de selecci�n */
    select.form-control {
        height: 50px; /* Aumentar la altura del campo de selecci�n */
        padding: 10px; /* Aumentar el padding interno */
    }
    </style>
</head>
<body class="bg-light">

    <div class="form-container">
        <h2><%= request.getParameter("idPago") != null ? "MODIFICAR PAGO" : "ADICIONAR PAGO" %></h2>

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
            // Obtener los par�metros necesarios
            String idPago = request.getParameter("idPago");
            String idCompra = request.getParameter("idCompra");

            // Inicializar variables para prellenar el formulario
            String fecha = "";
            String idMedioPago = "";
            String valor = "";

            // Si idPago no es nulo, significa que estamos modificando un pago existente
            MedioPagoPorCompra pago = null;
            if (idPago != null && !idPago.isEmpty()) {
                pago = new MedioPagoPorCompra(idPago);
                fecha = pago.getFecha(); // Aseg�rate de que el formato sea compatible con HTML
                idMedioPago = pago.getIdPagos();
                valor = pago.getValor();
            }

            // Cargar los medios de pago
            List<MedioDePago> mediosDePago = MedioDePago.getListaEnObjetos(null, null);
        %>

        <form action="procesarPagoC.jsp" method="post">
            <!-- Mostrar el ID de la compra -->
            <p><strong>ID de la compra:</strong> <%= idCompra != null ? idCompra : "No se encontr� el ID de la compra" %></p>

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


            <!-- Campo oculto para pasar el id de la compra -->
            <input type="hidden" name="idCompra" value="<%= idCompra %>">

            <!-- Campo oculto para pasar el id del pago si es una modificaci�n -->
            <input type="hidden" name="idPago" value="<%= idPago != null ? idPago : "" %>">

            <!-- Botones para agregar o modificar el pago -->

            <div class="text-center">
                <input type="submit" value="<%= idPago != null ? "Modificar" : "Agregar" %>" class="btn-submit">
                <input type="button" value="Cancelar" class="btn-submit" onclick="window.history.back();">

            <div class="form-buttons">
                <input type="submit" value="<%= idPago != null ? "Modificar" : "Agregar" %>">
                <input type="button" value="Cancelar" onclick="window.history.back();">

            </div>
        </form>
    </div>

</body>
</html>
