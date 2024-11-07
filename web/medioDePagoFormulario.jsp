<%@page import="clases.MedioDePago"%>
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
</style>

<%
   String accion = request.getParameter("accion");
   String id = "sin generar";
   String tipoPago = "";
   String descripcionMetodoPago = "";

   if (accion.equals("Modificar")) {
       id = request.getParameter("id");
       MedioDePago medioP = new MedioDePago(id); // Crear instancia de MedioDePago con el id
       tipoPago = medioP.getTipoPago();  
       descripcionMetodoPago = medioP.getDescripcionMetodoPago();
   }
%>

<div class="form-container">
    <h2><%= accion.toUpperCase() %> MEDIOS DE PAGO</h2>
    <form name="formulario" method="post" action="principal.jsp?CONTENIDO=medioDePagoActualizar.jsp">
        <div class="form-group">
            <label for="id">Id</label>
            <input type="text" id="id" class="form-control" value="<%= id %>" readonly>
        </div>
        <div class="form-group">
            <label for="tipoPago">Tipo de Pago</label>
            <input type="text" name="tipoPago" id="tipoPago" class="form-control" value="<%= tipoPago %>" maxlength="40" required>
        </div>
        <div class="form-group">
            <label for="descripcionMetodoPago">Descripción del Método de Pago</label>
            <textarea name="descripcionMetodoPago" id="descripcionMetodoPago" class="form-control" rows="5" required><%= descripcionMetodoPago %></textarea>
        </div>
        <input type="hidden" name="id" value="<%= id %>">
        <div class="text-center">
            <input type="submit" name="accion" value="<%= accion %>" class="btn-submit">
        </div>
    </form>
</div>
