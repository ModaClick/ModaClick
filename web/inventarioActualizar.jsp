<%@page import="clasesGenericas.ConectorBD"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="clases.Impuesto"%>
<%@page import="clases.Inventario"%>
<%@page import="clases.ImpuestoInventario"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    String idArticulo = request.getParameter("id");

    System.out.println("Acción recibida: " + accion);
    System.out.println("ID del artículo: " + idArticulo);

    if ("Eliminar".equals(accion) && idArticulo != null) {
        System.out.println("Eliminando impuestos asociados para el artículo con ID: " + idArticulo);
        ImpuestoInventario.eliminarPorArticulo(Integer.parseInt(idArticulo));

        Inventario inventario = new Inventario();
        inventario.setIdArticulo(idArticulo);
        boolean resultado = inventario.eliminar();

        if (resultado) {
            System.out.println("Artículo eliminado correctamente.");
        } else {
            System.out.println("Error al eliminar el artículo.");
        }
    } else {
        boolean subioArchivo = false;
        Map<String, String> variables = new HashMap<String, String>();
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        List<String> impuestosSeleccionados = new ArrayList<>();

        if (isMultipart) {
            String rutaActual = getServletContext().getRealPath("/");
            File destino = new File(rutaActual + "/presentacion/");
            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, destino);
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> elementosFormulario = upload.parseRequest(request);
            Iterator<FileItem> iterador = elementosFormulario.iterator();

            while (iterador.hasNext()) {
                FileItem item = iterador.next();
                if (item.isFormField()) {
                    if (item.getFieldName().equals("impuesto")) {
                        impuestosSeleccionados.add(item.getString());
                    } else {
                        variables.put(item.getFieldName(), item.getString());
                    }
                } else {
                    if (!item.getName().equals("")) {
                        subioArchivo = true;
                        File archivo = new File(destino, item.getName());
                        item.write(archivo);
                        variables.put(item.getFieldName(), item.getName());
                    } else {
                        variables.put(item.getFieldName(), "");
                    }
                }
            }
        }

        Inventario inventario = new Inventario();

        if (variables.get("accion").equals("Modificar")) {
            idArticulo = variables.get("id");
            System.out.println("Modificación: ID del artículo recibido: " + idArticulo);
            inventario.setIdArticulo(idArticulo);

            // Eliminar impuestos previos antes de añadir los nuevos
            ImpuestoInventario.eliminarPorArticulo(Integer.parseInt(idArticulo));
            System.out.println("Impuestos eliminados para el artículo con ID: " + idArticulo);
        }

        inventario.setNombreArticulo(variables.get("nombreArticulo"));
        inventario.setDescripcion(variables.get("descripcion"));
        inventario.setCostoUnitCompra(variables.get("costoUnitCompra"));      
        inventario.setValorUnitVenta(variables.get("valorUnitVenta"));
        inventario.setStock(variables.get("stock"));
        inventario.setStockMinimo(variables.get("stockMinimo"));
        inventario.setStockMaximo(variables.get("stockMaximo"));
        inventario.setTipoTela(variables.get("tipoTela"));
        inventario.setColorArticulo(variables.get("colorArticulo"));
        inventario.setTalla(variables.get("talla"));
        inventario.setFoto(variables.get("foto"));
        inventario.setIdCategoria(variables.get("idCategoria"));

        switch (variables.get("accion")) {
            case "Adicionar":
                boolean articuloGrabado = inventario.grabar();
                if (articuloGrabado) {
                    String sqlObtenerID = "SELECT idArticulo FROM Inventario WHERE nombreArticulo='" + inventario.getNombreArticulo() + "' ORDER BY idArticulo DESC LIMIT 1";
                    ResultSet rs = ConectorBD.consultar(sqlObtenerID);

                    if (rs != null && rs.next()) {
                        idArticulo = rs.getString("idArticulo");
                        inventario.setIdArticulo(idArticulo);

                        for (String idImpuesto : impuestosSeleccionados) {
                            boolean resultado = inventario.agregarImpuestoAInventario(
                                Integer.parseInt(idArticulo), 
                                Integer.parseInt(idImpuesto)
                            );
                            if (resultado) {
                                System.out.println("Impuesto agregado correctamente al artículo.");
                            } else {
                                System.out.println("Error al agregar el impuesto al artículo.");
                            }
                        }
                    } else {
                        System.out.println("Error al obtener el ID del artículo.");
                    }
                } else {
                    System.out.println("Error al grabar el artículo.");
                }
                break;

            case "Modificar":
                if (!subioArchivo) {
                    Inventario auxiliar = new Inventario(variables.get("id"));
                    inventario.setFoto(auxiliar.getFoto());
                }
                inventario.modificar();
                System.out.println("Modificación: Artículo con ID " + idArticulo + " modificado correctamente.");

                // Agregar los nuevos impuestos
                for (String idImpuesto : impuestosSeleccionados) {
                    boolean resultado = inventario.agregarImpuestoAInventario(
                        Integer.parseInt(idArticulo), 
                        Integer.parseInt(idImpuesto)
                    );
                    if (resultado) {
                        System.out.println("Impuesto agregado correctamente al artículo.");
                    } else {
                        System.out.println("Error al agregar el impuesto al artículo.");
                    }
                }
                break;
        }
    }
%>

<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=inventario.jsp";
</script>