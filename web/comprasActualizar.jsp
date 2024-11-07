<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.CompraDetalle"%> <!-- Importación de la clase CompraDetalle -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");
    Compra compra = new Compra();
    boolean redireccionar = false;

    switch (accion) {
        case "Adicionar":
            // Obtener el ID del proveedor
            String idProveedor = request.getParameter("proveedor").substring(0, request.getParameter("proveedor").indexOf("-")).trim();
            
            // Obtener la cadena de artículos comprados
            String cadenaArticulos = request.getParameter("articulosComprados");
            String[] articulosComprados = cadenaArticulos.split("\\|\\|");

            boolean stockInsuficiente = false;
            String mensajeStock = "No se puede realizar la compra. No hay suficiente stock para los siguientes artículos:<br><ul>";

            // Validar el stock de cada artículo antes de proceder
            for (String articulo : articulosComprados) {
                String[] datosArticulo = articulo.split("\\|");
                String idArticulo = datosArticulo[0];
                int cantidadComprada = Integer.parseInt(datosArticulo[1]);

                // Obtener el stock actual del artículo desde la base de datos
                Inventario inventario = new Inventario(idArticulo);
                int stockActual = Integer.parseInt(inventario.getStock());

                if (cantidadComprada > stockActual) {
                    stockInsuficiente = true;
                    mensajeStock += "<li>" + inventario.getNombreArticulo() + " - Stock disponible: " + stockActual + ", Cantidad solicitada: " + cantidadComprada + "</li>";
                }
            }

            mensajeStock += "</ul>";

            // Si no hay suficiente stock, mostrar el mensaje en la misma página y no procesar la compra
            if (stockInsuficiente) {
%>
                <div style="color: red; font-weight: bold; background-color: #ffe6e6; padding: 10px; border: 1px solid red; margin-top: 10px;">
                    <%= mensajeStock %>
                </div>
                <p><a href="javascript:history.back()" style="color: blue; font-weight: bold;">Regresar y ajustar la compra</a></p>
<%
            } else {
                // Procesar la compra si el stock es suficiente

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

                // Asignar el proveedor a la compra
                compra.setIdProveedor(idProveedor);
                
                // Grabar la compra utilizando el procedimiento almacenado
                compra.grabarConProcedimientoAlmacenado(cadenaArticulos, cadenaMediosPago);

                // Ahora actualizar el stock en el inventario
                for (String articulo : articulosComprados) {
                    String[] datosArticulo = articulo.split("\\|");
                    String idArticulo = datosArticulo[0];
                    int cantidadComprada = Integer.parseInt(datosArticulo[1]);

                    // Obtener el stock actual del artículo
                    Inventario inventario = new Inventario(idArticulo);
                    int stockActual = Integer.parseInt(inventario.getStock());

                    // Sumar la cantidad comprada al stock actual
                    int nuevoStock = stockActual + cantidadComprada;

                    // Actualizar el stock en la base de datos
                    inventario.setStock(String.valueOf(nuevoStock));
                    inventario.modificar();  // Método para actualizar el stock en la base de datos
                }

                redireccionar = true; // Activar redirección
            }
            break;

        case "Eliminar":
            // Obtener el ID de la compra y eliminar la compra
            String idCompra = request.getParameter("idCompra");
            compra.setIdCompra(idCompra);

            // Obtener los detalles de la compra para actualizar el stock antes de eliminar
            List<CompraDetalle> detallesCompra = compra.getDetalles();
            for (CompraDetalle detalle : detallesCompra) {
                String idArticulo = detalle.getIdArticuloInventario();
                int cantidadComprada = Integer.parseInt(detalle.getCantidad());

                // Obtener el stock actual del artículo y revertir el stock
                Inventario inventario = new Inventario(idArticulo);
                int stockActual = Integer.parseInt(inventario.getStock());
                int nuevoStock = stockActual - cantidadComprada;

                // Actualizar el stock en la base de datos
                inventario.setStock(String.valueOf(nuevoStock));
                inventario.modificar();
            }

            // Eliminar la compra usando el procedimiento almacenado
            if (compra.eliminarConProcedimiento()) {
                System.out.println("Compra eliminada correctamente usando el procedimiento almacenado.");
            } else {
                System.out.println("Error al eliminar la compra usando el procedimiento almacenado.");
            }
            redireccionar = true; // Activar redirección
            break;
    }

    // Realizar la redirección solo si es necesario
    if (redireccionar) {
%>
    <script type="text/javascript">
        document.location = "principal.jsp?CONTENIDO=compras.jsp";
    </script>
<%
    }
%>
