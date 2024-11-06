<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="clases.Venta"%>
<%@page import="clases.Persona"%>
<%@page import="clases.MedioDePago"%>
<%@page import="java.util.List"%>

<%
 int elementosXPagina = 5;
 int pagina = 1;
 if (request.getParameter("pagina") != null) {
     pagina = Integer.parseInt(request.getParameter("pagina"));
 }
 int registroInicial = (pagina - 1) * elementosXPagina;
 int registroFinal = registroInicial + elementosXPagina;

 // Inicialización de filtro
 String filtro = "";

 // Filtro por fecha de venta
 String chkFechaVenta = request.getParameter("chkFechaVenta");
 String inicio = "";
 String fin = "";
 if (chkFechaVenta != null) {
     chkFechaVenta = "checked";
     inicio = request.getParameter("inicio");
     fin = request.getParameter("fin");
     filtro = "(fechaVenta between '" + inicio + "' and '" + fin + "')";
 } else chkFechaVenta = "";

 // Filtro por número de venta
 String chkVenta = request.getParameter("chkVenta");
 String idVentaDetalle = ""; // idVentaDetalle
 if (chkVenta != null) {
     chkVenta = "checked";
     idVentaDetalle = request.getParameter("idVentaDetalle");
     if (!filtro.equals("")) filtro += " and ";
     filtro += "idVenta like '%" + idVentaDetalle + "%'";
 } else chkVenta = "";

 // Filtro por cliente
  String chkCliente = request.getParameter("chkCliente");
    String cliente = "";
    if (chkCliente != null) {
        chkCliente = "checked";
        cliente = request.getParameter("cliente");
        if (!filtro.equals("")) filtro += " and ";
        
        filtro += "concat(identificacion,' - ',nombre) like '%" + cliente + "%'"; // '-'
    } else chkCliente = "";
    
 // Filtro por medio de pago
 String chkMedioDePago = request.getParameter("chkMedioDePago");
    String idMedioDePago = "";
    if (chkMedioDePago != null) {
        chkMedioDePago = "checked";
        idMedioDePago = request.getParameter("idMedioDePago");
    } else chkMedioDePago = "";




 String lista = "";
 int totalLista = 0;
 int totalAbonado = 0;
 int totalSaldo = 0;

 // Obtener lista de ventas con filtro y paginación
 List<Venta> datos = Venta.getListaEnObjetos(filtro, "idVenta desc");
 int totalRegistros = datos.size();
 datos = Venta.getListaEnObjetos(filtro, "idVenta desc limit " + registroInicial + "," + elementosXPagina);

 // Generar lista de ventas
 for (int i = 0; i < datos.size(); i++) {
     Venta venta = datos.get(i);
     List<MedioPagoPorVenta> datosMedioDePago = venta.getMediosDePago();
     boolean presentarRegistro = false;
     String listaMediosDePago = "<table>";
     for (int j = 0; j < datosMedioDePago.size(); j++) {
         MedioPagoPorVenta medioPagoVenta = datosMedioDePago.get(j);
         if (idMedioDePago.equals("") || idMedioDePago.equals(medioPagoVenta.getIdMedioPagoFactura())) presentarRegistro = true;
         listaMediosDePago += "<tr>";
         listaMediosDePago += "<td>" + medioPagoVenta.getNombreMedioDePago() + "</td>";
         listaMediosDePago += "<td align='right'>" + medioPagoVenta.getValor() + "</td>";
         listaMediosDePago += "</tr>";
     }
     listaMediosDePago += "</table>";
     if (presentarRegistro) {
         totalLista += venta.getTotal();
         totalAbonado += venta.getAbonado();
         totalSaldo += venta.getSaldo();
         lista += "<tr>";
         lista += "<td>" + venta.getFechaVenta() + "</td>";
         lista += "<td>" + venta.getIdVenta() + "</td>";
         lista += "<td>" + venta.getCliente() + "</td>";
         lista += "<td>" + listaMediosDePago + "</td>";
         lista += "<td align='right'>" + venta.getTotal() + "</td>";
         lista += "<td align='right'>" + venta.getAbonado() + "</td>";
         lista += "<td align='right'>" + venta.getSaldo() + "</td>";
         lista += "<td>";
         lista += "<img src='presentacion/eliminar.png' title='Eliminar' onClick='eliminar(" + venta.getIdVenta() + ")'>";
         lista += "<img src='presentacion/detalle.png' title='Ver detalles' onClick='verDetalles(" + venta.getIdVenta() + ")'>";
         lista += "<img src='presentacion/pdf.png' title='Ver factura' onClick='verFactura(" + venta.getIdVenta() + ")'>";
         lista += "<img src='presentacion/pagos.png' title='Ver pagos pendientes' onClick='verPagos(" + venta.getIdVenta() + ")'>";
         lista += "<img src='presentacion/salida.png' title='Ver orden de salida' onClick='verSalidas(" + venta.getIdVenta() + ")'>";
         lista += "</td>";
         lista += "</tr>";
     }
 }
 int numeroDePaginas = (int) Math.ceil((double)totalRegistros / elementosXPagina);
%>


<h3>LISTA DE VENTAS</h3><p>
<form name="formulario" method="post">
    <div class="tabla-container">
    <table border="0">
        <tr>
            <td><input type="checkbox" name="chkFechaVenta" <%=chkFechaVenta%>>Fecha</td>
            <td>
                desde<input type="date" name="inicio" value="<%=inicio%>">
                hasta<input type="date" name="fin" value="<%=fin%>">
            </td>
            <td><input type="checkbox" name="chkVenta" <%=chkVenta%>>Venta</td>
            <td><input type="text" name="idVentaDetalle" value="<%=idVentaDetalle%>"></td>
        </tr>
        <tr>
            <td><input type="checkbox" name="chkCliente" <%=chkCliente%>>Cliente</td>
            <td><input type="text" name="cliente" id="cliente" value="<%=cliente%>" size="50"></td>
          <td><input type="checkbox" name="chkMedioPagoVenta" <%=chkMedioDePago%>>Medio de pago</td>
<td><select name="idMedioDePago"><%=MedioDePago.getListaEnOptions(idMedioDePago)%></select></td>

        </tr>
    </table><p>
    </div>
    <input type="submit" value="Buscar">
    <center>Página <%=pagina%> de <%=numeroDePaginas%>,
    mostrando registros del <%=registroInicial + 1%> al <%=Math.min(registroFinal, totalRegistros)%>
    de un total de <%=totalRegistros%> </center>
    <div class="tabla-container">
<table  border="1">
    <tr>
        <th>Fecha Venta</th><th>Número Venta</th><th>Cliente</th><th>Medio de pago</th><th>Total</th><th>Abonado</th><th>Saldo</th>
        <th><a href="principal.jsp?CONTENIDO=ventasFormulario.jsp&accion=Adicionar" title="Adicionar">
            <img src="presentacion/adicionar.png"></a>
            <img src="presentacion/excel.png" title="Generar reporte en excel" onclick="exportar('excel')">
            <img src="presentacion/word.png" title="Generar reporte en word" onclick='exportar("word")'> 
        </th>     
    </tr>
    <%=lista%>
    <tr>
        <th colspan="4">TOTAL</th>
        <th align='right'><%=totalLista%></th>
        <th align='right'><%=totalAbonado%></th>
        <th align='right'><%=totalSaldo%></th>
    </tr>
</table>
     </div>
    <img src="presentacion/primero.png" onclick="cambiarPagina('primero')"/>
    <img src="presentacion/anterior.png" onclick="cambiarPagina('anterior')"/>
    <input type="text" name="pagina"value="<%=pagina%>" size="2" onchange="cambiarPagina('especifico')">
    <img src="presentacion/siguiente.png" onclick="cambiarPagina('siguiente')"/>
    <img src="presentacion/ultimo.png" onclick="cambiarPagina('ultimo')"/>
</form>

<script type="text/javascript">
    var personas=<%=Persona.getListaEnArregloJs("tipo='C'", null)%>
    $("#cliente").autocomplete({
        source: personas
    }); 
    function cambiarPagina(pagina){
        paginaActual=parseInt(document.formulario.pagina.value);
        switch(pagina){
            case "primero": pagina=1; break;
            case "anterior": pagina=paginaActual-1; break;
            case "especifico": pagina=paginaActual; break;
            case "siguiente": pagina=paginaActual+1; break;
            case "ultimo": pagina=<%=numeroDePaginas%>; break;
        }
        document.formulario.pagina.value=pagina;
        document.formulario.submit();
    }
    function eliminar(idVenta){
        respuesta=confirm("Realmente desea eliminar la venta "+idVenta+" con sus detalles y pagos?");
        if(respuesta){
            document.location="principal.jsp?CONTENIDO=ventasActualizar.jsp&accion=Eliminar&idVenta="+idVenta;
        }
    }
    function verDetalles(idVenta){
        document.location="principal.jsp?CONTENIDO=ventasDetalles.jsp&idVenta="+idVenta;
    }
    function verFactura(idVenta){
      window.open("ventasGenerarFactura.jsp?idVenta=" + idVenta);
    }
    function exportar(formato){
        window.open("ventasExportar.jsp?formato="+formato+"&filtro=<%=filtro%>");
    }    
    
</script>
