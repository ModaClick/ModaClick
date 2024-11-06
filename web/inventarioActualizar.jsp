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
    boolean subioArchivo = false;
    Map<String, String> variables = new HashMap<String, String>();
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    List<String> impuestosSeleccionados = new ArrayList<>(); // Lista para almacenar los impuestos seleccionados

    if (isMultipart) {
        String rutaActual = getServletContext().getRealPath("/");
        File destino = new File(rutaActual + "/Presentacion/inventario/");
        DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, destino);
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> elementosFormulario = upload.parseRequest(request); // Procesamos los elementos del formulario
        Iterator<FileItem> iterador = elementosFormulario.iterator();
        
        while (iterador.hasNext()) {
            FileItem item = iterador.next();
            if (item.isFormField()) {
                if (item.getFieldName().equals("impuesto")) {
                    impuestosSeleccionados.add(item.getString()); // Agregamos los impuestos seleccionados
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
    inventario.setIdArticulo(variables.get("id"));
    inventario.setNombreArticulo(variables.get("nombreArticulo"));
    inventario.setDescripcion(variables.get("descripcion"));
    inventario.setCostoUnitCompra(variables.get("costoUnitarioCompra"));
    inventario.setValorUnitVenta(variables.get("valorUnitarioVenta"));
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
            inventario.grabar();
            break;
        case "Modificar":
            if (!subioArchivo) {
                Inventario auxiliar = new Inventario(variables.get("id"));
                inventario.setFoto(auxiliar.getFoto());
            }
            inventario.modificar();
            break;
        case "Eliminar":
            inventario.eliminar();
            break;
    }

    if (impuestosSeleccionados.isEmpty()) {
        System.out.println("No se seleccionaron impuestos.");
    } else {
        // **Eliminar primero los impuestos existentes**
        ImpuestoInventario.eliminarPorArticulo(Integer.parseInt(inventario.getIdArticulo()));

        // Procesar los impuestos seleccionados
        System.out.println("Impuestos seleccionados:");
        for (String idImpuesto : impuestosSeleccionados) {
            System.out.println("ID del impuesto seleccionado: " + idImpuesto);
            
            // Llamamos al método para agregar el impuesto a la tabla ImpuestoInventario
            ImpuestoInventario impuestoInventario = new ImpuestoInventario();
            boolean resultado = impuestoInventario.insertarImpuestoInventario(
                Integer.parseInt(inventario.getIdArticulo()), 
                Integer.parseInt(idImpuesto)
            );

            if (resultado) {
                System.out.println("Impuesto agregado correctamente al artículo.");
            } else {
                System.out.println("Error al agregar el impuesto al artículo.");
            }
        }
    }
%>

<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=inventario.jsp";
</script>
