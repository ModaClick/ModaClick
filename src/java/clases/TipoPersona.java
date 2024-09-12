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
            case "P" : nombre ="Vendedor"; break;
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
    String menu = "<ul id='menu'>";
    menu += "<li><a href='principal.jsp?CONTENIDO=inicio.jsp'>Inicio</a></li>";
    switch (this.codigo) {
        case "A":
            menu += "<li><a href='principal.jsp?CONTENIDO=categoria.jsp'>Categorias</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=inventario.jsp'>Inventario</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=usuarios.jsp'>Usuarios</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=clientes.jsp'>Clientes</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=productos.jsp'>Productos</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=ventas.jsp'>Ventas</a></li>";
            menu += "<li class='dropdown'><a href='#'>Reportes</a>";
            menu += "<ul class='dropdown-content'>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/productosMasVendidos.jsp'>Productos más vendidos</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=Reportes/productosMenosVendidos.jsp'>Productos menos vendidos</a></li>";
            menu += "</ul>";
            menu += "</li>";
            menu += "<li class='dropdown'><a href='#'>Indicadores</a>";
            menu += "<ul class='dropdown-content'>";
            menu += "<li><a href='principal.jsp?CONTENIDO=indicadores/ventas.jsp'>Indicador Ventas</a></li>";
            menu += "</ul>";
            menu += "</li>";
            break;
        case "P":
            menu += "<li><a href='principal.jsp?CONTENIDO=clientes.jsp'>Clientes</a></li>";
            menu += "<li><a href='principal.jsp?CONTENIDO=ventas.jsp'>Ventas</a></li>";
            break;
    }
    menu += "<li><a href='index.jsp'>Salir</a></li>";
    menu += "</ul>";
    return menu;
}


   
    public String getListaEnOptions(){
        String lista="";
        if(codigo==null) codigo="";
        switch(codigo){
            case "A":
                lista="<option value='A' selected>Administrador</option><option value='P'>Vendedor</option>";
                break;
            case "P":
                lista="<option value='P'>Administrador</option><option value='P' selected>Vendedor</option>";
                break;
            default:
                lista="<option value='A' selected>Administrador</option><option value='P'>Vendedor</option>";
                break;
        }
        return lista;
    }
}


