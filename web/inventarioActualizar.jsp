<%@page import="clases.Inventario"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext"%>
<%@page import="org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean subioArchivo = false;
    Map<String, String> variables = new HashMap<String, String>();
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    if (!isMultipart) {
        // Para el caso de que no sea un formulario multipart (esto debería manejarse correctamente en caso de formularios simples)
        variables.put("accion", request.getParameter("accion"));
        variables.put("id", request.getParameter("id"));
    } else {
        String rutaActual = getServletContext().getRealPath("/");
        out.println("Ruta actual: " + rutaActual);
        File destino = new File(rutaActual + "/Presentacion/inventario/");
        DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, destino);
        ServletFileUpload upload = new ServletFileUpload(factory);
        File archivo = null;
        
        ServletRequestContext origen = new ServletRequestContext(request);
        List<FileItem> elementosFormulario = upload.parseRequest(origen);
        Iterator<FileItem> iterador = elementosFormulario.iterator();
        
        while (iterador.hasNext()) {
            FileItem elemento = iterador.next();
            if (elemento.isFormField()) {
                out.println(elemento.getFieldName() + " = " + elemento.getString() + "<br>");
                variables.put(elemento.getFieldName(), elemento.getString());
            } else {
                out.println(elemento.getFieldName() + " = " + elemento.getName() + "<br>");
                if (!elemento.getName().equals("")) {
                    subioArchivo = true;
                    try {
                        archivo = new File(destino, elemento.getName());
                        elemento.write(archivo);
                        variables.put(elemento.getFieldName(), elemento.getName());
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("Error al subir el archivo: " + e.getMessage());
                    }
                } else {
                    variables.put(elemento.getFieldName(), "");
                }
            }
        }
    }
    
    Inventario inventario = new Inventario();
    inventario.setIdArticulo(variables.get("id"));
    inventario.setNombreArticulo(variables.get("nombreArticulo"));
    inventario.setDescripcion(variables.get("descripcion"));
    inventario.setCostoUnitarioCompra(variables.get("costoUnitarioCompra"));
    inventario.setValorUnitarioVenta(variables.get("valorUnitarioVenta"));
    inventario.setStock(variables.get("stock"));
    inventario.setStockMinimo(variables.get("stockMinimo"));
    inventario.setStockMaximo(variables.get("stockMaximo"));
    inventario.setTipoTela(variables.get("tipoTela"));
    inventario.setColorArticulo(variables.get("colorArticulo"));
    inventario.setTalla(variables.get("talla"));
    inventario.setFoto(variables.get("foto"));
    inventario.setIdCategoria(variables.get("idCategoria"));
    inventario.setImpuesto(variables.get("impuesto"));
    /*String[] impuestos = request.getParameterValues("impuesto");
    if (impuestos != null) {
        inventario.setImpuesto(String.join(",", impuestos));
    } else {
        inventario.setImpuesto("");
        out.println("Impuestos recibidos: " + (impuestos != null ? String.join(", ", impuestos) : "Ninguno"));

    }*/

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
%>

<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=inventario.jsp";
</script>
