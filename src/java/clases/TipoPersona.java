/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

/**
 *
 * @author SENA
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
    menu += "<li><a href='principal.jsp?CONTENIDO=inicio.jsp'>Inicio</a></li>";
    
    switch(this.codigo) {
        case "A":
            menu += "<li><a href='principal.jsp?CONTENIDO=categorias.jsp'>Categoría</a></li>";               
            menu += "<li><a href='principal.jsp?CONTENIDO=inventario.jsp'>Inventario</a></li>";              
            menu += "<li><a href='principal.jsp?CONTENIDO=mediosDePago.jsp'>Medios de Pago</a></li>";               
            menu += "<li><a href='principal.jsp?CONTENIDO=tiposEnvio.jsp'>Tipos Envio</a></li>";               
            menu += "<li><a href='principal.jsp?CONTENIDO=administradores.jsp'>Administradores</a></li>";                
            menu += "<li><a href='principal.jsp?CONTENIDO=proveedores.jsp'>Proveedores</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=clientes.jsp'>Clientes</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=ventas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=compras.jsp'>Compras</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=pedidos.jsp'>Pedidos</a></li>";
            menu += "<li class='submenu'><a href='#'>Devoluciones</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=devolucion/ventas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=devolucion/compras.jsp'>Compras</a></li>";
            menu += "</ul></li>";

            
            // Submenú de Reportes
            menu += "<li class='submenu'><a href='#'>Reportes</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=reportes/utilidadBruta.jsp'>Utilidad Bruta</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=reportes/compras.jsp'>Compras</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=reportes/ventas.jsp'>Ventas</a></li>";
            menu += "</ul></li>";
            
            // Submenú de Indicadores
            menu += "<li class='submenu'><a href='#'>Indicadores</a>";
            menu += "<ul>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/pedidos.jsp'>Pedidos</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/ventas.jsp'>Ventas</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/ordenDeSalida.jsp'>Orden De Salida</a></li>";
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


    
           

