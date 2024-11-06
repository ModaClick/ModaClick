/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

/**
 *
 * @author CASA
 */
public class TipoPersona {
   
    private String codigo;

    public TipoPersona(String codigo) {
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
   
    public String getNombre(){
        String nombre= null;
        switch (codigo){
            case "A" : nombre ="Administrador"; break;
            case "P" : nombre ="Proveedor"; break;
            case "C" : nombre ="Cliente"; break;
            default : nombre ="Desconocido"; break;
        }
        return nombre;
    }

    @Override
    public String toString() {
        return getNombre();
    }
public String getMenu() {
    String menu = "<ul class='menu'>";
    menu += "<li><a class='icon-home' href='principal.jsp?CONTENIDO=inicio.jsp'>Inicio</a></li>";

    switch (this.codigo) {
        case "A":
            menu += "<li><a class='icon-category' href='principal.jsp?CONTENIDO=categorias.jsp'>Categoría</a></li>";
            menu += "<li><a class='icon-inventory' href='principal.jsp?CONTENIDO=inventario.jsp'>Inventario</a></li>";
            menu += "<li><a class='icon-payment' href='principal.jsp?CONTENIDO=mediosDePago.jsp'>Medios de Pago</a></li>";
            menu += "<li><a class='icon-shipping' href='principal.jsp?CONTENIDO=tiposEnvio.jsp'>Tipos Envío</a></li>";
            menu += "<li><a class='icon-admin' href='principal.jsp?CONTENIDO=administradores.jsp'>Administradores</a></li>";
            menu += "<li><a class='icon-supplier' href='principal.jsp?CONTENIDO=proveedores.jsp'>Proveedores</a></li>";
            menu += "<li><a class='icon-client' href='principal.jsp?CONTENIDO=clientes.jsp'>Clientes</a></li>";
            menu += "<li><a class='icon-sales' href='principal.jsp?CONTENIDO=ventas.jsp'>Ventas</a></li>";
            menu += "<li><a class='icon-purchases' href='principal.jsp?CONTENIDO=compras.jsp'>Compras</a></li>";
            menu += "<li><a class='icon-orders' href='principal.jsp?CONTENIDO=pedidos.jsp'>Pedidos</a></li>";

            // Submenú de Devoluciones
            menu += "<li class='submenu'><a class='icon-returns' href='#'>Devoluciones</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=devolucion/DevolucionesVentas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=devolucion/DevolucionesCompras.jsp'>Compras</a></li>";
            menu += "</ul></li>";

            // Submenú de Reportes
            menu += "<li class='submenu'><a class='icon-reports' href='#'>Reportes</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/reporteUtilidadBruta.jsp'>Utilidad Bruta</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/reporteCompras.jsp'>Compras</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/reporteVentas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/reportePedidos.jsp'>Pedidos</a></li>";
            menu += "</ul></li>";

            // Submenú de Indicadores
            menu += "<li class='submenu'><a class='icon-indicators' href='#'>Indicadores</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/ventas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/inventario.jsp'>Inventario</a></li>";
            menu += "</ul></li>";

            break;
    }

    menu += "<li><a href='index.jsp'>Salir</a></li>";
    menu += "</ul>";

    return menu;
}


     public String getListaEnOptions() {
        // Solo ofrece "Administrador" como opción
        String lista = "";
        if (codigo == null) {
            codigo = "";
        }
        if ("A".equals(codigo)) {
            lista = "<option value='A'>Administrador</option>";
        } else {
            lista = "<option value='A'>Administrador</option>";
        }
        return lista;
    }
   
    
}


    
           

