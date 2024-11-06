<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<%@page import="clases.Inventario"%> <!-- Importación de la clase Inventario -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");
    Venta venta = new Venta();

    switch (accion) {
        case "Adicionar":
            // Obtener el ID del cliente
            String idCliente = request.getParameter("cliente").substring(0, request.getParameter("cliente").indexOf("-")).trim();
            
            // Obtener la cadena de artículos vendidos
            String cadenaArticulos = request.getParameter("articulosVendidos");
            String[] articulosVendidos = cadenaArticulos.split("\\|\\|");

            boolean stockInsuficiente = false;
            String mensajeStock = "No se puede realizar la venta. No hay suficiente stock para los siguientes artículos:<br><ul>";

            // Validar el stock de cada artículo antes de proceder
            for (String articulo : articulosVendidos) {
                String[] datosArticulo = articulo.split("\\|");
                String idArticulo = datosArticulo[0];
                int cantidadVendida = Integer.parseInt(datosArticulo[1]);

                // Obtener el stock actual del artículo desde la base de datos
                Inventario inventario = new Inventario(idArticulo);
                int stockActual = Integer.parseInt(inventario.getStock());

                if (cantidadVendida > stockActual) {
                    stockInsuficiente = true;
                    mensajeStock += "<li>" + inventario.getNombreArticulo() + " - Stock disponible: " + stockActual + ", Cantidad solicitada: " + cantidadVendida + "</li>";
                }
            }

            mensajeStock += "</ul>";

            // Si no hay suficiente stock, mostrar el mensaje en la misma página y no procesar la venta
            if (stockInsuficiente) {
%>
                <div style="color: red; font-weight: bold;">
                    <%= mensajeStock %>
                </div>
                <p><a href="javascript:history.back()">Regresar y ajustar la venta</a></p>
<%
            } else {
                // Procesar la venta si el stock es suficiente

                // Inicializar la cadena para medios de pago
                String cadenaMediosPago = "";

                // Procesar los medios de pago
                List<MedioDePago> datosMediosPago = MedioDePago.getListaEnObjetos(null, null);
                for (int i = 0; i < datosMediosPago.size(); i++) {
                    MedioDePago medioPago = datosMediosPago.get(i);
                    // Verificar si el valor del medio de pago está presente
                    if (request.getParameter("valor" + medioPago.getId()) != null) {
                        int valor = Integer.parseInt(request.getParameter("valor" + medioPago.getId()));
                        if (valor > 0) {
                            // Formatear la cadena de medios de pago
                            if (!cadenaMediosPago.equals("")) {
                                cadenaMediosPago += "||";
                            }
                            cadenaMediosPago += medioPago.getId() + "|" + valor;
                        }
                    }
                }

                // Imprimir para depuración (puedes eliminar estas líneas una vez confirmado el formato)
                out.print("Identificacion: " + idCliente + "<br>");
                out.print("Cadena de Productos: " + cadenaArticulos + "<br>");
                out.print("Cadena de Medios de Pago: " + cadenaMediosPago + "<br>");

                // Asignar el cliente a la venta
                venta.setIdCliente(idCliente);
                
                // Grabar la venta utilizando el procedimiento almacenado
                venta.grabarConProcedimientoAlmacenado(cadenaArticulos, cadenaMediosPago);

                // Ahora actualizar el stock en el inventario
                for (String articulo : articulosVendidos) {
                    String[] datosArticulo = articulo.split("\\|");
                    String idArticulo = datosArticulo[0];
                    int cantidadVendida = Integer.parseInt(datosArticulo[1]);

                    // Obtener el stock actual del artículo
                    Inventario inventario = new Inventario(idArticulo);
                    int stockActual = Integer.parseInt(inventario.getStock());

                    // Restar la cantidad vendida al stock actual
                    int nuevoStock = stockActual - cantidadVendida;

                    // Actualizar el stock en la base de datos
                    inventario.setStock(String.valueOf(nuevoStock));
                    inventario.modificar();  // Método para actualizar el stock en la base de datos
                }

                // Redireccionar de nuevo a la página de ventas
%>
                <script type="text/javascript">
                    document.location = "principal.jsp?CONTENIDO=ventas.jsp";
                </script>
<%
            }
            break;

        case "Eliminar":
            // Obtener y eliminar la venta por ID
            venta.setIdVenta(request.getParameter("idVenta"));
            venta.eliminar();
            break;
    }
%>
