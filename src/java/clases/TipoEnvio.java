/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
public class TipoEnvio {

    private String id;
    private String nombre;
    private String descripcion;

    public TipoEnvio() {
    }

    

    public TipoEnvio(String id) {
        String cadenaSQL = "select nombre, descripcion from TipoEnvio where id=" + id;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.id=id;
                nombre=resultado.getString("nombre");
                descripcion=resultado.getString("descripcion");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TipoEnvio.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @Override
    public String toString() {
        return nombre;
    }
    
    
    public boolean grabar(){
    String cadenaSQL= "insert into TipoEnvio (nombre,descripcion) values (' "+nombre+" ',' "+descripcion+" ')";
    return ConectorBD.ejecutarQuery(cadenaSQL);
}
    public boolean modificar() {
    String cadenaSQL = "update TipoEnvio set nombre='"+nombre+"', descripcion='"+descripcion+"' where id ="+id;
    return ConectorBD.ejecutarQuery(cadenaSQL);
    
}
    public boolean eliminar(){
        String cadenaSQL="delete from TipoEnvio where id="+id;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    public static ResultSet getLista(String filtro, String orden){
        if(filtro!=null && filtro!="")orden=" order by "+orden;
        else filtro="";
        if(orden!=null && orden!="")orden=" order by "+orden;
        else orden ="";
        String cadenaSQL="select id, nombre, descripcion from TipoEnvio "+filtro+orden;
        return ConectorBD.consultar(cadenaSQL);
    }
    
    public static List<TipoEnvio> getListaEnObjetos(String filtro, String orden){
        List<TipoEnvio> lista = new ArrayList<>();
        ResultSet datos = TipoEnvio.getLista(filtro, orden);
        if(datos!=null){
            try{
                while(datos.next()){
                    TipoEnvio envio = new TipoEnvio();
                    envio.setId(datos.getString("id"));
                    envio.setNombre(datos.getString("nombre"));
                    envio.setDescripcion(datos.getString("descripcion"));
                    lista.add(envio);
                    
                }
            }catch(SQLException ex){
                Logger.getLogger(TipoEnvio.class.getName()).log(Level.SEVERE,null,ex);
            }
        }
        return lista;
    }
    public static String getListaEnOptionEnvios(String preseleccionado){
        String lista="";
            List<TipoEnvio> datos= TipoEnvio.getListaEnObjetos(null, "nombre");
            for (int i = 0; i < datos.size(); i++) {
            TipoEnvio envio = datos.get(i);
            String auxiliar="";
            if(preseleccionado.equals(envio.getId())) auxiliar=" selected";
            lista+="<option value='" + envio.getId() + "'" + auxiliar + ">" + envio.getNombre() + "</option>";
           }
        return lista;
    }     
}

